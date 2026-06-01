// ---------------------------------------------------------------------------
// next-plus / next-minus / next-toward: walk the representable lattice.
//
// next-plus returns the smallest representable value strictly greater than
// the operand (within the active context's precision and exponent range);
// next-minus is its mirror. next-toward picks the direction based on which
// of the two operands is larger numerically. IEEE-754 names these
// nextUp / nextDown.
// ---------------------------------------------------------------------------

///|
/// GDA `next-plus`: smallest representable value greater than `self`.
fn Decimal::next_plus_raw(self : Decimal, ctx : Context) -> Decimal {
  match self.class {
    SNaN => quiet_snan(self, ctx)
    QNaN => self
    Infinity => if self.negative { largest_finite(true, ctx) } else { self }
    Finite => next_step(self, ctx, true)
  }
}

///|
/// GDA `next-minus`: largest representable value less than `self`.
fn Decimal::next_minus_raw(self : Decimal, ctx : Context) -> Decimal {
  match self.class {
    SNaN => quiet_snan(self, ctx)
    QNaN => self
    Infinity => if self.negative { self } else { largest_finite(false, ctx) }
    Finite => next_step(self, ctx, false)
  }
}

///|
/// GDA `next-toward`: walk `self` one ULP toward `other`. When the two
/// operands compare equal numerically, return `self` (with `other`'s sign
/// in the equal-zero case, per GDA's sign-of-zero rule for next-toward).
fn Decimal::next_toward_raw(
  self : Decimal,
  other : Decimal,
  ctx : Context,
) -> Decimal {
  match propagate_nan(self, other, ctx) {
    Some(d) => return d
    None => ()
  }
  let cmp = compare_numeric_int(self, other)
  if cmp == 0 {
    // Numerically equal — the value is unchanged but takes `other`'s sign, so
    // `nextToward(0.00, -0.0000)` yields `-0.00`, not `+0.00`. Quiet.
    return { ..self, negative: other.negative }
  }
  // The step itself is quiet (`next_plus` / `next_minus`), but next-toward
  // additionally signals when the stepped result leaves the normal range:
  // Overflow on Infinity, and Subnormal / Underflow when the result is below
  // e_min (with Clamped when the step collapses to a signed zero at etiny).
  // Inexact / Rounded accompany those — the true next value sits infinitely
  // close, so reaching a representable one is a rounding. Normal-range steps
  // stay quiet.
  let stepped = if cmp < 0 {
    Decimal::next_plus_raw(self, ctx)
  } else {
    Decimal::next_minus_raw(self, ctx)
  }
  raise_next_toward_flags(stepped, ctx)
  stepped
}

///|
/// Raise the status flags for a `next-toward` result whose value left the
/// normal range. See `next_toward` for the rationale.
fn raise_next_toward_flags(result : Decimal, ctx : Context) -> Unit {
  match result.class {
    Infinity => {
      ctx.raise_overflow()
      ctx.raise_inexact()
      ctx.raise_rounded()
    }
    Finite =>
      if result.coefficient.is_zero() {
        // Stepped across zero to a signed zero pinned at etiny.
        ctx.raise_subnormal()
        ctx.raise_underflow()
        ctx.raise_inexact()
        ctx.raise_rounded()
        ctx.raise_clamped()
      } else if adjusted_exponent(result) < ctx.e_min {
        ctx.raise_subnormal()
        ctx.raise_underflow()
        ctx.raise_inexact()
        ctx.raise_rounded()
      }
    _ => ()
  }
}

///|
/// The largest finite representable: `(10^precision - 1) × 10^etop`.
fn largest_finite(negative : Bool, ctx : Context) -> Decimal {
  let etop = ctx.etop()
  {
    class: Finite,
    negative,
    coefficient: pow10(ctx.precision) - 1N,
    exponent: etop,
  }
}

///|
/// Smallest positive subnormal: `1 × 10^etiny`. The next step above zero.
fn smallest_subnormal(negative : Bool, ctx : Context) -> Decimal {
  let etiny = ctx.etiny()
  { class: Finite, negative, coefficient: 1N, exponent: etiny }
}

///|
/// Unified step: `step_up == true` walks toward +∞ (next-plus), `false`
/// walks toward -∞ (next-minus). Routes through the sign-flipped helpers
/// so the directional logic lives in one place.
///
/// This is a *quiet* computation — it raises no status flags. `next-plus` /
/// `next-minus` are defined to be quiet; `next-toward` shares the same
/// stepping but raises its own flags from the result (see `next_toward`).
fn next_step(x : Decimal, ctx : Context, step_up : Bool) -> Decimal {
  if ctx.precision <= 0 {
    return invalid_nan(ctx)
  }
  // Zero special-case: next-plus(±0) = smallest +subnormal;
  // next-minus(±0) = smallest -subnormal. The input's sign is dropped.
  if x.coefficient.is_zero() {
    return smallest_subnormal(!step_up, ctx)
  }
  // Reduce to magnitude work: if the input is positive, "step up" walks
  // away from zero (increase magnitude) and "step down" walks toward zero
  // (decrease magnitude). For negative inputs the directions invert.
  let walking_away = (step_up && !x.negative) || (!step_up && x.negative)
  let stepped = if walking_away {
    step_magnitude_up(x.coefficient, x.exponent, ctx)
  } else {
    step_magnitude_down(x.coefficient, x.exponent, ctx)
  }
  match stepped {
    // Stepping past the largest representable lands on a signed Infinity.
    Overflow => signed_infinity(x.negative)
    // Magnitude stepped to zero — a signed zero at etiny on the opposite side
    // (next-plus(-tiny) → -0; next-minus(tiny) → +0).
    Zero => finite_zero(ctx.etiny(), x.negative)
    Value(coef, exp) =>
      { class: Finite, negative: x.negative, coefficient: coef, exponent: exp }
  }
}

///|
/// Outcome of a magnitude step: a concrete next value, or the "we went
/// past the largest representable" / "we went past zero" boundary.
priv enum StepResult {
  Value(BigInt, Int)
  Overflow
  Zero
}

///|
/// Step the magnitude `coef × 10^exp` up by 1 ULP under the active
/// precision / exponent range. The input is assumed positive and non-zero.
///
/// Over-precision inputs first round Ceiling-style (round toward larger
/// magnitude); if the rounding moved the value, that's already the
/// next-up. Otherwise the rounded result has its low digit incremented.
fn step_magnitude_up(coef : BigInt, exp : Int, ctx : Context) -> StepResult {
  let etop = ctx.etop()
  let etiny = ctx.etiny()
  let n = digit_count(coef)
  let adj = exp + n - 1
  // Below-tininess: smallest representable above zero.
  if adj < etiny {
    return Value(1N, etiny)
  }
  // Over-precision: Ceiling-style round, returning early if rounding
  // actually moved the value upward.
  let (c0, e0) = if n > ctx.precision {
    let drop = n - ctx.precision
    let divisor = pow10(drop)
    let kept = coef / divisor
    let dropped = coef % divisor
    let new_exp = exp + drop
    if !dropped.is_zero() {
      let candidate = kept + 1N
      let cap = pow10(ctx.precision)
      if candidate >= cap {
        let bumped = new_exp + 1
        if bumped > etop {
          return Overflow
        }
        return Value(candidate / 10N, bumped)
      }
      return Value(candidate, new_exp)
    }
    (kept, new_exp)
  } else {
    (coef, exp)
  }
  // At precision: pad if allowed, then add 1 ULP.
  let (c, e) = normalise_for_step(c0, e0, ctx.precision, etiny)
  let new_coef = c + 1N
  let cap = pow10(ctx.precision)
  if new_coef >= cap {
    let bumped_exp = e + 1
    if bumped_exp > etop {
      return Overflow
    }
    return Value(new_coef / 10N, bumped_exp)
  }
  Value(new_coef, e)
}

///|
/// Step the magnitude `coef × 10^exp` down by 1 ULP. Symmetric to
/// `step_magnitude_up`; the boundary case is the precision-floor crossing
/// (10^(p-1) → 10^p - 1 at exp - 1).
///
/// Over-precision inputs first Floor-truncate (drop the excess digits);
/// the truncated value is strictly less than the original, so that *is*
/// the next-down.
fn step_magnitude_down(coef : BigInt, exp : Int, ctx : Context) -> StepResult {
  let etiny = ctx.etiny()
  let n = digit_count(coef)
  let adj = exp + n - 1
  if adj < etiny {
    return Zero
  }
  let (c0, e0) = if n > ctx.precision {
    let drop = n - ctx.precision
    let divisor = pow10(drop)
    let kept = coef / divisor
    let dropped = coef % divisor
    let new_exp = exp + drop
    if !dropped.is_zero() {
      // Floor truncation already produced a value below the original.
      return Value(kept, new_exp)
    }
    (kept, new_exp)
  } else {
    (coef, exp)
  }
  let (c, e) = normalise_for_step(c0, e0, ctx.precision, etiny)
  let cap_min = pow10(ctx.precision - 1)
  if c == cap_min && e > etiny {
    return Value(pow10(ctx.precision) - 1N, e - 1)
  }
  let new_coef = c - 1N
  if new_coef.is_zero() {
    return Zero
  }
  Value(new_coef, e)
}

///|
/// Pad the coefficient with trailing zeros (lowering the exponent) so it
/// reaches `precision` digits — but never fall below `etiny`. Inputs whose
/// natural digit count already exceeds precision are returned as-is; the
/// boundary handling in `step_magnitude_up` / `step_magnitude_down` deals
/// with the wraparound at that point.
fn normalise_for_step(
  coef : BigInt,
  exp : Int,
  precision : Int,
  etiny : Int,
) -> (BigInt, Int) {
  let n = digit_count(coef)
  if n >= precision {
    return (coef, exp)
  }
  let pad_max = exp - etiny
  if pad_max <= 0 {
    return (coef, exp)
  }
  let pad = if precision - n < pad_max { precision - n } else { pad_max }
  (coef * pow10(pad), exp - pad)
}

///|
pub fn Decimal::next_toward(
  self : Decimal,
  other : Decimal,
  ctx : Context,
) -> (Decimal, Flags) {
  let ctx = { ..ctx, flags: Flags::new() }
  (self.next_toward_raw(other, ctx), ctx.flags)
}

///|
pub fn Decimal::next_plus(self : Decimal, ctx : Context) -> (Decimal, Flags) {
  let ctx = { ..ctx, flags: Flags::new() }
  (self.next_plus_raw(ctx), ctx.flags)
}

///|
pub fn Decimal::next_minus(self : Decimal, ctx : Context) -> (Decimal, Flags) {
  let ctx = { ..ctx, flags: Flags::new() }
  (self.next_minus_raw(ctx), ctx.flags)
}
