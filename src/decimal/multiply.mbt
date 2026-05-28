///| GDA `multiply`. Coefficients multiply, exponents add, signs XOR.
///
/// Special values follow the usual priority: sNaN wins over QNaN (with the
/// quieten-and-keep-sign rule); `0 * Infinity` is `NaN + Invalid_operation`
/// (signal currently dropped); finite-nonzero * Infinity yields an infinity
/// with the XOR sign; Infinity * Infinity yields the XOR-signed Infinity.
pub fn Decimal::multiply(
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
    (Finite, Finite) => multiply_finite(self, other).round(ctx)
    (Infinity, Finite) =>
      if other.coefficient.is_zero() {
        invalid_nan(ctx)
      } else {
        signed_infinity(sign)
      }
    (Finite, Infinity) =>
      if self.coefficient.is_zero() {
        invalid_nan(ctx)
      } else {
        signed_infinity(sign)
      }
    (Infinity, Infinity) => signed_infinity(sign)
    _ => abort("Decimal::multiply: unreachable class combination")
  }
}

///| Multiply two finite Decimals: coefficients multiply, exponents add. The
/// result sign is the XOR of operand signs even when the coefficient is zero
/// (so `-0 * +5 = -0`, per GDA's "sign of zero result is XOR of operand signs"
/// rule).
///
/// Short-circuit: when one side's coefficient is zero, the BigInt multiply is
/// `0 * anything = 0` — we skip the call and synthesize the zero directly,
/// saving a heap allocation for the BigInt result.
fn multiply_finite(a : Decimal, b : Decimal) -> Decimal {
  if a.coefficient.is_zero() || b.coefficient.is_zero() {
    return {
      class: Finite,
      negative: a.negative != b.negative,
      coefficient: 0N,
      exponent: a.exponent + b.exponent,
    }
  }
  // Small-int fast path: if both fit Int64 and their product also fits, do
  // the multiplication primitively. Saves the BigInt result allocation.
  match (fits_int64(a.coefficient), fits_int64(b.coefficient)) {
    (Some(ai), Some(bi)) =>
      match checked_mul_i64(ai, bi) {
        Some(p) =>
          return {
            class: Finite,
            negative: a.negative != b.negative,
            coefficient: BigInt::from_int64(p),
            exponent: a.exponent + b.exponent,
          }
        None => ()
      }
    _ => ()
  }
  {
    class: Finite,
    negative: a.negative != b.negative,
    coefficient: a.coefficient * b.coefficient,
    exponent: a.exponent + b.exponent,
  }
}
