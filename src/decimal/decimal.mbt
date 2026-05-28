///| Classification of a `Decimal` value, following the General Decimal
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

///| Arbitrary-precision signed decimal value, per the General Decimal
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
pub(all) struct Decimal {
  class : Class
  negative : Bool
  coefficient : BigInt
  exponent : Int
} derive(Eq)

///| Construct a finite decimal `(-1)^negative * coefficient * 10^exponent`.
/// Panics if `coefficient` is negative — encode the sign in `negative` instead.
pub fn Decimal::finite(
  coefficient : BigInt,
  exponent : Int,
  negative~ : Bool = false,
) -> Decimal {
  guard coefficient >= 0N else { abort("Decimal::finite: coefficient must be non-negative") }
  { class: Finite, negative, coefficient, exponent }
}

///| The decimal `+0`.
pub fn Decimal::zero() -> Decimal {
  { class: Finite, negative: false, coefficient: 0N, exponent: 0 }
}

///| The decimal `+1`.
pub fn Decimal::one() -> Decimal {
  { class: Finite, negative: false, coefficient: 1N, exponent: 0 }
}

///| `+Infinity`.
pub fn Decimal::infinity() -> Decimal {
  { class: Infinity, negative: false, coefficient: 0N, exponent: 0 }
}

///| `-Infinity`.
pub fn Decimal::neg_infinity() -> Decimal {
  { class: Infinity, negative: true, coefficient: 0N, exponent: 0 }
}

///| A quiet NaN with the given (non-negative) diagnostic payload.
pub fn Decimal::nan(payload~ : BigInt = 0N, negative~ : Bool = false) -> Decimal {
  guard payload >= 0N else { abort("Decimal::nan: payload must be non-negative") }
  { class: QNaN, negative, coefficient: payload, exponent: 0 }
}

///| A signaling NaN with the given (non-negative) diagnostic payload.
pub fn Decimal::snan(payload~ : BigInt = 0N, negative~ : Bool = false) -> Decimal {
  guard payload >= 0N else { abort("Decimal::snan: payload must be non-negative") }
  { class: SNaN, negative, coefficient: payload, exponent: 0 }
}

///| Lift a `BigInt` into a `Decimal` at exponent 0.
pub fn Decimal::of_bigint(n : BigInt) -> Decimal {
  if n >= 0N {
    { class: Finite, negative: false, coefficient: n, exponent: 0 }
  } else {
    { class: Finite, negative: true, coefficient: -n, exponent: 0 }
  }
}

///| Lift an `Int` into a `Decimal` at exponent 0.
pub fn Decimal::of_int(n : Int) -> Decimal {
  Decimal::of_bigint(BigInt::from_int(n))
}

///| Predicates.
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
