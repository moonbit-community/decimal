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

///| GDA `plus`: equivalent to `add('0', N)`. Differs from `minus` only on
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

///| GDA `abs`: `minus` if the operand's sign bit is set, `plus` otherwise.
/// Note that for NaN inputs the sign bit is *not* cleared — NaN propagation
/// wins over the "absolute value" intuition, so e.g. `abs(-NaN22) = -NaN22`.
pub fn Decimal::abs(self : Decimal) -> Decimal {
  if self.negative {
    Decimal::minus(self)
  } else {
    Decimal::plus(self)
  }
}

// ---------------------------------------------------------------------------
// Exact addition and subtraction.
//
// No rounding is applied — the result keeps every digit that arises from
// aligning the operand exponents. This is the right thing for dectest cases
// that don't carry an `Inexact`/`Rounded` condition. A future Context layer
// will add rounding-to-precision on top.
// ---------------------------------------------------------------------------

///| GDA `add`: arithmetic addition.
///
/// * sNaN in either operand: result is the sNaN with class quietened to QNaN.
///   sNaN at position 0 wins over sNaN at position 1 (and over any QNaN).
/// * QNaN propagation: if no sNaN, the first NaN (left-to-right) wins, with
///   its sign and payload preserved.
/// * Same-sign infinities: same-sign infinity returned.
/// * Opposite-sign infinities: `+Infinity + -Infinity = NaN` (the
///   `Invalid_operation` signal is dropped until a Context lands).
/// * Infinity + finite: the infinity.
/// * Finite + finite: numerical sum, preserving the smaller exponent (so
///   trailing zeros in either operand survive).
/// * Sign of a zero result: same sign when both operands share a sign,
///   `+0` otherwise (the default-rounding rule).
pub fn Decimal::add(self : Decimal, other : Decimal) -> Decimal {
  match (self.class, other.class) {
    (SNaN, _) => { ..self, class: QNaN }
    (_, SNaN) => { ..other, class: QNaN }
    (QNaN, _) => self
    (_, QNaN) => other
    (Infinity, Infinity) =>
      if self.negative == other.negative {
        self
      } else {
        Decimal::nan()
      }
    (Infinity, Finite) => self
    (Finite, Infinity) => other
    (Finite, Finite) => add_finite(self, other)
  }
}

///| GDA `subtract`. Special values handled directly (so sNaN is reported
/// from the right operand without being quietened en route); finite /
/// infinity cases delegate to `add` after a *bit-level* sign flip on the
/// second operand.
///
/// The flip is intentionally bit-level (not `Decimal::minus`) because GDA's
/// subtract zero-sign rule differs from add's: `subtract(-0, 0) = -0`, which
/// would lose its sign through `minus(0) = +0` followed by
/// `add(-0, +0) = +0`. Flipping the sign without zero-canonicalisation makes
/// `add(-0, -0) = -0` (the same-sign-zeros rule) produce the right answer.
pub fn Decimal::subtract(self : Decimal, other : Decimal) -> Decimal {
  match (self.class, other.class) {
    (SNaN, _) => { ..self, class: QNaN }
    (_, SNaN) => { ..other, class: QNaN }
    (QNaN, _) => self
    (_, QNaN) => other
    _ => Decimal::add(self, { ..other, negative: !other.negative })
  }
}

///| Add two finite Decimals: align to the smaller exponent, combine the
/// signed coefficients, and report the result in the same convention.
fn add_finite(a : Decimal, b : Decimal) -> Decimal {
  let result_exp = if a.exponent <= b.exponent {
    a.exponent
  } else {
    b.exponent
  }
  let a_scaled = scale_up(a.coefficient, a.exponent - result_exp)
  let b_scaled = scale_up(b.coefficient, b.exponent - result_exp)
  let (sum, neg) = signed_add(a_scaled, a.negative, b_scaled, b.negative)
  { class: Finite, negative: neg, coefficient: sum, exponent: result_exp }
}

///| Multiply `coeff` by `10^shift`. Shift must be non-negative.
fn scale_up(coeff : BigInt, shift : Int) -> BigInt {
  if shift == 0 {
    coeff
  } else {
    coeff * BigInt::pow(10N, BigInt::from_int(shift))
  }
}

///| GDA `multiply`. Coefficients multiply, exponents add, signs XOR.
///
/// Special values follow the usual priority: sNaN wins over QNaN (with the
/// quieten-and-keep-sign rule); `0 * Infinity` is `NaN + Invalid_operation`
/// (signal currently dropped); finite-nonzero * Infinity yields an infinity
/// with the XOR sign; Infinity * Infinity yields the XOR-signed Infinity.
pub fn Decimal::multiply(self : Decimal, other : Decimal) -> Decimal {
  match (self.class, other.class) {
    (SNaN, _) => { ..self, class: QNaN }
    (_, SNaN) => { ..other, class: QNaN }
    (QNaN, _) => self
    (_, QNaN) => other
    (Finite, Finite) => multiply_finite(self, other)
    (Infinity, Finite) =>
      if other.coefficient.is_zero() {
        Decimal::nan()
      } else {
        {
          class: Infinity,
          negative: self.negative != other.negative,
          coefficient: 0N,
          exponent: 0,
        }
      }
    (Finite, Infinity) =>
      if self.coefficient.is_zero() {
        Decimal::nan()
      } else {
        {
          class: Infinity,
          negative: self.negative != other.negative,
          coefficient: 0N,
          exponent: 0,
        }
      }
    (Infinity, Infinity) =>
      {
        class: Infinity,
        negative: self.negative != other.negative,
        coefficient: 0N,
        exponent: 0,
      }
  }
}

///| Multiply two finite Decimals: coefficients multiply, exponents add. The
/// result sign is the XOR of operand signs even when the coefficient is zero
/// (so `-0 * +5 = -0`, per GDA's "sign of zero result is XOR of operand signs"
/// rule).
fn multiply_finite(a : Decimal, b : Decimal) -> Decimal {
  {
    class: Finite,
    negative: a.negative != b.negative,
    coefficient: a.coefficient * b.coefficient,
    exponent: a.exponent + b.exponent,
  }
}

///| Add two non-negative magnitudes carrying signs separately, returning the
/// magnitude and sign of the result.
fn signed_add(
  a : BigInt,
  a_neg : Bool,
  b : BigInt,
  b_neg : Bool,
) -> (BigInt, Bool) {
  if a_neg == b_neg {
    // Same sign: magnitudes add, sign preserved (covers +0+0=+0, -0+-0=-0).
    (a + b, a_neg)
  } else {
    // Opposite signs: subtract magnitudes; cancellation yields +0.
    let cmp = a.compare(b)
    if cmp > 0 {
      (a - b, a_neg)
    } else if cmp < 0 {
      (b - a, b_neg)
    } else {
      (0N, false)
    }
  }
}
// ---------------------------------------------------------------------------
// Bit-level sign operations: `copy`, `copy_abs`, `copy_negate`, `copy_sign`.
//
// These never apply arithmetic rules — sNaN passes through as sNaN (no
// `Invalid_operation` signal), payloads are preserved exactly, and zero is
// *not* canonicalised to `+0`. Use these when you want a sign operation
// without disturbing the operand's class.
// ---------------------------------------------------------------------------

///| GDA `copy`: structural identity. The operand is returned unchanged. The
/// op exists in the spec so that `copy(sNaN)` round-trips as `sNaN` instead
/// of being quietened — a property no arithmetic op offers.
pub fn Decimal::copy(self : Decimal) -> Decimal {
  self
}

///| GDA `copyAbs`: clear the sign bit. Unlike `abs`, the sign of NaN is
/// cleared too (`copyAbs(-NaN10) = NaN10`).
pub fn Decimal::copy_abs(self : Decimal) -> Decimal {
  { ..self, negative: false }
}

///| GDA `copyNegate`: flip the sign bit. Unlike `minus`, the sign of NaN is
/// flipped too and zero stays signed.
pub fn Decimal::copy_negate(self : Decimal) -> Decimal {
  { ..self, negative: !self.negative }
}

///| GDA `copySign`: take everything from `self` except the sign bit, which
/// comes from `other`.
pub fn Decimal::copy_sign(self : Decimal, other : Decimal) -> Decimal {
  { ..self, negative: other.negative }
}
