///| First 40 cases from `power.decTest`.
let power_subset : String =
  #|precision:   16
  #|rounding:    half_even
  #|maxExponent: 384
  #|minExponent: -383
  #|powx001 power    '0'  '0'         -> NaN Invalid_operation
  #|powx002 power    '0'  '1'         -> '0'
  #|powx003 power    '0'  '2'         -> '0'
  #|powx004 power    '1'  '0'         -> '1'
  #|powx005 power    '1'  '1'         -> '1'
  #|powx006 power    '1'  '2'         -> '1'
  #|powx010 power    '2'  '0'         -> '1'
  #|powx011 power    '2'  '1'         -> '2'
  #|powx012 power    '2'  '2'         -> '4'
  #|powx013 power    '2'  '3'         -> '8'
  #|powx014 power    '2'  '4'         -> '16'
  #|powx015 power    '2'  '5'         -> '32'
  #|powx016 power    '2'  '6'         -> '64'
  #|powx017 power    '2'  '7'         -> '128'
  #|powx018 power    '2'  '8'         -> '256'
  #|powx019 power    '2'  '9'         -> '512'
  #|powx020 power    '2'  '10'        -> '1024'
  #|powx021 power    '2'  '11'        -> '2048'
  #|powx022 power    '2'  '12'        -> '4096'
  #|powx023 power    '2'  '15'        -> '32768'
  #|powx024 power    '2'  '16'        -> '65536'
  #|powx025 power    '2'  '31'        -> '2147483648'
  #|powx026 power    '2'  '32'        -> '4294967296'
  #|precision: 9
  #|powx027 power    '2'  '31'        -> '2.14748365E+9' Inexact Rounded
  #|powx028 power    '2'  '32'        -> '4.29496730E+9' Inexact Rounded
  #|precision: 10
  #|powx029 power    '2'  '31'        -> '2147483648'
  #|powx030 power    '2'  '32'        -> '4294967296'
  #|precision: 9
  #|powx031 power    '3'  '2'         -> 9
  #|powx032 power    '4'  '2'         -> 16
  #|powx033 power    '5'  '2'         -> 25
  #|powx034 power    '6'  '2'         -> 36
  #|powx035 power    '7'  '2'         -> 49
  #|powx036 power    '8'  '2'         -> 64
  #|powx037 power    '9'  '2'         -> 81
  #|powx038 power    '10' '2'         -> 100
  #|powx039 power    '11' '2'         -> 121
  #|powx040 power    '12' '2'         -> 144
  #|powx041 power    '3'  '3'         -> 27
  #|powx042 power    '4'  '3'         -> 64
  #|powx043 power    '5'  '3'         -> 125

///|
test "power.decTest subset" {
  let cases = parse_dectest(power_subset)
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
    abort("power.decTest failures")
  }
}
