///| `copy` cases from `copy.decTest`, filtered to those that need
/// neither rounding nor a GDA `#` null operand. Copy ops never signal,
/// so this subset has no condition-dependent skips.
let copy_subset : String =
  #|cpyx001 copy       +7.50  -> 7.50
  #|cpyx011 copy  Infinity    -> Infinity
  #|cpyx012 copy  -Infinity   -> -Infinity
  #|cpyx021 copy         NaN  -> NaN
  #|cpyx022 copy        -NaN  -> -NaN
  #|cpyx023 copy        sNaN  -> sNaN
  #|cpyx024 copy       -sNaN  -> -sNaN
  #|cpyx031 copy       NaN10  -> NaN10
  #|cpyx032 copy      -NaN10  -> -NaN10
  #|cpyx033 copy      sNaN10  -> sNaN10
  #|cpyx034 copy     -sNaN10  -> -sNaN10
  #|cpyx035 copy       NaN7   -> NaN7
  #|cpyx036 copy      -NaN7   -> -NaN7
  #|cpyx037 copy      sNaN101 -> sNaN101
  #|cpyx038 copy     -sNaN101 -> -sNaN101
  #|cpyx101 copy          7   -> 7
  #|cpyx102 copy         -7   -> -7
  #|cpyx103 copy         75   -> 75
  #|cpyx104 copy        -75   -> -75
  #|cpyx105 copy       7.50   -> 7.50
  #|cpyx106 copy      -7.50   -> -7.50
  #|cpyx107 copy       7.500  -> 7.500
  #|cpyx108 copy      -7.500  -> -7.500
  #|cpyx111 copy          0   -> 0
  #|cpyx112 copy         -0   -> -0
  #|cpyx113 copy       0E+4   -> 0E+4
  #|cpyx114 copy      -0E+4   -> -0E+4
  #|cpyx115 copy     0.0000   -> 0.0000
  #|cpyx116 copy    -0.0000   -> -0.0000
  #|cpyx117 copy      0E-141  -> 0E-141
  #|cpyx118 copy     -0E-141  -> -0E-141
  #|cpyx121 copy   268268268        -> 268268268
  #|cpyx122 copy  -268268268        -> -268268268
  #|cpyx123 copy   134134134        -> 134134134
  #|cpyx124 copy  -134134134        -> -134134134
  #|cpyx131 copy  9.99999999E+999   -> 9.99999999E+999
  #|cpyx132 copy  1E-999            -> 1E-999
  #|cpyx133 copy  1.00000000E-999   -> 1.00000000E-999
  #|cpyx134 copy  1E-1007           -> 1E-1007
  #|cpyx135 copy  -1E-1007          -> -1E-1007
  #|cpyx136 copy  -1.00000000E-999  -> -1.00000000E-999
  #|cpyx137 copy  -1E-999           -> -1E-999
  #|cpyx138 copy  -9.99999999E+999  -> -9.99999999E+999

///|
test "copy.decTest subset round-trips through parse + copy + toSci" {
  let cases = parse_dectest(copy_subset)
  assert_eq(cases.length(), 43)
  let (failures, _) = run_cases_with_flags(cases)
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
