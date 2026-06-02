// ---------------------------------------------------------------------------
// Division, integer division, and remainder.
//
// `divide(a, b)` performs true division with precision-driven rounding.
// `divide_int(a, b)` is the truncated integer quotient of `a / b`;
// `remainder(a, b)` is `a - divide_int(a, b) * b`.
// ---------------------------------------------------------------------------

///|
/// GDA `divide`: true division with precision-driven rounding. The result
/// has `precision` digits (before final rounding) and an exponent chosen so
/// that the value is `(a / b)` to within half a ULP under the active
/// rounding mode.
///
/// Special values follow the usual NaN / Infinity propagation rules:
/// * `Infinity / Infinity` → NaN (`Invalid_operation`).
/// * `Infinity / finite-nonzero` → `±Infinity` (XOR sign).
/// * `finite / Infinity` → `±0` (XOR sign).
/// * `0 / x` (x ≠ 0) → signed `0` with `ideal_exp = a.exp - b.exp`.
/// * `x / 0` (x ≠ 0) → `±Infinity` (`Division_by_zero` raised).
/// * `0 / 0` → NaN (`Division_undefined` raised).
///
/// Precision is required: when `ctx.precision == 0` and the division is
/// not exact, the result is NaN with `Invalid_operation` raised — there's
/// no stopping criterion for a non-terminating decimal (e.g. 1/3).
pub fn Decimal::divide(
  self : Decimal,
  other : Decimal,
  ctx : Context,
) -> (Decimal, Flags) {
  let ctx = { ..ctx, flags: Flags::new() }
  (self.divide_raw(other, ctx), ctx.flags)
}

///|
/// Internal worker for `divide`: returns the value, raising into `ctx.flags`.
fn Decimal::divide_raw(
  self : Decimal,
  other : Decimal,
  ctx : Context,
) -> Decimal {
  match propagate_nan(self, other, ctx) {
    Some(d) => return d
    None => ()
  }
  let sign = xor_sign(self, other)
  match (self.class, other.class) {
    (Infinity, Infinity) => invalid_nan(ctx)
    (Infinity, Finite) =>
      // Inf / finite (zero or not) is Inf — no Division_by_zero, since
      // the dividend's magnitude already dominates.
      signed_infinity(sign)
    (Finite, Infinity) => {
      // Per GDA: finite / Inf is ±0 with exponent etiny. Clamped fires
      // because we're folding to the subnormal floor. With precision==0
      // the exponent has no defined meaning so we settle for 0.
      let exp = if ctx.precision > 0 {
        ctx.raise_clamped()
        ctx.etiny()
      } else {
        0
      }
      finite_zero(exp, sign)
    }
    (Finite, Finite) =>
      if other.coefficient.is_zero() {
        if self.coefficient.is_zero() {
          ctx.raise_division_undefined()
          Decimal::nan()
        } else {
          ctx.raise_division_by_zero()
          signed_infinity(sign)
        }
      } else {
        divide_finite(self, other, ctx).finalize_raw(ctx)
      }
    _ => abort("Decimal::divide: unreachable class combination")
  }
}

///|
/// GDA `divide-integer`: truncated integer quotient `trunc(a / b)`.
///
/// * Special values follow the usual NaN / Infinity propagation rules.
/// * `0 / 0` raises `Division_undefined`; `Infinity / Infinity` raises
///   `Invalid_operation`.
/// * `finite / 0` (with finite ≠ 0) and `Infinity / 0` give a signed
///   Infinity; finite non-zero divided by zero raises `Division_by_zero`.
/// * `finite / Infinity` is a signed zero.
/// * Result exponent for the finite/finite case is `0`: the quotient is by
///   definition an integer.
/// * If the finite quotient exceeds the active precision,
///   `Division_impossible` is raised and the result is NaN.
pub fn Decimal::divide_int(
  self : Decimal,
  other : Decimal,
  ctx : Context,
) -> (Decimal, Flags) {
  let ctx = { ..ctx, flags: Flags::new() }
  (self.divide_int_raw(other, ctx), ctx.flags)
}

///|
/// Internal worker for `divide_int`: returns the value, raising into `ctx.flags`.
fn Decimal::divide_int_raw(
  self : Decimal,
  other : Decimal,
  ctx : Context,
) -> Decimal {
  match propagate_nan(self, other, ctx) {
    Some(d) => return d
    None => ()
  }
  let sign = xor_sign(self, other)
  match (self.class, other.class) {
    (Infinity, Infinity) => invalid_nan(ctx)
    (Infinity, Finite) =>
      // Inf / finite (zero or not) is just Inf — no Division_by_zero,
      // since the dividend's magnitude already dominates.
      signed_infinity(sign)
    (Finite, Infinity) => finite_zero(0, sign)
    (Finite, Finite) =>
      if other.coefficient.is_zero() {
        if self.coefficient.is_zero() {
          // 0 / 0 uses the dedicated Division_undefined signal, distinct
          // from the catch-all Invalid_operation that Inf/Inf raises.
          ctx.raise_division_undefined()
          Decimal::nan()
        } else {
          ctx.raise_division_by_zero()
          signed_infinity(sign)
        }
      } else {
        divide_int_finite(self, other, ctx)
      }
    _ => abort("Decimal::divide_int: unreachable class combination")
  }
}

///|
/// GDA `remainder`: `a - divide_int(a, b) * b`.
///
/// The result carries `a`'s sign (and exponent `min(a.exp, b.exp)` via the
/// underlying subtract). Special cases:
///
/// * NaN / sNaN propagate per the usual rules.
/// * `Infinity` as dividend, or `0` as divisor: NaN.
/// * Finite dividend with `Infinity` divisor: the dividend is returned
///   unchanged.
pub fn Decimal::remainder(
  self : Decimal,
  other : Decimal,
  ctx : Context,
) -> (Decimal, Flags) {
  let ctx = { ..ctx, flags: Flags::new() }
  (self.remainder_raw(other, ctx), ctx.flags)
}

///|
/// Internal worker for `remainder`: returns the value, raising into `ctx.flags`.
fn Decimal::remainder_raw(
  self : Decimal,
  other : Decimal,
  ctx : Context,
) -> Decimal {
  match propagate_nan(self, other, ctx) {
    Some(d) => return d
    None => ()
  }
  match (self.class, other.class) {
    (Infinity, _) => invalid_nan(ctx)
    (Finite, Infinity) => self
    (Finite, Finite) =>
      if other.coefficient.is_zero() {
        if self.coefficient.is_zero() {
          // 0 % 0 uses the dedicated Division_undefined signal — same
          // rule as divide(0, 0) and divide_int(0, 0).
          ctx.raise_division_undefined()
          Decimal::nan()
        } else {
          invalid_nan(ctx)
        }
      } else {
        remainder_finite(self, other, ctx)
      }
    _ => abort("Decimal::remainder: unreachable class combination")
  }
}

///|
/// Truncated integer division for finite non-zero divisor.
///
/// Short-circuits via the adjusted exponents: if `|a| < |b|` the integer
/// quotient is zero, and we return before scaling — important when the
/// operands' exponents differ by a billion. If the upper bound on the
/// quotient digit count is implausibly large we surface `NaN` (GDA's
/// `Division_impossible`) instead of attempting an intractable BigInt op.
fn divide_int_finite(a : Decimal, b : Decimal, ctx : Context) -> Decimal {
  let neg = xor_sign(a, b)
  let adj_a = adjusted_exponent(a)
  let adj_b = adjusted_exponent(b)
  if adj_a < adj_b {
    return finite_zero(0, neg)
  }
  // Bail out before align_for_int_div on intractable inputs. Use a fixed
  // 100_000-digit cap rather than the precision cap — `adj_a - adj_b + 1`
  // is only an *upper* bound on the quotient's digit count (loose for
  // many real cases like `remainder(1000003, 5)` where adj diff is 6 but
  // the actual quotient has 6 digits, fitting precision 6).
  if adj_a - adj_b + 1 > 100_000 {
    ctx.raise_division_impossible()
    return Decimal::nan()
  }
  let (an, bn) = align_for_int_div(
    a.coefficient,
    a.exponent,
    b.coefficient,
    b.exponent,
  )
  let quotient = an / bn
  // Tight Division_impossible check using the actual quotient digit count.
  if ctx.precision > 0 && digit_count(quotient) > ctx.precision {
    ctx.raise_division_impossible()
    return Decimal::nan()
  }
  { class: Finite, negative: neg, coefficient: quotient, exponent: 0 }
}

///|
/// True finite division with precision-driven rounding:
///
/// 1. Adjust dividend and divisor so the dividend's coefficient has the
///    same digit count as the divisor and is ≥ it (so the quotient will be
///    at least one digit).
/// 2. Pre-multiply the dividend by `10^(precision - 1)` so the integer
///    `quo_rem` yields exactly `precision` quotient digits.
/// 3. Decide rounding from the remainder via `2·rem vs divisor` (the
///    half indicator: `-1` below half, `0` exactly half, `+1` above half).
///
/// The final exponent recomposes the three sources of scale:
/// `(a.exp - b.exp) - adj_coeffs - adj_exp10`, where `adj_coeffs` is the
/// digit-alignment shift from step 1 and `adj_exp10 = precision - 1` is
/// step 2.
fn divide_finite(a : Decimal, b : Decimal, ctx : Context) -> Decimal {
  let neg = a.negative != b.negative
  let shift_exp = a.exponent - b.exponent
  // 0 / x = signed zero with the ideal exponent.
  if a.coefficient.is_zero() {
    return finite_zero(shift_exp, neg)
  }
  // precision == 0: try exact division. If non-exact, GDA's Division_impossible
  // (signalled here as Invalid_operation + NaN) — there's no terminating
  // precision to stop at for a repeating decimal.
  if ctx.precision == 0 {
    let (an, bn) = align_for_int_div(
      a.coefficient,
      a.exponent,
      b.coefficient,
      b.exponent,
    )
    let rem = an % bn
    if !rem.is_zero() {
      return invalid_nan(ctx)
    }
    return { class: Finite, negative: neg, coefficient: an / bn, exponent: 0 }
  }
  let mut dividend = a.coefficient
  let mut divisor = b.coefficient
  let nd_dividend = digit_count(dividend)
  let nd_divisor = digit_count(divisor)
  let nd_diff = nd_dividend - nd_divisor
  if nd_diff < 0 {
    dividend = dividend * pow10(-nd_diff)
  } else if nd_diff > 0 {
    divisor = divisor * pow10(nd_diff)
  }
  let mut adj_coeffs = -nd_diff
  // After equal-digit-count alignment the dividend may still be < divisor
  // (e.g. 1.23 vs 2.34); one more ×10 guarantees dividend ≥ divisor.
  if dividend < divisor {
    dividend = dividend * 10N
    adj_coeffs = adj_coeffs + 1
  }
  // Pre-multiply by 10^(precision - 1) to give the integer quo_rem a
  // result with `precision` digits. When the natural result would land in
  // the subnormal range, cap the pre-multiplier so the algorithm rounds
  // directly to etiny — avoiding the double-rounding bias from doing one
  // pass at precision and another at etiny.
  let etiny = ctx.etiny()
  let exp_budget = shift_exp - adj_coeffs - etiny
  let adj_exp10 = clamp(exp_budget, 0, ctx.precision - 1)
  if adj_exp10 > 0 {
    dividend = dividend * pow10(adj_exp10)
  }
  let mut quot = dividend / divisor
  let rem = dividend % divisor
  let mut final_exp = shift_exp - adj_coeffs - adj_exp10
  if !rem.is_zero() {
    ctx.raise_inexact()
    ctx.raise_rounded()
    let cmp = (rem << 1).compare(divisor)
    let round_up = decide_div_round(quot, neg, cmp, ctx.rounding)
    if round_up {
      quot = quot + 1N
    }
  } else {
    // GDA §4.3.4: an exact divide result is normalised — trailing zeros are
    // stripped until the exponent reaches `ideal_exp = a.exp - b.exp`.
    // Without this, `divide(2, 2)` would render as `1.00000000` (precision
    // trailing zeros from the scaling step) rather than `1`.
    let (s_coef, s_exp) = strip_trailing_zeros_to(quot, final_exp, shift_exp)
    quot = s_coef
    final_exp = s_exp
    // When the natural quotient had more digits than precision allowed,
    // the scaling factors compressed those LSDs into the exponent (e.g.
    // `12345678000 / 1 = 1.23456780E+10` — the two trailing zeros of the
    // natural value land in the exponent, not the coefficient). That's a
    // precision-induced rounding even though rem is zero, so Rounded
    // fires. `final_exp > shift_exp` is the signal.
    if final_exp > shift_exp {
      ctx.raise_rounded()
    }
  }
  { class: Finite, negative: neg, coefficient: quot, exponent: final_exp }
}

///|
/// Strip trailing zeros from `coef` while raising the exponent, but not
/// past `target_exp`. Used by divide to normalise exact results down to
/// the `ideal_exp = a.exp - b.exp` GDA convention.
fn strip_trailing_zeros_to(
  coef : BigInt,
  exp : Int,
  target_exp : Int,
) -> (BigInt, Int) {
  strip_trailing_zeros(coef, exp, e => e < target_exp)
}

///|
/// Decide whether the precision-truncated quotient should round up by
/// one. `cmp` is `(2·rem).compare(divisor)`: `-1` if the remainder is less
/// than half the divisor, `0` if exactly half, `+1` if more than half.
///
/// This mirrors `round_decision` from rounding.mbt but takes the half
/// indicator pre-computed (rather than picking it out of a `dropped` value).
fn decide_div_round(
  quot : BigInt,
  negative : Bool,
  cmp : Int,
  mode : Rounding,
) -> Bool {
  // Called only when the remainder is non-zero, so the discard is non-zero and
  // `cmp` (2·rem vs divisor) is the half indicator.
  should_round_up(quot, negative, cmp, true, mode)
}

///|
/// Exact finite remainder: `a - divide_int_finite(a, b) * b`, with the final
/// subtract performed under the caller context so precision rules apply only
/// at the public result boundary.
fn remainder_finite(a : Decimal, b : Decimal, ctx : Context) -> Decimal {
  let exact_ctx = Context::exact()
  // Use the caller's `ctx` so Division_impossible flags through when the
  // integer quotient overflows precision — remainder shares the
  // quotient-size constraint with divide-integer.
  let quot = divide_int_finite(a, b, ctx)
  if quot.class is QNaN {
    return quot
  }
  let prod = Decimal::multiply_raw(quot, b, exact_ctx)
  let result = Decimal::subtract_raw(a, prod, ctx)
  if result.class is Finite && result.coefficient.is_zero() {
    { ..result, negative: a.negative }
  } else {
    result
  }
}
