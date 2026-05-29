// ---------------------------------------------------------------------------
// Quantize: rescale a value to a target exponent.
//
// Quantize is the canonical "set the scale" op in GDA — used to enforce
// storage shapes (e.g. "round this monetary amount to two decimal places"
// is `quantize(x, 0.01)`) and as a primitive for `to-integral-value`.
// ---------------------------------------------------------------------------

///|
/// GDA `quantize`: return a value equal to `self` (possibly rounded) with
/// exponent equal to `other.exponent`.
///
/// * If `other.exponent < self.exponent`, the coefficient is multiplied by
///   `10^(self.exponent - other.exponent)` to pad with trailing zeros.
/// * If `other.exponent > self.exponent`, the coefficient loses the excess
///   trailing digits under the active rounding mode; `Rounded` is raised
///   (with `Inexact` if those digits were non-zero).
///
/// Special-value rules: any NaN propagates per usual; two infinities give
/// back `self`; mixing an infinity with a finite is `Invalid_operation`
/// (cannot rescale a finite to an infinite exponent or vice versa).
///
/// If the rescaled coefficient would have more than `precision` digits,
/// the result is `NaN` with `Invalid_operation` raised — there's no
/// representable value with that exponent at the given precision.
pub fn Decimal::quantize(
  self : Decimal,
  other : Decimal,
  ctx : Context,
) -> Decimal {
  match propagate_nan(self, other, ctx) {
    Some(d) => return d
    None => ()
  }
  match (self.class, other.class) {
    (Infinity, Infinity) => self
    (Infinity, Finite) | (Finite, Infinity) => invalid_nan(ctx)
    (Finite, Finite) => quantize_finite(self, other.exponent, ctx)
    _ => abort("Decimal::quantize: unreachable class combination")
  }
}

///|
/// GDA `rescale`: like `quantize`, but the second operand's *value*
/// (not its exponent) is the target exponent. `rescale(x, 2) ≡
/// quantize(x, 1E+2)`. Provided for spec completeness; quantize is the
/// more general form.
pub fn Decimal::rescale(
  self : Decimal,
  other : Decimal,
  ctx : Context,
) -> Decimal {
  match propagate_nan(self, other, ctx) {
    Some(d) => return d
    None => ()
  }
  match (self.class, other.class) {
    (Infinity, Infinity) => self
    (_, Infinity) | (Infinity, _) => invalid_nan(ctx)
    (Finite, Finite) => {
      let target_exp = match integer_value(other) {
        Some(v) => v
        None => return invalid_nan(ctx)
      }
      quantize_finite(self, target_exp, ctx)
    }
    _ => abort("Decimal::rescale: unreachable class combination")
  }
}

///|
/// GDA `scaleb`: shift the exponent of `self` by `other` (an integer).
/// Equivalent to multiplying by `10^other`, with the result re-finalised
/// so overflow / underflow / clamp rules still apply.
///
/// `other` must be a finite integer with |value| ≤ `2 · (e_max +
/// precision)`; out-of-range yields NaN with `Invalid_operation`.
pub fn Decimal::scaleb(
  self : Decimal,
  other : Decimal,
  ctx : Context,
) -> Decimal {
  match propagate_nan(self, other, ctx) {
    Some(d) => return d
    None => ()
  }
  match (self.class, other.class) {
    (_, Infinity) => invalid_nan(ctx)
    (Infinity, Finite) =>
      match integer_value(other) {
        Some(_) => self
        None => invalid_nan(ctx)
      }
    (Finite, Finite) => {
      // scaleb's second operand must be a bare integer — exponent 0 with
      // no fractional or trailing-zero scaling. `1.00` and `1E+1` are
      // rejected even though they're numerically integral.
      if other.exponent != 0 {
        return invalid_nan(ctx)
      }
      let n = match integer_value(other) {
        Some(v) => v
        None => return invalid_nan(ctx)
      }
      let limit = 2 * (ctx.e_max + ctx.precision)
      let abs_n = if n < 0 { -n } else { n }
      if abs_n > limit {
        return invalid_nan(ctx)
      }
      // The shifted exponent is computed in 64 bits to avoid `Int` wraparound
      // for extreme operand/shift combinations. When it lands far outside the
      // representable band it is clamped to a value that `finalize` treats
      // identically — anything above e_max overflows the same way, anything
      // far below etiny underflows to the same zero — so the clamp never
      // changes the result, only keeps the exponent inside `Int`.
      let shifted = self.exponent.to_int64() + n.to_int64()
      let exp = if ctx.precision <= 0 {
        self.exponent + n
      } else {
        let hi = (ctx.e_max + 1).to_int64()
        let lo = (ctx.etiny() - ctx.precision).to_int64()
        if shifted > hi {
          ctx.e_max + 1
        } else if shifted < lo {
          ctx.etiny() - ctx.precision
        } else {
          shifted.to_int()
        }
      }
      ({ ..self, exponent: exp } : Decimal).finalize(ctx)
    }
    _ => abort("Decimal::scaleb: unreachable class combination")
  }
}

///|
/// Finite-finite quantize body: rescale `a` to `target_exp`.
///
/// Every representability test is decided on exponents and digit *counts*
/// alone, before any coefficient is built. This is what keeps quantize fast
/// and bounded even for the deliberately extreme targets the spec admits — a
/// quantum tens of millions of places away from the value would otherwise
/// force a power of ten with millions of digits.
///
/// The guards, in order:
/// * The target exponent must lie in `[etiny, e_max]`; outside that band the
///   requested quantum has no representable value (`Invalid_operation`).
/// * The (re)scaled coefficient must fit `precision`: padding by `-diff`
///   digits when lowering the exponent, or rounding away `diff` digits when
///   raising it. If padding alone would overflow precision, give up now.
/// * After rounding, a `999…→1000…` carry can still push past precision, and
///   the result's adjusted exponent must not exceed `e_max`; either is
///   `Invalid_operation` at the fixed target exponent.
///
/// `Subnormal` is raised for an in-range result below `e_min`, but `Underflow`
/// is suppressed (per IEEE-754, quantize never signals it).
fn quantize_finite(a : Decimal, target_exp : Int, ctx : Context) -> Decimal {
  let bounded = ctx.precision > 0
  if bounded && (target_exp < ctx.etiny() || target_exp > ctx.e_max) {
    return invalid_nan(ctx)
  }
  // Compute the result coefficient and whether the rescale rounded / lost
  // digits, short-circuiting the unrepresentable cases to NaN.
  let (coef, rounded, inexact) = if a.coefficient.is_zero() {
    (0N, false, false)
  } else {
    let diff = target_exp - a.exponent
    if bounded && digit_count(a.coefficient) - diff > ctx.precision {
      return invalid_nan(ctx)
    }
    if diff <= 0 {
      // Lower (or equal) target exponent: pad with `-diff` trailing zeros.
      (scale_up(a.coefficient, -diff), false, false)
    } else {
      // Higher target exponent: drop `diff` low digits under rounding.
      // Raising the exponent always shortens the coefficient, so `Rounded`
      // fires even when the discarded digits were zero (`-10 → -1E+1`). Only
      // a non-zero discard changes the value, which is what `Inexact` reports.
      let (candidate, _, dropped) = round_drop(
        a.coefficient,
        diff,
        a.negative,
        ctx.rounding,
      )
      (candidate, true, !dropped.is_zero())
    }
  }
  let result = { ..a, coefficient: coef, exponent: target_exp }
  if bounded &&
    (
      digit_count(coef) > ctx.precision ||
      (!coef.is_zero() && adjusted_exponent(result) > ctx.e_max)
    ) {
    return invalid_nan(ctx)
  }
  if rounded {
    ctx.raise_rounded()
  }
  if inexact {
    ctx.raise_inexact()
  }
  if bounded && !coef.is_zero() && adjusted_exponent(result) < ctx.e_min {
    ctx.raise_subnormal()
  }
  result
}

///|
/// GDA `to-integral-value`: round `self` to an integer (exponent 0) using
/// the context's rounding mode, *without* raising `Inexact` or `Rounded`.
///
/// IEEE-754 §5.9: the inexact result is intentional behaviour, so the
/// operation suppresses those signals even when rounding actually happens.
/// Implementations of currency / scoring scales reach for this when they
/// want to drop fractional digits silently.
///
/// `Decimal::to_integral_exact` is the same op but with normal flag
/// raising.
pub fn Decimal::to_integral_value(self : Decimal, ctx : Context) -> Decimal {
  to_integral(self, ctx, false)
}

///|
/// GDA `to-integral-exact`: round to integer, raising `Inexact` /
/// `Rounded` exactly when the rounding discarded digits or changed the
/// value. Behaviour-identical to `quantize(self, 1, ctx)` but with the
/// `Invalid_operation` guard suppressed for "value too big to fit" — the
/// op's purpose is to drop fractional digits, so it always succeeds for
/// representable inputs.
pub fn Decimal::to_integral_exact(self : Decimal, ctx : Context) -> Decimal {
  to_integral(self, ctx, true)
}

///|
/// Shared body. `raise_flags` controls whether the precision-rounding
/// signal is reported (the only difference between the value / exact
/// variants).
fn to_integral(d : Decimal, ctx : Context, raise_flags : Bool) -> Decimal {
  match d.class {
    SNaN => quiet_snan(d, ctx)
    QNaN => d
    Infinity => d
    Finite => to_integral_finite(d, ctx, raise_flags)
  }
}

///|
/// GDA `reduce` (also known as `normalize`): strip trailing zeros from
/// the coefficient, raising the exponent to compensate, so the result
/// has the same value but the most "concise" representation.
///
/// Zero is normalised to `exponent = 0` regardless of input exponent
/// (`reduce(0E+5) = 0`); sign is preserved.
///
/// Re-finalises the result so precision rounding still applies if the
/// stripped coefficient happens to exceed `ctx.precision` (unusual but
/// possible for inputs that arrive over-wide).
pub fn Decimal::reduce(self : Decimal, ctx : Context) -> Decimal {
  match self.class {
    SNaN => quiet_snan(self, ctx)
    QNaN => self
    Infinity => self
    Finite =>
      // Round to the context *first*, then strip trailing zeros. The order
      // matters for subnormals: rounding can shorten the coefficient to the
      // digits available at etiny (raising Rounded / Inexact / Subnormal /
      // Underflow), and only the rounded value's trailing zeros should be
      // removed — stripping first would change the exponent the subnormal
      // round depends on. Overflow can finalise to Infinity, which has no
      // zeros to strip.
      match self.finalize(ctx) {
        { class: Finite, .. } as rounded => reduce_finite(rounded)
        other => other
      }
  }
}

///|
/// Coefficient-stripping body. Zero normalises to exp 0; non-zero strips
/// trailing zeros by dividing by 10 while the last digit is 0.
fn reduce_finite(d : Decimal) -> Decimal {
  if d.coefficient.is_zero() {
    return { ..d, exponent: 0 }
  }
  let (coef, exp) = strip_trailing_zeros(d.coefficient, d.exponent, _ => true)
  { ..d, coefficient: coef, exponent: exp }
}

///|
/// Finite path. Already-integer inputs (`exponent >= 0`) are returned
/// unchanged. Otherwise drop the `-exponent` fractional digits under the
/// active rounding mode.
fn to_integral_finite(
  d : Decimal,
  ctx : Context,
  raise_flags : Bool,
) -> Decimal {
  if d.exponent >= 0 {
    return d
  }
  let drop_len = -d.exponent
  let (candidate, _, dropped) = round_drop(
    d.coefficient,
    drop_len,
    d.negative,
    ctx.rounding,
  )
  if raise_flags {
    // For to_integral_exact, Rounded fires whenever we entered this branch
    // (input has fractional part) with a non-zero coefficient — the
    // representation changed (`1.0 → 1`) even when the dropped digits
    // were all zero. Zero-coefficient inputs (`0.0 → 0`) don't fire.
    if !d.coefficient.is_zero() {
      ctx.raise_rounded()
    }
    if !dropped.is_zero() {
      ctx.raise_inexact()
    }
  }
  { ..d, coefficient: candidate, exponent: 0 }
}
