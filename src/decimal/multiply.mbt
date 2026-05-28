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
    (Finite, Finite) => multiply_finite(self, other).finalize(ctx)
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

///| GDA `fused-multiply-add`: `(self * other) + addend` with a single
/// rounding at the final addition. Equivalent to running the multiply at
/// unbounded precision, then re-finalising the sum under the caller's
/// context — so the precision-bounded product never loses digits that
/// would have been recovered by the subsequent add.
///
/// NaN / Infinity / zero edge cases route through the existing
/// `Decimal::multiply` and `Decimal::add`, which already implement the
/// GDA propagation and `0 * Infinity` / `±Infinity + ∓Infinity` rules.
/// The only subtlety is sNaN in the addend: the exact-context multiply
/// can't see it, but the subsequent add will signal `Invalid_operation`
/// and quieten it as required.
pub fn Decimal::fma(
  self : Decimal,
  other : Decimal,
  addend : Decimal,
  ctx : Context,
) -> Decimal {
  let exact = Context::exact()
  let product = Decimal::multiply(self, other, exact)
  // Reflect the exact-context's signals into the caller context — multiply
  // raises Invalid_operation for 0×∞, and the user ought to see that.
  if exact.flags.invalid_operation {
    ctx.raise_invalid_operation()
  }
  Decimal::add(product, addend, ctx)
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
