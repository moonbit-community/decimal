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

///| GDA `rescale`: like `quantize`, but the second operand's *value*
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
      let target_exp = match integer_value_for_scale(other) {
        Some(v) => v
        None => return invalid_nan(ctx)
      }
      quantize_finite(self, target_exp, ctx)
    }
    _ => abort("Decimal::rescale: unreachable class combination")
  }
}

///| GDA `scaleb`: shift the exponent of `self` by `other` (an integer).
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
    (Infinity, Finite) => {
      match integer_value_for_scale(other) {
        Some(_) => self
        None => invalid_nan(ctx)
      }
    }
    (Finite, Finite) => {
      // scaleb's second operand must be a bare integer — exponent 0 with
      // no fractional or trailing-zero scaling. `1.00` and `1E+1` are
      // rejected even though they're numerically integral.
      if other.exponent != 0 {
        return invalid_nan(ctx)
      }
      let n = match integer_value_for_scale(other) {
        Some(v) => v
        None => return invalid_nan(ctx)
      }
      let limit = 2 * (ctx.e_max + ctx.precision)
      let abs_n = if n < 0 { -n } else { n }
      if abs_n > limit {
        return invalid_nan(ctx)
      }
      let result = { ..self, exponent: self.exponent + n }
      result.finalize(ctx)
    }
    _ => abort("Decimal::scaleb: unreachable class combination")
  }
}

///| Return `Some(n)` iff `y` is a finite integer (no fractional part)
/// fitting in `Int`. Used by `rescale` / `scaleb` to validate the
/// second-operand integer constraint.
fn integer_value_for_scale(y : Decimal) -> Int? {
  if !(y.class is Finite) {
    return None
  }
  if y.exponent >= 0 {
    let scaled = y.coefficient * pow10(y.exponent)
    match fits_int64(scaled) {
      Some(v) =>
        if v.compare(2147483647L) <= 0 {
          Some(if y.negative { -v.to_int() } else { v.to_int() })
        } else {
          None
        }
      None => None
    }
  } else {
    let factor = pow10(-y.exponent)
    if (y.coefficient % factor).is_zero() {
      let int_coef = y.coefficient / factor
      match fits_int64(int_coef) {
        Some(v) =>
          if v.compare(2147483647L) <= 0 {
            Some(if y.negative { -v.to_int() } else { v.to_int() })
          } else {
            None
          }
        None => None
      }
    } else {
      None
    }
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

///| GDA `trim`: strip the *insignificant* trailing zeros — those past the
/// decimal point. Unlike `reduce`, this only collapses zeros to the right
/// of the radix; integer-side trailing zeros stay.
///
/// Concretely:
/// * `exponent == 0`: identity (`10` stays `10`).
/// * `exponent < 0`: strip trailing zeros, stopping once the exponent
///   reaches 0 (`1.00 → 1`, but `1.001 → 1.001`).
/// * `exponent > 0`: strip all trailing zeros (`10E+1 → 1E+2`), since the
///   value can be re-expressed without them and there's no decimal point
///   to preserve scale around.
/// * Zero normalises to `0` (exponent 0), preserving sign.
pub fn Decimal::trim(self : Decimal, ctx : Context) -> Decimal {
  match self.class {
    SNaN => quiet_snan(self, ctx)
    QNaN => self
    Infinity => self
    Finite => trim_finite(self)
  }
}

///| Body of `trim` — see the public function's docstring for the rule
/// table.
fn trim_finite(d : Decimal) -> Decimal {
  if d.coefficient.is_zero() {
    return { ..d, exponent: 0 }
  }
  if d.exponent == 0 {
    return d
  }
  let was_negative_exp = d.exponent < 0
  let mut coef = d.coefficient
  let mut exp = d.exponent
  while !coef.is_zero() {
    let next = coef / 10N
    if next * 10N != coef {
      break
    }
    coef = next
    exp = exp + 1
    if was_negative_exp && exp == 0 {
      break
    }
  }
  { ..d, coefficient: coef, exponent: exp }
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
