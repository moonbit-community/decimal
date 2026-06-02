///|
/// Decode a single UTF-16 code unit at `i` into a `Char`. Only correct for
/// the ASCII subset of any input; non-BMP / surrogate inputs are out of scope
/// for the call sites that use this helper (decimal grammar + dectest format
/// are ASCII-only).
fn char_at(s : String, i : Int) -> Char {
  s[i].to_int().unsafe_to_char()
}

///|
/// Largest power of ten kept in `pow10_table`. Covers IEEE 754 `decimal128`'s
/// 34-digit precision (and the digit counts the round / align hot paths probe)
/// with wide headroom; shifts beyond it fall back to a one-shot `BigInt::pow`.
const POW10_MAX : Int = 128

///|
/// Pre-computed powers of ten `10^0` … `10^POW10_MAX`, built once at startup,
/// so the hot-path digit-shift / digit-count routines index the table instead
/// of allocating via `BigInt::pow`.
let pow10_table : Array[BigInt] = {
  let table = Array::new(capacity=POW10_MAX + 1)
  let mut p : BigInt = 1N
  for _i in 0..<=POW10_MAX {
    table.push(p)
    p = p * 10N
  }
  table
}

///|
/// Clamp `v` into the inclusive range `[lo, hi]`.
fn clamp(v : Int, lo : Int, hi : Int) -> Int {
  if v < lo {
    lo
  } else if v > hi {
    hi
  } else {
    v
  }
}

///|
/// Compute `10^n` as a `BigInt`. Negative `n` is a programmer error and
/// aborts. Small `n` lands in `pow10_table`; larger `n` allocates fresh.
fn pow10(n : Int) -> BigInt {
  guard n >= 0 else { abort("pow10: negative exponent \{n}") }
  if n < pow10_table.length() {
    pow10_table[n]
  } else {
    BigInt::pow(10N, BigInt::from_int(n))
  }
}

///|
/// Powers of five `5^0` … `5^POW5_MAX`, built once at startup. `from_double`
/// spreads a binary fraction's `2^-k` as `5^k × 10^-k`, so the conversion's hot
/// factor is a power of five; caching them avoids a `BigInt::pow` per call.
const POW5_MAX : Int = 128

///|
let pow5_table : Array[BigInt] = {
  let table = Array::new(capacity=POW5_MAX + 1)
  let mut p : BigInt = 1N
  for _i in 0..<=POW5_MAX {
    table.push(p)
    p = p * 5N
  }
  table
}

///|
/// `5^n` as a `BigInt`. Negative `n` is a programmer error and aborts.
fn pow5(n : Int) -> BigInt {
  guard n >= 0 else { abort("pow5: negative exponent \{n}") }
  if n < pow5_table.length() {
    pow5_table[n]
  } else {
    BigInt::pow(5N, BigInt::from_int(n))
  }
}

///|
/// Number of decimal digits in the magnitude of `b`. Zero counts as one
/// digit. Uses `bit_length() * log10(2)` for an O(1) estimate, then a single
/// power-of-ten comparison to refine the boundary case where the estimate
/// could be off by one.
///
/// This replaces `b.to_string().length()` in every hot-path digit-count
/// reader (`round_finite`, `compare_magnitudes`). For the small coefficients
/// dectest exercises (< 30 digits), avoiding `to_string` is a measurable
/// win — `to_string` does O(n²) grade-school divisions just to discard the
/// resulting characters past their `.length()`.
fn digit_count(b : BigInt) -> Int {
  if b.is_zero() {
    return 1
  }
  let bits = b.bit_length()
  // `log10(2) ≈ 0.30102999566`. The fixed-point factor `30103 / 100000` is
  // accurate enough that the estimate lands either on the true digit count
  // or one off; the comparison against `pow10(estimate)` resolves the tie.
  let estimate = bits * 30103 / 100000 + 1
  if b < pow10(estimate - 1) {
    estimate - 1
  } else {
    estimate
  }
}

///|
/// Try to extract a non-negative `Int64` from a `BigInt` if it fits in 63
/// bits. Returns `None` for values past `Int64.MAX`. The arithmetic ops use
/// this to opt into a fast path for small operands.
fn fits_int64(b : BigInt) -> Int64? {
  if b.bit_length() < 63 {
    Some(b.to_int64())
  } else {
    None
  }
}

///|
/// Convert a non-negative `BigInt` magnitude to a signed `Int`, or `None` if it
/// does not fit the `Int` range. Used to read an integer-valued operand.
fn bigint_to_int(magnitude : BigInt, negative : Bool) -> Int? {
  match fits_int64(magnitude) {
    Some(v) =>
      if v.compare(2147483647L) <= 0 {
        Some(if negative { -v.to_int() } else { v.to_int() })
      } else {
        None
      }
    None => None
  }
}

///|
/// Strip trailing factors of ten from `coef` (raising `exp` to compensate),
/// continuing while the coefficient is non-zero, its last digit is `0`, and
/// `keep` accepts the current exponent. Returns the reduced `(coef, exp)`.
/// Shared by `reduce` and the exact-divide normalisation, which differ only in
/// their `keep` predicate.
fn strip_trailing_zeros(
  coef : BigInt,
  exp : Int,
  keep : (Int) -> Bool,
) -> (BigInt, Int) {
  for c = coef, e = exp {
    if c.is_zero() || !keep(e) {
      break (c, e)
    }
    let q = c / 10N
    if q * 10N == c {
      continue q, e + 1
    } else {
      break (c, e)
    }
  }
}

///|
/// Multiply `coeff` by `10^shift`. Shift must be non-negative. Hot-path
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

///|
fn min_exponent(a : Decimal, b : Decimal) -> Int {
  if a.exponent <= b.exponent {
    a.exponent
  } else {
    b.exponent
  }
}

///|
/// Align two finite Decimals to a shared exponent — the smaller of the two —
/// returning the scaled magnitudes and that shared exponent.
///
/// This is the shape additive ops (add, subtract, numeric-compare) all need:
/// once both magnitudes refer to the same power of ten, the operation is just
/// integer arithmetic on the coefficients with the common exponent preserved.
///
/// `scale_up` is allocation-free for the zero short-circuit and the cached
/// `pow10_table` range, so the helper is cheap for the common case where the
/// exponent gap is small. Callers that have an Int64 fast path live alongside
/// it (e.g. `try_add_finite_small`) handle their own small-int alignment.
fn align(a : Decimal, b : Decimal) -> (BigInt, BigInt, Int) {
  let result_exp = min_exponent(a, b)
  let a_scaled = scale_up(a.coefficient, a.exponent - result_exp)
  let b_scaled = scale_up(b.coefficient, b.exponent - result_exp)
  (a_scaled, b_scaled, result_exp)
}

///|
fn adjusted_exponent(d : Decimal) -> Int {
  adjusted_exponent_parts(d.coefficient, d.exponent)
}

///|
fn adjusted_exponent_parts(coeff : BigInt, exponent : Int) -> Int {
  exponent + digit_count(coeff) - 1
}

///|
/// Add two non-negative magnitudes carrying signs separately, returning the
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

///|
/// Bring `a` and `b` to a representation where `an / bn` (BigInt integer
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
