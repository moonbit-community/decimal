#!/usr/bin/env python3
"""Run MoonBit blackbox tests with real cross-package parallelism.

`moon test` itself runs test binaries sequentially within a single target
(only the build phase is parallelised). For projects with several heavy
test packages — like this one's dectest fixtures — that leaves most cores
idle on a long run. This script bypasses the limitation:

  1. `moon test --build-only` compiles everything and prints the list of
     artifact paths (one `.blackbox_test.exe` per package).
  2. For each artifact, we read the matching `__blackbox_test_info.json`
     to know what tests live in which `.mbt` files and build the
     `file:start-end/...` argument the native test driver expects.
  3. We launch all artifacts in parallel via `concurrent.futures`,
     collect their stdout/stderr, and report pass/fail summaries.
"""

from __future__ import annotations

import argparse
import concurrent.futures
import json
import os
import re
import subprocess
import sys
import time
from dataclasses import dataclass
from pathlib import Path


REPO_ROOT = Path(__file__).resolve().parent.parent
BUILD_DIR = REPO_ROOT / "_build"

TOTAL_RE = re.compile(r"Total tests:\s*(\d+),\s*passed:\s*(\d+),\s*failed:\s*(\d+)")
# Native blackbox tests emit one `MOON TEST RESULT` JSON block per test,
# with `"message": ""` for a pass and a non-empty message for a failure.
RESULT_RE = re.compile(
    r"----- BEGIN MOON TEST RESULT -----\s*(.+?)\s*----- END MOON TEST RESULT -----",
    re.DOTALL,
)


@dataclass
class Artifact:
    exe: Path
    arg: str
    name: str  # short package name like "add0_test"


def run_command(cmd: list[str], cwd: Path) -> tuple[int, str]:
    proc = subprocess.run(
        cmd, cwd=cwd, capture_output=True, text=True
    )
    return proc.returncode, proc.stdout + proc.stderr


def collect_artifacts(target: str, release: bool) -> list[Path]:
    """Run `moon test --build-only` and parse the JSON it prints."""
    cmd = [
        "nix", "develop", "--command",
        "moon", "test", "--target", target, "--build-only",
    ]
    if release:
        cmd.append("--release")
    code, out = run_command(cmd, REPO_ROOT)
    if code != 0:
        sys.stderr.write(out)
        raise SystemExit(f"moon build-only failed (exit {code})")
    # The JSON lives on the last line and looks like:
    #   {"artifacts_path":["/path/to/foo.exe", "/path/to/bar.exe"]}
    last = next((ln for ln in reversed(out.splitlines()) if ln.startswith("{")), None)
    if last is None:
        raise SystemExit("could not find artifacts JSON in moon output")
    paths = json.loads(last)["artifacts_path"]
    return [Path(p) for p in paths]


def build_arg(exe: Path) -> str:
    """Read the package's __blackbox_test_info.json and build the
    `file:start-end/...` argument the native driver parses."""
    info_path = exe.parent / "__blackbox_test_info.json"
    info = json.loads(info_path.read_text())
    parts: list[str] = []
    for file_name, tests in info["tests"].items():
        if not tests:
            # The driver still expects an explicit range; an empty file gets
            # `:0-0` so the loop body never runs.
            parts.append(f"{file_name}:0-0")
            continue
        # Tests are listed with an "index" field; build the half-open range.
        indices = sorted(t["index"] for t in tests)
        # We just take the full span `0 .. max+1`. Gaps are unlikely here and
        # the driver tolerates them (it loops `i in start..<end`).
        parts.append(f"{file_name}:0-{max(indices) + 1}")
    return "/".join(parts)


def make_artifact(exe: Path) -> Artifact:
    return Artifact(exe=exe, arg=build_arg(exe), name=exe.parent.name)


def run_one(art: Artifact) -> tuple[Artifact, int, float, str]:
    """Run one blackbox exe and return (artifact, exit_code, elapsed, output)."""
    start = time.perf_counter()
    proc = subprocess.run(
        [str(art.exe), art.arg],
        cwd=REPO_ROOT,
        capture_output=True,
        text=True,
    )
    elapsed = time.perf_counter() - start
    return art, proc.returncode, elapsed, proc.stdout + proc.stderr


def summarise(art: Artifact, code: int, elapsed: float, output: str) -> str:
    # Each test prints a `MOON TEST RESULT` JSON block on its own; we parse
    # them all to get pass / fail counts.
    blocks = RESULT_RE.findall(output)
    if blocks:
        passed = 0
        failed = 0
        for raw in blocks:
            try:
                info = json.loads(raw)
            except json.JSONDecodeError:
                failed += 1
                continue
            if info.get("message"):
                failed += 1
            else:
                passed += 1
        total = passed + failed
        status = "ok" if failed == 0 and code == 0 else "FAIL"
        return f"{art.name:30s} {status:5s} {passed}/{total} ({elapsed:5.1f}s)"
    # Old wasm-style summary line, used for legacy compatibility.
    match = TOTAL_RE.search(output)
    if match:
        total, passed, failed = match.groups()
        status = "ok" if failed == "0" else "FAIL"
        return f"{art.name:30s} {status:5s} {passed}/{total} ({elapsed:5.1f}s)"
    # No result emitted — abnormal exit (OOM, SIGABRT, etc.).
    return f"{art.name:30s} CRASH exit={code} ({elapsed:5.1f}s)"


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--target", default="native",
                        help="moon test --target value (default: native)")
    parser.add_argument(
        "--debug", action="store_true",
        help="build/run in debug mode instead of release",
    )
    parser.add_argument(
        "-j", "--jobs", type=int, default=os.cpu_count(),
        help="max parallel test exes (default: nproc)",
    )
    parser.add_argument(
        "--show-output", action="store_true",
        help="print each test's full stdout/stderr on failure",
    )
    args = parser.parse_args()

    print(f"building ({args.target}, {'debug' if args.debug else 'release'})...",
          flush=True)
    exes = collect_artifacts(args.target, release=not args.debug)
    artifacts = [make_artifact(e) for e in exes]
    print(f"  {len(artifacts)} test artifacts", flush=True)

    print(f"running with {args.jobs} workers...", flush=True)
    start = time.perf_counter()
    failures = []
    with concurrent.futures.ThreadPoolExecutor(max_workers=args.jobs) as pool:
        futures = {pool.submit(run_one, a): a for a in artifacts}
        for fut in concurrent.futures.as_completed(futures):
            art, code, elapsed, output = fut.result()
            line = summarise(art, code, elapsed, output)
            print(f"  {line}", flush=True)
            if "FAIL" in line or "ABRT" in line:
                failures.append((art, code, output))
    wall = time.perf_counter() - start

    print(f"wall: {wall:.1f}s")
    if failures:
        print(f"{len(failures)} package(s) failed:")
        for art, code, output in failures:
            print(f"  --- {art.name} (exit {code}) ---")
            if args.show_output:
                print(output)
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
