///|
/// Pure-clamp cases from `add.decTest` — results whose only condition is
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
/// Subnormal-tagged neighbours (addx1511–1514, 1611–1614, etc.) are scoped
/// out of this pure-Clamped subset — they also carry Underflow / Subnormal
/// conditions and are exercised in the `add` and `subnormal` test packages.
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
/// Pure-clamp case from `subtract.decTest` — opposite-sign cancellation
/// producing a zero below etiny.
let clamp_subset_subtract : String =
  #|precision: 3
  #|maxexponent: 999
  #|minexponent: -999
  #|rounding: half_up
  #|subx1053 subtract  0.100E-999  0.1E-999  ->   0E-1001    Clamped

///|
/// Pure-clamp cases from `multiply.decTest` — zero × non-zero / non-zero ×
/// zero where the product's exponent lies outside `[etiny, e_max]`.
/// mulx505 specifically exercises the upper-bound clamp: a zero with
/// exponent above `e_max` (not `etop`) gets folded to `e_max`,
/// unconditionally. This was missing from the original implementation.
let clamp_subset_multiply : String =
  #|precision: 7
  #|rounding: half_up
  #|maxexponent: 92
  #|minexponent: -92
  #|mulx504  multiply  0E-60 1000E-60  -> 0E-98 Clamped
  #|mulx505  multiply  100E+60 0E+60   -> 0E+92 Clamped

///|
fn run_clamp_subset(
  label : String,
  subset : String,
  expected : Int,
) -> Unit raise {
  let cases = parse_dectest(subset)
  assert_eq(cases.length(), expected)
  let (failures, _) = run_cases_with_flags(cases)
  if failures.length() > 0 {
    println("\{label}: \{failures.length()} of \{cases.length()} cases failed:")
    let limit = if failures.length() < 20 { failures.length() } else { 20 }
    for i in 0..<limit {
      println("  \{failures[i]}")
    }
    if failures.length() > limit {
      println("  ... \{failures.length() - limit} more")
    }
    abort("\{label}.decTest failures")
  }
}

///|
test "clamp add subset: zero results below etiny are lifted to etiny" {
  run_clamp_subset("add", clamp_subset, 12)
}

///|
test "clamp subtract subset: opposite-sign cancellation below etiny" {
  run_clamp_subset("subtract", clamp_subset_subtract, 1)
}

///|
test "clamp multiply subset: zero exponent clamps to [etiny, e_max]" {
  run_clamp_subset("multiply", clamp_subset_multiply, 2)
}
