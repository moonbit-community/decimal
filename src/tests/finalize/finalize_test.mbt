///|
test "finalize half_up basic" {
  let ctx = Context::new(precision=3, rounding=HalfUp)
  // 12345 → 12300 (123 vs dropped 45, first digit 4 < 5)
  let (r, flags) = Decimal::finalize(Decimal::parse("12345"), ctx)
  assert_eq(r.to_sci_string(), "1.23E+4")
  assert_true(flags.rounded)
  assert_true(flags.inexact)
}

///|
test "finalize half_up ties go away from zero" {
  let ctx = Context::new(precision=3, rounding=HalfUp)
  // 12950 → 130 * 10^2 (first dropped digit is 5, half_up rounds up)
  let (r, _) = Decimal::finalize(Decimal::parse("12950"), ctx)
  assert_eq(r.to_sci_string(), "1.30E+4")
}

///|
test "finalize half_up carry-over from 999" {
  let ctx = Context::new(precision=3, rounding=HalfUp)
  // 9995 → 999 kept + 5 dropped → round up → 1000 (4 digits), re-sliced to
  // 100 * 10^2 = 10000.
  let (r, _) = Decimal::finalize(Decimal::parse("9995"), ctx)
  assert_eq(r.to_sci_string(), "1.00E+4")
}

///|
test "finalize half_even on tie rounds to even" {
  let ctx = Context::new(precision=3, rounding=HalfEven)
  // 12550 — first dropped is 5, rest zero → exact tie. Kept = 125, odd last
  // digit → round up to 126.
  let (r, _) = Decimal::finalize(Decimal::parse("12550"), ctx)
  assert_eq(r.to_sci_string(), "1.26E+4")
  // 12450 — same shape but kept = 124, even → stay at 124.
  let (r2, _) = Decimal::finalize(Decimal::parse("12450"), ctx)
  assert_eq(r2.to_sci_string(), "1.24E+4")
}

///|
test "finalize half_even non-tie still uses standard half logic" {
  let ctx = Context::new(precision=3, rounding=HalfEven)
  // 12551 → first dropped 5, rest nonzero → above the halfway point, round up.
  let (r, _) = Decimal::finalize(Decimal::parse("12551"), ctx)
  assert_eq(r.to_sci_string(), "1.26E+4")
}

///|
test "finalize zero precision is identity" {
  let ctx = Context::exact()
  let (r, flags) = Decimal::finalize(Decimal::parse("12345.6789"), ctx)
  assert_eq(r.to_sci_string(), "12345.6789")
  assert_false(flags.rounded)
}

///|
test "finalize leaves NaN and Infinity alone" {
  let ctx = Context::new(precision=3, rounding=HalfUp)
  let (nan_out, flags) = Decimal::finalize(Decimal::parse("NaN123456789"), ctx)
  assert_eq(nan_out.to_sci_string(), "NaN123456789")
  assert_false(flags.rounded)
  let (inf_out, _) = Decimal::finalize(Decimal::parse("-Infinity"), ctx)
  assert_eq(inf_out.to_sci_string(), "-Infinity")
}

///|
test "finalize ceiling and floor track sign" {
  let pos = Decimal::parse("1.49")
  let neg = Decimal::parse("-1.49")
  // Ceiling: positive non-zero discard → round up (toward +inf).
  let ctx_c = Context::new(precision=2, rounding=Ceiling)
  assert_eq(Decimal::finalize(pos, ctx_c).0.to_sci_string(), "1.5")
  // Ceiling on negative: non-zero discard rounds toward zero (closer to +inf).
  assert_eq(Decimal::finalize(neg, ctx_c).0.to_sci_string(), "-1.4")
  // Floor on positive: round toward zero.
  let ctx_f = Context::new(precision=2, rounding=Floor)
  assert_eq(Decimal::finalize(pos, ctx_f).0.to_sci_string(), "1.4")
  // Floor on negative: round away from zero.
  assert_eq(Decimal::finalize(neg, ctx_f).0.to_sci_string(), "-1.5")
}

///|
test "finalize down truncates" {
  let ctx = Context::new(precision=2, rounding=Down)
  assert_eq(
    Decimal::finalize(Decimal::parse("1.99"), ctx).0.to_sci_string(),
    "1.9",
  )
  assert_eq(
    Decimal::finalize(Decimal::parse("-1.99"), ctx).0.to_sci_string(),
    "-1.9",
  )
}

///|
test "finalize up moves any discarded non-zero away from zero" {
  let ctx = Context::new(precision=2, rounding=Up)
  assert_eq(
    Decimal::finalize(Decimal::parse("1.01"), ctx).0.to_sci_string(),
    "1.1",
  )
  assert_eq(
    Decimal::finalize(Decimal::parse("-1.01"), ctx).0.to_sci_string(),
    "-1.1",
  )
}

///|
test "finalize overflow to infinity in half-aware modes" {
  // precision=3, e_max=5 → etop=3, largest finite = 999E+3. `1E+6` has
  // adjusted exponent 6 > 5, so it overflows; HalfUp routes to +Infinity.
  let ctx = Context::new(precision=3, e_max=5, rounding=HalfUp)
  let (r, flags) = Decimal::finalize(Decimal::parse("1E+6"), ctx)
  assert_eq(r.to_sci_string(), "Infinity")
  assert_true(flags.overflow)
  assert_true(flags.inexact)
  assert_true(flags.rounded)
}

///|
test "finalize overflow honours sign for half-aware modes" {
  let ctx = Context::new(precision=3, e_max=5, rounding=HalfEven)
  let (r, flags) = Decimal::finalize(Decimal::parse("-1E+6"), ctx)
  assert_eq(r.to_sci_string(), "-Infinity")
  assert_true(flags.overflow)
}

///|
test "finalize overflow to largest finite under Down" {
  // Down never invents trailing digits; on overflow it caps at 999E+3.
  let ctx = Context::new(precision=3, e_max=5, rounding=Down)
  let (r, flags) = Decimal::finalize(Decimal::parse("1E+6"), ctx)
  assert_eq(r.to_sci_string(), "9.99E+5")
  assert_true(flags.overflow)
}

///|
test "finalize overflow under Ceiling and Floor tracks sign" {
  // Ceiling: +overflow → +Inf, -overflow → largest finite (toward zero).
  let ctx_c = Context::new(precision=3, e_max=5, rounding=Ceiling)
  assert_eq(
    Decimal::finalize(Decimal::parse("1E+6"), ctx_c).0.to_sci_string(),
    "Infinity",
  )
  assert_eq(
    Decimal::finalize(Decimal::parse("-1E+6"), ctx_c).0.to_sci_string(),
    "-9.99E+5",
  )
  // Floor: mirror.
  let ctx_f = Context::new(precision=3, e_max=5, rounding=Floor)
  assert_eq(
    Decimal::finalize(Decimal::parse("1E+6"), ctx_f).0.to_sci_string(),
    "9.99E+5",
  )
  assert_eq(
    Decimal::finalize(Decimal::parse("-1E+6"), ctx_f).0.to_sci_string(),
    "-Infinity",
  )
}

///|
test "finalize zero never overflows but its exponent clamps to e_max" {
  // A zero has no significant digits, so it can't overflow — but the GDA
  // spec still bounds zero's exponent in [etiny, e_max] for representability.
  let ctx = Context::new(precision=3, e_max=5, rounding=HalfUp)
  let (r, flags) = Decimal::finalize(Decimal::parse("0E+99"), ctx)
  assert_eq(r.to_sci_string(), "0E+5")
  assert_false(flags.overflow)
  assert_true(flags.clamped)
}

///|
test "finalize precision-zero skips overflow check entirely" {
  // Without precision, GDA disables range checks even when e_max is small.
  let ctx = Context::exact()
  let (r, flags) = Decimal::finalize(Decimal::parse("1E+999"), ctx)
  assert_eq(r.to_sci_string(), "1E+999")
  assert_false(flags.overflow)
}

///|
test "finalize clamp folds exponent down" {
  // precision=3, e_max=5 → etop=3. `1E+5` is in range (adj=5 ≤ e_max), but
  // exponent 5 > etop=3, so clamp pads the coefficient: 1 × 10^(5-3) = 100,
  // exponent = 3. Numerically still 1E+5, but written as "1.00E+5".
  let ctx = Context::new(precision=3, e_max=5, clamp=true)
  let (r, flags) = Decimal::finalize(Decimal::parse("1E+5"), ctx)
  assert_eq(r.to_sci_string(), "1.00E+5")
  assert_true(flags.clamped)
  assert_false(flags.overflow)
}

///|
test "finalize clamp leaves in-range exponents alone" {
  // precision=3, e_max=5 → etop=3. Input parses to (coef=123, exp=0):
  // exponent 0 ≤ etop, no fold. Renders as "123" per GDA's plain-form rule.
  let ctx = Context::new(precision=3, e_max=5, clamp=true)
  let (r, flags) = Decimal::finalize(Decimal::parse("1.23E+2"), ctx)
  assert_eq(r.to_sci_string(), "123")
  assert_false(flags.clamped)
}

///|
test "finalize clamp off leaves exponents above etop alone" {
  // Same input as the clamp-on case, but clamp defaults off: exponent 5
  // passes through, no padding, no clamped flag.
  let ctx = Context::new(precision=3, e_max=5)
  let (r, flags) = Decimal::finalize(Decimal::parse("1E+5"), ctx)
  assert_eq(r.to_sci_string(), "1E+5")
  assert_false(flags.clamped)
}

///|
test "finalize clamp applies to zero too" {
  // A zero with exponent above etop gets folded — preserves the "fits in
  // the storable exponent range" invariant the IEEE-754 formats need.
  let ctx = Context::new(precision=3, e_max=5, clamp=true)
  let (r, flags) = Decimal::finalize(Decimal::parse("0E+5"), ctx)
  assert_eq(r.to_sci_string(), "0E+3")
  assert_true(flags.clamped)
}
