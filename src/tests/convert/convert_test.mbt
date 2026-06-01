// Conversions between `Decimal` and the machine numeric types.

///|
test "of_int64 widens exactly" {
  inspect(Decimal::of_int64(0L), content="0")
  inspect(
    Decimal::of_int64(9223372036854775807L),
    content="9223372036854775807",
  )
  inspect(
    Decimal::of_int64(-9223372036854775808L),
    content="-9223372036854775808",
  )
}

///|
/// Exact binary-fraction values round-trip through Decimal and back to the
/// identical double — the strongest single check on of_double + to_double.
test "double round-trip is exact" {
  let xs : Array[Double] = [
    0.1, 0.5, 1.5, -2.5, 3.14159265358979, 1.0e10, 1.0e-10, 1234.5678, -0.0,
  ]
  for x in xs {
    assert_eq(Decimal::of_double(x).to_double(), x)
  }
}

///|
/// Powers of two and other dyadic values reduce to their canonical form (no
/// spurious trailing zeros), matching Python's `Decimal(float)`.
test "of_double canonical exact form" {
  inspect(Decimal::of_double(2.0), content="2")
  inspect(Decimal::of_double(0.5), content="0.5")
  inspect(Decimal::of_double(-0.0), content="-0")
  // 0.1 carries its full binary expansion (denominator 2^55).
  inspect(
    Decimal::of_double(0.1),
    content="0.1000000000000000055511151231257827021181583404541015625",
  )
}

///|
test "of_double specials" {
  let nan = (0.0 : Double) / 0.0
  let inf = (1.0 : Double) / 0.0
  assert_true(Decimal::of_double(nan).is_nan())
  assert_true(Decimal::of_double(inf).is_infinite())
  let neg = Decimal::of_double(-inf)
  assert_true(neg.is_infinite())
  inspect(neg, content="-Infinity")
}

///|
test "to_bigint: integers only" {
  // Integral values (in any cohort) convert exactly; `-0` becomes `0`.
  assert_eq(Decimal::parse("42").to_bigint().unwrap(), 42N)
  assert_eq(Decimal::parse("-0").to_bigint().unwrap(), 0N)
  assert_eq(Decimal::parse("1.500E+3").to_bigint().unwrap(), 1500N)
  assert_eq(Decimal::parse("100E-2").to_bigint().unwrap(), 1N)
  // Non-integers and specials fail rather than truncate.
  assert_true(Decimal::parse("3.5").to_bigint() is None)
  assert_true(Decimal::parse("0.001").to_bigint() is None)
  assert_true(Decimal::parse("Infinity").to_bigint() is None)
  assert_true(Decimal::parse("NaN").to_bigint() is None)
}

///|
test "to_int / to_int64: range checked" {
  assert_eq(Decimal::parse("2147483647").to_int().unwrap(), 2147483647)
  assert_eq(Decimal::parse("-2147483648").to_int().unwrap(), -2147483648)
  // One past Int range fails rather than wrapping.
  assert_true(Decimal::parse("2147483648").to_int() is None)
  assert_true(Decimal::parse("-2147483649").to_int() is None)
  // ...but still fits Int64.
  assert_eq(Decimal::parse("2147483648").to_int64().unwrap(), 2147483648L)
  assert_eq(
    Decimal::parse("9223372036854775807").to_int64().unwrap(),
    9223372036854775807L,
  )
  assert_true(Decimal::parse("9223372036854775808").to_int64() is None)
  assert_true(Decimal::parse("3.5").to_int() is None)
}

///|
test "to_double: lossy, total, saturating" {
  inspect(Decimal::parse("0.5").to_double(), content="0.5")
  inspect(Decimal::parse("100").to_double(), content="100")
  // Beyond binary64 range saturates to a signed infinity.
  let big = Decimal::parse("1E400").to_double()
  assert_true(big.is_inf() && big > 0.0)
  let small = Decimal::parse("-1E400").to_double()
  assert_true(small.is_inf() && small < 0.0)
  // Specials map across.
  assert_true(Decimal::parse("NaN").to_double().is_nan())
  inspect(Decimal::parse("Infinity").to_double(), content="Infinity")
}
