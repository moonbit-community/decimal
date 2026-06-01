// Microbenchmarks, grouped by workload (small/large arithmetic, conversion,
// format, math functions). Each is an independently-named `@bench.T` test; run
// with `moon test src/tests/bench` (or `moon bench`). Operands are built once
// outside `b.bench`; `b.keep` defeats dead-code elimination.

// ---------------------------------------------------------------------------
// Small arithmetic (decimal64).
// ---------------------------------------------------------------------------

///|
test "bench add small" (b : @bench.T) {
  let ctx = Context::decimal64()
  let x = Decimal::parse("12345.678")
  let y = Decimal::parse("98.7654")
  b.bench(() => b.keep(x.add(y, ctx)))
}

///|
test "bench subtract small" (b : @bench.T) {
  let ctx = Context::decimal64()
  let x = Decimal::parse("12345.678")
  let y = Decimal::parse("98.7654")
  b.bench(() => b.keep(x.subtract(y, ctx)))
}

///|
test "bench multiply small" (b : @bench.T) {
  let ctx = Context::decimal64()
  let x = Decimal::parse("12345.678")
  let y = Decimal::parse("98.7654")
  b.bench(() => b.keep(x.multiply(y, ctx)))
}

///|
test "bench divide small" (b : @bench.T) {
  let ctx = Context::decimal64()
  let x = Decimal::parse("12345.678")
  let y = Decimal::parse("98.7654")
  b.bench(() => b.keep(x.divide(y, ctx)))
}

// ---------------------------------------------------------------------------
// Large arithmetic (decimal128, full 34-digit operands).
// ---------------------------------------------------------------------------

///|
test "bench add large" (b : @bench.T) {
  let ctx = Context::decimal128()
  let x = Decimal::parse("1.234567890123456789012345678901234")
  let y = Decimal::parse("9.876543210987654321098765432109876")
  b.bench(() => b.keep(x.add(y, ctx)))
}

///|
test "bench multiply large" (b : @bench.T) {
  let ctx = Context::decimal128()
  let x = Decimal::parse("1.234567890123456789012345678901234")
  let y = Decimal::parse("9.876543210987654321098765432109876")
  b.bench(() => b.keep(x.multiply(y, ctx)))
}

///|
test "bench divide large" (b : @bench.T) {
  let ctx = Context::decimal128()
  let x = Decimal::parse("1.234567890123456789012345678901234")
  let y = Decimal::parse("9.876543210987654321098765432109876")
  b.bench(() => b.keep(x.divide(y, ctx)))
}

// ---------------------------------------------------------------------------
// Conversion.
// ---------------------------------------------------------------------------

///|
test "bench parse" (b : @bench.T) {
  b.bench(() => b.keep(try! Decimal::parse("12345.6789")))
}

///|
test "bench of_double" (b : @bench.T) {
  b.bench(() => b.keep(Decimal::of_double(3.141592653589793)))
}

///|
test "bench to_double" (b : @bench.T) {
  let d = Decimal::parse("3.141592653589793")
  b.bench(() => b.keep(d.to_double()))
}

// ---------------------------------------------------------------------------
// Format.
// ---------------------------------------------------------------------------

///|
test "bench to_sci_string" (b : @bench.T) {
  let d = Decimal::parse("1.234567890123456E+20")
  b.bench(() => b.keep(d.to_sci_string()))
}

///|
test "bench to_eng_string" (b : @bench.T) {
  let d = Decimal::parse("1.234567890123456E+20")
  b.bench(() => b.keep(d.to_eng_string()))
}

// ---------------------------------------------------------------------------
// Mathematical functions (decimal64, correctly-rounded Ziv loops).
// ---------------------------------------------------------------------------

///|
test "bench sqrt" (b : @bench.T) {
  let ctx = Context::decimal64()
  let x = Decimal::parse("2")
  b.bench(() => b.keep(x.sqrt(ctx)))
}

///|
test "bench exp" (b : @bench.T) {
  let ctx = Context::decimal64()
  let x = Decimal::parse("1.5")
  b.bench(() => b.keep(x.exp(ctx)))
}

///|
test "bench ln" (b : @bench.T) {
  let ctx = Context::decimal64()
  let x = Decimal::parse("123.456")
  b.bench(() => b.keep(x.ln(ctx)))
}

///|
test "bench power" (b : @bench.T) {
  let ctx = Context::decimal64()
  let x = Decimal::parse("1.5")
  let y = Decimal::parse("2.5")
  b.bench(() => b.keep(x.power(y, ctx)))
}
