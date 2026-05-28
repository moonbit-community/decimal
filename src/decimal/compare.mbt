// ---------------------------------------------------------------------------
// Total-order comparison and quantum equality.
//
// These ops are bit-level — no NaN signalling, no rounding — and complete
// the "Decimal as a comparable, sortable value" story alongside the copy
// family.
// ---------------------------------------------------------------------------

///| GDA `compare-total`: total ordering across every Decimal value,
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

///| GDA `compare-total-magnitude`: `compare-total` applied to `|self|` and
/// `|other|`. Sign-stripping happens via `copy_abs`, which clears the sign
/// bit even on NaN.
pub fn Decimal::compare_total_mag(self : Decimal, other : Decimal) -> Decimal {
  Decimal::compare_total(Decimal::copy_abs(self), Decimal::copy_abs(other))
}

///| GDA `same-quantum`: returns `1` if `self` and `other` have the same
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

///| Return -1 / 0 / 1 for the abstract total order, before wrapping in a
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

///| Class-rank for the positive-side total order. Finite is lowest, then
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

///| Compare two finite Decimals (same sign) in the total order: numerical
/// magnitude first; on a tie, smaller exponent sorts first regardless of
/// sign (per GDA, the rule applies to both positive and negative chains).
fn compare_finite_total(a : Decimal, b : Decimal) -> Int {
  let mag_cmp = compare_magnitudes(
    a.coefficient, a.exponent, b.coefficient, b.exponent,
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

///| Compare the magnitudes of two finite coefficients carrying separate
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
  let a_adj = a_exp + a_coeff.to_string().length() - 1
  let b_adj = b_exp + b_coeff.to_string().length() - 1
  if a_adj != b_adj {
    return if a_adj < b_adj { -1 } else { 1 }
  }
  // Same adjusted exponent — scale one operand to the other's exponent so
  // the bare BigInt comparison is value-accurate. The scaling factor is at
  // most the digit-count difference between coefficients, which is bounded.
  if a_exp == b_exp {
    a_coeff.compare(b_coeff)
  } else if a_exp > b_exp {
    (a_coeff * BigInt::pow(10N, BigInt::from_int(a_exp - b_exp))).compare(
      b_coeff,
    )
  } else {
    a_coeff.compare(
      b_coeff * BigInt::pow(10N, BigInt::from_int(b_exp - a_exp)),
    )
  }
}
