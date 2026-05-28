///| First 60 cases each from `and.decTest`, `or.decTest`, `xor.decTest`,
/// `invert.decTest`. Validates the digit-wise bit-string semantics: each
/// operand has a coefficient whose decimal digits are all 0 or 1, with
/// exponent 0 and non-negative sign; the op runs position-by-position on
/// the right-aligned digit sequences.
let and_subset : String =
  #|precision:   9
  #|rounding:    half_up
  #|maxExponent: 999
  #|minExponent: -999
  #|andx001 and             0    0 ->    0
  #|andx002 and             0    1 ->    0
  #|andx003 and             1    0 ->    0
  #|andx004 and             1    1 ->    1
  #|andx005 and          1100 1010 -> 1000
  #|andx006 and          1111   10 ->   10
  #|andx007 and          1111 1010 -> 1010
  #|-- and at msd and msd-1
  #|andx010 and 000000000 000000000 ->           0
  #|andx011 and 000000000 100000000 ->           0
  #|andx012 and 100000000 000000000 ->           0
  #|andx013 and 100000000 100000000 ->   100000000
  #|andx014 and 000000000 000000000 ->           0
  #|andx015 and 000000000 010000000 ->           0
  #|andx016 and 010000000 000000000 ->           0
  #|andx017 and 010000000 010000000 ->    10000000
  #|andx021 and 111111111     111111111  ->  111111111
  #|andx022 and 111111111111  111111111  ->  111111111
  #|andx023 and 111111111111   11111111  ->   11111111
  #|andx024 and 111111111      11111111  ->   11111111
  #|andx025 and 111111111       1111111  ->    1111111
  #|andx026 and 111111111111     111111  ->     111111
  #|andx027 and 111111111111      11111  ->      11111
  #|andx028 and 111111111111       1111  ->       1111
  #|andx029 and 111111111111        111  ->        111
  #|andx031 and 111111111111         11  ->         11
  #|andx032 and 111111111111          1  ->          1
  #|andx033 and 111111111111 1111111111  ->  111111111
  #|andx034 and 11111111111 11111111111  ->  111111111
  #|andx035 and 1111111111 111111111111  ->  111111111
  #|andx036 and 111111111 1111111111111  ->  111111111
  #|andx040 and 111111111  111111111111  ->  111111111
  #|andx041 and  11111111  111111111111  ->   11111111
  #|andx042 and  11111111     111111111  ->   11111111
  #|andx043 and   1111111     111111111  ->    1111111
  #|andx044 and    111111     111111111  ->     111111
  #|andx045 and     11111     111111111  ->      11111
  #|andx046 and      1111     111111111  ->       1111
  #|andx047 and       111     111111111  ->        111
  #|andx048 and        11     111111111  ->         11
  #|andx049 and         1     111111111  ->          1
  #|andx050 and 1111111111  1  ->  1
  #|andx051 and  111111111  1  ->  1
  #|andx052 and   11111111  1  ->  1
  #|andx053 and    1111111  1  ->  1
  #|andx054 and     111111  1  ->  1
  #|andx055 and      11111  1  ->  1
  #|andx056 and       1111  1  ->  1
  #|andx057 and        111  1  ->  1
  #|andx058 and         11  1  ->  1
  #|andx059 and          1  1  ->  1
  #|andx060 and 1111111111  0  ->  0
  #|andx061 and  111111111  0  ->  0
  #|andx062 and   11111111  0  ->  0
  #|andx063 and    1111111  0  ->  0
  #|andx064 and     111111  0  ->  0
  #|andx065 and      11111  0  ->  0
  #|andx066 and       1111  0  ->  0
  #|andx067 and        111  0  ->  0
  #|andx068 and         11  0  ->  0

let or_subset : String =
  #|-- or specification.  The tests are not exhaustive.                   --
  #|precision:   9
  #|rounding:    half_up
  #|maxExponent: 999
  #|minExponent: -999
  #|orx001 or             0    0 ->    0
  #|orx002 or             0    1 ->    1
  #|orx003 or             1    0 ->    1
  #|orx004 or             1    1 ->    1
  #|orx005 or          1100 1010 -> 1110
  #|orx006 or 000000000 000000000 ->           0
  #|orx007 or 000000000 100000000 ->   100000000
  #|orx008 or 100000000 000000000 ->   100000000
  #|orx009 or 100000000 100000000 ->   100000000
  #|orx010 or 000000000 000000000 ->           0
  #|orx011 or 000000000 010000000 ->    10000000
  #|orx012 or 010000000 000000000 ->    10000000
  #|orx013 or 010000000 010000000 ->    10000000
  #|orx021 or 111111111     111111111  ->  111111111
  #|orx022 or 111111111111  111111111  ->  111111111
  #|orx023 or  11111111      11111111  ->   11111111
  #|orx025 or   1111111       1111111  ->    1111111
  #|orx026 or    111111        111111  ->     111111
  #|orx027 or     11111         11111  ->      11111
  #|orx028 or      1111          1111  ->       1111
  #|orx029 or       111           111  ->        111
  #|orx031 or        11            11  ->         11
  #|orx032 or         1             1  ->          1
  #|orx033 or 111111111111 1111111111  ->  111111111
  #|orx034 or 11111111111 11111111111  ->  111111111
  #|orx035 or 1111111111 111111111111  ->  111111111
  #|orx036 or 111111111 1111111111111  ->  111111111
  #|orx040 or 111111111  111111111111  ->  111111111
  #|orx041 or  11111111  111111111111  ->  111111111
  #|orx042 or  11111111     111111111  ->  111111111
  #|orx043 or   1111111     100000010  ->  101111111
  #|orx044 or    111111     100000100  ->  100111111
  #|orx045 or     11111     100001000  ->  100011111
  #|orx046 or      1111     100010000  ->  100011111
  #|orx047 or       111     100100000  ->  100100111
  #|orx048 or        11     101000000  ->  101000011
  #|orx049 or         1     110000000  ->  110000001
  #|orx050 or 1111111111  1  ->  111111111
  #|orx051 or  111111111  1  ->  111111111
  #|orx052 or   11111111  1  ->  11111111
  #|orx053 or    1111111  1  ->  1111111
  #|orx054 or     111111  1  ->  111111
  #|orx055 or      11111  1  ->  11111
  #|orx056 or       1111  1  ->  1111
  #|orx057 or        111  1  ->  111
  #|orx058 or         11  1  ->  11
  #|orx059 or          1  1  ->  1
  #|orx060 or 1111111111  0  ->  111111111
  #|orx061 or  111111111  0  ->  111111111
  #|orx062 or   11111111  0  ->  11111111
  #|orx063 or    1111111  0  ->  1111111
  #|orx064 or     111111  0  ->  111111
  #|orx065 or      11111  0  ->  11111
  #|orx066 or       1111  0  ->  1111
  #|orx067 or        111  0  ->  111
  #|orx068 or         11  0  ->  11
  #|orx069 or          1  0  ->  1
  #|orx070 or 1  1111111111  ->  111111111
  #|orx071 or 1   111111111  ->  111111111

let xor_subset : String =
  #|precision:   9
  #|rounding:    half_up
  #|maxExponent: 999
  #|minExponent: -999
  #|xorx001 xor             0    0 ->    0
  #|xorx002 xor             0    1 ->    1
  #|xorx003 xor             1    0 ->    1
  #|xorx004 xor             1    1 ->    0
  #|xorx005 xor          1100 1010 ->  110
  #|xorx006 xor          1111   10 -> 1101
  #|xorx010 xor 000000000 000000000 ->           0
  #|xorx011 xor 000000000 100000000 ->   100000000
  #|xorx012 xor 100000000 000000000 ->   100000000
  #|xorx013 xor 100000000 100000000 ->           0
  #|xorx014 xor 000000000 000000000 ->           0
  #|xorx015 xor 000000000 010000000 ->    10000000
  #|xorx016 xor 010000000 000000000 ->    10000000
  #|xorx017 xor 010000000 010000000 ->           0
  #|xorx021 xor 111111111     111111111  ->  0
  #|xorx022 xor 111111111111  111111111  ->  0
  #|xorx023 xor  11111111      11111111  ->  0
  #|xorx025 xor   1111111       1111111  ->  0
  #|xorx026 xor    111111        111111  ->  0
  #|xorx027 xor     11111         11111  ->  0
  #|xorx028 xor      1111          1111  ->  0
  #|xorx029 xor       111           111  ->  0
  #|xorx031 xor        11            11  ->  0
  #|xorx032 xor         1             1  ->  0
  #|xorx033 xor 111111111111 1111111111  ->  0
  #|xorx034 xor 11111111111 11111111111  ->  0
  #|xorx035 xor 1111111111 111111111111  ->  0
  #|xorx036 xor 111111111 1111111111111  ->  0
  #|xorx040 xor 111111111  111111111111  ->  0
  #|xorx041 xor  11111111  111111111111  ->  100000000
  #|xorx042 xor  11111111     111111111  ->  100000000
  #|xorx043 xor   1111111     100000010  ->  101111101
  #|xorx044 xor    111111     100000100  ->  100111011
  #|xorx045 xor     11111     100001000  ->  100010111
  #|xorx046 xor      1111     100010000  ->  100011111
  #|xorx047 xor       111     100100000  ->  100100111
  #|xorx048 xor        11     101000000  ->  101000011
  #|xorx049 xor         1     110000000  ->  110000001
  #|xorx050 xor 1111111111  1  ->  111111110
  #|xorx051 xor  111111111  1  ->  111111110
  #|xorx052 xor   11111111  1  ->  11111110
  #|xorx053 xor    1111111  1  ->  1111110
  #|xorx054 xor     111111  1  ->  111110
  #|xorx055 xor      11111  1  ->  11110
  #|xorx056 xor       1111  1  ->  1110
  #|xorx057 xor        111  1  ->  110
  #|xorx058 xor         11  1  ->  10
  #|xorx059 xor          1  1  ->  0
  #|xorx060 xor 1111111111  0  ->  111111111
  #|xorx061 xor  111111111  0  ->  111111111
  #|xorx062 xor   11111111  0  ->  11111111
  #|xorx063 xor    1111111  0  ->  1111111
  #|xorx064 xor     111111  0  ->  111111
  #|xorx065 xor      11111  0  ->  11111
  #|xorx066 xor       1111  0  ->  1111
  #|xorx067 xor        111  0  ->  111
  #|xorx068 xor         11  0  ->  11
  #|xorx069 xor          1  0  ->  1
  #|xorx070 xor 1  1111111111  ->  111111110
  #|xorx071 xor 1   111111111  ->  111111110

let invert_subset : String =
  #|precision:   9
  #|rounding:    half_up
  #|maxExponent: 999
  #|minExponent: -999
  #|invx001 invert             0 -> 111111111
  #|invx002 invert             1 -> 111111110
  #|invx003 invert            10 -> 111111101
  #|invx004 invert     111111111 ->         0
  #|invx005 invert     000000000 -> 111111111
  #|invx006 invert     101010101 -> '10101010'
  #|invx007 invert 000000000 ->   111111111
  #|invx009 invert 100000000 ->    11111111
  #|invx011 invert 000000000 ->   111111111
  #|invx013 invert 010000000 ->   101111111
  #|invx021 invert 111111111     ->  0
  #|invx022 invert 111111111111  ->  0
  #|invx023 invert  11111111     ->  100000000
  #|invx025 invert   1111111     ->  110000000
  #|invx026 invert    111111     ->  111000000
  #|invx027 invert     11111     ->  111100000
  #|invx028 invert      1111     ->  111110000
  #|invx029 invert       111     ->  111111000
  #|invx031 invert        11     ->  111111100
  #|invx032 invert         1     ->  111111110
  #|invx033 invert 111111111111  ->  0
  #|invx034 invert 11111111111   ->  0
  #|invx035 invert 1111111111    ->  0
  #|invx036 invert 111111111     ->  0
  #|invx080 invert 011111111   ->  100000000
  #|invx081 invert 101111111   ->   10000000
  #|invx082 invert 110111111   ->    1000000
  #|invx083 invert 111011111   ->     100000
  #|invx084 invert 111101111   ->      10000
  #|invx085 invert 111110111   ->       1000
  #|invx086 invert 111111011   ->        100
  #|invx087 invert 111111101   ->         10
  #|invx088 invert 111111110   ->          1
  #|invx089 invert 011111011   ->  100000100
  #|invx090 invert 101111101   ->   10000010
  #|invx091 invert 110111110   ->    1000001
  #|invx092 invert 111011101   ->     100010
  #|invx093 invert 111101011   ->      10100
  #|invx094 invert 111110111   ->       1000
  #|invx095 invert 111101011   ->      10100
  #|invx096 invert 111011101   ->     100010
  #|invx097 invert 110111110   ->    1000001
  #|invx098 invert 101111101   ->   10000010
  #|invx099 invert 011111011   ->  100000100
  #|invx220 invert 111111112   ->  NaN Invalid_operation
  #|invx221 invert 333333333   ->  NaN Invalid_operation
  #|invx222 invert 555555555   ->  NaN Invalid_operation
  #|invx223 invert 777777777   ->  NaN Invalid_operation
  #|invx224 invert 999999999   ->  NaN Invalid_operation
  #|invx225 invert 222222222   ->  NaN Invalid_operation
  #|invx226 invert 444444444   ->  NaN Invalid_operation
  #|invx227 invert 666666666   ->  NaN Invalid_operation
  #|invx228 invert 888888888   ->  NaN Invalid_operation
  #|invx229 invert 999999999   ->  NaN Invalid_operation
  #|invx230 invert 999999999   ->  NaN Invalid_operation
  #|invx231 invert 999999999   ->  NaN Invalid_operation
  #|invx232 invert 999999999   ->  NaN Invalid_operation
  #|invx240 invert  567468689  ->  NaN Invalid_operation
  #|invx241 invert  567367689  ->  NaN Invalid_operation
  #|invx242 invert -631917772  ->  NaN Invalid_operation

///|
fn run_subset(label : String, subset : String, expected : Int) -> Unit raise {
  let cases = parse_dectest(subset)
  assert_eq(cases.length(), expected)
  let (failures, _) = run_cases(cases)
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
test "and.decTest subset" {
  // 59 cases — the subset includes one `-- and at msd and msd-1` comment
  // line which the runner correctly skips during parse.
  run_subset("and", and_subset, 59)
}

///|
test "or.decTest subset" {
  // 59 cases — same comment-line quirk as and.
  run_subset("or", or_subset, 59)
}

///|
test "xor.decTest subset" {
  run_subset("xor", xor_subset, 60)
}

///|
test "invert.decTest subset" {
  run_subset("invert", invert_subset, 60)
}
