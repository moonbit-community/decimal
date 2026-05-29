///|
/// GDA `minus`: equivalent to `subtract('0', N)`. Concretely:
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

///|
/// GDA `plus`: equivalent to `add('0', N)`. Differs from `minus` only on
/// finite non-zero and Infinity (where it preserves the sign instead of
/// flipping). Zero is canonicalized to `+0`, QNaN propagates unchanged, and
/// sNaN is silently quietened.
pub fn Decimal::plus(self : Decimal) -> Decimal {
  match self.class {
    QNaN => self
    SNaN => { ..self, class: QNaN }
    Finite =>
      if self.coefficient.is_zero() {
        { ..self, negative: false }
      } else {
        self
      }
    Infinity => self
  }
}

///|
/// GDA `abs`: `minus` if the operand's sign bit is set, `plus` otherwise.
/// Note that for NaN inputs the sign bit is *not* cleared — NaN propagation
/// wins over the "absolute value" intuition, so e.g. `abs(-NaN22) = -NaN22`.
pub fn Decimal::abs(self : Decimal) -> Decimal {
  if self.negative {
    Decimal::minus(self)
  } else {
    Decimal::plus(self)
  }
}
