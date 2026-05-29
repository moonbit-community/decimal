///|
/// First 60 cases each from `scaleb.decTest` and `rescale.decTest`.
let scaleb_subset : String =
  #|precision:   9
  #|rounding:    half_up
  #|maxExponent: 999
  #|minExponent: -999
  #|scbx001 scaleb       7.50   10 -> 7.50E+10
  #|scbx002 scaleb       7.50    3 -> 7.50E+3
  #|scbx003 scaleb       7.50    2 -> 750
  #|scbx004 scaleb       7.50    1 -> 75.0
  #|scbx005 scaleb       7.50    0 -> 7.50
  #|scbx006 scaleb       7.50   -1 -> 0.750
  #|scbx007 scaleb       7.50   -2 -> 0.0750
  #|scbx008 scaleb       7.50  -10 -> 7.50E-10
  #|scbx009 scaleb      -7.50    3 -> -7.50E+3
  #|scbx010 scaleb      -7.50    2 -> -750
  #|scbx011 scaleb      -7.50    1 -> -75.0
  #|scbx012 scaleb      -7.50    0 -> -7.50
  #|scbx013 scaleb      -7.50   -1 -> -0.750
  #|scbx014 scaleb  Infinity   1 -> Infinity
  #|scbx015 scaleb  -Infinity  2 -> -Infinity
  #|scbx016 scaleb  Infinity  -1 -> Infinity
  #|scbx017 scaleb  -Infinity -2 -> -Infinity
  #|scbx018 scaleb  10  Infinity -> NaN Invalid_operation
  #|scbx019 scaleb  10 -Infinity -> NaN Invalid_operation
  #|scbx021 scaleb         NaN  1 -> NaN
  #|scbx022 scaleb        -NaN -1 -> -NaN
  #|scbx025 scaleb    4    NaN    -> NaN
  #|scbx026 scaleb -Inf   -NaN    -> -NaN
  #|scbx030 scaleb  1.23    1    ->  12.3
  #|scbx031 scaleb  1.23    1.00 ->  NaN Invalid_operation
  #|scbx032 scaleb  1.23    1.1  ->  NaN Invalid_operation
  #|scbx033 scaleb  1.23    1.01 ->  NaN Invalid_operation
  #|scbx034 scaleb  1.23    0.01 ->  NaN Invalid_operation
  #|scbx035 scaleb  1.23    0.11 ->  NaN Invalid_operation
  #|scbx036 scaleb  1.23    0.999999999 ->  NaN Invalid_operation
  #|scbx037 scaleb  1.23   -1    ->  0.123
  #|scbx038 scaleb  1.23   -1.00 ->  NaN Invalid_operation
  #|scbx039 scaleb  1.23   -1.1  ->  NaN Invalid_operation
  #|scbx040 scaleb  1.23   -1.01 ->  NaN Invalid_operation
  #|scbx041 scaleb  1.23   -0.01 ->  NaN Invalid_operation
  #|scbx042 scaleb  1.23   -0.11 ->  NaN Invalid_operation
  #|scbx043 scaleb  1.23   -0.999999999 ->  NaN Invalid_operation
  #|scbx044 scaleb  1.23    0.1         ->  NaN Invalid_operation
  #|scbx045 scaleb  1.23    1E+1        ->  NaN Invalid_operation
  #|scbx046 scaleb  1.23    1.1234E+6   ->  NaN Invalid_operation
  #|scbx047 scaleb  1.23    1.123E+4    ->  NaN Invalid_operation
  #|scbx122 scaleb  1.23    2017        ->  NaN Invalid_operation
  #|scbx123 scaleb  1.23    2018        ->  NaN Invalid_operation
  #|scbx126 scaleb  1.23   -2017        ->  NaN Invalid_operation
  #|scbx127 scaleb  1.23   -2018        ->  NaN Invalid_operation
  #|scbx861 scaleb  NaN01   -Inf     ->  NaN1
  #|scbx862 scaleb -NaN02   -1000    -> -NaN2
  #|scbx863 scaleb  NaN03    1000    ->  NaN3
  #|scbx864 scaleb  NaN04    Inf     ->  NaN4
  #|scbx865 scaleb  NaN05    NaN61   ->  NaN5
  #|scbx866 scaleb -Inf     -NaN71   -> -NaN71
  #|scbx867 scaleb -1000     NaN81   ->  NaN81
  #|scbx868 scaleb  1000     NaN91   ->  NaN91
  #|scbx869 scaleb  Inf      NaN101  ->  NaN101
  #|scbx051 scaleb          7   -2  -> 0.07
  #|scbx052 scaleb         -7   -2  -> -0.07
  #|scbx053 scaleb         75   -2  -> 0.75
  #|scbx054 scaleb        -75   -2  -> -0.75
  #|scbx055 scaleb       7.50   -2  -> 0.0750
  #|scbx056 scaleb      -7.50   -2  -> -0.0750

///|
let rescale_subset : String =
  #|precision:   9
  #|rounding:    half_up
  #|maxExponent: 999
  #|minexponent: -999
  #|resx001 rescale 0       0   -> 0
  #|resx002 rescale 1       0   -> 1
  #|resx003 rescale 0.1    +2   -> 0E+2 Inexact Rounded
  #|resx005 rescale 0.1    +1   -> 0E+1 Inexact Rounded
  #|resx006 rescale 0.1     0   -> 0 Inexact Rounded
  #|resx007 rescale 0.1    -1   -> 0.1
  #|resx008 rescale 0.1    -2   -> 0.10
  #|resx009 rescale 0.1    -3   -> 0.100
  #|resx010 rescale 0.9    +2   -> 0E+2 Inexact Rounded
  #|resx011 rescale 0.9    +1   -> 0E+1 Inexact Rounded
  #|resx012 rescale 0.9    +0   -> 1 Inexact Rounded
  #|resx013 rescale 0.9    -1   -> 0.9
  #|resx014 rescale 0.9    -2   -> 0.90
  #|resx015 rescale 0.9    -3   -> 0.900
  #|resx021 rescale -0      0   -> -0
  #|resx022 rescale -1      0   -> -1
  #|resx023 rescale -0.1   +2   -> -0E+2 Inexact Rounded
  #|resx025 rescale -0.1   +1   -> -0E+1 Inexact Rounded
  #|resx026 rescale -0.1    0   -> -0 Inexact Rounded
  #|resx027 rescale -0.1   -1   -> -0.1
  #|resx028 rescale -0.1   -2   -> -0.10
  #|resx029 rescale -0.1   -3   -> -0.100
  #|resx030 rescale -0.9   +2   -> -0E+2 Inexact Rounded
  #|resx031 rescale -0.9   +1   -> -0E+1 Inexact Rounded
  #|resx032 rescale -0.9   +0   -> -1 Inexact Rounded
  #|resx033 rescale -0.9   -1   -> -0.9
  #|resx034 rescale -0.9   -2   -> -0.90
  #|resx035 rescale -0.9   -3   -> -0.900
  #|resx036 rescale -0.5   +2   -> -0E+2 Inexact Rounded
  #|resx037 rescale -0.5   +1   -> -0E+1 Inexact Rounded
  #|resx038 rescale -0.5   +0   -> -1 Inexact Rounded
  #|resx039 rescale -0.5   -1   -> -0.5
  #|resx040 rescale -0.5   -2   -> -0.50
  #|resx041 rescale -0.5   -3   -> -0.500
  #|resx042 rescale -0.9   +2   -> -0E+2 Inexact Rounded
  #|resx043 rescale -0.9   +1   -> -0E+1 Inexact Rounded
  #|resx044 rescale -0.9   +0   -> -1 Inexact Rounded
  #|resx045 rescale -0.9   -1   -> -0.9
  #|resx046 rescale -0.9   -2   -> -0.90
  #|resx047 rescale -0.9   -3   -> -0.900
  #|resx060 rescale 2.17   -3   -> 2.170
  #|resx061 rescale 2.17   -2   -> 2.17
  #|resx062 rescale 2.17   -1   -> 2.2 Inexact Rounded
  #|resx063 rescale 2.17    0   -> 2 Inexact Rounded
  #|resx064 rescale 2.17   +1   -> 0E+1 Inexact Rounded
  #|resx065 rescale 2      Inf  -> NaN Invalid_operation
  #|resx066 rescale -0.1    0   -> -0 Inexact Rounded
  #|resx067 rescale -0      5   -> -0E+5
  #|resx068 rescale +35236450.6 -2 -> NaN Invalid_operation
  #|resx069 rescale -35236450.6 -2 -> NaN Invalid_operation
  #|resx070 rescale 217    -1   -> 217.0
  #|resx071 rescale 217     0   -> 217
  #|resx072 rescale 217    +1   -> 2.2E+2 Inexact Rounded
  #|resx073 rescale 217    +2   -> 2E+2 Inexact Rounded
  #|resx089 rescale 12     +4   -> 0E+4 Inexact Rounded
  #|resx090 rescale 12     +3   -> 0E+3 Inexact Rounded
  #|resx091 rescale 12     +2   -> 0E+2 Inexact Rounded
  #|resx092 rescale 12     +1   -> 1E+1 Inexact Rounded
  #|resx093 rescale 1.2345 -2   -> 1.23 Inexact Rounded
  #|resx094 rescale 1.2355 -2   -> 1.24 Inexact Rounded

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
test "scaleb.decTest subset" {
  run_subset("scaleb", scaleb_subset, 60)
}

///|
test "rescale.decTest subset" {
  run_subset("rescale", rescale_subset, 60)
}
