// ---------------------------------------------------------------------------
// Exact addition and subtraction.
//
// No rounding is applied — the result keeps every digit that arises from
// aligning the operand exponents. This is the right thing for dectest cases
// that don't carry an `Inexact`/`Rounded` condition. A future Context layer
// will add rounding-to-precision on top.
// ---------------------------------------------------------------------------

///| GDA `add`: arithmetic addition.
///
/// * sNaN in either operand: result is the sNaN with class quietened to QNaN.
///   sNaN at position 0 wins over sNaN at position 1 (and over any QNaN).
/// * QNaN propagation: if no sNaN, the first NaN (left-to-right) wins, with
///   its sign and payload preserved.
/// * Same-sign infinities: same-sign infinity returned.
/// * Opposite-sign infinities: `+Infinity + -Infinity = NaN` (the
///   `Invalid_operation` signal is dropped until a Context lands).
/// * Infinity + finite: the infinity.
/// * Finite + finite: numerical sum, preserving the smaller exponent (so
///   trailing zeros in either operand survive).
/// * Sign of a zero result: same sign when both operands share a sign,
///   `+0` otherwise (the default-rounding rule).
pub fn Decimal::add(self : Decimal, other : Decimal, ctx : Context) -> Decimal {
  match propagate_nan(self, other, ctx) {
    Some(d) => return d
    None => ()
  }
  match (self.class, other.class) {
    (Infinity, Infinity) =>
      if self.negative == other.negative {
        self
      } else {
        invalid_nan(ctx)
      }
    (Infinity, Finite) => self
    (Finite, Infinity) => other
    (Finite, Finite) => add_finite(self, other, ctx).round(ctx)
    _ => abort("Decimal::add: unreachable class combination")
  }
}

///| GDA `subtract`. Special values handled directly (so sNaN is reported
/// from the right operand without being quietened en route); finite /
/// infinity cases delegate to `add` after a *bit-level* sign flip on the
/// second operand.
///
/// The flip is intentionally bit-level (not `Decimal::minus`) because GDA's
/// subtract zero-sign rule differs from add's: `subtract(-0, 0) = -0`, which
/// would lose its sign through `minus(0) = +0` followed by
/// `add(-0, +0) = +0`. Flipping the sign without zero-canonicalisation makes
/// `add(-0, -0) = -0` (the same-sign-zeros rule) produce the right answer.
pub fn Decimal::subtract(
  self : Decimal,
  other : Decimal,
  ctx : Context,
) -> Decimal {
  match propagate_nan(self, other, ctx) {
    Some(d) => d
    None => Decimal::add(self, { ..other, negative: !other.negative }, ctx)
  }
}

///| Add two finite Decimals: align to the smaller exponent, combine the
/// signed coefficients, and report the result in the same convention.
///
/// Several short-circuits avoid materialising the alignment factor:
///
/// * `a + 0` collapses to `a` if `a.exponent <= b.exponent` (the result
///   already has the smaller exponent), otherwise the zero side keeps its
///   exponent for trailing-zero preservation.
/// * Symmetric short-circuit for `0 + b`.
/// * "Below the noise" (when both operands are non-zero with an adjusted
///   exponent gap so large no precision-9-or-more context could resolve the
///   smaller operand): we return the larger directly.
fn add_finite(a : Decimal, b : Decimal, ctx : Context) -> Decimal {
  // Zero short-circuits. `a.negative == b.negative` only matters when both
  // operands are zero — then GDA preserves the shared sign (and decides +0
  // by default when signs differ, -0 under `Floor`). When one side is
  // non-zero and the other is zero (any sign), the result is just the
  // non-zero side with the smaller exponent — no sign coupling needed.
  if b.coefficient.is_zero() {
    if a.coefficient.is_zero() {
      if a.negative == b.negative {
        return align_zero_add(a, b, ctx)
      }
      let result_exp = if a.exponent <= b.exponent {
        a.exponent
      } else {
        b.exponent
      }
      let neg = match ctx.rounding {
        Floor => true
        _ => false
      }
      return finite_zero(result_exp, neg)
    }
    return align_zero_add(a, b, ctx)
  }
  if a.coefficient.is_zero() {
    return align_zero_add(b, a, ctx)
  }
  // Small-int fast path: when both operands fit in `Int64` and the
  // alignment factor isn't too large, do the whole add in primitive Int64,
  // skipping BigInt allocations for scale_up / signed_add. The path bails
  // out (returns `None`) on any overflow, falling through to the BigInt
  // logic below.
  match try_add_finite_small(a, b) {
    Some(d) => return d
    None => ()
  }
  let result_exp = if a.exponent <= b.exponent {
    a.exponent
  } else {
    b.exponent
  }
  let a_scaled = scale_up(a.coefficient, a.exponent - result_exp)
  let b_scaled = scale_up(b.coefficient, b.exponent - result_exp)
  let (sum, neg) = signed_add(a_scaled, a.negative, b_scaled, b.negative)
  { class: Finite, negative: neg, coefficient: sum, exponent: result_exp }
}

///| Attempt the add in Int64. Returns `None` if either coefficient or any
/// intermediate overflows. Caller falls back to the BigInt path on `None`.
fn try_add_finite_small(a : Decimal, b : Decimal) -> Decimal? {
  let a64 = fits_int64(a.coefficient)
  let b64 = fits_int64(b.coefficient)
  guard a64 is Some(ai) else { return None }
  guard b64 is Some(bi) else { return None }
  let result_exp = if a.exponent <= b.exponent {
    a.exponent
  } else {
    b.exponent
  }
  let a_shift = a.exponent - result_exp
  let b_shift = b.exponent - result_exp
  let ai_scaled = match scale_up_i64(ai, a_shift) {
    Some(v) => v
    None => return None
  }
  let bi_scaled = match scale_up_i64(bi, b_shift) {
    Some(v) => v
    None => return None
  }
  // Signed add at Int64 precision.
  let (sum, neg) = if a.negative == b.negative {
    match checked_add_i64(ai_scaled, bi_scaled) {
      Some(s) => (s, a.negative)
      None => return None
    }
  } else if ai_scaled > bi_scaled {
    (ai_scaled - bi_scaled, a.negative)
  } else if ai_scaled < bi_scaled {
    (bi_scaled - ai_scaled, b.negative)
  } else {
    (0L, false)
  }
  Some({
    class: Finite,
    negative: neg,
    coefficient: BigInt::from_int64(sum),
    exponent: result_exp,
  })
}

///| Multiply `n` by `10^shift` in `Int64`, returning `None` on overflow.
/// `shift == 0` is the identity short-circuit; `shift >= 19` always
/// overflows since `10^19 > Int64.MAX`.
fn scale_up_i64(n : Int64, shift : Int) -> Int64? {
  if shift == 0 || n == 0L {
    return Some(n)
  }
  match pow10_int64(shift) {
    Some(factor) => checked_mul_i64(n, factor)
    None => None
  }
}

///| Fast path for `non_zero + zero` (and `zero + zero` when signs match).
///
/// Without precision, GDA's "result exponent = min(a.exp, b.exp)" rule needs
/// the non-zero operand scaled up to the smaller exponent so trailing-zero
/// scale is preserved. With precision, the rounded result has at most
/// `precision` digits — so we never need to materialise a coefficient with
/// more than `precision` digits, regardless of the exponent gap. That keeps
/// `add(0, 9E+999)`-style cases from allocating a 1000-digit BigInt only to
/// throw most of it away in `round_finite`.
fn align_zero_add(
  non_zero : Decimal,
  zero : Decimal,
  ctx : Context,
) -> Decimal {
  let shift = non_zero.exponent - zero.exponent
  if shift <= 0 {
    return non_zero
  }
  // Both-zero case: value is zero regardless of scaling, so just preserve
  // the smaller exponent without inventing a "precision-bounded" form.
  if non_zero.coefficient.is_zero() {
    return { ..non_zero, exponent: zero.exponent }
  }
  let n_digits = digit_count(non_zero.coefficient)
  // Precision-bounded fast path: pad with only as many trailing zeros as
  // precision allows. The resulting coefficient ends with the same trailing
  // zeros `round_finite` would settle on, with no oversized intermediate.
  if ctx.precision > 0 && n_digits + shift > ctx.precision {
    let pad = ctx.precision - n_digits
    if pad <= 0 {
      // Original coefficient already too long; let round_finite handle it.
      return non_zero
    }
    ctx.flags.rounded = true
    return {
      ..non_zero,
      coefficient: non_zero.coefficient * pow10(pad),
      exponent: non_zero.exponent - pad,
    }
  }
  {
    ..non_zero,
    coefficient: scale_up(non_zero.coefficient, shift),
    exponent: zero.exponent,
  }
}

///| Multiply `coeff` by `10^shift`. Shift must be non-negative. Hot-path
/// shifts (`< 33`) land in the `pow10_table` cache and avoid a fresh
/// allocation.
///
/// The zero short-circuit matters when callers align around extreme exponent
/// gaps — `0 * 10^huge` is still zero, but materialising the `10^huge` BigInt
/// would consume gigabytes.
fn scale_up(coeff : BigInt, shift : Int) -> BigInt {
  if shift == 0 || coeff.is_zero() {
    coeff
  } else {
    coeff * pow10(shift)
  }
}

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

///| Add two non-negative magnitudes carrying signs separately, returning the
/// magnitude and sign of the result.
fn signed_add(
  a : BigInt,
  a_neg : Bool,
  b : BigInt,
  b_neg : Bool,
) -> (BigInt, Bool) {
  if a_neg == b_neg {
    // Same sign: magnitudes add, sign preserved (covers +0+0=+0, -0+-0=-0).
    (a + b, a_neg)
  } else {
    // Opposite signs: subtract magnitudes; cancellation yields +0.
    let cmp = a.compare(b)
    if cmp > 0 {
      (a - b, a_neg)
    } else if cmp < 0 {
      (b - a, b_neg)
    } else {
      (0N, false)
    }
  }
}
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
        ctx.flags.division_by_zero = true
      }
      signed_infinity(sign)
    }
    (Finite, Infinity) => finite_zero(0, sign)
    (Finite, Finite) =>
      if other.coefficient.is_zero() {
        if self.coefficient.is_zero() {
          invalid_nan(ctx)
        } else {
          ctx.flags.division_by_zero = true
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
  let adj_a = a.exponent + digit_count(a.coefficient) - 1
  let adj_b = b.exponent + digit_count(b.coefficient) - 1
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

///| Bring `a` and `b` to a representation where `an / bn` (BigInt integer
/// division) is the truncated integer quotient of the abstract values.
///
/// Value(a) / Value(b) = (a_coeff / b_coeff) * 10^(a_exp - b_exp). To get an
/// integer-division-friendly form, scale up the operand with the larger
/// exponent so the powers of ten cancel.
fn align_for_int_div(
  a_coeff : BigInt,
  a_exp : Int,
  b_coeff : BigInt,
  b_exp : Int,
) -> (BigInt, BigInt) {
  if a_exp >= b_exp {
    (scale_up(a_coeff, a_exp - b_exp), b_coeff)
  } else {
    (a_coeff, scale_up(b_coeff, b_exp - a_exp))
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
