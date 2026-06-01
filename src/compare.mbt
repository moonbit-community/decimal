// ---------------------------------------------------------------------------
// Total-order comparison and quantum equality.
//
// These ops are bit-level — no NaN signalling, no rounding — and complete
// the "Decimal as a comparable, sortable value" story alongside the copy
// family.
// ---------------------------------------------------------------------------

///|
/// GDA `compare`: numeric comparison returning `-1`, `0`, or `1` as a
/// Decimal. Distinct from `compare-total` in that NaN operands propagate
/// (compare-total wraps NaN into the total order) and values that are
/// numerically equal but differ in scale (e.g. `1` vs `1.0`) return `0`.
///
/// sNaN in either operand: signals `Invalid_operation` and returns the
/// quietened sNaN. QNaN: propagates per the usual left-to-right rule.
///
/// For infinities: `-Infinity < every finite < +Infinity`. Two infinities
/// of the same sign are equal; opposite signs use the sign rule.
pub fn Decimal::compare(
  self : Decimal,
  other : Decimal,
  ctx : Context,
) -> (Decimal, Flags) {
  let ctx = { ..ctx, flags: Flags::new() }
  (self.compare_raw(other, ctx), ctx.flags)
}

///|
/// Internal worker for `compare`: returns the value, raising into `ctx.flags`.
fn Decimal::compare_raw(
  self : Decimal,
  other : Decimal,
  ctx : Context,
) -> Decimal {
  match propagate_nan(self, other, ctx) {
    Some(d) => return d
    None => ()
  }
  Decimal::of_int(compare_numeric_int(self, other))
}

///|
/// Signed-numeric comparison for non-NaN operands. Returns the same
/// `-1` / `0` / `+1` shape as `compare_total_int`, but follows the
/// "value-only, scale-agnostic" rule of `compare`.
/// `-1` for a negative sign, `+1` for positive — the comparison value of a
/// sign bit.
fn sign_to_cmp(negative : Bool) -> Int {
  if negative {
    -1
  } else {
    1
  }
}

///|
/// Signed-numeric comparison for non-NaN operands.
fn compare_numeric_int(a : Decimal, b : Decimal) -> Int {
  match (a.class, b.class) {
    (Infinity, Infinity) =>
      if a.negative == b.negative {
        0
      } else {
        sign_to_cmp(a.negative)
      }
    (Infinity, Finite) => sign_to_cmp(a.negative)
    (Finite, Infinity) => -sign_to_cmp(b.negative)
    (Finite, Finite) => {
      if a.coefficient.is_zero() && b.coefficient.is_zero() {
        return 0
      }
      if a.negative != b.negative {
        return if a.negative { -1 } else { 1 }
      }
      let mag = compare_magnitudes(
        a.coefficient,
        a.exponent,
        b.coefficient,
        b.exponent,
      )
      if a.negative {
        -mag
      } else {
        mag
      }
    }
    _ => abort("compare_numeric_int: NaN should be filtered by propagate_nan")
  }
}

///|
/// GDA `compare-signal`: numerically compare like `compare`, but signal
/// `Invalid_operation` on *any* NaN operand — quiet NaNs are treated as
/// signaling.
pub fn Decimal::compare_signal(
  self : Decimal,
  other : Decimal,
  ctx : Context,
) -> (Decimal, Flags) {
  let ctx = { ..ctx, flags: Flags::new() }
  (self.compare_signal_raw(other, ctx), ctx.flags)
}

///|
/// Internal worker for `compare_signal`: returns the value, raising into `ctx.flags`.
fn Decimal::compare_signal_raw(
  self : Decimal,
  other : Decimal,
  ctx : Context,
) -> Decimal {
  if self.class is QNaN || other.class is QNaN {
    ctx.raise_invalid_operation()
  }
  // sNaN already raises Invalid_operation inside propagate_nan, so
  // `compare` handles the signaling/quietening for us.
  Decimal::compare_raw(self, other, ctx)
}

///|
/// GDA `max`: numeric maximum.
///
/// Picks the larger operand; on a numerical tie GDA's sign / exponent
/// rule applies (positive over negative; if same sign, larger exponent
/// for the positive chain, smaller exponent for the negative chain).
///
/// NaN handling diverges from `compare`: a single quiet NaN is ignored,
/// and `max(qNaN, x) = x` (with x re-finalised). A signaling NaN still
/// signals and quietens. Both qNaN: canonical NaN returned (the left
/// operand here).
pub fn Decimal::max(
  self : Decimal,
  other : Decimal,
  ctx : Context,
) -> (Decimal, Flags) {
  let ctx = { ..ctx, flags: Flags::new() }
  (self.max_raw(other, ctx), ctx.flags)
}

///|
/// Internal worker for `max`: returns the value, raising into `ctx.flags`.
fn Decimal::max_raw(self : Decimal, other : Decimal, ctx : Context) -> Decimal {
  max_min_choose(self, other, ctx, true, false)
}

///|
/// GDA `min`: numeric minimum. Mirrors `max`'s sign / exponent tiebreak.
pub fn Decimal::min(
  self : Decimal,
  other : Decimal,
  ctx : Context,
) -> (Decimal, Flags) {
  let ctx = { ..ctx, flags: Flags::new() }
  (self.min_raw(other, ctx), ctx.flags)
}

///|
/// Internal worker for `min`: returns the value, raising into `ctx.flags`.
fn Decimal::min_raw(self : Decimal, other : Decimal, ctx : Context) -> Decimal {
  max_min_choose(self, other, ctx, false, false)
}

///|
/// GDA `max-magnitude`: compare by absolute value, returning the operand
/// whose magnitude is larger. Sign of the returned operand is preserved.
/// On a magnitude tie the same sign / exponent rule as `max` applies.
pub fn Decimal::max_magnitude(
  self : Decimal,
  other : Decimal,
  ctx : Context,
) -> (Decimal, Flags) {
  let ctx = { ..ctx, flags: Flags::new() }
  (self.max_magnitude_raw(other, ctx), ctx.flags)
}

///|
/// Internal worker for `max_magnitude`: returns the value, raising into `ctx.flags`.
fn Decimal::max_magnitude_raw(
  self : Decimal,
  other : Decimal,
  ctx : Context,
) -> Decimal {
  max_min_choose(self, other, ctx, true, true)
}

///|
/// GDA `min-magnitude`: compare by absolute value, returning the operand
/// whose magnitude is smaller.
pub fn Decimal::min_magnitude(
  self : Decimal,
  other : Decimal,
  ctx : Context,
) -> (Decimal, Flags) {
  let ctx = { ..ctx, flags: Flags::new() }
  (self.min_magnitude_raw(other, ctx), ctx.flags)
}

///|
/// Internal worker for `min_magnitude`: returns the value, raising into `ctx.flags`.
fn Decimal::min_magnitude_raw(
  self : Decimal,
  other : Decimal,
  ctx : Context,
) -> Decimal {
  max_min_choose(self, other, ctx, false, true)
}

///|
/// Shared backbone for max / min / max-magnitude / min-magnitude.
///
/// NaN routing for max / min:
/// * Any sNaN → signal `Invalid_operation`, return it quietened.
/// * Exactly one qNaN → return the other operand (finalised under ctx).
/// * Both qNaN → return `self` as the canonical NaN (no signal).
///
/// For non-NaN pairs the chosen operand is finalised under ctx — `max`
/// rounds its result the way an arithmetic op would.
fn max_min_choose(
  a : Decimal,
  b : Decimal,
  ctx : Context,
  is_max : Bool,
  magnitude : Bool,
) -> Decimal {
  if a.class is SNaN {
    return quiet_snan(a, ctx)
  }
  if b.class is SNaN {
    return quiet_snan(b, ctx)
  }
  let a_qnan = a.class is QNaN
  let b_qnan = b.class is QNaN
  if a_qnan && b_qnan {
    return truncate_nan_payload(a, ctx)
  }
  if a_qnan {
    return b.finalize_raw(ctx)
  }
  if b_qnan {
    return a.finalize_raw(ctx)
  }
  let cmp = if magnitude {
    compare_numeric_int({ ..a, negative: false }, { ..b, negative: false })
  } else {
    compare_numeric_int(a, b)
  }
  // `pick_max` is +1 to choose `a`, -1 to choose `b`, under the `max`
  // orientation. On a numerical tie GDA breaks by sign, then by exponent
  // (whichever lies further from zero in the chosen direction).
  let pick_max = if cmp != 0 {
    cmp
  } else if a.negative != b.negative {
    sign_to_cmp(a.negative)
  } else if a.negative {
    // Both negative: the smaller exponent is the larger magnitude.
    if a.exponent < b.exponent {
      1
    } else {
      -1
    }
    // Both positive: the larger exponent is the larger value.
  } else if a.exponent > b.exponent {
    1
  } else {
    -1
  }
  let pick = if is_max { pick_max } else { -pick_max }
  let choice = if pick > 0 { a } else { b }
  choice.finalize_raw(ctx)
}

///|
/// GDA `compare-total`: total ordering across every Decimal value,
/// including NaNs. Returns `-1`, `0`, or `1` as a `Decimal`.
///
/// Ordering, from smallest to largest:
///
/// ```text
///   -NaN(p) ... < -sNaN(p) ... < -Infinity < -finite ... <
///   +0 = -0 (per numerical value, broken by exponent)
///   ... +finite < +Infinity < +sNaN(p) ... < +NaN(p) ...
/// ```
///
/// For numerically-equal finites with different exponents, the operand with
/// the smaller exponent sorts first — regardless of sign. This is GDA's
/// sign-independent tie-break rule.
pub fn Decimal::compare_total(self : Decimal, other : Decimal) -> Decimal {
  Decimal::of_int(compare_total_int(self, other))
}

///|
/// GDA `compare-total-magnitude`: `compare-total` applied to `|self|` and
/// `|other|`. Sign-stripping happens via `copy_abs`, which clears the sign
/// bit even on NaN.
pub fn Decimal::compare_total_mag(self : Decimal, other : Decimal) -> Decimal {
  Decimal::compare_total(Decimal::copy_abs(self), Decimal::copy_abs(other))
}

///|
/// GDA `same-quantum`: returns `1` if `self` and `other` have the same
/// exponent, `0` otherwise. Finites compare exponents directly; two
/// infinities count as the same quantum; any two NaNs (sign-agnostic, both
/// QNaN and SNaN) count as the same; mismatched classes return `0`.
pub fn Decimal::same_quantum(self : Decimal, other : Decimal) -> Decimal {
  let same = match (self.class, other.class) {
    (Finite, Finite) => self.exponent == other.exponent
    (Infinity, Infinity) => true
    (QNaN, QNaN) | (QNaN, SNaN) | (SNaN, QNaN) | (SNaN, SNaN) => true
    _ => false
  }
  if same {
    Decimal::one()
  } else {
    Decimal::zero()
  }
}

///|
/// Return -1 / 0 / 1 for the abstract total order, before wrapping in a
/// `Decimal` at the public boundary.
fn compare_total_int(a : Decimal, b : Decimal) -> Int {
  // 1. Different signs: negative < positive.
  if a.negative != b.negative {
    return if a.negative { -1 } else { 1 }
  }
  // 2. Same sign. Compare class rank.
  let a_rank = class_rank(a.class)
  let b_rank = class_rank(b.class)
  if a_rank != b_rank {
    let raw = if a_rank < b_rank { -1 } else { 1 }
    // The class-rank ordering above is the positive-side ordering; mirror
    // it on the negative side so that `-NaN < -sNaN < -Infinity < -finite`.
    return if a.negative { -raw } else { raw }
  }
  // 3. Same class.
  match a.class {
    Finite => compare_finite_total(a, b)
    Infinity => 0
    QNaN | SNaN => {
      let payload_cmp = a.coefficient.compare(b.coefficient)
      if a.negative {
        -payload_cmp
      } else {
        payload_cmp
      }
    }
  }
}

///|
/// Class-rank for the positive-side total order. Finite is lowest, then
/// Infinity, then SNaN, then QNaN. The negative side mirrors this in
/// `compare_total_int`.
fn class_rank(c : Class) -> Int {
  match c {
    Finite => 0
    Infinity => 1
    SNaN => 2
    QNaN => 3
  }
}

///|
/// Compare two finite Decimals (same sign) in the total order: numerical
/// magnitude first; on a tie, smaller exponent sorts first regardless of
/// sign (per GDA, the rule applies to both positive and negative chains).
fn compare_finite_total(a : Decimal, b : Decimal) -> Int {
  let mag_cmp = compare_magnitudes(
    a.coefficient,
    a.exponent,
    b.coefficient,
    b.exponent,
  )
  let value_cmp = if a.negative { -mag_cmp } else { mag_cmp }
  if value_cmp != 0 {
    return value_cmp
  }
  // Numerically equal — break the tie by exponent. The rule mirrors the sign:
  // on the positive side, larger exponent sorts higher (1 > 1.0); on the
  // negative side, larger exponent sorts lower (-0 < -0.0). Equivalently,
  // larger exponent always moves further from zero in the signed direction.
  let raw = if a.exponent > b.exponent {
    1
  } else if a.exponent < b.exponent {
    -1
  } else {
    0
  }
  if a.negative {
    -raw
  } else {
    raw
  }
}

///|
/// Compare the magnitudes of two finite coefficients carrying separate
/// exponents. Adjusted-exponent fast path avoids materialising
/// scaled-up-by-billion BigInts when the magnitudes differ by orders.
fn compare_magnitudes(
  a_coeff : BigInt,
  a_exp : Int,
  b_coeff : BigInt,
  b_exp : Int,
) -> Int {
  let a_zero = a_coeff.is_zero()
  let b_zero = b_coeff.is_zero()
  if a_zero && b_zero {
    return 0
  }
  if a_zero {
    return -1
  }
  if b_zero {
    return 1
  }
  let a_adj = adjusted_exponent_parts(a_coeff, a_exp)
  let b_adj = adjusted_exponent_parts(b_coeff, b_exp)
  if a_adj != b_adj {
    return if a_adj < b_adj { -1 } else { 1 }
  }
  // Same adjusted exponent — scale one operand to the other's exponent so
  // the bare BigInt comparison is value-accurate. The scaling factor is at
  // most the digit-count difference between coefficients, which is bounded.
  if a_exp == b_exp {
    a_coeff.compare(b_coeff)
  } else if a_exp > b_exp {
    (a_coeff * pow10(a_exp - b_exp)).compare(b_coeff)
  } else {
    a_coeff.compare(b_coeff * pow10(b_exp - a_exp))
  }
}
