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

///| Truncated integer division for finite non-zero divisor.
///
/// Short-circuits via the adjusted exponents: if `|a| < |b|` the integer
/// quotient is zero, and we return before scaling — important when the
/// operands' exponents differ by a billion. If the upper bound on the
/// quotient digit count is implausibly large we surface `NaN` (GDA's
/// `Division_impossible`) instead of attempting an intractable BigInt op.
fn divide_int_finite(a : Decimal, b : Decimal) -> Decimal {
  let adj_a = adjusted_exponent(a)
  let adj_b = adjusted_exponent(b)
  if adj_a < adj_b {
    return {
      class: Finite,
      negative: a.negative != b.negative,
      coefficient: 0N,
      exponent: 0,
    }
  }
  // `adj_a - adj_b + 1` upper-bounds the digit count of the integer quotient.
  // 100_000 digits is well past any precision a Context would set, so further
  // computation is pointless and the GDA outcome here is Division_impossible.
  if adj_a - adj_b + 1 > 100_000 {
    return Decimal::nan()
  }
  let (an, bn) = align_for_int_div(
    a.coefficient, a.exponent, b.coefficient, b.exponent,
  )
  {
    class: Finite,
    negative: a.negative != b.negative,
    coefficient: an / bn,
    exponent: 0,
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
  let exact_ctx = Context::exact()
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
        // Intermediate quotient and product stay exact — the final subtract
        // is the only place that applies the caller's precision.
        let quot = divide_int_finite(self, other)
        let prod = Decimal::multiply(quot, other, exact_ctx)
        let result = Decimal::subtract(self, prod, ctx)
        if result.class is Finite && result.coefficient.is_zero() {
          { ..result, negative: self.negative }
        } else {
          result
        }
      }
    _ => abort("Decimal::remainder: unreachable class combination")
  }
}
