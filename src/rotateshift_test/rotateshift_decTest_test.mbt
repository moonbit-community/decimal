///| First 60 cases each from `rotate.decTest` and `shift.decTest`.
/// Skips sNaN cases pending runner-side flag validation.
let rotate_subset : String =
  #|precision:   9
  #|rounding:    half_up
  #|maxExponent: 999
  #|minExponent: -999
  #|rotx001 rotate          0    0  ->  0
  #|rotx002 rotate          0    2  ->  0
  #|rotx003 rotate          1    2  ->  100
  #|rotx004 rotate         34    8  ->  400000003
  #|rotx005 rotate          1    9  ->  1
  #|rotx006 rotate          1   -1  ->  100000000
  #|rotx007 rotate  123456789   -1  ->  912345678
  #|rotx008 rotate  123456789   -8  ->  234567891
  #|rotx009 rotate  123456789   -9  ->  123456789
  #|rotx010 rotate          0   -2  ->  0
  #|rotx011 rotate        1    1.5    -> NaN Invalid_operation
  #|rotx012 rotate        1    1.0    -> NaN Invalid_operation
  #|rotx013 rotate        1    0.1    -> NaN Invalid_operation
  #|rotx014 rotate        1    0.0    -> NaN Invalid_operation
  #|rotx015 rotate        1    1E+1   -> NaN Invalid_operation
  #|rotx016 rotate        1    1E+99  -> NaN Invalid_operation
  #|rotx017 rotate        1    Inf    -> NaN Invalid_operation
  #|rotx018 rotate        1    -Inf   -> NaN Invalid_operation
  #|rotx020 rotate        1    -1000  -> NaN Invalid_operation
  #|rotx021 rotate        1    -10    -> NaN Invalid_operation
  #|rotx022 rotate        1     10    -> NaN Invalid_operation
  #|rotx023 rotate        1     1000  -> NaN Invalid_operation
  #|rotx030 rotate  123456789          -9   -> 123456789
  #|rotx031 rotate  123456789          -8   -> 234567891
  #|rotx032 rotate  123456789          -7   -> 345678912
  #|rotx033 rotate  123456789          -6   -> 456789123
  #|rotx034 rotate  123456789          -5   -> 567891234
  #|rotx035 rotate  123456789          -4   -> 678912345
  #|rotx036 rotate  123456789          -3   -> 789123456
  #|rotx037 rotate  123456789          -2   -> 891234567
  #|rotx038 rotate  123456789          -1   -> 912345678
  #|rotx039 rotate  123456789          -0   -> 123456789
  #|rotx040 rotate  123456789          +0   -> 123456789
  #|rotx041 rotate  123456789          +1   -> 234567891
  #|rotx042 rotate  123456789          +2   -> 345678912
  #|rotx043 rotate  123456789          +3   -> 456789123
  #|rotx044 rotate  123456789          +4   -> 567891234
  #|rotx045 rotate  123456789          +5   -> 678912345
  #|rotx046 rotate  123456789          +6   -> 789123456
  #|rotx047 rotate  123456789          +7   -> 891234567
  #|rotx048 rotate  123456789          +8   -> 912345678
  #|rotx049 rotate  123456789          +9   -> 123456789
  #|rotx060 rotate  0E-10              +9   ->   0E-10
  #|rotx061 rotate  0E-10              -9   ->   0E-10
  #|rotx062 rotate  0.000              +9   ->   0.000
  #|rotx063 rotate  0.000              -9   ->   0.000
  #|rotx064 rotate  0E+10              +9   ->   0E+10
  #|rotx065 rotate  0E+10              -9   ->   0E+10
  #|rotx066 rotate -0E-10              +9   ->  -0E-10
  #|rotx067 rotate -0E-10              -9   ->  -0E-10
  #|rotx068 rotate -0.000              +9   ->  -0.000
  #|rotx069 rotate -0.000              -9   ->  -0.000
  #|rotx070 rotate -0E+10              +9   ->  -0E+10
  #|rotx071 rotate -0E+10              -9   ->  -0E+10
  #|rotx141 rotate  9.99999999E+999     -1  -> 9.99999999E+999
  #|rotx142 rotate  9.99999999E+999     -8  -> 9.99999999E+999
  #|rotx143 rotate  9.99999999E+999      1  -> 9.99999999E+999
  #|rotx144 rotate  9.99999999E+999      8  -> 9.99999999E+999
  #|rotx145 rotate  1E-999              -1  -> 1.00000000E-991
  #|rotx146 rotate  1E-999              -8  -> 1.0E-998

let shift_subset : String =
  #|precision:   9
  #|rounding:    half_up
  #|maxExponent: 999
  #|minExponent: -999
  #|shix001 shift          0    0  ->  0
  #|shix002 shift          0    2  ->  0
  #|shix003 shift          1    2  ->  100
  #|shix004 shift          1    8  ->  100000000
  #|shix005 shift          1    9  ->  0
  #|shix006 shift          1   -1  ->  0
  #|shix007 shift  123456789   -1  ->  12345678
  #|shix008 shift  123456789   -8  ->  1
  #|shix009 shift  123456789   -9  ->  0
  #|shix010 shift          0   -2  ->  0
  #|shix011 shift        1    1.5    -> NaN Invalid_operation
  #|shix012 shift        1    1.0    -> NaN Invalid_operation
  #|shix013 shift        1    0.1    -> NaN Invalid_operation
  #|shix014 shift        1    0.0    -> NaN Invalid_operation
  #|shix015 shift        1    1E+1   -> NaN Invalid_operation
  #|shix016 shift        1    1E+99  -> NaN Invalid_operation
  #|shix017 shift        1    Inf    -> NaN Invalid_operation
  #|shix018 shift        1    -Inf   -> NaN Invalid_operation
  #|shix020 shift        1    -1000  -> NaN Invalid_operation
  #|shix021 shift        1    -10    -> NaN Invalid_operation
  #|shix022 shift        1     10    -> NaN Invalid_operation
  #|shix023 shift        1     1000  -> NaN Invalid_operation
  #|shix030 shift  123456789          -9   -> 0
  #|shix031 shift  123456789          -8   -> 1
  #|shix032 shift  123456789          -7   -> 12
  #|shix033 shift  123456789          -6   -> 123
  #|shix034 shift  123456789          -5   -> 1234
  #|shix035 shift  123456789          -4   -> 12345
  #|shix036 shift  123456789          -3   -> 123456
  #|shix037 shift  123456789          -2   -> 1234567
  #|shix038 shift  123456789          -1   -> 12345678
  #|shix039 shift  123456789          -0   -> 123456789
  #|shix040 shift  123456789          +0   -> 123456789
  #|shix041 shift  123456789          +1   -> 234567890
  #|shix042 shift  123456789          +2   -> 345678900
  #|shix043 shift  123456789          +3   -> 456789000
  #|shix044 shift  123456789          +4   -> 567890000
  #|shix045 shift  123456789          +5   -> 678900000
  #|shix046 shift  123456789          +6   -> 789000000
  #|shix047 shift  123456789          +7   -> 890000000
  #|shix048 shift  123456789          +8   -> 900000000
  #|shix049 shift  123456789          +9   -> 0
  #|shix051 shift 34        8   ->  '400000000'
  #|shix052 shift 12        9   ->  '0'
  #|shix053 shift 123456789 -2  ->  '1234567'
  #|shix054 shift 123456789 0   ->  '123456789'
  #|shix055 shift 123456789 +2  ->  '345678900'
  #|shix060 shift  0E-10              +9   ->   0E-10
  #|shix061 shift  0E-10              -9   ->   0E-10
  #|shix062 shift  0.000              +9   ->   0.000
  #|shix063 shift  0.000              -9   ->   0.000
  #|shix064 shift  0E+10              +9   ->   0E+10
  #|shix065 shift  0E+10              -9   ->   0E+10
  #|shix066 shift -0E-10              +9   ->  -0E-10
  #|shix067 shift -0E-10              -9   ->  -0E-10
  #|shix068 shift -0.000              +9   ->  -0.000
  #|shix069 shift -0.000              -9   ->  -0.000
  #|shix070 shift -0E+10              +9   ->  -0E+10
  #|shix071 shift -0E+10              -9   ->  -0E+10
  #|shix141 shift  9.99999999E+999     -1  -> 9.9999999E+998

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
test "rotate.decTest subset" {
  run_subset("rotate", rotate_subset, 60)
}

///|
test "shift.decTest subset" {
  run_subset("shift", shift_subset, 60)
}
