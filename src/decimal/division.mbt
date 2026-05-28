// ---------------------------------------------------------------------------
// Integer division and remainder.
//
// `divide_int(a, b)` is the truncated integer quotient of `a / b`;
// `remainder(a, b)` is `a - divide_int(a, b) * b`. Both are exact for the
// finite cases — neither introduces rounding (unlike `divide`, which we
// won't ship until rounding lands).
// ---------------------------------------------------------------------------

///| GDA `divide-integer`: truncated integer quotient `trunc(a / b)`.
///
/// * Special values follow the usual NaN / Infinity propagation rules.
/// * `0 / 0` and `Infinity / Infinity` collapse to NaN (`Invalid_operation`
///   signal currently dropped).
/// * `finite / 0` (with finite ≠ 0) and `Infinity / 0` give a signed
///   Infinity (the GDA `Division_by_zero` signal is also dropped for now).
/// * `finite / Infinity` is a signed zero.
/// * Result exponent for the finite/finite case is `0`: the quotient is by
///   definition an integer.
/// * No precision check; GDA would raise `Division_impossible` if the
///   quotient overflows the active precision. Without a Context that
///   constraint is simply not enforced.
pub fn Decimal::divide_int(
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
    (Infinity, Finite) => {
      if other.coefficient.is_zero() {
        ctx.raise_division_by_zero()
      }
      signed_infinity(sign)
    }
    (Finite, Infinity) => finite_zero(0, sign)
    (Finite, Finite) =>
      if other.coefficient.is_zero() {
        if self.coefficient.is_zero() {
          invalid_nan(ctx)
        } else {
          ctx.raise_division_by_zero()
          signed_infinity(sign)
        }
      } else {
        divide_int_finite(self, other)
      }
    _ => abort("Decimal::divide_int: unreachable class combination")
  }
}

///| GDA `remainder`: `a - divide_int(a, b) * b`.
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
        invalid_nan(ctx)
      } else {
        remainder_finite(self, other, ctx)
      }
    _ => abort("Decimal::remainder: unreachable class combination")
  }
}
