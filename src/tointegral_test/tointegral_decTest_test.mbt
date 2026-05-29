///|
/// First 60 cases each from `tointegral.decTest` and `tointegralx.decTest`.
/// Distinct test bodies because the two ops differ only in whether
/// `Inexact` / `Rounded` are raised on rounded results — the runner
/// currently only validates output strings, so the visible result is
/// identical, but the two GDA files probe different input ranges.
let tointegral_subset : String =
  #|precision:   9
  #|rounding:    half_up
  #|maxExponent: 999
  #|minExponent: -999
  #|intx001 tointegral      0     ->  0
  #|intx002 tointegral      0.0   ->  0
  #|intx003 tointegral      0.1   ->  0
  #|intx004 tointegral      0.2   ->  0
  #|intx005 tointegral      0.3   ->  0
  #|intx006 tointegral      0.4   ->  0
  #|intx007 tointegral      0.5   ->  1
  #|intx008 tointegral      0.6   ->  1
  #|intx009 tointegral      0.7   ->  1
  #|intx010 tointegral      0.8   ->  1
  #|intx011 tointegral      0.9   ->  1
  #|intx012 tointegral      1     ->  1
  #|intx013 tointegral      1.0   ->  1
  #|intx014 tointegral      1.1   ->  1
  #|intx015 tointegral      1.2   ->  1
  #|intx016 tointegral      1.3   ->  1
  #|intx017 tointegral      1.4   ->  1
  #|intx018 tointegral      1.5   ->  2
  #|intx019 tointegral      1.6   ->  2
  #|intx020 tointegral      1.7   ->  2
  #|intx021 tointegral      1.8   ->  2
  #|intx022 tointegral      1.9   ->  2
  #|intx031 tointegral     -0     -> -0
  #|intx032 tointegral     -0.0   -> -0
  #|intx033 tointegral     -0.1   -> -0
  #|intx034 tointegral     -0.2   -> -0
  #|intx035 tointegral     -0.3   -> -0
  #|intx036 tointegral     -0.4   -> -0
  #|intx037 tointegral     -0.5   -> -1
  #|intx038 tointegral     -0.6   -> -1
  #|intx039 tointegral     -0.7   -> -1
  #|intx040 tointegral     -0.8   -> -1
  #|intx041 tointegral     -0.9   -> -1
  #|intx042 tointegral     -1     -> -1
  #|intx043 tointegral     -1.0   -> -1
  #|intx044 tointegral     -1.1   -> -1
  #|intx045 tointegral     -1.2   -> -1
  #|intx046 tointegral     -1.3   -> -1
  #|intx047 tointegral     -1.4   -> -1
  #|intx048 tointegral     -1.5   -> -2
  #|intx049 tointegral     -1.6   -> -2
  #|intx050 tointegral     -1.7   -> -2
  #|intx051 tointegral     -1.8   -> -2
  #|intx052 tointegral     -1.9   -> -2
  #|intx053 tointegral    10E+30  -> 1.0E+31
  #|intx054 tointegral   -10E+30  -> -1.0E+31
  #|precision: 9
  #|intx060 tointegral '56267E-10'   -> '0'
  #|intx061 tointegral '56267E-5'    -> '1'
  #|intx062 tointegral '56267E-2'    -> '563'
  #|intx063 tointegral '56267E-1'    -> '5627'
  #|intx065 tointegral '56267E-0'    -> '56267'
  #|intx066 tointegral '56267E+0'    -> '56267'
  #|intx067 tointegral '56267E+1'    -> '5.6267E+5'
  #|intx068 tointegral '56267E+2'    -> '5.6267E+6'
  #|intx069 tointegral '56267E+3'    -> '5.6267E+7'
  #|intx070 tointegral '56267E+4'    -> '5.6267E+8'
  #|intx071 tointegral '56267E+5'    -> '5.6267E+9'
  #|intx072 tointegral '56267E+6'    -> '5.6267E+10'
  #|intx073 tointegral '1.23E+96'    -> '1.23E+96'
  #|intx074 tointegral '1.23E+384'   -> '1.23E+384'

///|
let tointegralx_subset : String =
  #|precision:   9
  #|rounding:    half_up
  #|maxExponent: 999
  #|minExponent: -999
  #|intxx001 tointegralx      0     ->  0
  #|intxx002 tointegralx      0.0   ->  0
  #|intxx003 tointegralx      0.1   ->  0 Inexact Rounded
  #|intxx004 tointegralx      0.2   ->  0 Inexact Rounded
  #|intxx005 tointegralx      0.3   ->  0 Inexact Rounded
  #|intxx006 tointegralx      0.4   ->  0 Inexact Rounded
  #|intxx007 tointegralx      0.5   ->  1 Inexact Rounded
  #|intxx008 tointegralx      0.6   ->  1 Inexact Rounded
  #|intxx009 tointegralx      0.7   ->  1 Inexact Rounded
  #|intxx010 tointegralx      0.8   ->  1 Inexact Rounded
  #|intxx011 tointegralx      0.9   ->  1 Inexact Rounded
  #|intxx012 tointegralx      1     ->  1
  #|intxx013 tointegralx      1.0   ->  1 Rounded
  #|intxx014 tointegralx      1.1   ->  1 Inexact Rounded
  #|intxx015 tointegralx      1.2   ->  1 Inexact Rounded
  #|intxx016 tointegralx      1.3   ->  1 Inexact Rounded
  #|intxx017 tointegralx      1.4   ->  1 Inexact Rounded
  #|intxx018 tointegralx      1.5   ->  2 Inexact Rounded
  #|intxx019 tointegralx      1.6   ->  2 Inexact Rounded
  #|intxx020 tointegralx      1.7   ->  2 Inexact Rounded
  #|intxx021 tointegralx      1.8   ->  2 Inexact Rounded
  #|intxx022 tointegralx      1.9   ->  2 Inexact Rounded
  #|intxx031 tointegralx     -0     -> -0
  #|intxx032 tointegralx     -0.0   -> -0
  #|intxx033 tointegralx     -0.1   -> -0 Inexact Rounded
  #|intxx034 tointegralx     -0.2   -> -0 Inexact Rounded
  #|intxx035 tointegralx     -0.3   -> -0 Inexact Rounded
  #|intxx036 tointegralx     -0.4   -> -0 Inexact Rounded
  #|intxx037 tointegralx     -0.5   -> -1 Inexact Rounded
  #|intxx038 tointegralx     -0.6   -> -1 Inexact Rounded
  #|intxx039 tointegralx     -0.7   -> -1 Inexact Rounded
  #|intxx040 tointegralx     -0.8   -> -1 Inexact Rounded
  #|intxx041 tointegralx     -0.9   -> -1 Inexact Rounded
  #|intxx042 tointegralx     -1     -> -1
  #|intxx043 tointegralx     -1.0   -> -1 Rounded
  #|intxx044 tointegralx     -1.1   -> -1 Inexact Rounded
  #|intxx045 tointegralx     -1.2   -> -1 Inexact Rounded
  #|intxx046 tointegralx     -1.3   -> -1 Inexact Rounded
  #|intxx047 tointegralx     -1.4   -> -1 Inexact Rounded
  #|intxx048 tointegralx     -1.5   -> -2 Inexact Rounded
  #|intxx049 tointegralx     -1.6   -> -2 Inexact Rounded
  #|intxx050 tointegralx     -1.7   -> -2 Inexact Rounded
  #|intxx051 tointegralx     -1.8   -> -2 Inexact Rounded
  #|intxx052 tointegralx     -1.9   -> -2 Inexact Rounded
  #|intxx053 tointegralx    10E+30  -> 1.0E+31
  #|intxx054 tointegralx   -10E+30  -> -1.0E+31
  #|precision: 9
  #|intxx060 tointegralx '56267E-10'   -> '0'               Inexact Rounded
  #|intxx061 tointegralx '56267E-5'    -> '1'               Inexact Rounded
  #|intxx062 tointegralx '56267E-2'    -> '563'             Inexact Rounded
  #|intxx063 tointegralx '56267E-1'    -> '5627'            Inexact Rounded
  #|intxx065 tointegralx '56267E-0'    -> '56267'
  #|intxx066 tointegralx '56267E+0'    -> '56267'
  #|intxx067 tointegralx '56267E+1'    -> '5.6267E+5'
  #|intxx068 tointegralx '56267E+2'    -> '5.6267E+6'
  #|intxx069 tointegralx '56267E+3'    -> '5.6267E+7'
  #|intxx070 tointegralx '56267E+4'    -> '5.6267E+8'
  #|intxx071 tointegralx '56267E+5'    -> '5.6267E+9'
  #|intxx072 tointegralx '56267E+6'    -> '5.6267E+10'
  #|intxx073 tointegralx '1.23E+96'    -> '1.23E+96'
  #|intxx074 tointegralx '1.23E+384'   -> '1.23E+384'

///|
fn run_subset(label : String, subset : String, expected : Int) -> Unit raise {
  let cases = parse_dectest(subset)
  assert_eq(cases.length(), expected)
  let (failures, _) = run_cases_with_flags(cases)
  if failures.length() > 0 {
    println("\{label}: \{failures.length()} of \{cases.length()} cases failed:")
    let limit = if failures.length() < 30 { failures.length() } else { 30 }
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
test "tointegral.decTest subset" {
  run_subset("tointegral", tointegral_subset, 60)
}

///|
test "tointegralx.decTest subset" {
  run_subset("tointegralx", tointegralx_subset, 60)
}
