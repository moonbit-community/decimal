// ---------------------------------------------------------------------------
// Result finalisation and precision rounding.
// ---------------------------------------------------------------------------

///| Finalise a `Decimal` result under the active context: round to
/// `precision`, then enforce the exponent range. Non-finite results pass
/// through unchanged — NaN and Infinity have no representation to round and
/// no exponent to clamp.
///
/// Flags raised here:
/// * `rounded` — whenever precision-driven adjustment shortened the
///   coefficient.
/// * `inexact` — when that shortening discarded non-zero digits, or when
///   overflow truncated a finite result.
/// * `overflow` — when the rounded result's adjusted exponent exceeds
///   `e_max`. Per GDA the result then becomes `±Infinity` or the
///   largest-finite-representable value, depending on the rounding mode.
///
/// `underflow` / `subnormal` / `clamped` are not raised yet; those land
/// alongside the subnormal handling and the `clamp` field on Context.
pub fn Decimal::finalize(self : Decimal, ctx : Context) -> Decimal {
  match self.class {
    Finite => check_range(round_finite(self, ctx), ctx)
    _ => self
  }
}

///| Apply the exponent-range rules to an already-rounded finite. Today this
/// only detects overflow; underflow/subnormal and the clamp fold-down will
/// be added here once the subnormal flow lands.
fn check_range(d : Decimal, ctx : Context) -> Decimal {
  if ctx.precision == 0 {
    return d
  }
  // Zero values have no meaningful adjusted exponent and can't overflow.
  if d.coefficient.is_zero() {
    return d
  }
  let adj = adjusted_exponent(d)
  if adj > ctx.e_max {
    return apply_overflow(d, ctx)
  }
  d
}

///| GDA §9.5.1 overflow. The rounding mode picks between `±Infinity` and
/// the largest finite representable (`(10^precision - 1) × 10^etop`,
/// `etop = e_max - precision + 1`). `overflow`, `inexact`, and `rounded` all
/// fire.
fn apply_overflow(d : Decimal, ctx : Context) -> Decimal {
  ctx.raise_overflow()
  ctx.raise_inexact()
  ctx.raise_rounded()
  let to_inf = match ctx.rounding {
    HalfUp | HalfEven | HalfDown | Up => true
    Ceiling => !d.negative
    Floor => d.negative
    Down | ZeroFiveUp => false
  }
  if to_inf {
    signed_infinity(d.negative)
  } else {
    let etop = ctx.e_max - ctx.precision + 1
    {
      class: Finite,
      negative: d.negative,
      coefficient: pow10(ctx.precision) - 1N,
      exponent: etop,
    }
  }
}

///| The finite rounding path. Splits the coefficient into kept and
/// dropped parts via BigInt div/mod (no String round-trip), decides whether
/// to round up, and handles the `999→1000` carry-over.
fn round_finite(d : Decimal, ctx : Context) -> Decimal {
  if ctx.precision == 0 {
    return d
  }
  let n = digit_count(d.coefficient)
  if n <= ctx.precision {
    return d
  }
  let dropped_len = n - ctx.precision
  let divisor = pow10(dropped_len)
  let kept = d.coefficient / divisor
  let dropped = d.coefficient % divisor
  let round_up = round_decision(
    dropped, dropped_len, kept, d.negative, ctx.rounding,
  )
  let candidate = if round_up { kept + 1N } else { kept }
  // 999 → 1000: candidate gained a digit. The new digit count is exactly
  // `precision + 1`; comparing against `10^precision` is the cheap check.
  let precision_cap = pow10(ctx.precision)
  let (final_coeff, extra) = if candidate >= precision_cap {
    (candidate / 10N, 1)
  } else {
    (candidate, 0)
  }
  let new_exp = d.exponent + dropped_len + extra
  ctx.raise_rounded()
  if !dropped.is_zero() {
    ctx.raise_inexact()
  }
  { ..d, coefficient: final_coeff, exponent: new_exp }
}

///| Decide whether to round the kept coefficient up by one, working entirely
/// on the BigInt `dropped` value. The "first dropped digit" and "non-zero
/// remainder" predicates that the rounding modes need can be recovered from
/// `dropped` and its width `dropped_len` without ever going through a string.
fn round_decision(
  dropped : BigInt,
  dropped_len : Int,
  kept : BigInt,
  negative : Bool,
  mode : Rounding,
) -> Bool {
  if dropped_len == 0 {
    return false
  }
  // `dropped` may have leading zeros relative to `dropped_len` — e.g. when
  // the original coefficient ended in zeros — so the "first dropped digit"
  // is the *most significant* of the `dropped_len` written-out digits, not
  // of `dropped` itself.
  let top_divisor = pow10(dropped_len - 1)
  let first_digit = (dropped / top_divisor).to_int()
  let rest = dropped % top_divisor
  let rest_nonzero = !rest.is_zero()
  let dropped_nonzero = first_digit != 0 || rest_nonzero
  match mode {
    Down => false
    Up => dropped_nonzero
    HalfUp => first_digit >= 5
    HalfDown =>
      if first_digit > 5 {
        true
      } else if first_digit < 5 {
        false
      } else {
        rest_nonzero
      }
    HalfEven =>
      if first_digit > 5 {
        true
      } else if first_digit < 5 {
        false
      } else if rest_nonzero {
        true
      } else {
        // Exact tie. Round to make the last kept digit even.
        (kept % 10N).to_int() % 2 != 0
      }
    Ceiling => !negative && dropped_nonzero
    Floor => negative && dropped_nonzero
    ZeroFiveUp => {
      let last = (kept % 10N).to_int()
      (last == 0 || last == 5) && dropped_nonzero
    }
  }
}
