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
pub fn Decimal::add(self : Decimal, other : Decimal, ctx : Context) -> Decimal {
  match (self.class, other.class) {
    (SNaN, _) => {
      ctx.flags.invalid_operation = true
      { ..self, class: QNaN }
    }
    (_, SNaN) => {
      ctx.flags.invalid_operation = true
      { ..other, class: QNaN }
    }
    (QNaN, _) => self
    (_, QNaN) => other
    (Infinity, Infinity) =>
      if self.negative == other.negative {
        self
      } else {
        ctx.flags.invalid_operation = true
        Decimal::nan()
      }
    (Infinity, Finite) => self
    (Finite, Infinity) => other
    (Finite, Finite) => add_finite(self, other).round(ctx)
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
pub fn Decimal::subtract(
  self : Decimal,
  other : Decimal,
  ctx : Context,
) -> Decimal {
  match (self.class, other.class) {
    (SNaN, _) => {
      ctx.flags.invalid_operation = true
      { ..self, class: QNaN }
    }
    (_, SNaN) => {
      ctx.flags.invalid_operation = true
      { ..other, class: QNaN }
    }
    (QNaN, _) => self
    (_, QNaN) => other
    _ => Decimal::add(self, { ..other, negative: !other.negative }, ctx)
  }
}

///| Add two finite Decimals: align to the smaller exponent, combine the
/// signed coefficients, and report the result in the same convention.
///
/// Several short-circuits avoid materialising the alignment factor:
///
/// * `a + 0` collapses to `a` if `a.exponent <= b.exponent` (the result
///   already has the smaller exponent), otherwise the zero side keeps its
///   exponent for trailing-zero preservation.
/// * Symmetric short-circuit for `0 + b`.
/// * "Below the noise" (when both operands are non-zero with an adjusted
///   exponent gap so large no precision-9-or-more context could resolve the
///   smaller operand): we return the larger directly.
fn add_finite(a : Decimal, b : Decimal) -> Decimal {
  // `0 + b` / `a + 0` — common in dectest where one side is `0` to test
  // trailing-zero preservation. We still align exponents (smaller wins) so
  // `0.00 + 1` keeps `1` and `0 + 1.0` keeps `1.0`.
  if b.coefficient.is_zero() && a.negative == b.negative {
    return align_zero_add(a, b)
  }
  if a.coefficient.is_zero() && a.negative == b.negative {
    return align_zero_add(b, a)
  }
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

///| Fast path for `non_zero + zero` (and `zero + zero` when signs match):
/// the result is the non-zero operand, with exponent reduced to the smaller
/// of the two so trailing-zero count is preserved.
fn align_zero_add(non_zero : Decimal, zero : Decimal) -> Decimal {
  if zero.exponent < non_zero.exponent {
    {
      ..non_zero,
      coefficient: scale_up(
        non_zero.coefficient,
        non_zero.exponent - zero.exponent,
      ),
      exponent: zero.exponent,
    }
  } else {
    non_zero
  }
}

///| Multiply `coeff` by `10^shift`. Shift must be non-negative. Hot-path
/// shifts (`< 33`) land in the `pow10_table` cache and avoid a fresh
/// allocation.
///
/// The zero short-circuit matters when callers align around extreme exponent
/// gaps — `0 * 10^huge` is still zero, but materialising the `10^huge` BigInt
/// would consume gigabytes.
fn scale_up(coeff : BigInt, shift : Int) -> BigInt {
  if shift == 0 || coeff.is_zero() {
    coeff
  } else {
    coeff * pow10(shift)
  }
}

///| GDA `multiply`. Coefficients multiply, exponents add, signs XOR.
///
/// Special values follow the usual priority: sNaN wins over QNaN (with the
/// quieten-and-keep-sign rule); `0 * Infinity` is `NaN + Invalid_operation`
/// (signal currently dropped); finite-nonzero * Infinity yields an infinity
/// with the XOR sign; Infinity * Infinity yields the XOR-signed Infinity.
pub fn Decimal::multiply(
  self : Decimal,
  other : Decimal,
  ctx : Context,
) -> Decimal {
  match (self.class, other.class) {
    (SNaN, _) => {
      ctx.flags.invalid_operation = true
      { ..self, class: QNaN }
    }
    (_, SNaN) => {
      ctx.flags.invalid_operation = true
      { ..other, class: QNaN }
    }
    (QNaN, _) => self
    (_, QNaN) => other
    (Finite, Finite) => multiply_finite(self, other).round(ctx)
    (Infinity, Finite) =>
      if other.coefficient.is_zero() {
        ctx.flags.invalid_operation = true
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
        ctx.flags.invalid_operation = true
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
///
/// Short-circuit: when one side's coefficient is zero, the BigInt multiply is
/// `0 * anything = 0` — we skip the call and synthesize the zero directly,
/// saving a heap allocation for the BigInt result.
fn multiply_finite(a : Decimal, b : Decimal) -> Decimal {
  if a.coefficient.is_zero() || b.coefficient.is_zero() {
    return {
      class: Finite,
      negative: a.negative != b.negative,
      coefficient: 0N,
      exponent: a.exponent + b.exponent,
    }
  }
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

// ---------------------------------------------------------------------------
// Integer division and remainder.
//
// `divide_int(a, b)` is the truncated integer quotient of `a / b`;
// `remainder(a, b)` is `a - divide_int(a, b) * b`. Both are exact for the
// finite cases — neither introduces rounding (unlike `divide`, which we
// won't ship until rounding lands).
// ---------------------------------------------------------------------------

///| GDA `divide-integer`: truncated integer quotient `trunc(a / b)`.
///
/// * Special values follow the usual NaN / Infinity propagation rules.
/// * `0 / 0` and `Infinity / Infinity` collapse to NaN (`Invalid_operation`
///   signal currently dropped).
/// * `finite / 0` (with finite ≠ 0) and `Infinity / 0` give a signed
///   Infinity (the GDA `Division_by_zero` signal is also dropped for now).
/// * `finite / Infinity` is a signed zero.
/// * Result exponent for the finite/finite case is `0`: the quotient is by
///   definition an integer.
/// * No precision check; GDA would raise `Division_impossible` if the
///   quotient overflows the active precision. Without a Context that
///   constraint is simply not enforced.
pub fn Decimal::divide_int(
  self : Decimal,
  other : Decimal,
  ctx : Context,
) -> Decimal {
  match (self.class, other.class) {
    (SNaN, _) => {
      ctx.flags.invalid_operation = true
      { ..self, class: QNaN }
    }
    (_, SNaN) => {
      ctx.flags.invalid_operation = true
      { ..other, class: QNaN }
    }
    (QNaN, _) => self
    (_, QNaN) => other
    (Infinity, Infinity) => {
      ctx.flags.invalid_operation = true
      Decimal::nan()
    }
    (Infinity, Finite) => {
      if other.coefficient.is_zero() {
        ctx.flags.division_by_zero = true
      }
      {
        class: Infinity,
        negative: self.negative != other.negative,
        coefficient: 0N,
        exponent: 0,
      }
    }
    (Finite, Infinity) =>
      {
        class: Finite,
        negative: self.negative != other.negative,
        coefficient: 0N,
        exponent: 0,
      }
    (Finite, Finite) =>
      if other.coefficient.is_zero() {
        if self.coefficient.is_zero() {
          ctx.flags.invalid_operation = true
          Decimal::nan()
        } else {
          ctx.flags.division_by_zero = true
          {
            class: Infinity,
            negative: self.negative != other.negative,
            coefficient: 0N,
            exponent: 0,
          }
        }
      } else {
        divide_int_finite(self, other)
      }
  }
}

///| Truncated integer division for finite non-zero divisor.
///
/// Short-circuits via the adjusted exponents: if `|a| < |b|` the integer
/// quotient is zero, and we return before scaling — important when the
/// operands' exponents differ by a billion. If the upper bound on the
/// quotient digit count is implausibly large we surface `NaN` (GDA's
/// `Division_impossible`) instead of attempting an intractable BigInt op.
fn divide_int_finite(a : Decimal, b : Decimal) -> Decimal {
  let adj_a = a.exponent + a.coefficient.to_string().length() - 1
  let adj_b = b.exponent + b.coefficient.to_string().length() - 1
  if adj_a < adj_b {
    return {
      class: Finite,
      negative: a.negative != b.negative,
      coefficient: 0N,
      exponent: 0,
    }
  }
  // `adj_a - adj_b + 1` upper-bounds the digit count of the integer quotient.
  // 100_000 digits is well past any precision a Context would set, so further
  // computation is pointless and the GDA outcome here is Division_impossible.
  if adj_a - adj_b + 1 > 100_000 {
    return Decimal::nan()
  }
  let (an, bn) = align_for_int_div(
    a.coefficient, a.exponent, b.coefficient, b.exponent,
  )
  {
    class: Finite,
    negative: a.negative != b.negative,
    coefficient: an / bn,
    exponent: 0,
  }
}

///| Bring `a` and `b` to a representation where `an / bn` (BigInt integer
/// division) is the truncated integer quotient of the abstract values.
///
/// Value(a) / Value(b) = (a_coeff / b_coeff) * 10^(a_exp - b_exp). To get an
/// integer-division-friendly form, scale up the operand with the larger
/// exponent so the powers of ten cancel.
fn align_for_int_div(
  a_coeff : BigInt,
  a_exp : Int,
  b_coeff : BigInt,
  b_exp : Int,
) -> (BigInt, BigInt) {
  if a_exp >= b_exp {
    (scale_up(a_coeff, a_exp - b_exp), b_coeff)
  } else {
    (a_coeff, scale_up(b_coeff, b_exp - a_exp))
  }
}

///| GDA `remainder`: `a - divide_int(a, b) * b`.
///
/// The result carries `a`'s sign (and exponent `min(a.exp, b.exp)` via the
/// underlying subtract). Special cases:
///
/// * NaN / sNaN propagate per the usual rules.
/// * `Infinity` as dividend, or `0` as divisor: NaN.
/// * Finite dividend with `Infinity` divisor: the dividend is returned
///   unchanged.
pub fn Decimal::remainder(
  self : Decimal,
  other : Decimal,
  ctx : Context,
) -> Decimal {
  let exact_ctx = Context::exact()
  match (self.class, other.class) {
    (SNaN, _) => {
      ctx.flags.invalid_operation = true
      { ..self, class: QNaN }
    }
    (_, SNaN) => {
      ctx.flags.invalid_operation = true
      { ..other, class: QNaN }
    }
    (QNaN, _) => self
    (_, QNaN) => other
    (Infinity, _) => {
      ctx.flags.invalid_operation = true
      Decimal::nan()
    }
    (Finite, Infinity) => self
    (Finite, Finite) =>
      if other.coefficient.is_zero() {
        ctx.flags.invalid_operation = true
        Decimal::nan()
      } else {
        // Intermediate quotient and product stay exact — the final subtract
        // is the only place that applies the caller's precision.
        let quot = divide_int_finite(self, other)
        let prod = Decimal::multiply(quot, other, exact_ctx)
        let result = Decimal::subtract(self, prod, ctx)
        if result.class is Finite && result.coefficient.is_zero() {
          { ..result, negative: self.negative }
        } else {
          result
        }
      }
  }
}
