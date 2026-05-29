// ---------------------------------------------------------------------------
// Bit-level sign operations: `copy`, `copy_abs`, `copy_negate`, `copy_sign`.
//
// These never apply arithmetic rules — sNaN passes through as sNaN (no
// `Invalid_operation` signal), payloads are preserved exactly, and zero is
// *not* canonicalised to `+0`. Use these when you want a sign operation
// without disturbing the operand's class.
// ---------------------------------------------------------------------------

///|
/// GDA `copy`: structural identity. The operand is returned unchanged. The
/// op exists in the spec so that `copy(sNaN)` round-trips as `sNaN` instead
/// of being quietened — a property no arithmetic op offers.
pub fn Decimal::copy(self : Decimal) -> Decimal {
  self
}

///|
/// GDA `copyAbs`: clear the sign bit. Unlike `abs`, the sign of NaN is
/// cleared too (`copyAbs(-NaN10) = NaN10`).
pub fn Decimal::copy_abs(self : Decimal) -> Decimal {
  { ..self, negative: false }
}

///|
/// GDA `copyNegate`: flip the sign bit. Unlike `minus`, the sign of NaN is
/// flipped too and zero stays signed.
pub fn Decimal::copy_negate(self : Decimal) -> Decimal {
  { ..self, negative: !self.negative }
}

///|
/// GDA `copySign`: take everything from `self` except the sign bit, which
/// comes from `other`.
pub fn Decimal::copy_sign(self : Decimal, other : Decimal) -> Decimal {
  { ..self, negative: other.negative }
}
