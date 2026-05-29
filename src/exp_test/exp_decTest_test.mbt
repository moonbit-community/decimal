///| First 40 cases from `exp.decTest`.
let exp_subset : String =
  #|precision:   9
  #|rounding:    half_even
  #|maxExponent: 384
  #|minexponent: -383
  #|expx001 exp  -Infinity     -> 0
  #|expx002 exp  -10           -> 0.0000453999298 Inexact Rounded
  #|expx003 exp  -1            -> 0.367879441 Inexact Rounded
  #|expx004 exp   0            -> 1
  #|expx005 exp  -0            -> 1
  #|expx006 exp   1            -> 2.71828183  Inexact Rounded
  #|expx007 exp   0.693147181  -> 2.00000000  Inexact Rounded
  #|expx008 exp   10           -> 22026.4658  Inexact Rounded
  #|expx009 exp  +Infinity     -> Infinity
  #|precision:   7
  #|expx011 exp  0.1          ->  1.105171  Inexact Rounded
  #|expx012 exp  0.01         ->  1.010050  Inexact Rounded
  #|expx013 exp  0.001        ->  1.001001  Inexact Rounded
  #|expx014 exp  0.0001       ->  1.000100  Inexact Rounded
  #|expx015 exp  0.00001      ->  1.000010  Inexact Rounded
  #|expx016 exp  0.000001     ->  1.000001  Inexact Rounded
  #|expx017 exp  0.0000001    ->  1.000000  Inexact Rounded
  #|expx018 exp  0.0000003    ->  1.000000  Inexact Rounded
  #|expx019 exp  0.0000004    ->  1.000000  Inexact Rounded
  #|expx020 exp  0.0000005    ->  1.000001  Inexact Rounded
  #|expx021 exp  0.0000008    ->  1.000001  Inexact Rounded
  #|expx022 exp  0.0000009    ->  1.000001  Inexact Rounded
  #|expx023 exp  0.0000010    ->  1.000001  Inexact Rounded
  #|expx024 exp  0.0000011    ->  1.000001  Inexact Rounded
  #|expx025 exp  0.00000009   ->  1.000000  Inexact Rounded
  #|expx026 exp  0.00000005   ->  1.000000  Inexact Rounded
  #|expx027 exp  0.00000004   ->  1.000000  Inexact Rounded
  #|expx028 exp  0.00000001   ->  1.000000  Inexact Rounded
  #|expx030 exp  0.00000000   ->  1
  #|expx031 exp  0E+100       ->  1
  #|expx032 exp  0E-100       ->  1
  #|expx033 exp -0.00000000   ->  1
  #|expx034 exp -0E+100       ->  1
  #|expx035 exp -0E-100       ->  1
  #|precision:   7
  #|expx041 exp  1          ->  2.718282  Inexact Rounded
  #|expx042 exp -1          ->  0.3678794 Inexact Rounded
  #|expx043 exp  10         ->  22026.47  Inexact Rounded
  #|expx044 exp -10         ->  0.00004539993 Inexact Rounded
  #|expx045 exp  100        ->  2.688117E+43  Inexact Rounded
  #|expx046 exp -100        ->  3.720076E-44  Inexact Rounded
  #|precision: 16
  #|expx055 exp -5.42410311287441459172E+2 -> 2.717658486884572E-236 Inexact Rounded

///|
test "exp.decTest subset" {
  let cases = parse_dectest(exp_subset)
  assert_eq(cases.length(), 40)
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
    abort("exp.decTest failures")
  }
}
