///| First 100 cases from `divide.decTest` (the sanity / sign / trailing-zero
/// section). Skips cases tagged `Subnormal`, `Overflow`, `Underflow`,
/// `Clamped`, `Conversion_syntax`, or `Division_impossible` — those need
/// either subnormal handling (not yet shipped) or runner-side flag
/// validation (currently we only compare the rendered result string).
let divide_subset : String =
  #|precision:   9
  #|rounding:    half_up
  #|maxExponent: 384
  #|minexponent: -383
  #|divx001 divide  1     1    ->  1
  #|divx002 divide  2     1    ->  2
  #|divx003 divide  1     2    ->  0.5
  #|divx004 divide  2     2    ->  1
  #|divx005 divide  0     1    ->  0
  #|divx006 divide  0     2    ->  0
  #|divx007 divide  1     3    ->  0.333333333 Inexact Rounded
  #|divx008 divide  2     3    ->  0.666666667 Inexact Rounded
  #|divx009 divide  3     3    ->  1
  #|divx010 divide  2.4   1    ->  2.4
  #|divx011 divide  2.4   -1   ->  -2.4
  #|divx012 divide  -2.4  1    ->  -2.4
  #|divx013 divide  -2.4  -1   ->  2.4
  #|divx014 divide  2.40  1    ->  2.40
  #|divx015 divide  2.400 1    ->  2.400
  #|divx016 divide  2.4   2    ->  1.2
  #|divx017 divide  2.400 2    ->  1.200
  #|divx018 divide  2.    2    ->  1
  #|divx019 divide  20    20   ->  1
  #|divx020 divide  187   187    ->  1
  #|divx021 divide  5     2      ->  2.5
  #|divx022 divide  50    20     ->  2.5
  #|divx023 divide  500   200    ->  2.5
  #|divx024 divide  50.0  20.0   ->  2.5
  #|divx025 divide  5.00  2.00   ->  2.5
  #|divx026 divide  5     2.0    ->  2.5
  #|divx027 divide  5     2.000  ->  2.5
  #|divx028 divide  5     0.20   ->  25
  #|divx029 divide  5     0.200  ->  25
  #|divx030 divide  10    1      ->  10
  #|divx031 divide  100   1      ->  100
  #|divx032 divide  1000  1      ->  1000
  #|divx033 divide  1000  100    ->  10
  #|divx035 divide  1     2      ->  0.5
  #|divx036 divide  1     4      ->  0.25
  #|divx037 divide  1     8      ->  0.125
  #|divx038 divide  1     16     ->  0.0625
  #|divx039 divide  1     32     ->  0.03125
  #|divx040 divide  1     64     ->  0.015625
  #|divx041 divide  1    -2      ->  -0.5
  #|divx042 divide  1    -4      ->  -0.25
  #|divx043 divide  1    -8      ->  -0.125
  #|divx044 divide  1    -16     ->  -0.0625
  #|divx045 divide  1    -32     ->  -0.03125
  #|divx046 divide  1    -64     ->  -0.015625
  #|divx047 divide -1     2      ->  -0.5
  #|divx048 divide -1     4      ->  -0.25
  #|divx049 divide -1     8      ->  -0.125
  #|divx050 divide -1     16     ->  -0.0625
  #|divx051 divide -1     32     ->  -0.03125
  #|divx052 divide -1     64     ->  -0.015625
  #|divx053 divide -1    -2      ->  0.5
  #|divx054 divide -1    -4      ->  0.25
  #|divx055 divide -1    -8      ->  0.125
  #|divx056 divide -1    -16     ->  0.0625
  #|divx057 divide -1    -32     ->  0.03125
  #|divx058 divide -1    -64     ->  0.015625
  #|divx070 divide  999999999        1    ->  999999999
  #|divx071 divide  999999999.4      1    ->  999999999 Inexact Rounded
  #|divx072 divide  999999999.5      1    ->  1.00000000E+9 Inexact Rounded
  #|divx073 divide  999999999.9      1    ->  1.00000000E+9 Inexact Rounded
  #|divx074 divide  999999999.999    1    ->  1.00000000E+9 Inexact Rounded
  #|precision: 6
  #|divx080 divide  999999999     1  ->  1.00000E+9 Inexact Rounded
  #|divx081 divide  99999999      1  ->  1.00000E+8 Inexact Rounded
  #|divx082 divide  9999999       1  ->  1.00000E+7 Inexact Rounded
  #|divx083 divide  999999        1  ->  999999
  #|divx084 divide  99999         1  ->  99999
  #|divx085 divide  9999          1  ->  9999
  #|divx086 divide  999           1  ->  999
  #|divx087 divide  99            1  ->  99
  #|divx088 divide  9             1  ->  9
  #|precision: 9
  #|divx090 divide  0.            1    ->  0
  #|divx091 divide  .0            1    ->  0.0
  #|divx092 divide  0.00          1    ->  0.00
  #|divx093 divide  0.00E+9       1    ->  0E+7
  #|divx094 divide  0.0000E-50    1    ->  0E-54
  #|divx095 divide  1            1E-8  ->  1E+8
  #|divx096 divide  1            1E-9  ->  1E+9
  #|divx097 divide  1            1E-10 ->  1E+10
  #|divx098 divide  1            1E-11 ->  1E+11
  #|divx099 divide  1            1E-12 ->  1E+12
  #|divx100 divide  1  1   -> 1
  #|divx101 divide  1  2   -> 0.5
  #|divx102 divide  1  3   -> 0.333333333 Inexact Rounded
  #|divx103 divide  1  4   -> 0.25
  #|divx104 divide  1  5   -> 0.2
  #|divx105 divide  1  6   -> 0.166666667 Inexact Rounded
  #|divx106 divide  1  7   -> 0.142857143 Inexact Rounded
  #|divx107 divide  1  8   -> 0.125
  #|divx108 divide  1  9   -> 0.111111111 Inexact Rounded
  #|divx109 divide  1  10  -> 0.1
  #|divx110 divide  1  1   -> 1
  #|divx111 divide  2  1   -> 2
  #|divx112 divide  3  1   -> 3
  #|divx113 divide  4  1   -> 4
  #|divx114 divide  5  1   -> 5
  #|divx115 divide  6  1   -> 6
  #|divx116 divide  7  1   -> 7
  #|divx117 divide  8  1   -> 8
  #|divx118 divide  9  1   -> 9

///|
test "divide.decTest subset round-trips through parse + divide + toSci" {
  let cases = parse_dectest(divide_subset)
  assert_eq(cases.length(), 100)
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
    abort("divide.decTest failures")
  }
}
