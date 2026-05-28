///| First 80 cases from `reduce.decTest`. Skips Conversion_syntax and
/// sNaN-input cases pending runner-side flag validation.
let reduce_subset : String =
  #|precision:   9
  #|rounding:    half_up
  #|maxExponent: 999
  #|minexponent: -999
  #|redx001 reduce '1'      -> '1'
  #|redx002 reduce '-1'     -> '-1'
  #|redx003 reduce '1.00'   -> '1'
  #|redx004 reduce '-1.00'  -> '-1'
  #|redx005 reduce '0'      -> '0'
  #|redx006 reduce '0.00'   -> '0'
  #|redx007 reduce '00.0'   -> '0'
  #|redx008 reduce '00.00'  -> '0'
  #|redx009 reduce '00'     -> '0'
  #|redx010 reduce '0E+1'   -> '0'
  #|redx011 reduce '0E+5'   -> '0'
  #|redx012 reduce '-2'     -> '-2'
  #|redx013 reduce '2'      -> '2'
  #|redx014 reduce '-2.00'  -> '-2'
  #|redx015 reduce '2.00'   -> '2'
  #|redx016 reduce '-0'     -> '-0'
  #|redx017 reduce '-0.00'  -> '-0'
  #|redx018 reduce '-00.0'  -> '-0'
  #|redx019 reduce '-00.00' -> '-0'
  #|redx020 reduce '-00'    -> '-0'
  #|redx021 reduce '-0E+5'   -> '-0'
  #|redx022 reduce '-0E+1'  -> '-0'
  #|redx030 reduce '+0.1'            -> '0.1'
  #|redx031 reduce '-0.1'            -> '-0.1'
  #|redx032 reduce '+0.01'           -> '0.01'
  #|redx033 reduce '-0.01'           -> '-0.01'
  #|redx034 reduce '+0.001'          -> '0.001'
  #|redx035 reduce '-0.001'          -> '-0.001'
  #|redx036 reduce '+0.000001'       -> '0.000001'
  #|redx037 reduce '-0.000001'       -> '-0.000001'
  #|redx038 reduce '+0.000000000001' -> '1E-12'
  #|redx039 reduce '-0.000000000001' -> '-1E-12'
  #|redx041 reduce 1.1        -> 1.1
  #|redx042 reduce 1.10       -> 1.1
  #|redx043 reduce 1.100      -> 1.1
  #|redx044 reduce 1.110      -> 1.11
  #|redx045 reduce -1.1       -> -1.1
  #|redx046 reduce -1.10      -> -1.1
  #|redx047 reduce -1.100     -> -1.1
  #|redx048 reduce -1.110     -> -1.11
  #|redx049 reduce 9.9        -> 9.9
  #|redx050 reduce 9.90       -> 9.9
  #|redx051 reduce 9.900      -> 9.9
  #|redx052 reduce 9.990      -> 9.99
  #|redx053 reduce -9.9       -> -9.9
  #|redx054 reduce -9.90      -> -9.9
  #|redx055 reduce -9.900     -> -9.9
  #|redx056 reduce -9.990     -> -9.99
  #|redx060 reduce  10.0        -> 1E+1
  #|redx061 reduce  10.00       -> 1E+1
  #|redx062 reduce  100.0       -> 1E+2
  #|redx063 reduce  100.00      -> 1E+2
  #|redx064 reduce  1.1000E+3   -> 1.1E+3
  #|redx065 reduce  1.10000E+3  -> 1.1E+3
  #|redx066 reduce -10.0        -> -1E+1
  #|redx067 reduce -10.00       -> -1E+1
  #|redx068 reduce -100.0       -> -1E+2
  #|redx069 reduce -100.00      -> -1E+2
  #|redx070 reduce -1.1000E+3   -> -1.1E+3
  #|redx071 reduce -1.10000E+3  -> -1.1E+3
  #|redx080 reduce  10E+1       -> 1E+2
  #|redx081 reduce  100E+1      -> 1E+3
  #|redx082 reduce  1.0E+2      -> 1E+2
  #|redx083 reduce  1.0E+3      -> 1E+3
  #|redx084 reduce  1.1E+3      -> 1.1E+3
  #|redx085 reduce  1.00E+3     -> 1E+3
  #|redx086 reduce  1.10E+3     -> 1.1E+3
  #|redx087 reduce -10E+1       -> -1E+2
  #|redx088 reduce -100E+1      -> -1E+3
  #|redx089 reduce -1.0E+2      -> -1E+2
  #|redx090 reduce -1.0E+3      -> -1E+3
  #|redx091 reduce -1.1E+3      -> -1.1E+3
  #|redx092 reduce -1.00E+3     -> -1E+3
  #|redx093 reduce -1.10E+3     -> -1.1E+3
  #|redx100 reduce  11          -> 11
  #|redx101 reduce  10          -> 1E+1
  #|redx102 reduce  10.         -> 1E+1
  #|redx103 reduce  1.1E+1      -> 11
  #|redx104 reduce  1.0E+1      -> 1E+1
  #|redx105 reduce  1.10E+2     -> 1.1E+2

///|
test "reduce.decTest subset" {
  let cases = parse_dectest(reduce_subset)
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
    abort("reduce.decTest failures")
  }
}
