///| First 100 cases from `fma.decTest`. Skips Subnormal / Underflow /
/// Overflow / Conversion_syntax / sNaN cases pending runner-side flag
/// validation.
let fma_subset : String =
  #|precision:   9
  #|rounding:    half_up
  #|maxExponent: 384
  #|minexponent: -383
  #|fmax0001 fma  1   1   1 ->   2
  #|fmax0002 fma  1   1   2 ->   3
  #|fmax0003 fma  2   2   3 ->   7
  #|fmax0004 fma  9   9   9 ->  90
  #|fmax0005 fma -1   1   1 ->   0
  #|fmax0006 fma -1   1   2 ->   1
  #|fmax0007 fma -2   2   3 ->  -1
  #|fmax0008 fma -9   9   9 -> -72
  #|fmax0011 fma  1  -1   1 ->   0
  #|fmax0012 fma  1  -1   2 ->   1
  #|fmax0013 fma  2  -2   3 ->  -1
  #|fmax0014 fma  9  -9   9 -> -72
  #|fmax0015 fma  1   1  -1 ->   0
  #|fmax0016 fma  1   1  -2 ->  -1
  #|fmax0017 fma  2   2  -3 ->   1
  #|fmax0018 fma  9   9  -9 ->  72
  #|fmax0019 fma  3   5   7 ->  22
  #|fmax0029 fma  3  -5   7 ->  -8
  #|fmax0800 fma  Inf   Inf   Inf    ->  Infinity
  #|fmax0801 fma  Inf   Inf  -Inf    ->  NaN Invalid_operation
  #|fmax0802 fma  Inf  -Inf   Inf    ->  NaN Invalid_operation
  #|fmax0803 fma  Inf  -Inf  -Inf    -> -Infinity
  #|fmax0804 fma -Inf   Inf   Inf    ->  NaN Invalid_operation
  #|fmax0805 fma -Inf   Inf  -Inf    -> -Infinity
  #|fmax0806 fma -Inf  -Inf   Inf    ->  Infinity
  #|fmax0807 fma -Inf  -Inf  -Inf    ->  NaN Invalid_operation
  #|fmax0808 fma -Inf   0       1    ->  NaN Invalid_operation
  #|fmax0809 fma -Inf   0     NaN    ->  NaN Invalid_operation
  #|fmax0900 fma  NaN2  NaN3  NaN5   ->  NaN2
  #|fmax0901 fma  0     NaN3  NaN5   ->  NaN3
  #|fmax0902 fma  0     0     NaN5   ->  NaN5
  #|fmax2000 fma 2      2  0E+999999  -> 4
  #|fmax2001 fma 2      3  0E+999999  -> 6
  #|fmax2002 fma 5      1  0E+999999  -> 5
  #|fmax2003 fma 5      2  0E+999999  -> 10
  #|fmax2004 fma 1.20   2  0E+999999  -> 2.40
  #|fmax2005 fma 1.20   0  0E+999999  -> 0.00
  #|fmax2006 fma 1.20  -2  0E+999999  -> -2.40
  #|fmax2007 fma -1.20  2  0E+999999  -> -2.40
  #|fmax2008 fma -1.20  0  0E+999999  -> 0.00
  #|fmax2009 fma -1.20 -2  0E+999999  -> 2.40
  #|fmax2010 fma 5.09 7.1  0E+999999  -> 36.139
  #|fmax2011 fma 2.5    4  0E+999999  -> 10.0
  #|fmax2012 fma 2.50   4  0E+999999  -> 10.00
  #|fmax2013 fma 1.23456789 1.00000000  0E+999999  -> 1.23456789 Rounded
  #|fmax2014 fma 9.999999999 9.999999999  0E+999999  -> 100.000000 Inexact Rounded
  #|fmax2015 fma 2.50   4  0E+999999  -> 10.00
  #|precision: 6
  #|fmax2016 fma 2.50   4  0E+999999  -> 10.00
  #|fmax2017 fma  9.999999  9.999999  0E+999999  ->  100.000 Inexact Rounded
  #|fmax2018 fma  9.999999 -9.999999  0E+999999  -> -100.000 Inexact Rounded
  #|fmax2019 fma -9.999999  9.999999  0E+999999  -> -100.000 Inexact Rounded
  #|fmax2020 fma -9.999999 -9.999999  0E+999999  ->  100.000 Inexact Rounded
  #|precision: 15
  #|fmax2059 fma 999999999999 9765625  0E+999999  -> 9.76562499999023E+18 Inexact Rounded
  #|precision: 30
  #|fmax2160 fma 999999999999 9765625  0E+999999  -> 9765624999990234375
  #|precision: 9
  #|fmax2021 fma  0      0      0E+999999  ->  0
  #|fmax2022 fma  0     -0      0E+999999  ->  0
  #|fmax2023 fma -0      0      0E+999999  ->  0
  #|fmax2024 fma -0     -0      0E+999999  ->  0
  #|fmax2025 fma -0.0   -0.0    0E+999999  ->  0.00
  #|fmax2026 fma -0.0   -0.0    0E+999999  ->  0.00
  #|fmax2027 fma -0.0   -0.0    0E+999999  ->  0.00
  #|fmax2028 fma -0.0   -0.0    0E+999999  ->  0.00
  #|fmax2030 fma  5.00   1E-3   0E+999999  ->  0.00500
  #|fmax2031 fma  00.00  0.000  0E+999999  ->  0.00000
  #|fmax2032 fma  00.00  0E-3   0E+999999  ->  0.00000     -- rhs is 0
  #|fmax2033 fma  0E-3   00.00  0E+999999  ->  0.00000     -- lhs is 0
  #|fmax2034 fma -5.00   1E-3   0E+999999  -> -0.00500
  #|fmax2035 fma -00.00  0.000  0E+999999  ->  0.00000
  #|fmax2036 fma -00.00  0E-3   0E+999999  ->  0.00000     -- rhs is 0
  #|fmax2037 fma -0E-3   00.00  0E+999999  ->  0.00000     -- lhs is 0
  #|fmax2038 fma  5.00  -1E-3   0E+999999  -> -0.00500
  #|fmax2039 fma  00.00 -0.000  0E+999999  ->  0.00000
  #|fmax2040 fma  00.00 -0E-3   0E+999999  ->  0.00000     -- rhs is 0
  #|fmax2041 fma  0E-3  -00.00  0E+999999  ->  0.00000     -- lhs is 0
  #|fmax2042 fma -5.00  -1E-3   0E+999999  ->  0.00500
  #|fmax2043 fma -00.00 -0.000  0E+999999  ->  0.00000
  #|fmax2044 fma -00.00 -0E-3   0E+999999  ->  0.00000     -- rhs is 0
  #|fmax2045 fma -0E-3  -00.00  0E+999999  ->  0.00000     -- lhs is 0
  #|fmax2050 fma 1.20 3         0E+999999  -> 3.60
  #|fmax2051 fma 7    3         0E+999999  -> 21
  #|fmax2052 fma 0.9  0.8       0E+999999  -> 0.72
  #|fmax2053 fma 0.9  -0        0E+999999  -> 0.0
  #|fmax2054 fma 654321 654321  0E+999999  -> 4.28135971E+11  Inexact Rounded
  #|fmax2060 fma 123.45 1e7   0E+999999  ->  1.2345E+9
  #|fmax2061 fma 123.45 1e8   0E+999999  ->  1.2345E+10
  #|fmax2062 fma 123.45 1e+9  0E+999999  ->  1.2345E+11
  #|fmax2063 fma 123.45 1e10  0E+999999  ->  1.2345E+12
  #|fmax2064 fma 123.45 1e11  0E+999999  ->  1.2345E+13
  #|fmax2065 fma 123.45 1e12  0E+999999  ->  1.2345E+14
  #|fmax2066 fma 123.45 1e13  0E+999999  ->  1.2345E+15
  #|precision: 9
  #|fmax2080 fma 0.1 123456789           0E+999999  -> 12345678.9
  #|fmax2081 fma 0.1 1234567891          0E+999999  -> 123456789 Inexact Rounded
  #|fmax2082 fma 0.1 12345678912         0E+999999  -> 1.23456789E+9 Inexact Rounded
  #|fmax2083 fma 0.1 12345678912345      0E+999999  -> 1.23456789E+12 Inexact Rounded
  #|fmax2084 fma 0.1 123456789           0E+999999  -> 12345678.9
  #|precision: 8
  #|fmax2085 fma 0.1 12345678912         0E+999999  -> 1.2345679E+9 Inexact Rounded
  #|fmax2086 fma 0.1 12345678912345      0E+999999  -> 1.2345679E+12 Inexact Rounded
  #|precision: 7
  #|fmax2087 fma 0.1 12345678912         0E+999999  -> 1.234568E+9 Inexact Rounded
  #|fmax2088 fma 0.1 12345678912345      0E+999999  -> 1.234568E+12 Inexact Rounded
  #|precision: 9
  #|fmax2090 fma 123456789          0.1  0E+999999  -> 12345678.9

///|
test "fma.decTest subset" {
  let cases = parse_dectest(fma_subset)
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
    abort("fma.decTest failures")
  }
}
