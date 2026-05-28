///| `copynegate` cases from `copynegate.decTest`, filtered to those that need
/// neither rounding nor a GDA `#` null operand. Copy ops never signal,
/// so this subset has no condition-dependent skips.
let copynegate_subset : String =
  #|cpnx001 copynegate       +7.50  -> -7.50
  #|cpnx011 copynegate  Infinity    -> -Infinity
  #|cpnx012 copynegate  -Infinity   -> Infinity
  #|cpnx021 copynegate         NaN  -> -NaN
  #|cpnx022 copynegate        -NaN  -> NaN
  #|cpnx023 copynegate        sNaN  -> -sNaN
  #|cpnx024 copynegate       -sNaN  -> sNaN
  #|cpnx031 copynegate       NaN13  -> -NaN13
  #|cpnx032 copynegate      -NaN13  -> NaN13
  #|cpnx033 copynegate      sNaN13  -> -sNaN13
  #|cpnx034 copynegate     -sNaN13  -> sNaN13
  #|cpnx035 copynegate       NaN70  -> -NaN70
  #|cpnx036 copynegate      -NaN70  -> NaN70
  #|cpnx037 copynegate      sNaN101 -> -sNaN101
  #|cpnx038 copynegate     -sNaN101 -> sNaN101
  #|cpnx101 copynegate          7   -> -7
  #|cpnx102 copynegate         -7   -> 7
  #|cpnx103 copynegate         75   -> -75
  #|cpnx104 copynegate        -75   -> 75
  #|cpnx105 copynegate       7.50   -> -7.50
  #|cpnx106 copynegate      -7.50   -> 7.50
  #|cpnx107 copynegate       7.500  -> -7.500
  #|cpnx108 copynegate      -7.500  -> 7.500
  #|cpnx111 copynegate          0   -> -0
  #|cpnx112 copynegate         -0   -> 0
  #|cpnx113 copynegate       0E+4   -> -0E+4
  #|cpnx114 copynegate      -0E+4   -> 0E+4
  #|cpnx115 copynegate     0.0000   -> -0.0000
  #|cpnx116 copynegate    -0.0000   -> 0.0000
  #|cpnx117 copynegate      0E-141  -> -0E-141
  #|cpnx118 copynegate     -0E-141  -> 0E-141
  #|cpnx121 copynegate  268268268         -> -268268268
  #|cpnx122 copynegate  -268268268        -> 268268268
  #|cpnx123 copynegate  134134134         -> -134134134
  #|cpnx124 copynegate  -134134134        -> 134134134
  #|cpnx131 copynegate  9.99999999E+999   -> -9.99999999E+999
  #|cpnx132 copynegate  1E-999                     -> -1E-999
  #|cpnx133 copynegate  1.00000000E-999   -> -1.00000000E-999
  #|cpnx134 copynegate  1E-1007                    -> -1E-1007
  #|cpnx135 copynegate  -1E-1007                   -> 1E-1007
  #|cpnx136 copynegate  -1.00000000E-999  -> 1.00000000E-999
  #|cpnx137 copynegate  -1E-999                    -> 1E-999
  #|cpnx138 copynegate  -9.99999999E+999  -> 9.99999999E+999

///|
test "copynegate.decTest subset round-trips through parse + copynegate + toSci" {
  let cases = parse_dectest(copynegate_subset)
  assert_eq(cases.length(), 43)
  let (failures, _) = run_cases(cases)
  if failures.length() > 0 {
    let buf = StringBuilder::new()
    buf.write_string("\{failures.length()} of \{cases.length()} cases failed:\n")
    for f in failures {
      buf.write_string("  ")
      buf.write_string(f)
      buf.write_char('\n')
    }
    abort(buf.to_string())
  }
}
