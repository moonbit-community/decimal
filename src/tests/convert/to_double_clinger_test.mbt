// The `to_double` Clinger fast path (coefficient < 2^53 and |exponent| <= 22)
// claims to be correctly rounded. Its reference for "correctly rounded" is the
// standard library's decimal-string parser, so the fast path must agree with it
// bit-for-bit. We sweep boundary coefficients around 2^52 and 2^53 crossed with
// every exponent in the fast-path window, both signs.

///|
test "to_double fast path matches the correctly-rounded string parser" {
  let coeffs : Array[Int64] = [
    0L, 1L, 2L, 9L, 10L, 99L, 100L, 7L, 123456789L, 1234567890123456L, 3141592653589793L,
    5000000000000000L, 4503599627370495L, // 2^52 - 1
     4503599627370496L, // 2^52
     4503599627370497L, // 2^52 + 1
     9007199254740990L, // 2^53 - 2
     9007199254740991L, // 2^53 - 1
  ]
  let mut mismatches = 0
  for c in coeffs {
    for neg in [false, true] {
      for e in -22..<=22 {
        let lit = (if neg { "-" } else { "" }) +
          c.to_string() +
          "e" +
          e.to_string()
        let fast = (Decimal::parse(lit) catch { _ => Decimal::of_int64(0L) }).to_double()
        let reference = @string.parse_double(lit) catch { _ => 0.0 }
        if fast.reinterpret_as_int64() != reference.reinterpret_as_int64() {
          mismatches = mismatches + 1
        }
      }
    }
  }
  assert_eq(mismatches, 0)
}
