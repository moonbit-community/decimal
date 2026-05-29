///| First 60 cases from `trim.decTest`.
let trim_subset : String =
  #|precision:   9
  #|rounding:    half_up
  #|maxExponent: 999
  #|minexponent: -999
  #|trmx001 trim '1'      -> '1'
  #|trmx002 trim '-1'     -> '-1'
  #|trmx003 trim '1.00'   -> '1'
  #|trmx004 trim '-1.00'  -> '-1'
  #|trmx005 trim '0'      -> '0'
  #|trmx006 trim '0.00'   -> '0'
  #|trmx007 trim '00.0'   -> '0'
  #|trmx008 trim '00.00'  -> '0'
  #|trmx009 trim '00'     -> '0'
  #|trmx010 trim '-2'     -> '-2'
  #|trmx011 trim '2'      -> '2'
  #|trmx012 trim '-2.00'  -> '-2'
  #|trmx013 trim '2.00'   -> '2'
  #|trmx014 trim '-0'     -> '-0'
  #|trmx015 trim '-0.00'  -> '-0'
  #|trmx016 trim '-00.0'  -> '-0'
  #|trmx017 trim '-00.00' -> '-0'
  #|trmx018 trim '-00'    -> '-0'
  #|trmx019 trim '0E+5'   -> '0'
  #|trmx020 trim '-0E+1'  -> '-0'
  #|trmx030 trim '+0.1'            -> '0.1'
  #|trmx031 trim '-0.1'            -> '-0.1'
  #|trmx032 trim '+0.01'           -> '0.01'
  #|trmx033 trim '-0.01'           -> '-0.01'
  #|trmx034 trim '+0.001'          -> '0.001'
  #|trmx035 trim '-0.001'          -> '-0.001'
  #|trmx036 trim '+0.000001'       -> '0.000001'
  #|trmx037 trim '-0.000001'       -> '-0.000001'
  #|trmx038 trim '+0.000000000001' -> '1E-12'
  #|trmx039 trim '-0.000000000001' -> '-1E-12'
  #|trmx041 trim 1.1        -> 1.1
  #|trmx042 trim 1.10       -> 1.1
  #|trmx043 trim 1.100      -> 1.1
  #|trmx044 trim 1.110      -> 1.11
  #|trmx045 trim -1.1       -> -1.1
  #|trmx046 trim -1.10      -> -1.1
  #|trmx047 trim -1.100     -> -1.1
  #|trmx048 trim -1.110     -> -1.11
  #|trmx049 trim 9.9        -> 9.9
  #|trmx050 trim 9.90       -> 9.9
  #|trmx051 trim 9.900      -> 9.9
  #|trmx052 trim 9.990      -> 9.99
  #|trmx053 trim -9.9       -> -9.9
  #|trmx054 trim -9.90      -> -9.9
  #|trmx055 trim -9.900     -> -9.9
  #|trmx056 trim -9.990     -> -9.99
  #|trmx060 trim  10.0        -> 10
  #|trmx061 trim  10.00       -> 10
  #|trmx062 trim  100.0       -> 100
  #|trmx063 trim  100.00      -> 100
  #|trmx064 trim  1.1000E+3   -> 1100
  #|trmx065 trim  1.10000E+3  -> 1100
  #|trmx066 trim -10.0        -> -10
  #|trmx067 trim -10.00       -> -10
  #|trmx068 trim -100.0       -> -100
  #|trmx069 trim -100.00      -> -100
  #|trmx070 trim -1.1000E+3   -> -1100
  #|trmx071 trim -1.10000E+3  -> -1100
  #|trmx080 trim  10E+1       -> 1E+2
  #|trmx081 trim  100E+1      -> 1E+3

///|
test "trim.decTest subset" {
  let cases = parse_dectest(trim_subset)
  assert_eq(cases.length(), 60)
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
    abort("trim.decTest failures")
  }
}
