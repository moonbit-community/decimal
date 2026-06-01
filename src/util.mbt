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
/// Powers of five `5^0` … `5^POW5_MAX`, built once at startup. `of_double`
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
/// `10^n` as `Int64` if it fits, `None` if `n >= 19` (10^19 overflows
/// Int64.MAX). The fast-path arithmetic routines use this to choose whether
/// they can align coefficients without leaving the Int64 lane.
let pow10_int64_table : FixedArray[Int64] = [
  1L, 10L, 100L, 1000L, 10000L, 100000L, 1000000L, 10000000L, 100000000L, 1000000000L,
  10000000000L, 100000000000L, 1000000000000L, 10000000000000L, 100000000000000L,
  1000000000000000L, 10000000000000000L, 100000000000000000L, 1000000000000000000L,
]

///|
fn pow10_int64(n : Int) -> Int64? {
  if n >= 0 && n < pow10_int64_table.length() {
    Some(pow10_int64_table[n])
  } else {
    None
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
/// Multiply two non-negative `Int64`s and report overflow with `None`.
/// Used by the small-int multiply fast path to bail out into BigInt when
/// the product exceeds Int64.
fn checked_mul_i64(a : Int64, b : Int64) -> Int64? {
  // The straightforward overflow check: divide back if either is non-zero.
  // For non-negative inputs, `a * b` overflows iff `a > Int64.MAX / b`.
  if a == 0L || b == 0L {
    Some(0L)
  } else if a > 9223372036854775807L / b {
    None
  } else {
    Some(a * b)
  }
}

///|
/// Add two non-negative `Int64`s and report overflow with `None`.
fn checked_add_i64(a : Int64, b : Int64) -> Int64? {
  if a > 9223372036854775807L - b {
    None
  } else {
    Some(a + b)
  }
}
