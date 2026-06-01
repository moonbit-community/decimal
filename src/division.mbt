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
pub fn Decimal::divide(
  self : Decimal,
  other : Decimal,
  ctx : Context,
) -> (Decimal, Flags) {
  let ctx = { ..ctx, flags: Flags::new() }
  (self.divide_raw(other, ctx), ctx.flags)
}

///|
pub fn Decimal::divide_int(
  self : Decimal,
  other : Decimal,
  ctx : Context,
) -> (Decimal, Flags) {
  let ctx = { ..ctx, flags: Flags::new() }
  (self.divide_int_raw(other, ctx), ctx.flags)
}

///|
pub fn Decimal::remainder(
  self : Decimal,
  other : Decimal,
  ctx : Context,
) -> (Decimal, Flags) {
  let ctx = { ..ctx, flags: Flags::new() }
  (self.remainder_raw(other, ctx), ctx.flags)
}
