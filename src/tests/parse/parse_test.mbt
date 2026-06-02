///|
test "parse plain integer" {
  let d = Decimal::parse("42")
  assert_eq(d.class, Finite)
  assert_eq(d.coefficient, 42N)
  assert_eq(d.exponent, 0)
  assert_false(d.negative)
}

///|
test "parse signed integer" {
  let d = Decimal::parse("-17")
  assert_eq(d.coefficient, 17N)
  assert_true(d.negative)
  let d = Decimal::parse("+9")
  assert_eq(d.coefficient, 9N)
  assert_false(d.negative)
}

///|
test "parse fractional preserves trailing zeros in the exponent" {
  // GDA convention: `3.14` is coefficient=314, exponent=-2 — *not*
  // coefficient=3 + scale=1.4. Trailing zeros after the dot survive.
  let d = Decimal::parse("3.14")
  assert_eq(d.coefficient, 314N)
  assert_eq(d.exponent, -2)
  let d = Decimal::parse("1.00")
  assert_eq(d.coefficient, 100N)
  assert_eq(d.exponent, -2)
}

///|
test "parse leading and trailing dot forms" {
  // Leading dot `.5`
  let d = Decimal::parse(".5")
  assert_eq(d.coefficient, 5N)
  assert_eq(d.exponent, -1)
  // Trailing dot `1.` is accepted per Java BigDecimal and GDA grammar.
  let d = Decimal::parse("1.")
  assert_eq(d.coefficient, 1N)
  assert_eq(d.exponent, 0)
}

///|
test "parse scientific notation" {
  // 1.5e3 = 1500 → coefficient=15, exponent=2
  let d = Decimal::parse("1.5e3")
  assert_eq(d.coefficient, 15N)
  assert_eq(d.exponent, 2)
  // 2e-5 → coefficient=2, exponent=-5
  let d = Decimal::parse("2e-5")
  assert_eq(d.coefficient, 2N)
  assert_eq(d.exponent, -5)
  // Uppercase + explicit positive sign on the exponent both accepted.
  let d = Decimal::parse("1.5E+3")
  assert_eq(d.coefficient, 15N)
  assert_eq(d.exponent, 2)
}

///|
test "parse signed zero distinct from positive zero" {
  let pos = Decimal::parse("0")
  let neg = Decimal::parse("-0")
  assert_false(pos.negative)
  assert_true(neg.negative)
  // The sign bit is preserved (checked above), but `-0` and `+0` are
  // numerically equal, so they compare equal under `Eq`.
  assert_true(pos == neg)
}

///|
test "parse leading zeros and large coefficient" {
  let d = Decimal::parse("0044")
  assert_eq(d.coefficient, 44N)
  // 50-digit value round-trips through BigInt.
  let big = "12345678901234567890123456789012345678901234567890"
  let d = Decimal::parse(big)
  assert_eq(d.coefficient, BigInt::from_string(big))
}

///|
test "parse infinity (case-insensitive)" {
  let d = Decimal::parse("Infinity")
  assert_eq(d.class, Infinity)
  assert_false(d.negative)
  let d = Decimal::parse("-Inf")
  assert_eq(d.class, Infinity)
  assert_true(d.negative)
  assert_eq(Decimal::parse("INF").class, Infinity)
  assert_eq(Decimal::parse("+INFINITY").class, Infinity)
}

///|
test "parse nan with optional payload" {
  let d = Decimal::parse("NaN")
  assert_eq(d.class, QNaN)
  assert_eq(d.coefficient, 0N)
  let d = Decimal::parse("NaN123")
  assert_eq(d.class, QNaN)
  assert_eq(d.coefficient, 123N)
  let d = Decimal::parse("-nan")
  assert_eq(d.class, QNaN)
  assert_true(d.negative)
}

///|
test "parse signaling nan" {
  let d = Decimal::parse("sNaN")
  assert_eq(d.class, SNaN)
  let d = Decimal::parse("SNAN42")
  assert_eq(d.class, SNaN)
  assert_eq(d.coefficient, 42N)
}

///|
/// Capture a parse attempt as a `Result` so the rejection tests can match on the
/// error variant. The real API is the raising `Decimal::parse`; this wrapper
/// just turns the raise into a value via `try ... catch`.
fn try_parse(s : String) -> Result[Decimal, ParseError] {
  Ok(Decimal::parse(s)) catch {
    e => Err(e)
  }
}

///|
test "reject empty input" {
  assert_true(try_parse("") is Err(Empty))
}

///|
test "reject lone dot" {
  assert_true(try_parse(".") is Err(ExpectedDigit(..)))
}

///|
test "reject exponent without digits" {
  assert_true(try_parse("1e") is Err(InvalidExponent(..)))
  assert_true(try_parse("1e+") is Err(InvalidExponent(..)))
}

///|
test "reject malformed special keyword" {
  assert_true(try_parse("Inx") is Err(_))
  assert_true(try_parse("Na") is Err(_))
  assert_true(try_parse("sNa") is Err(_))
}

///|
test "reject underscore separator and whitespace" {
  assert_true(try_parse("1_000") is Err(_))
  assert_true(try_parse(" 1") is Err(_))
  assert_true(try_parse("1 ") is Err(_))
}

///|
test "from_string: GDA to-number rounds, flags, and conversion_syntax" {
  // Valid literal with more digits than precision → rounded + inexact.
  let (r, flags) = Decimal::from_string(
    "1.23456789",
    Context::new(precision=3, rounding=HalfUp),
  )
  assert_eq(r.to_sci_string(), "1.23")
  assert_true(flags.rounded)
  assert_true(flags.inexact)
  assert_false(flags.conversion_syntax)
  // Malformed input → quiet NaN + conversion_syntax (no raise).
  let (bad, bf) = Decimal::from_string("not a number", Context::new())
  assert_true(bad.is_nan())
  assert_true(bf.conversion_syntax)
  // Valid, exact context → unchanged, no flags.
  let (e, ef) = Decimal::from_string("1.5", Context::exact())
  assert_eq(e.to_sci_string(), "1.5")
  assert_false(ef.conversion_syntax)
}
