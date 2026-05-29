///| First 80 cases from `compare.decTest` (the sanity / Inf / sign group).
/// Skips NaN-returning cases tagged `Invalid_operation` and sNaN cases —
/// those need flag-validation support in the runner.
let compare_subset : String =
  #|precision:   9
  #|rounding:    half_up
  #|maxExponent: 999
  #|minexponent: -999
  #|comx001 compare  -2  -2  -> 0
  #|comx002 compare  -2  -1  -> -1
  #|comx003 compare  -2   0  -> -1
  #|comx004 compare  -2   1  -> -1
  #|comx005 compare  -2   2  -> -1
  #|comx006 compare  -1  -2  -> 1
  #|comx007 compare  -1  -1  -> 0
  #|comx008 compare  -1   0  -> -1
  #|comx009 compare  -1   1  -> -1
  #|comx010 compare  -1   2  -> -1
  #|comx011 compare   0  -2  -> 1
  #|comx012 compare   0  -1  -> 1
  #|comx013 compare   0   0  -> 0
  #|comx014 compare   0   1  -> -1
  #|comx015 compare   0   2  -> -1
  #|comx016 compare   1  -2  -> 1
  #|comx017 compare   1  -1  -> 1
  #|comx018 compare   1   0  -> 1
  #|comx019 compare   1   1  -> 0
  #|comx020 compare   1   2  -> -1
  #|comx021 compare   2  -2  -> 1
  #|comx022 compare   2  -1  -> 1
  #|comx023 compare   2   0  -> 1
  #|comx025 compare   2   1  -> 1
  #|comx026 compare   2   2  -> 0
  #|comx031 compare  -20  -20  -> 0
  #|comx032 compare  -20  -10  -> -1
  #|comx033 compare  -20   00  -> -1
  #|comx034 compare  -20   10  -> -1
  #|comx035 compare  -20   20  -> -1
  #|comx036 compare  -10  -20  -> 1
  #|comx037 compare  -10  -10  -> 0
  #|comx038 compare  -10   00  -> -1
  #|comx039 compare  -10   10  -> -1
  #|comx040 compare  -10   20  -> -1
  #|comx041 compare   00  -20  -> 1
  #|comx042 compare   00  -10  -> 1
  #|comx043 compare   00   00  -> 0
  #|comx044 compare   00   10  -> -1
  #|comx045 compare   00   20  -> -1
  #|comx046 compare   10  -20  -> 1
  #|comx047 compare   10  -10  -> 1
  #|comx048 compare   10   00  -> 1
  #|comx049 compare   10   10  -> 0
  #|comx050 compare   10   20  -> -1
  #|comx051 compare   20  -20  -> 1
  #|comx052 compare   20  -10  -> 1
  #|comx053 compare   20   00  -> 1
  #|comx055 compare   20   10  -> 1
  #|comx056 compare   20   20  -> 0
  #|comx061 compare  -2.0  -2.0  -> 0
  #|comx062 compare  -2.0  -1.0  -> -1
  #|comx063 compare  -2.0   0.0  -> -1
  #|comx064 compare  -2.0   1.0  -> -1
  #|comx065 compare  -2.0   2.0  -> -1
  #|comx066 compare  -1.0  -2.0  -> 1
  #|comx067 compare  -1.0  -1.0  -> 0
  #|comx068 compare  -1.0   0.0  -> -1
  #|comx069 compare  -1.0   1.0  -> -1
  #|comx070 compare  -1.0   2.0  -> -1
  #|comx071 compare   0.0  -2.0  -> 1
  #|comx072 compare   0.0  -1.0  -> 1
  #|comx073 compare   0.0   0.0  -> 0
  #|comx074 compare   0.0   1.0  -> -1
  #|comx075 compare   0.0   2.0  -> -1
  #|comx076 compare   1.0  -2.0  -> 1
  #|comx077 compare   1.0  -1.0  -> 1
  #|comx078 compare   1.0   0.0  -> 1
  #|comx079 compare   1.0   1.0  -> 0
  #|comx080 compare   1.0   2.0  -> -1
  #|comx081 compare   2.0  -2.0  -> 1
  #|comx082 compare   2.0  -1.0  -> 1
  #|comx083 compare   2.0   0.0  -> 1
  #|comx085 compare   2.0   1.0  -> 1
  #|comx086 compare   2.0   2.0  -> 0
  #|maxexponent: 999999999
  #|minexponent: -999999999
  #|comx095 compare  9.99999999E+999999999 9.99999999E+999999999  -> 0
  #|comx096 compare -9.99999999E+999999999 9.99999999E+999999999  -> -1
  #|comx097 compare  9.99999999E+999999999 -9.99999999E+999999999 -> 1
  #|comx098 compare -9.99999999E+999999999 -9.99999999E+999999999 -> 0
  #|comx100 compare   7.0    7.0    -> 0

///|
test "compare.decTest subset round-trips through parse + compare + toSci" {
  let cases = parse_dectest(compare_subset)
  assert_eq(cases.length(), 80)
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
    abort("compare.decTest failures")
  }
}
