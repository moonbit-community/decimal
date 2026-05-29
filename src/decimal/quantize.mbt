// ---------------------------------------------------------------------------
// Quantize: rescale a value to a target exponent.
//
// Quantize is the canonical "set the scale" op in GDA — used to enforce
// storage shapes (e.g. "round this monetary amount to two decimal places"
// is `quantize(x, 0.01)`) and as a primitive for `to-integral-value`.
// ---------------------------------------------------------------------------

///| GDA `quantize`: return a value equal to `self` (possibly rounded) with
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

///| Finite-finite quantize body: rescale `a` to `target_exp`.
fn quantize_finite(a : Decimal, target_exp : Int, ctx : Context) -> Decimal {
  let diff = target_exp - a.exponent
  if diff == 0 {
    return check_quantize_precision(a, ctx)
  }
  if diff < 0 {
    // Pad with trailing zeros — moving the exponent down.
    let pad = -diff
    let coef = scale_up(a.coefficient, pad)
    let result = { ..a, coefficient: coef, exponent: target_exp }
    return check_quantize_precision(result, ctx)
  }
  // diff > 0: drop trailing digits under rounding.
  let divisor = pow10(diff)
  let kept = a.coefficient / divisor
  let dropped = a.coefficient % divisor
  let round_up = round_decision(
    dropped, diff, kept, a.negative, ctx.rounding,
  )
  let candidate = if round_up { kept + 1N } else { kept }
  // Only raise Rounded when actual rounding happened — zero input with
  // zero dropped digits is just an exponent shift, not a round.
  if !dropped.is_zero() || candidate != kept {
    ctx.raise_rounded()
  }
  if !dropped.is_zero() {
    ctx.raise_inexact()
  }
  let result = { ..a, coefficient: candidate, exponent: target_exp }
  check_quantize_precision(result, ctx)
}

///| Quantize must keep the coefficient within precision; any overflow at
/// this step is `Invalid_operation` (there's no representable value with
/// the requested exponent at the given precision).
fn check_quantize_precision(d : Decimal, ctx : Context) -> Decimal {
  if ctx.precision > 0 && digit_count(d.coefficient) > ctx.precision {
    return invalid_nan(ctx)
  }
  d
}

///| GDA `to-integral-value`: round `self` to an integer (exponent 0) using
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

///| GDA `to-integral-exact`: round to integer, raising `Inexact` /
/// `Rounded` exactly when the rounding discarded digits or changed the
/// value. Behaviour-identical to `quantize(self, 1, ctx)` but with the
/// `Invalid_operation` guard suppressed for "value too big to fit" — the
/// op's purpose is to drop fractional digits, so it always succeeds for
/// representable inputs.
pub fn Decimal::to_integral_exact(self : Decimal, ctx : Context) -> Decimal {
  to_integral(self, ctx, true)
}

///| Shared body. `raise_flags` controls whether the precision-rounding
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

///| GDA `reduce` (also known as `normalize`): strip trailing zeros from
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
    Finite => reduce_finite(self).finalize(ctx)
  }
}

///| Coefficient-stripping body. Zero normalises to exp 0; non-zero strips
/// trailing zeros by dividing by 10 while the last digit is 0.
fn reduce_finite(d : Decimal) -> Decimal {
  if d.coefficient.is_zero() {
    return { ..d, exponent: 0 }
  }
  let mut coef = d.coefficient
  let mut exp = d.exponent
  while !coef.is_zero() {
    let next = coef / 10N
    if next * 10N != coef {
      break
    }
    coef = next
    exp = exp + 1
  }
  { ..d, coefficient: coef, exponent: exp }
}

///| Finite path. Already-integer inputs (`exponent >= 0`) are returned
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
  let divisor = pow10(drop_len)
  let kept = d.coefficient / divisor
  let dropped = d.coefficient % divisor
  let round_up = round_decision(
    dropped, drop_len, kept, d.negative, ctx.rounding,
  )
  let candidate = if round_up { kept + 1N } else { kept }
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
