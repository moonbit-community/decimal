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
    (Finite, Finite) => add_finite(self, other, ctx).finalize(ctx)
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
  // Below-the-noise short-circuit. Only applies for rounding modes whose
  // decision is determined by digits within half a ULP — `Up`, `Ceiling`,
  // `Floor`, and `ZeroFiveUp` are sensitive to *any* non-zero discard, so
  // for those we still have to materialise the alignment and let
  // `round_finite` see the discarded bit.
  if ctx.precision > 0 && is_half_mode(ctx.rounding) {
    let a_adj = a.exponent + digit_count(a.coefficient) - 1
    let b_adj = b.exponent + digit_count(b.coefficient) - 1
    if a_adj > b_adj + ctx.precision + 1 {
      ctx.raise_inexact()
      return align_zero_add(a, b, ctx)
    }
    if b_adj > a_adj + ctx.precision + 1 {
      ctx.raise_inexact()
      return align_zero_add(b, a, ctx)
    }
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
    ctx.raise_rounded()
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

///| Whether the rounding mode is "half-aware" — its decision depends on
/// whether the discarded portion exceeds half a ULP, with sub-half-ULP
/// discards never crossing a kept-digit boundary. Below-the-noise short-
/// circuits are safe here regardless of operand signs.
///
/// `Down` is excluded even though same-sign Down would be safe, because the
/// opposite-sign borrow can shave the last kept digit (`123456789 +
/// -0.000001 = 123456788.999...` truncates to `123456788`, not `123456789`).
/// The conservative gate keeps the shortcut independent of operand signs.
fn is_half_mode(r : Rounding) -> Bool {
  match r {
    HalfUp | HalfEven | HalfDown => true
    Up | Down | Ceiling | Floor | ZeroFiveUp => false
  }
}
