///|
/// `copyabs` cases from `copyabs.decTest`, filtered to those that need
/// neither rounding nor a GDA `#` null operand. Copy ops never signal,
/// so this subset has no condition-dependent skips.
let copyabs_subset : String =
  #|cpax001 copyabs       +7.50  -> 7.50
  #|cpax011 copyabs  Infinity    -> Infinity
  #|cpax012 copyabs  -Infinity   -> Infinity
  #|cpax021 copyabs         NaN  -> NaN
  #|cpax022 copyabs        -NaN  -> NaN
  #|cpax023 copyabs        sNaN  -> sNaN
  #|cpax024 copyabs       -sNaN  -> sNaN
  #|cpax031 copyabs       NaN10  -> NaN10
  #|cpax032 copyabs      -NaN15  -> NaN15
  #|cpax033 copyabs      sNaN15  -> sNaN15
  #|cpax034 copyabs     -sNaN10  -> sNaN10
  #|cpax035 copyabs       NaN7   -> NaN7
  #|cpax036 copyabs      -NaN7   -> NaN7
  #|cpax037 copyabs      sNaN101 -> sNaN101
  #|cpax038 copyabs     -sNaN101 -> sNaN101
  #|cpax101 copyabs          7   -> 7
  #|cpax102 copyabs         -7   -> 7
  #|cpax103 copyabs         75   -> 75
  #|cpax104 copyabs        -75   -> 75
  #|cpax105 copyabs       7.10   -> 7.10
  #|cpax106 copyabs      -7.10   -> 7.10
  #|cpax107 copyabs       7.500  -> 7.500
  #|cpax108 copyabs      -7.500  -> 7.500
  #|cpax111 copyabs          0   -> 0
  #|cpax112 copyabs         -0   -> 0
  #|cpax113 copyabs       0E+6   -> 0E+6
  #|cpax114 copyabs      -0E+6   -> 0E+6
  #|cpax115 copyabs     0.0000   -> 0.0000
  #|cpax116 copyabs    -0.0000   -> 0.0000
  #|cpax117 copyabs      0E-141  -> 0E-141
  #|cpax118 copyabs     -0E-141  -> 0E-141
  #|cpax121 copyabs   268268268        -> 268268268
  #|cpax122 copyabs  -268268268        -> 268268268
  #|cpax123 copyabs   134134134        -> 134134134
  #|cpax124 copyabs  -134134134        -> 134134134
  #|cpax131 copyabs  9.99999999E+999   -> 9.99999999E+999
  #|cpax132 copyabs  1E-999            -> 1E-999
  #|cpax133 copyabs  1.00000000E-999   -> 1.00000000E-999
  #|cpax134 copyabs  1E-1007           -> 1E-1007
  #|cpax135 copyabs  -1E-1007          -> 1E-1007
  #|cpax136 copyabs  -1.00000000E-999  -> 1.00000000E-999
  #|cpax137 copyabs  -1E-999           -> 1E-999
  #|cpax199 copyabs  -9.99999999E+999  -> 9.99999999E+999

///|
test "copyabs.decTest subset round-trips through parse + copyabs + toSci" {
  let cases = parse_dectest(copyabs_subset)
  assert_eq(cases.length(), 43)
  let (failures, _) = run_cases_with_flags(cases)
  if failures.length() > 0 {
    let buf = StringBuilder::new()
    buf.write_string(
      "\{failures.length()} of \{cases.length()} cases failed:\n",
    )
    for f in failures {
      buf.write_string("  ")
      buf.write_string(f)
      buf.write_char('\n')
    }
    abort(buf.to_string())
  }
}
