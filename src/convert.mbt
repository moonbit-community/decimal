// ---------------------------------------------------------------------------
// Conversions between `Decimal` and the machine numeric types.
//
// Two directions with deliberately different totality:
//
// * `of_*` widen a machine value into the (broader) decimal domain. They are
//   total and exact — `from_double` keeps every bit of the binary value.
// * `to_*` narrow a decimal into a (smaller) machine type, so they are
//   partial: the integer extractors return `None` when the value is not a
//   finite integer or falls outside the target's range, and `to_double`
//   stays total but lossy (rounding to the nearest representable binary64,
//   with out-of-range magnitudes saturating to ±Infinity).
//
// Rounding a non-integer down to an integer first is the caller's job, via
// `to_integral_value` / `to_integral_exact`; these extractors never discard
// a fractional part silently.
// ---------------------------------------------------------------------------

///|
/// Exact powers of ten `10^0` … `10^22` as binary64. Each is exactly
/// representable (`10^k = 2^k * 5^k` and `5^22 < 2^52`, so the 53-bit
/// significand holds it without rounding), which is what makes the `to_double`
/// fast path a single correctly-rounded operation.
let pow10_dbl_table : Array[Double] = {
  let t = Array::new(capacity=23)
  let mut p = 1.0
  for _i in 0..<=22 {
    t.push(p)
    p = p * 10.0
  }
  t
}

///|
/// Lift an `Int64` into a `Decimal` at exponent 0. Exact and total.
pub fn Decimal::from_int64(n : Int64) -> Decimal {
  Decimal::from_bigint(BigInt::from_int64(n))
}

///|
/// Convert a binary64 `Double` into the `Decimal` carrying its *exact* value.
///
/// A finite double is a binary fraction `±mantissa × 2^e`, which has an exact
/// finite decimal expansion — so the result is faithful, not rounded:
/// `from_double(0.1)` is `0.1000000000000000055511151231257827021181583404541015625`,
/// the value `0.1` actually denotes in binary64. (For the short, human-facing
/// form instead, parse the rendered string: `Decimal::parse(d.to_string())`.)
///
/// `NaN` and `±Infinity` map to the corresponding decimal specials.
pub fn Decimal::from_double(x : Double) -> Decimal {
  let bits = x.reinterpret_as_int64()
  let negative = bits < 0L
  // Bit layout: [sign:1][biased exponent:11][fraction:52].
  let raw_exp = ((bits >> 52) & 0x7FFL).to_int()
  let frac = bits & 0xF_FFFF_FFFF_FFFFL
  if raw_exp == 0x7FF {
    return if frac == 0L {
      signed_infinity(negative)
    } else {
      Decimal::nan(negative~)
    }
  }
  // Reconstruct the significand and its power-of-two scale. Normal numbers
  // carry the implicit leading 1; subnormals do not and sit at the fixed
  // minimum exponent.
  let (mantissa, exp2) = if raw_exp == 0 {
    (frac, -1074)
  } else {
    (frac | (1L << 52), raw_exp - 1075)
  }
  if mantissa == 0L {
    return finite_zero(0, negative)
  }
  // Strip the significand's trailing factors of two, lifting them into the
  // exponent. This yields the canonical exact decimal (the cohort member with
  // the fewest trailing zeros): `from_double(2.0)` is `2`, not `2.000…`.
  let (mantissa, exp2) = for m = mantissa, e = exp2; (m & 1L) == 0L; {
    continue m >> 1, e + 1
  } nobreak {
    (m, e)
  }
  // mantissa < 2^53, so it always fits a positive Int64 → BigInt.
  let m = BigInt::from_int64(mantissa)
  // value = m × 2^exp2. For exp2 ≥ 0 that is an integer; for exp2 < 0 spread
  // the 2^exp2 as 5^|exp2| × 10^exp2 so the coefficient stays integral.
  let (coefficient, exponent) = if exp2 >= 0 {
    (m << exp2, 0)
  } else {
    (m * pow5(-exp2), exp2)
  }
  { class: Finite, negative, coefficient, exponent }
}

///|
/// The exact integer value of `self` as a `BigInt`, or `None` when `self` is
/// not a finite integer (NaN, ±Infinity, or carrying a non-zero fractional
/// part). `-0` converts to `0`.
pub fn Decimal::to_bigint(self : Decimal) -> BigInt? {
  guard self.class is Finite else { None }
  let magnitude = if self.exponent >= 0 {
    self.coefficient * pow10(self.exponent)
  } else {
    let divisor = pow10(-self.exponent)
    // A non-zero remainder means there is a fractional part to lose, so the
    // value is not an integer and the conversion fails rather than truncates.
    guard (self.coefficient % divisor).is_zero() else { return None }
    self.coefficient / divisor
  }
  Some(if self.negative { -magnitude } else { magnitude })
}

///|
/// The exact value of `self` as a machine `Int`, or `None` when it is not a
/// finite integer or falls outside `[Int::min_value, Int::max_value]`.
pub fn Decimal::to_int(self : Decimal) -> Int? {
  guard self.to_bigint() is Some(n) else { return None }
  guard n >= -2147483648N && n <= 2147483647N else { return None }
  Some(n.to_int())
}

///|
/// The exact value of `self` as a machine `Int64`, or `None` when it is not a
/// finite integer or falls outside `[Int64::min_value, Int64::max_value]`.
pub fn Decimal::to_int64(self : Decimal) -> Int64? {
  guard self.to_bigint() is Some(n) else { return None }
  guard n >= -9223372036854775808N && n <= 9223372036854775807N else {
    return None
  }
  Some(n.to_int64())
}

///|
/// Convert `self` to the nearest binary64 `Double`. Total but lossy: finite
/// values round to nearest (delegating to the standard library's
/// correctly-rounded decimal-string parser), magnitudes beyond binary64's
/// range saturate to `±Infinity`, and the decimal specials map across
/// directly.
pub fn Decimal::to_double(self : Decimal) -> Double {
  match self.class {
    QNaN | SNaN => (0.0 : Double) / 0.0
    Infinity =>
      if self.negative {
        (-1.0 : Double) / 0.0
      } else {
        (1.0 : Double) / 0.0
      }
    Finite => {
      let e = self.exponent
      if e >= -22 && e <= 22 && self.coefficient.bit_length() <= 53 {
        // Clinger fast path: when the coefficient is exact in binary64
        // (< 2^53, i.e. bit_length <= 53) and 10^|exponent| is exactly
        // representable (|exponent| <= 22, since 10^k = 2^k * 5^k with
        // 5^22 < 2^52), the value is a single product/quotient of two exact
        // doubles. Round-to-nearest-even then performs exactly one rounding,
        // so the result is the correctly-rounded binary64 — identical to the
        // string route but without building a literal or running the parser.
        let c = self.coefficient.to_int64().to_double()
        let r = if e >= 0 {
          c * pow10_dbl_table[e]
        } else {
          c / pow10_dbl_table[-e]
        }
        // r is +0.0 when the coefficient is zero; reattach the sign so -0
        // maps to -0.0 exactly as the string route did.
        if self.negative {
          -r
        } else {
          r
        }
      } else {
        // A minimal `<coefficient>e<exponent>` literal parses to the same value
        // the stdlib rounds correctly — cheaper to build than the full
        // scientific string. The only failure mode is an exponent past binary64's
        // range, which saturates to a signed infinity.
        let sign = if self.negative { "-" } else { "" }
        let literal = sign +
          coeff_to_string(self.coefficient) +
          "e" +
          self.exponent.to_string()
        @string.parse_double(literal) catch {
          _ =>
            if self.negative {
              (-1.0 : Double) / 0.0
            } else {
              (1.0 : Double) / 0.0
            }
        }
      }
    }
  }
}
