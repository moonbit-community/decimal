// ---------------------------------------------------------------------------
// Context-aware addition and subtraction.
//
// Finite operands are aligned to the smaller exponent, combined exactly, then
// passed through `finalize(ctx)` so precision, exponent bounds, rounding mode,
// and status flags are applied uniformly.
// ---------------------------------------------------------------------------

///|
/// GDA `add`: arithmetic addition.
///
/// * sNaN in either operand: result is the sNaN with class quietened to QNaN.
///   sNaN at position 0 wins over sNaN at position 1 (and over any QNaN).
/// * QNaN propagation: if no sNaN, the first NaN (left-to-right) wins, with
///   its sign and payload preserved.
/// * Same-sign infinities: same-sign infinity returned.
/// * Opposite-sign infinities: `+Infinity + -Infinity = NaN` (the
///   `Invalid_operation` signal is raised).
/// * Infinity + finite: the infinity.
/// * Finite + finite: exact sum at the smaller operand exponent, then
///   context finalization.
/// * Sign of a zero result: same sign when both operands share a sign,
///   `-0` under `Floor` when signs differ, `+0` otherwise.
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

///|
/// GDA `subtract`. NaN operands are intercepted first so the right operand's
/// NaN is reported with its sign and payload intact (the bit-level flip below
/// would otherwise toggle a NaN's sign bit); everything else — finite and
/// infinity — is resolved by `add` after a *bit-level* sign flip on the second
/// operand.
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

///|
/// Add two finite Decimals: align to the smaller exponent, combine the
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
      let result_exp = min_exponent(a, b)
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
    let a_adj = adjusted_exponent(a)
    let b_adj = adjusted_exponent(b)
    if a_adj > b_adj + ctx.precision + 1 {
      return below_noise_sum(a, b, a_adj, ctx)
    }
    if b_adj > a_adj + ctx.precision + 1 {
      return below_noise_sum(b, a, b_adj, ctx)
    }
  }
  // Small-int fast path: when both operands fit in `Int64` and the
  // alignment factor isn't too large, do the whole add in primitive Int64,
  // skipping BigInt allocations for scale_up / signed_add. The path bails
  // out (returns `None`) on any overflow, falling through to the BigInt
  // logic below.
  match try_add_finite_small(a, b, ctx) {
    Some(d) => return d
    None => ()
  }
  let (a_scaled, b_scaled, result_exp) = align(a, b)
  let (sum, neg) = signed_add(a_scaled, a.negative, b_scaled, b.negative)
  let final_neg = cancellation_sign(
    sum,
    a.negative,
    b.negative,
    ctx.rounding,
    neg,
  )
  { class: Finite, negative: final_neg, coefficient: sum, exponent: result_exp }
}

///|
/// Attempt the add in Int64. Returns `None` if either coefficient or any
/// intermediate overflows. Caller falls back to the BigInt path on `None`.
fn try_add_finite_small(a : Decimal, b : Decimal, ctx : Context) -> Decimal? {
  let a64 = fits_int64(a.coefficient)
  let b64 = fits_int64(b.coefficient)
  guard a64 is Some(ai) else { return None }
  guard b64 is Some(bi) else { return None }
  let result_exp = min_exponent(a, b)
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
  let final_neg = cancellation_neg(
    sum == 0L,
    a.negative,
    b.negative,
    ctx.rounding,
    neg,
  )
  Some({
    class: Finite,
    negative: final_neg,
    coefficient: BigInt::from_int64(sum),
    exponent: result_exp,
  })
}

///|
/// GDA sign-of-zero rule for additive cancellation. When opposite-sign
/// operands cancel to exactly zero (`a + -a`), the result is `+0` under
/// every rounding mode except `Floor`, which yields `-0`. Same-sign
/// operations and non-zero results keep the sign `signed_add` reports.
fn cancellation_sign(
  sum : BigInt,
  a_neg : Bool,
  b_neg : Bool,
  rounding : Rounding,
  computed_sign : Bool,
) -> Bool {
  cancellation_neg(sum.is_zero(), a_neg, b_neg, rounding, computed_sign)
}

///|
/// GDA sign-of-zero rule for additive cancellation, on a precomputed
/// is-zero flag: opposite-sign operands cancelling to zero yield `+0` under
/// every mode except `Floor` (which gives `-0`); otherwise the computed sign
/// passes through. Shared by the Int64 fast path and the BigInt path.
fn cancellation_neg(
  is_zero : Bool,
  a_neg : Bool,
  b_neg : Bool,
  rounding : Rounding,
  computed_sign : Bool,
) -> Bool {
  if is_zero && a_neg != b_neg {
    rounding == Floor
  } else {
    computed_sign
  }
}

///|
/// Sum when `small` lies more than `precision + 1` places below `large`:
/// the result is `large` rounded to precision with `small` discarded below
/// the round digit — always `Inexact` + `Rounded`. Returning the precision-
/// bounded value (instead of materialising the full alignment) is what keeps
/// extreme exponent gaps cheap; the caller's `finalize` still applies
/// overflow, clamp, and strict-subnormal rounding from that bounded value.
///
/// One boundary the bounded value hides: opposite signs with `large` a power
/// of ten *borrow* one place, so the pre-round magnitude is a decade smaller
/// — subnormal at `e_min - 1` — even though the rounded result carries back up
/// to `e_min`. `finalize` keys `Subnormal` off the rounded value and so would
/// miss it; raise it (with `Underflow`, the discard being inexact) here.
fn below_noise_sum(
  large : Decimal,
  small : Decimal,
  large_adj : Int,
  ctx : Context,
) -> Decimal {
  ctx.raise_inexact()
  ctx.raise_rounded()
  if large.negative != small.negative &&
    large_adj == ctx.e_min &&
    is_power_of_ten(large.coefficient) {
    ctx.raise_subnormal()
    ctx.raise_underflow()
  }
  align_zero_add(large, small, ctx)
}

///|
/// Whether `coef` is a power of ten (`1` followed by zeros): its leading
/// digit is `1` and the rest are `0`. Such an operand is the only one whose
/// magnitude drops a decade under a sub-ULP borrow.
fn is_power_of_ten(coef : BigInt) -> Bool {
  !coef.is_zero() && coef == pow10(digit_count(coef) - 1)
}

///|
/// Fast path for `non_zero + zero` (and `zero + zero` when signs match).
///
/// Without precision, GDA's "result exponent = min(a.exp, b.exp)" rule needs
/// the non-zero operand scaled up to the smaller exponent so trailing-zero
/// scale is preserved. With precision, the rounded result has at most
/// `precision` digits — so we never need to materialise a coefficient with
/// more than `precision` digits, regardless of the exponent gap. That keeps
/// `add(0, 9E+999)`-style cases from allocating a 1000-digit BigInt only to
/// throw most of it away in `round_finite`.
fn align_zero_add(non_zero : Decimal, zero : Decimal, ctx : Context) -> Decimal {
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
    ctx.raise_rounded()
    if pad <= 0 {
      // Operand already fills (or exceeds) precision — there's no headroom
      // to materialise extra trailing zeros, so the result is the operand
      // itself. Rounded still fires because the alignment was bounded by
      // precision, mirroring what round_finite would have signalled.
      return non_zero
    }
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

///|
/// Whether the rounding mode is "half-aware" — its decision depends on
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
