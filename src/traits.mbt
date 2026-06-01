// ---------------------------------------------------------------------------
// Numeric Eq / Compare / Hash: a Decimal is a first-class comparable,
// sortable, hashable value.
//
// Equality, ordering, and hashing compare by numeric value: `1.0` and `1.00`
// are equal, `-0` and `+0` are equal, and every cohort of a value hashes
// alike. NaN is reflexive (`NaN == NaN`) and ordered below every other value,
// which makes `Compare` a genuine total order — safe for sorting and for use
// as a map key. The signalling, value-only comparison defined by the
// arithmetic specification stays available as the explicit `compare` /
// `compare_signal` methods.
// ---------------------------------------------------------------------------

///|
/// Total numeric order with NaN ordered below everything (and equal to
/// itself). `-0`/`+0` and differing cohorts of one value compare equal,
/// matching the numeric `Eq`/`Hash` below.
fn numeric_total_cmp(a : Decimal, b : Decimal) -> Int {
  let a_nan = a.class is (QNaN | SNaN)
  let b_nan = b.class is (QNaN | SNaN)
  if a_nan && b_nan {
    0
  } else if a_nan {
    -1
  } else if b_nan {
    1
  } else {
    compare_numeric_int(a, b)
  }
}

///|
/// Numeric equality: `1.0 == 1.00`, `-0 == +0`, and `NaN == NaN` (reflexive,
/// so the impl is lawful with `Hash`). Use `compare_signal` for the
/// signalling, non-reflexive NaN semantics.
pub impl Eq for Decimal with fn equal(self, other) {
  numeric_total_cmp(self, other) == 0
}

///|
/// Total numeric order (NaN lowest). Consistent with `Eq`: `compare == 0`
/// exactly when `==`.
pub impl Compare for Decimal with fn compare(self, other) {
  numeric_total_cmp(self, other)
}

///|
/// Hash consistent with the numeric `Eq`: every cohort of a value hashes the
/// same (trailing zeros stripped), all zeros hash alike regardless of sign,
/// and all NaNs hash alike.
pub impl Hash for Decimal with fn hash_combine(self, hasher) {
  match self.class {
    QNaN | SNaN => hasher.combine_int(0)
    Infinity => {
      hasher.combine_int(1)
      hasher.combine_int(if self.negative { 1 } else { 0 })
    }
    Finite =>
      if self.coefficient.is_zero() {
        hasher.combine_int(2)
      } else {
        let (coef, exp) = strip_trailing_zeros(
          self.coefficient,
          self.exponent,
          _ => true,
        )
        hasher.combine_int(3)
        hasher.combine_int(if self.negative { 1 } else { 0 })
        hasher.combine(coef)
        hasher.combine_int(exp)
      }
  }
}
