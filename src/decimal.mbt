///|
/// Classification of a `Decimal` value, following the General Decimal
/// Arithmetic specification (Cowlishaw / IEEE 754-2008 decimal).
pub(all) enum Class {
  /// A finite number `coefficient * 10^exponent`.
  Finite
  /// ±Infinity. The sign is carried by `Decimal.negative`.
  Infinity
  /// Quiet NaN. `coefficient` carries the optional diagnostic payload.
  QNaN
  /// Signaling NaN. `coefficient` carries the optional diagnostic payload.
  SNaN
} derive(Eq)

///|
pub impl Show for Class with fn to_string(self) {
  match self {
    Finite => "Finite"
    Infinity => "Infinity"
    QNaN => "QNaN"
    SNaN => "SNaN"
  }
}

///|
/// Arbitrary-precision signed decimal value, per the General Decimal
/// Arithmetic specification.
///
/// For `class = Finite`, the numeric value is
/// `(-1)^negative * coefficient * 10^exponent`.
///
/// For `class = Infinity`, only `negative` is meaningful.
///
/// For `class = QNaN` / `SNaN`, `coefficient` carries the diagnostic payload
/// (zero if none was specified) and `negative` carries the sign.
///
/// `coefficient` is always non-negative; the sign lives in `negative` so that
/// `-0`, `-Infinity` and `-NaN` round-trip distinctly.
pub struct Decimal {
  class : Class
  negative : Bool
  coefficient : BigInt
  exponent : Int
}

///|
/// Default rendering is GDA `to-scientific-string`. See `Decimal::to_sci_string`.
pub impl Show for Decimal with fn to_string(self) {
  Decimal::to_sci_string(self)
}

///|
/// Construct a finite decimal `(-1)^negative * coefficient * 10^exponent`, or
/// `None` if `coefficient` is negative (the representation keeps the sign in
/// `negative` and the coefficient non-negative). For a signed integer use
/// `of_bigint` / `of_int`; this constructor is for when you need an explicit
/// exponent (e.g. `try_finite(150N, -2)` is `1.50`) or an explicit `-0`.
pub fn Decimal::try_finite(
  coefficient : BigInt,
  exponent : Int,
  negative? : Bool = false,
) -> Decimal? {
  guard coefficient >= 0N else { None }
  Some({ class: Finite, negative, coefficient, exponent })
}

///|
/// Low-level finite constructor that trusts `coefficient >= 0` and skips the
/// check. The result is malformed (and downstream behavior undefined) if the
/// coefficient is negative — callers maintaining the representation invariant
/// use this; everyone else uses `try_finite` or `of_bigint`.
pub fn Decimal::finite_unchecked(
  coefficient : BigInt,
  exponent : Int,
  negative? : Bool = false,
) -> Decimal {
  { class: Finite, negative, coefficient, exponent }
}

///|
/// Shared `+0`, `+1`, and quiet `NaN` singletons. Reused by the
/// constructor wrappers below and by every op that wants to return one of
/// these constants without re-allocating a struct.
let zero_singleton : Decimal = {
  class: Finite,
  negative: false,
  coefficient: 0N,
  exponent: 0,
}

///|
let one_singleton : Decimal = {
  class: Finite,
  negative: false,
  coefficient: 1N,
  exponent: 0,
}

///|
let nan_singleton : Decimal = {
  class: QNaN,
  negative: false,
  coefficient: 0N,
  exponent: 0,
}

///|
/// The decimal `+0`.
pub fn Decimal::zero() -> Decimal {
  zero_singleton
}

///|
/// The decimal `+1`.
pub fn Decimal::one() -> Decimal {
  one_singleton
}

///|
/// `+Infinity`.
pub fn Decimal::infinity() -> Decimal {
  { class: Infinity, negative: false, coefficient: 0N, exponent: 0 }
}

///|
/// `-Infinity`.
pub fn Decimal::neg_infinity() -> Decimal {
  { class: Infinity, negative: true, coefficient: 0N, exponent: 0 }
}

///|
/// A quiet NaN with the given (non-negative) diagnostic payload. The
/// no-payload, non-negative variant returns a shared singleton.
///
/// Panics if `payload` is negative — the payload is stored as the
/// (non-negative) coefficient. A negative payload is a programmer error, not
/// untrusted input, so it fails fast rather than returning an error.
pub fn Decimal::nan(
  payload? : BigInt = 0N,
  negative? : Bool = false,
) -> Decimal {
  guard payload >= 0N else {
    abort("Decimal::nan: payload must be non-negative")
  }
  if !negative && payload.is_zero() {
    nan_singleton
  } else {
    { class: QNaN, negative, coefficient: payload, exponent: 0 }
  }
}

///|
/// A signaling NaN with the given (non-negative) diagnostic payload.
/// Panics if `payload` is negative (a programmer error, as for `nan`).
pub fn Decimal::snan(
  payload? : BigInt = 0N,
  negative? : Bool = false,
) -> Decimal {
  guard payload >= 0N else {
    abort("Decimal::snan: payload must be non-negative")
  }
  { class: SNaN, negative, coefficient: payload, exponent: 0 }
}

///|
/// Lift a `BigInt` into a `Decimal` at exponent 0.
pub fn Decimal::of_bigint(n : BigInt) -> Decimal {
  if n >= 0N {
    { class: Finite, negative: false, coefficient: n, exponent: 0 }
  } else {
    { class: Finite, negative: true, coefficient: -n, exponent: 0 }
  }
}

///|
/// Lift an `Int` into a `Decimal` at exponent 0.
pub fn Decimal::of_int(n : Int) -> Decimal {
  Decimal::of_bigint(BigInt::from_int(n))
}

///|
/// Predicates.
pub fn Decimal::is_finite(self : Decimal) -> Bool {
  self.class is Finite
}

///|
pub fn Decimal::is_infinite(self : Decimal) -> Bool {
  self.class is Infinity
}

///|
pub fn Decimal::is_nan(self : Decimal) -> Bool {
  self.class is QNaN || self.class is SNaN
}

///|
pub fn Decimal::is_signaling(self : Decimal) -> Bool {
  self.class is SNaN
}

///|
/// GDA `canonical`: returns the canonical form of `self`. For this
/// library every value is already canonical, so this is the identity —
/// kept for API completeness alongside `is-canonical`.
pub fn Decimal::canonical(self : Decimal) -> Decimal {
  self
}

///|
/// GDA `class`: render the operand's category as one of the ten symbolic
/// labels from §3.5: `sNaN`, `NaN`, `+Infinity`, `-Infinity`, `+Normal`,
/// `-Normal`, `+Subnormal`, `-Subnormal`, `+Zero`, `-Zero`. The Normal /
/// Subnormal distinction needs the active `Context` to know `e_min`.
///
/// Named `number_class` rather than `class` because `class` is a field
/// name on `Decimal`; the GDA op name `class` would clash with field
/// access syntax.
pub fn Decimal::number_class(self : Decimal, ctx : Context) -> String {
  let sign = if self.negative { "-" } else { "+" }
  match self.class {
    SNaN => "sNaN"
    QNaN => "NaN"
    Infinity => sign + "Infinity"
    Finite =>
      if self.coefficient.is_zero() {
        sign + "Zero"
      } else if self.is_subnormal(ctx) {
        sign + "Subnormal"
      } else {
        sign + "Normal"
      }
  }
}

///|
/// `true` for finite zero (sign-independent: `0` and `-0` both qualify).
pub fn Decimal::is_zero(self : Decimal) -> Bool {
  self.class is Finite && self.coefficient.is_zero()
}

///|
/// Every value produced by this library is canonical — we don't have the
/// IEEE-754 DPD representation's "non-canonical" encoding to worry about,
/// so the answer is unconditionally `true`. Provided for API completeness
/// (`is-canonical` is one of GDA's mandatory predicates).
pub fn Decimal::is_canonical(_self : Decimal) -> Bool {
  true
}

///|
/// `true` for non-zero finite values whose adjusted exponent is within
/// `[ctx.e_min, ctx.e_max]` — i.e. the operand is representable in the
/// "normal" range. Zero and the entire NaN / Infinity family are not
/// normal.
pub fn Decimal::is_normal(self : Decimal, ctx : Context) -> Bool {
  if !(self.class is Finite) {
    return false
  }
  if self.coefficient.is_zero() {
    return false
  }
  let adj = adjusted_exponent(self)
  adj >= ctx.e_min
}

///|
/// `true` for finite non-zero values whose adjusted exponent is below
/// `ctx.e_min` — i.e. the operand is representable but in the gradual-
/// underflow region. `is_normal` and `is_subnormal` partition the
/// finite-non-zero values.
pub fn Decimal::is_subnormal(self : Decimal, ctx : Context) -> Bool {
  if !(self.class is Finite) {
    return false
  }
  if self.coefficient.is_zero() {
    return false
  }
  let adj = adjusted_exponent(self)
  adj < ctx.e_min
}
