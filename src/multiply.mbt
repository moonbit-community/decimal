///|
/// GDA `multiply`. Coefficients multiply, exponents add, signs XOR.
///
/// Special values follow the usual priority: sNaN wins over QNaN (with the
/// quieten-and-keep-sign rule); `0 * Infinity` is `NaN` and raises `Invalid_operation`; finite-nonzero *
/// Infinity yields an infinity
/// with the XOR sign; Infinity * Infinity yields the XOR-signed Infinity.
fn Decimal::multiply_raw(
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
    (Finite, Finite) => multiply_finite(self, other).finalize_raw(ctx)
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

///|
/// GDA `fused-multiply-add`: `(self * other) + addend` with a single
/// rounding at the final addition. Equivalent to running the multiply at
/// unbounded precision, then re-finalising the sum under the caller's
/// context — so the precision-bounded product never loses digits that
/// would have been recovered by the subsequent add.
///
/// NaN propagation runs as a single left-to-right scan over all three
/// operands: the leftmost *signaling* NaN wins outright (raising
/// `Invalid_operation`), regardless of position — a signaling addend beats a
/// quiet multiplicand. With no signaling NaN, a quiet NaN in a multiplicand
/// propagates (leftmost first). Only once both multiplicands are non-NaN does
/// the actual `(self * other) + addend` run, where `multiply` signals
/// `0 * Infinity` and `add` signals `±Infinity + ∓Infinity` and propagates a
/// quiet-NaN addend.
///
/// The product is formed at unbounded precision so the precision-bounded
/// result never loses digits the subsequent add would have recovered.
fn Decimal::fma_raw(
  self : Decimal,
  other : Decimal,
  addend : Decimal,
  ctx : Context,
) -> Decimal {
  // Leftmost signaling NaN across (self, other, addend) wins.
  if self.class is SNaN {
    return quiet_snan(self, ctx)
  }
  if other.class is SNaN {
    return quiet_snan(other, ctx)
  }
  if addend.class is SNaN {
    return quiet_snan(addend, ctx)
  }
  // No signaling NaN: a quiet NaN in a multiplicand propagates (leftmost
  // first), without the 0×∞ check the real multiply would apply.
  if self.class is QNaN {
    return truncate_nan_payload(self, ctx)
  }
  if other.class is QNaN {
    return truncate_nan_payload(other, ctx)
  }
  // Both multiplicands are non-NaN: form the exact product (which may signal
  // 0×∞), then add the addend (which handles ∞−∞ and a quiet-NaN addend).
  let exact = Context::exact()
  let product = Decimal::multiply_raw(self, other, exact)
  if exact.flags.invalid_operation {
    ctx.raise_invalid_operation()
  }
  product.add_raw(addend, ctx)
}

///|
/// Multiply two finite Decimals: coefficients multiply, exponents add. The
/// result sign is the XOR of operand signs even when the coefficient is zero
/// (so `-0 * +5 = -0`, per GDA's "sign of zero result is XOR of operand signs"
/// rule).
///
/// Short-circuit: when one side's coefficient is zero, the BigInt multiply is
/// `0 * anything = 0` — we skip the call and synthesize the zero directly,
/// saving a heap allocation for the BigInt result.
fn multiply_finite(a : Decimal, b : Decimal) -> Decimal {
  let neg = xor_sign(a, b)
  let exp = a.exponent + b.exponent
  if a.coefficient.is_zero() || b.coefficient.is_zero() {
    return finite_zero(exp, neg)
  }
  // Small-int fast path; falls through to the BigInt multiply on overflow.
  match try_multiply_finite_small(a, b, neg, exp) {
    Some(d) => return d
    None => ()
  }
  {
    class: Finite,
    negative: neg,
    coefficient: a.coefficient * b.coefficient,
    exponent: exp,
  }
}

///|
/// Attempt the product in `Int64`, returning `None` if either coefficient or
/// the product overflows. Mirrors `try_add_finite_small`.
fn try_multiply_finite_small(
  a : Decimal,
  b : Decimal,
  neg : Bool,
  exp : Int,
) -> Decimal? {
  guard fits_int64(a.coefficient) is Some(ai) else { return None }
  guard fits_int64(b.coefficient) is Some(bi) else { return None }
  guard checked_mul_i64(ai, bi) is Some(p) else { return None }
  Some({
    class: Finite,
    negative: neg,
    coefficient: BigInt::from_int64(p),
    exponent: exp,
  })
}

///|
pub fn Decimal::multiply(
  self : Decimal,
  other : Decimal,
  ctx : Context,
) -> (Decimal, Flags) {
  let ctx = { ..ctx, flags: Flags::new() }
  (self.multiply_raw(other, ctx), ctx.flags)
}

///|
pub fn Decimal::fma(
  self : Decimal,
  other : Decimal,
  addend : Decimal,
  ctx : Context,
) -> (Decimal, Flags) {
  let ctx = { ..ctx, flags: Flags::new() }
  (self.fma_raw(other, addend, ctx), ctx.flags)
}
