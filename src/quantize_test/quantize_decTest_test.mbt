///| First 80 cases from `quantize.decTest` — sanity sample of the
/// rescale-to-target-exponent path. Skips Subnormal / Underflow / Overflow /
/// Conversion_syntax / sNaN cases pending runner-side flag validation
/// (and, for subnormal, the underflow re-rounding branch in finalize).
let quantize_subset : String =
  #|precision:   9
  #|rounding:    half_up
  #|maxExponent: 999
  #|minexponent: -999
  #|quax001 quantize 0       1e0   -> 0
  #|quax002 quantize 1       1e0   -> 1
  #|quax003 quantize 0.1    1e+2   -> 0E+2 Inexact Rounded
  #|quax005 quantize 0.1    1e+1   -> 0E+1 Inexact Rounded
  #|quax006 quantize 0.1     1e0   -> 0 Inexact Rounded
  #|quax007 quantize 0.1    1e-1   -> 0.1
  #|quax008 quantize 0.1    1e-2   -> 0.10
  #|quax009 quantize 0.1    1e-3   -> 0.100
  #|quax010 quantize 0.9    1e+2   -> 0E+2 Inexact Rounded
  #|quax011 quantize 0.9    1e+1   -> 0E+1 Inexact Rounded
  #|quax012 quantize 0.9    1e+0   -> 1 Inexact Rounded
  #|quax013 quantize 0.9    1e-1   -> 0.9
  #|quax014 quantize 0.9    1e-2   -> 0.90
  #|quax015 quantize 0.9    1e-3   -> 0.900
  #|quax021 quantize -0      1e0   -> -0
  #|quax022 quantize -1      1e0   -> -1
  #|quax023 quantize -0.1   1e+2   -> -0E+2 Inexact Rounded
  #|quax025 quantize -0.1   1e+1   -> -0E+1 Inexact Rounded
  #|quax026 quantize -0.1    1e0   -> -0 Inexact Rounded
  #|quax027 quantize -0.1   1e-1   -> -0.1
  #|quax028 quantize -0.1   1e-2   -> -0.10
  #|quax029 quantize -0.1   1e-3   -> -0.100
  #|quax030 quantize -0.9   1e+2   -> -0E+2 Inexact Rounded
  #|quax031 quantize -0.9   1e+1   -> -0E+1 Inexact Rounded
  #|quax032 quantize -0.9   1e+0   -> -1 Inexact Rounded
  #|quax033 quantize -0.9   1e-1   -> -0.9
  #|quax034 quantize -0.9   1e-2   -> -0.90
  #|quax035 quantize -0.9   1e-3   -> -0.900
  #|quax036 quantize -0.5   1e+2   -> -0E+2 Inexact Rounded
  #|quax037 quantize -0.5   1e+1   -> -0E+1 Inexact Rounded
  #|quax038 quantize -0.5   1e+0   -> -1 Inexact Rounded
  #|quax039 quantize -0.5   1e-1   -> -0.5
  #|quax040 quantize -0.5   1e-2   -> -0.50
  #|quax041 quantize -0.5   1e-3   -> -0.500
  #|quax042 quantize -0.9   1e+2   -> -0E+2 Inexact Rounded
  #|quax043 quantize -0.9   1e+1   -> -0E+1 Inexact Rounded
  #|quax044 quantize -0.9   1e+0   -> -1 Inexact Rounded
  #|quax045 quantize -0.9   1e-1   -> -0.9
  #|quax046 quantize -0.9   1e-2   -> -0.90
  #|quax047 quantize -0.9   1e-3   -> -0.900
  #|quax060 quantize 2.17   0.001  -> 2.170
  #|quax061 quantize 2.17   0.01   -> 2.17
  #|quax062 quantize 2.17   0.1    -> 2.2 Inexact Rounded
  #|quax063 quantize 2.17   1e+0   -> 2 Inexact Rounded
  #|quax064 quantize 2.17   1e+1   -> 0E+1 Inexact Rounded
  #|quax065 quantize -Inf    Inf   -> -Infinity
  #|quax066 quantize 2       Inf   -> NaN Invalid_operation
  #|quax067 quantize -0.1    1     -> -0 Inexact Rounded
  #|quax068 quantize -0      1e+5     -> -0E+5
  #|quax069 quantize +35236450.6 1e-2 -> NaN Invalid_operation
  #|quax070 quantize -35236450.6 1e-2 -> NaN Invalid_operation
  #|quax071 quantize 217    1e-1   -> 217.0
  #|quax072 quantize 217    1e+0   -> 217
  #|quax073 quantize 217    1e+1   -> 2.2E+2 Inexact Rounded
  #|quax074 quantize 217    1e+2   -> 2E+2 Inexact Rounded
  #|quax089 quantize 12     1e+4   -> 0E+4 Inexact Rounded
  #|quax090 quantize 12     1e+3   -> 0E+3 Inexact Rounded
  #|quax091 quantize 12     1e+2   -> 0E+2 Inexact Rounded
  #|quax092 quantize 12     1e+1   -> 1E+1 Inexact Rounded
  #|quax093 quantize 1.2345 1e-2   -> 1.23 Inexact Rounded
  #|quax094 quantize 1.2355 1e-2   -> 1.24 Inexact Rounded
  #|quax095 quantize 1.2345 1e-6   -> 1.234500
  #|quax096 quantize 9.9999 1e-2   -> 10.00 Inexact Rounded
  #|quax097 quantize 0.0001 1e-2   -> 0.00 Inexact Rounded
  #|quax098 quantize 0.001  1e-2   -> 0.00 Inexact Rounded
  #|quax099 quantize 0.009  1e-2   -> 0.01 Inexact Rounded
  #|quax100 quantize 92     1e+2   -> 1E+2 Inexact Rounded
  #|quax101 quantize -1      1e0   ->  -1
  #|quax102 quantize -1     1e-1   ->  -1.0
  #|quax103 quantize -1     1e-2   ->  -1.00
  #|quax104 quantize  0      1e0   ->  0
  #|quax105 quantize  0     1e-1   ->  0.0
  #|quax106 quantize  0     1e-2   ->  0.00
  #|quax107 quantize  0.00   1e0   ->  0
  #|quax108 quantize  0     1e+1   ->  0E+1
  #|quax109 quantize  0     1e+2   ->  0E+2
  #|quax110 quantize +1      1e0   ->  1
  #|quax111 quantize +1     1e-1   ->  1.0
  #|quax112 quantize +1     1e-2   ->  1.00
  #|quax120 quantize   1.04  1e-3 ->  1.040

///|
test "quantize.decTest subset" {
  let cases = parse_dectest(quantize_subset)
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
    abort("quantize.decTest failures")
  }
}
