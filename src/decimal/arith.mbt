///| GDA `minus`: equivalent to `subtract('0', N)`. Concretely:
///
/// * Finite non-zero: flip the sign bit, coefficient and exponent unchanged.
/// * Finite zero: result is `+0` with the same exponent (the GDA addition rule
///   for two zeros with opposite signs yields `+0` under default rounding).
/// * Infinity: flip the sign bit.
/// * QNaN: propagate the operand unchanged (NaN keeps its original sign).
/// * SNaN: convert to QNaN with the same sign and payload. The
///   `Invalid_operation` signal that GDA prescribes here is silently dropped
///   until a `Context` is wired up.
pub fn Decimal::minus(self : Decimal) -> Decimal {
  match self.class {
    QNaN => self
    SNaN => { ..self, class: QNaN }
    Finite =>
      if self.coefficient.is_zero() {
        { ..self, negative: false }
      } else {
        { ..self, negative: !self.negative }
      }
    Infinity => { ..self, negative: !self.negative }
  }
}
