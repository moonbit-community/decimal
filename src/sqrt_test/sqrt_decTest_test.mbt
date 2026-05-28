///| First 80 cases from `squareroot.decTest`. Skips Subnormal / Underflow /
/// Overflow / sNaN cases pending runner-side flag validation.
let sqrt_subset : String =
  #|precision:   9
  #|rounding:    half_up
  #|maxExponent: 384
  #|minexponent: -383
  #|sqtx001 squareroot 1       -> 1
  #|sqtx002 squareroot -1      -> NaN Invalid_operation
  #|sqtx003 squareroot 1.00    -> 1.0
  #|sqtx004 squareroot -1.00   -> NaN Invalid_operation
  #|sqtx005 squareroot 0       -> 0
  #|sqtx006 squareroot 00.0    -> 0.0
  #|sqtx007 squareroot 0.00    -> 0.0
  #|sqtx008 squareroot 00.00   -> 0.0
  #|sqtx009 squareroot 00.000  -> 0.00
  #|sqtx010 squareroot 00.0000 -> 0.00
  #|sqtx011 squareroot 00      -> 0
  #|sqtx012 squareroot -2      -> NaN Invalid_operation
  #|sqtx013 squareroot 2       -> 1.41421356 Inexact Rounded
  #|sqtx014 squareroot -2.00   -> NaN Invalid_operation
  #|sqtx015 squareroot 2.00    -> 1.41421356 Inexact Rounded
  #|sqtx016 squareroot -0      -> -0
  #|sqtx017 squareroot -0.0    -> -0.0
  #|sqtx018 squareroot -00.00  -> -0.0
  #|sqtx019 squareroot -00.000 -> -0.00
  #|sqtx020 squareroot -0.0000 -> -0.00
  #|sqtx021 squareroot -0E+9   -> -0E+4
  #|sqtx022 squareroot -0E+10  -> -0E+5
  #|sqtx023 squareroot -0E+11  -> -0E+5
  #|sqtx024 squareroot -0E+12  -> -0E+6
  #|sqtx025 squareroot -00     -> -0
  #|sqtx026 squareroot 0E+5    -> 0E+2
  #|sqtx027 squareroot 4.0     -> 2.0
  #|sqtx028 squareroot 4.00    -> 2.0
  #|sqtx030 squareroot +0.1            -> 0.316227766 Inexact Rounded
  #|sqtx031 squareroot -0.1            -> NaN Invalid_operation
  #|sqtx032 squareroot +0.01           -> 0.1
  #|sqtx033 squareroot -0.01           -> NaN Invalid_operation
  #|sqtx034 squareroot +0.001          -> 0.0316227766 Inexact Rounded
  #|sqtx035 squareroot -0.001          -> NaN Invalid_operation
  #|sqtx036 squareroot +0.000001       -> 0.001
  #|sqtx037 squareroot -0.000001       -> NaN Invalid_operation
  #|sqtx038 squareroot +0.000000000001 -> 0.000001
  #|sqtx039 squareroot -0.000000000001 -> NaN Invalid_operation
  #|sqtx041 squareroot 1.1        -> 1.04880885 Inexact Rounded
  #|sqtx042 squareroot 1.10       -> 1.04880885 Inexact Rounded
  #|sqtx043 squareroot 1.100      -> 1.04880885 Inexact Rounded
  #|sqtx044 squareroot 1.110      -> 1.05356538 Inexact Rounded
  #|sqtx045 squareroot -1.1       -> NaN Invalid_operation
  #|sqtx046 squareroot -1.10      -> NaN Invalid_operation
  #|sqtx047 squareroot -1.100     -> NaN Invalid_operation
  #|sqtx048 squareroot -1.110     -> NaN Invalid_operation
  #|sqtx049 squareroot 9.9        -> 3.14642654 Inexact Rounded
  #|sqtx050 squareroot 9.90       -> 3.14642654 Inexact Rounded
  #|sqtx051 squareroot 9.900      -> 3.14642654 Inexact Rounded
  #|sqtx052 squareroot 9.990      -> 3.16069613 Inexact Rounded
  #|sqtx053 squareroot -9.9       -> NaN Invalid_operation
  #|sqtx054 squareroot -9.90      -> NaN Invalid_operation
  #|sqtx055 squareroot -9.900     -> NaN Invalid_operation
  #|sqtx056 squareroot -9.990     -> NaN Invalid_operation
  #|sqtx060 squareroot  1           -> 1
  #|sqtx061 squareroot  1.0         -> 1.0
  #|sqtx062 squareroot  1.00        -> 1.0
  #|sqtx063 squareroot  10.0        -> 3.16227766 Inexact Rounded
  #|sqtx064 squareroot  10.0        -> 3.16227766 Inexact Rounded
  #|sqtx065 squareroot  10.0        -> 3.16227766 Inexact Rounded
  #|sqtx066 squareroot  10.00       -> 3.16227766 Inexact Rounded
  #|sqtx067 squareroot  100         -> 10
  #|sqtx068 squareroot  100.0       -> 10.0
  #|sqtx069 squareroot  100.00      -> 10.0
  #|sqtx070 squareroot  1.1000E+3   -> 33.1662479 Inexact Rounded
  #|sqtx071 squareroot  1.10000E+3  -> 33.1662479 Inexact Rounded
  #|sqtx072 squareroot -10.0        -> NaN Invalid_operation
  #|sqtx073 squareroot -10.00       -> NaN Invalid_operation
  #|sqtx074 squareroot -100.0       -> NaN Invalid_operation
  #|sqtx075 squareroot -100.00      -> NaN Invalid_operation
  #|sqtx076 squareroot -1.1000E+3   -> NaN Invalid_operation
  #|sqtx077 squareroot -1.10000E+3  -> NaN Invalid_operation
  #|sqtx078 squareroot  1.000       -> 1.00
  #|sqtx079 squareroot  1.0000      -> 1.00
  #|sqtx080 squareroot     1  -> 1
  #|sqtx081 squareroot     4  -> 2
  #|sqtx082 squareroot     9  -> 3
  #|sqtx083 squareroot    16  -> 4
  #|sqtx084 squareroot    25  -> 5
  #|sqtx085 squareroot    36  -> 6

///|
test "squareroot.decTest subset" {
  let cases = parse_dectest(sqrt_subset)
  assert_eq(cases.length(), 80)
  let (failures, _) = run_cases(cases)
  if failures.length() > 0 {
    println("\{failures.length()} of \{cases.length()} cases failed:")
    let limit = if failures.length() < 30 { failures.length() } else { 30 }
    for i in 0..<limit {
      println("  \{failures[i]}")
    }
    if failures.length() > limit {
      println("  ... \{failures.length() - limit} more")
    }
    abort("sqrt.decTest failures")
  }
}
