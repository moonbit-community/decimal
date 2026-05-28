///| Pure-clamp cases from `add.decTest` — results whose only condition is
/// `Clamped`. These exercise the etiny-floor branch in finalize: a finite
/// zero (either an input zero or one produced by exact cancellation) with
/// `exponent < etiny` has its exponent lifted to `etiny = e_min -
/// precision + 1` and `Clamped` is raised.
///
/// The two rounding-mode groups (`half_up`, `floor`) probe the sign rule
/// for diff-sign zero addition: under `half_up` the result is `+0`; under
/// `floor` (and only floor) the result inherits `-0`. The `-- *` marker
/// next to addx1625/1626/1636/1637 is the GDA file's own annotation for
/// those Floor-specific lines.
///
/// Subnormal-tagged neighbours (addx1511–1514, 1611–1614, etc.) are
/// excluded — they need finalize's underflow / re-rounding branch which
/// depends on quantize.
let clamp_subset : String =
  #|precision: 16
  #|maxexponent: 384
  #|minexponent: -383
  #|rounding: half_up
  #|addx1504 add  0E-400   0E-19  ->  0E-398 Clamped
  #|addx1505 add -0E-400   0E-19  ->  0E-398 Clamped
  #|addx1506 add  0E-400  -0E-19  ->  0E-398 Clamped
  #|addx1507 add -0E-400  -0E-19  -> -0E-398 Clamped
  #|addx1516 add -1E-401   1E-401 ->  0E-398 Clamped
  #|addx1517 add  1E-401  -1E-401 ->  0E-398 Clamped
  #|rounding: floor
  #|addx1624 add  0E-400   0E-19  ->  0E-398 Clamped
  #|addx1625 add -0E-400   0E-19  -> -0E-398 Clamped
  #|addx1626 add  0E-400  -0E-19  -> -0E-398 Clamped
  #|addx1627 add -0E-400  -0E-19  -> -0E-398 Clamped
  #|addx1636 add -1E-401   1E-401 -> -0E-398 Clamped
  #|addx1637 add  1E-401  -1E-401 -> -0E-398 Clamped

///|
test "clamp.decTest subset: zero results below etiny are lifted to etiny" {
  let cases = parse_dectest(clamp_subset)
  assert_eq(cases.length(), 12)
  let (failures, _) = run_cases(cases)
  if failures.length() > 0 {
    println("\{failures.length()} of \{cases.length()} cases failed:")
    let limit = if failures.length() < 20 { failures.length() } else { 20 }
    for i in 0..<limit {
      println("  \{failures[i]}")
    }
    if failures.length() > limit {
      println("  ... \{failures.length() - limit} more")
    }
    abort("clamp.decTest failures")
  }
}
