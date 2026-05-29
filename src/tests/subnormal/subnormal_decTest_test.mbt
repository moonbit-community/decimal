///|
/// Subnormal cluster from `add.decTest` (addx910-937). Tests both
/// "natural subnormal" cases (where exponent ≥ etiny but adjusted < emin)
/// and "underflow re-rounded" cases (where exponent < etiny so digits
/// are dropped to lift the exponent to etiny). Excludes the
/// Clamped-but-rounded-to-zero outliers (addx918-920) — they need a
/// special-case in apply_subnormal that doesn't lift exp to etiny when
/// the result is exactly zero from the re-round.
let subnormal_subset : String =
  #|maxexponent: 999
  #|minexponent: -999
  #|precision: 3
  #|rounding: half_up
  #|addx910 add  1.00E-999   0    ->   1.00E-999
  #|addx911 add  0.1E-999    0    ->   1E-1000   Subnormal
  #|addx912 add  0.10E-999   0    ->   1.0E-1000 Subnormal
  #|addx913 add  0.100E-999  0    ->   1.0E-1000 Subnormal Rounded
  #|addx914 add  0.01E-999   0    ->   1E-1001   Subnormal
  #|addx915 add  0.999E-999  0    ->   1.00E-999 Inexact Rounded Subnormal Underflow
  #|addx916 add  0.099E-999  0    ->   1.0E-1000 Inexact Rounded Subnormal Underflow
  #|addx917 add  0.009E-999  0    ->   1E-1001   Inexact Rounded Subnormal Underflow
  #|addx918 add  0.001E-999  0    ->   0E-1001   Inexact Rounded Subnormal Underflow Clamped
  #|addx919 add  0.0009E-999 0    ->   0E-1001   Inexact Rounded Subnormal Underflow Clamped
  #|addx920 add  0.0001E-999 0    ->   0E-1001   Inexact Rounded Subnormal Underflow Clamped
  #|addx931 add -0.1E-999    0    ->  -1E-1000   Subnormal
  #|addx932 add -0.10E-999   0    ->  -1.0E-1000 Subnormal
  #|addx933 add -0.100E-999  0    ->  -1.0E-1000 Subnormal Rounded
  #|addx934 add -0.01E-999   0    ->  -1E-1001   Subnormal
  #|addx935 add -0.999E-999  0    ->  -1.00E-999 Inexact Rounded Subnormal Underflow
  #|addx936 add -0.099E-999  0    ->  -1.0E-1000 Inexact Rounded Subnormal Underflow
  #|addx937 add -0.009E-999  0    ->  -1E-1001   Inexact Rounded Subnormal Underflow

///|
test "subnormal addx cluster" {
  let cases = parse_dectest(subnormal_subset)
  assert_eq(cases.length(), 18)
  let (failures, _) = run_cases_with_flags(cases)
  if failures.length() > 0 {
    println("\{failures.length()} of \{cases.length()} cases failed:")
    let limit = if failures.length() < 30 { failures.length() } else { 30 }
    for i in 0..<limit {
      println("  \{failures[i]}")
    }
    if failures.length() > limit {
      println("  ... \{failures.length() - limit} more")
    }
    abort("subnormal.decTest failures")
  }
}
