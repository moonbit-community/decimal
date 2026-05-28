///|
test "round half_up basic" {
  let ctx = Context::new(precision=3, rounding=HalfUp)
  // 12345 → 12300 (123 vs dropped 45, first digit 4 < 5)
  let r = Decimal::round(Decimal::parse("12345"), ctx)
  assert_eq(r.to_sci_string(), "1.23E+4")
  assert_true(ctx.flags.rounded)
  assert_true(ctx.flags.inexact)
}

///|
test "round half_up ties go away from zero" {
  let ctx = Context::new(precision=3, rounding=HalfUp)
  // 12950 → 130 * 10^2 (first dropped digit is 5, half_up rounds up)
  let r = Decimal::round(Decimal::parse("12950"), ctx)
  assert_eq(r.to_sci_string(), "1.30E+4")
}

///|
test "round half_up carry-over from 999" {
  let ctx = Context::new(precision=3, rounding=HalfUp)
  // 9995 → 9 kept + 9 9 5 dropped... actually 999 kept + 5 dropped → round up
  // → 1000 (4 digits), needs re-slicing to 100 * 10^2 = 10000
  let r = Decimal::round(Decimal::parse("9995"), ctx)
  assert_eq(r.to_sci_string(), "1.00E+4")
}

///|
test "round half_even on tie rounds to even" {
  let ctx = Context::new(precision=3, rounding=HalfEven)
  // 12550 — first dropped is 5, rest zero → exact tie. Kept = 125, odd last
  // digit → round up to 126.
  let r = Decimal::round(Decimal::parse("12550"), ctx)
  assert_eq(r.to_sci_string(), "1.26E+4")
  // 12450 — same shape but kept = 124, even → stay at 124.
  let ctx2 = Context::new(precision=3, rounding=HalfEven)
  let r = Decimal::round(Decimal::parse("12450"), ctx2)
  assert_eq(r.to_sci_string(), "1.24E+4")
}

///|
test "round half_even non-tie still uses standard half logic" {
  let ctx = Context::new(precision=3, rounding=HalfEven)
  // 12551 → first dropped 5, rest nonzero → above the halfway point, round up.
  let r = Decimal::round(Decimal::parse("12551"), ctx)
  assert_eq(r.to_sci_string(), "1.26E+4")
}

///|
test "round zero precision is identity" {
  let ctx = Context::exact()
  let r = Decimal::round(Decimal::parse("12345.6789"), ctx)
  assert_eq(r.to_sci_string(), "12345.6789")
  assert_false(ctx.flags.rounded)
}

///|
test "round leaves NaN and Infinity alone" {
  let ctx = Context::new(precision=3, rounding=HalfUp)
  let nan_in = Decimal::parse("NaN123456789")
  let nan_out = Decimal::round(nan_in, ctx)
  assert_eq(nan_out.to_sci_string(), "NaN123456789")
  assert_false(ctx.flags.rounded)
  let inf_in = Decimal::parse("-Infinity")
  let inf_out = Decimal::round(inf_in, ctx)
  assert_eq(inf_out.to_sci_string(), "-Infinity")
}

///|
test "round ceiling and floor track sign" {
  let pos = Decimal::parse("1.49")
  let neg = Decimal::parse("-1.49")
  // Ceiling: positive non-zero discard → round up (toward +inf).
  let ctx_c1 = Context::new(precision=2, rounding=Ceiling)
  assert_eq(Decimal::round(pos, ctx_c1).to_sci_string(), "1.5")
  // Ceiling on negative: non-zero discard rounds toward zero (closer to +inf).
  let ctx_c2 = Context::new(precision=2, rounding=Ceiling)
  assert_eq(Decimal::round(neg, ctx_c2).to_sci_string(), "-1.4")
  // Floor on positive: round toward zero.
  let ctx_f1 = Context::new(precision=2, rounding=Floor)
  assert_eq(Decimal::round(pos, ctx_f1).to_sci_string(), "1.4")
  // Floor on negative: round away from zero.
  let ctx_f2 = Context::new(precision=2, rounding=Floor)
  assert_eq(Decimal::round(neg, ctx_f2).to_sci_string(), "-1.5")
}

///|
test "round down truncates" {
  let ctx = Context::new(precision=2, rounding=Down)
  assert_eq(Decimal::round(Decimal::parse("1.99"), ctx).to_sci_string(), "1.9")
  assert_eq(Decimal::round(Decimal::parse("-1.99"), ctx).to_sci_string(), "-1.9")
}

///|
test "round up moves any discarded non-zero away from zero" {
  let ctx = Context::new(precision=2, rounding=Up)
  assert_eq(Decimal::round(Decimal::parse("1.01"), ctx).to_sci_string(), "1.1")
  assert_eq(Decimal::round(Decimal::parse("-1.01"), ctx).to_sci_string(), "-1.1")
}
