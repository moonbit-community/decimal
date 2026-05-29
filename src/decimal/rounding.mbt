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
    Finite => {
      // Capture the operand's adjusted exponent *before* rounding so the
      // subnormal check uses the GDA-defined "pre-round adj < e_min"
      // rule. Without this, results that round up to the e_min boundary
      // (e.g., 0.999E-999 → 1.00E-999 at precision 3) would miss
      // Subnormal/Underflow because their post-round adj equals e_min.
      let pre_adj = if self.coefficient.is_zero() {
        0
      } else {
        adjusted_exponent(self)
      }
      check_range(round_finite(self, ctx), pre_adj, ctx)
    }
    _ => self
  }
}

///| Apply the exponent-range rules to an already-rounded finite. Three
/// stages:
///
/// * Overflow (GDA §9.5.1) — non-zero result with `adjusted > e_max` goes
///   to `±Infinity` or the largest representable, depending on rounding.
/// * Subnormal-side etiny clamp — a result with `exponent < etiny` whose
///   coefficient is zero gets its exponent lifted to etiny and `Clamped`
///   raised. This is *unconditional*: the GDA spec treats the etiny floor
///   as a representability invariant, distinct from the `clamp` opt-in.
/// * Overflow-side clamp (GDA §9.5.3) — when `ctx.clamp` is on, finite
///   results with `exponent > etop` get the exponent folded down to etop
///   by padding the coefficient.
///
/// Non-zero subnormal (where the coefficient has more digits than fits at
/// etiny) needs the underflow re-rounding path; that depends on quantize
/// and lands separately.
fn check_range(d : Decimal, pre_adj : Int, ctx : Context) -> Decimal {
  if ctx.precision == 0 {
    return d
  }
  if d.coefficient.is_zero() {
    let etiny = ctx.e_min - ctx.precision + 1
    if d.exponent < etiny {
      ctx.raise_clamped()
      return { ..d, exponent: etiny }
    }
    if d.exponent > ctx.e_max {
      ctx.raise_clamped()
      return { ..d, exponent: ctx.e_max }
    }
    // A zero that arose from underflow rounding still needs the
    // Subnormal / Underflow / Clamped trio raised — the *pre-round*
    // operand was subnormal, even though the rounded result is exactly
    // zero at etiny.
    if pre_adj < ctx.e_min {
      ctx.raise_subnormal()
      if ctx.flags.inexact {
        ctx.raise_underflow()
      }
      ctx.raise_clamped()
    }
    return if ctx.clamp { apply_clamp(d, ctx) } else { d }
  }
  let adj = adjusted_exponent(d)
  if adj > ctx.e_max {
    return apply_overflow(d, ctx)
  }
  // Subnormal status is decided by the *pre-round* adjusted exponent
  // (GDA §9.5.2): a result whose unrounded value sat below e_min is
  // subnormal even when the rounded coefficient happens to land at
  // adj == e_min (e.g., 0.999E-999 → 1.00E-999 at precision 3).
  if pre_adj < ctx.e_min {
    return apply_subnormal(d, ctx)
  }
  if ctx.clamp {
    apply_clamp(d, ctx)
  } else {
    d
  }
}

///| GDA §9.5.2 subnormal / underflow. A finite non-zero result whose
/// adjusted exponent sits below `e_min` is "tiny" — representable only
/// at the etiny floor, possibly losing additional digits in the process.
///
/// If the operand's exponent is already at or above `etiny`, no re-
/// rounding is needed; the result is just flagged `Subnormal`. If the
/// exponent is below etiny, the coefficient is re-rounded so the
/// exponent lifts to etiny, and `Underflow` + `Inexact` fire when the
/// re-rounding discards non-zero digits.
///| Mark a subnormal result and raise associated flags. `round_finite`
/// already pushed the rounding past both the precision and etiny cuts,
/// so this is purely a flag-raising step — no re-rounding.
fn apply_subnormal(d : Decimal, ctx : Context) -> Decimal {
  ctx.raise_subnormal()
  // Underflow fires when the subnormal result is also inexact (raised
  // upstream by round_finite when non-zero digits were discarded).
  if ctx.flags.inexact {
    ctx.raise_underflow()
  }
  // If the rounding collapsed the value to zero at the etiny floor, the
  // etiny clamp rule fires alongside Subnormal.
  if d.coefficient.is_zero() {
    ctx.raise_clamped()
  }
  d
}

///| GDA §9.5.3 clamp. When the result's exponent exceeds `etop`, fold it
/// down to `etop` by multiplying the coefficient by `10^(exp - etop)`, and
/// raise `clamped`. The numeric value is preserved (trailing zeros land in
/// the coefficient instead of the exponent), but the resulting coefficient
/// may exceed `precision` digits — which is fine, since the IEEE-754
/// formats define the storable digit count to *include* the padding.
fn apply_clamp(d : Decimal, ctx : Context) -> Decimal {
  let etop = ctx.e_max - ctx.precision + 1
  if d.exponent <= etop {
    return d
  }
  let pad = d.exponent - etop
  ctx.raise_clamped()
  {
    ..d,
    coefficient: scale_up(d.coefficient, pad),
    exponent: etop,
  }
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

///| The finite rounding path. Decides how many digits to drop based on
/// *both* the precision cap and the etiny floor — taking the larger of
/// the two so a single rounding pass produces a result that already
/// satisfies both constraints, avoiding the double-rounding bias from
/// rounding to precision and then re-rounding to etiny separately.
///
/// e.g., `1.52445E-80` with precision 5 and etiny -83:
/// * Precision alone would drop 1 digit (six → five) and round half-up
///   to `1.5245E-80`, then a subsequent subnormal pass would drop one
///   more and round to `1.525E-80`.
/// * Combined drop is 2 digits, rounding `1.52445E-80` once gives
///   `1.524E-80` (the correctly-rounded subnormal result).
fn round_finite(d : Decimal, ctx : Context) -> Decimal {
  if ctx.precision == 0 {
    return d
  }
  // Zero coefficients have nothing to round; the etiny / e_max exponent
  // clamp lives in check_range's zero branch, where it surfaces Clamped
  // rather than Rounded.
  if d.coefficient.is_zero() {
    return d
  }
  let n = digit_count(d.coefficient)
  let prec_drop = if n > ctx.precision { n - ctx.precision } else { 0 }
  let etiny = ctx.e_min - ctx.precision + 1
  let sub_drop = if etiny > d.exponent { etiny - d.exponent } else { 0 }
  let dropped_len = if prec_drop > sub_drop { prec_drop } else { sub_drop }
  if dropped_len == 0 {
    return d
  }
  // Short-circuit: if every digit lies past the drop point (`dropped_len >
  // n`), `pow10(dropped_len)` would explode for cases like
  // `multiply(0.1, 9E-999999998)` where the natural exponent (-999999999)
  // sits a billion places below etiny. The first-dropped-digit is then a
  // leading zero (the coefficient is padded on the left to dropped_len),
  // so we can decide round_decision by hand without materialising any
  // big factor.
  if dropped_len > n {
    let coef_nonzero = !d.coefficient.is_zero()
    let round_up = match ctx.rounding {
      Down => false
      Up => coef_nonzero
      HalfUp => false
      HalfDown => false
      HalfEven => false
      Ceiling => !d.negative && coef_nonzero
      Floor => d.negative && coef_nonzero
      ZeroFiveUp => coef_nonzero
    }
    let candidate : BigInt = if round_up { 1N } else { 0N }
    ctx.raise_rounded()
    if coef_nonzero {
      ctx.raise_inexact()
    }
    return { ..d, coefficient: candidate, exponent: etiny }
  }
  let divisor = pow10(dropped_len)
  let kept = d.coefficient / divisor
  let dropped = d.coefficient % divisor
  let round_up = round_decision(
    dropped, dropped_len, kept, d.negative, ctx.rounding,
  )
  let candidate = if round_up { kept + 1N } else { kept }
  // 999 → 1000: candidate gained a digit. Check via digit count rather
  // than `candidate >= pow10(precision)` — the latter materialises a
  // huge BigInt when precision is large (e.g. multiply.decTest has
  // sections with precision 999_999, where pow10(999_999) is a
  // million-digit number).
  let (final_coeff, extra) = if digit_count(candidate) > ctx.precision {
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
