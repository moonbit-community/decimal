///| Decode a single UTF-16 code unit at `i` into a `Char`. Only correct for
/// the ASCII subset of any input; non-BMP / surrogate inputs are out of scope
/// for the call sites that use this helper (decimal grammar + dectest format
/// are ASCII-only).
fn char_at(s : String, i : Int) -> Char {
  s[i].to_int().unsafe_to_char()
}

///| Pre-computed powers of ten covering every shift that fits in `Int.max`
/// signed digits (33 entries: `10^0` through `10^32`). 32 digits is past the
/// IEEE 754 `decimal128` precision (34), so almost every call site lands in
/// the table; values beyond it fall back to a one-shot `BigInt::pow`.
let pow10_table : Array[BigInt] = [
  1N, 10N, 100N, 1000N, 10000N, 100000N, 1000000N, 10000000N, 100000000N,
  1000000000N, 10000000000N, 100000000000N, 1000000000000N,
  10000000000000N, 100000000000000N, 1000000000000000N,
  10000000000000000N, 100000000000000000N, 1000000000000000000N,
  10000000000000000000N, 100000000000000000000N, 1000000000000000000000N,
  10000000000000000000000N, 100000000000000000000000N,
  1000000000000000000000000N, 10000000000000000000000000N,
  100000000000000000000000000N, 1000000000000000000000000000N,
  10000000000000000000000000000N, 100000000000000000000000000000N,
  1000000000000000000000000000000N, 10000000000000000000000000000000N,
  100000000000000000000000000000000N,
]

///| Compute `10^n` as a `BigInt`. Negative `n` is a programmer error and
/// aborts. Small `n` lands in `pow10_table`; larger `n` allocates fresh.
fn pow10(n : Int) -> BigInt {
  guard n >= 0 else { abort("pow10: negative exponent \{n}") }
  if n < pow10_table.length() {
    pow10_table[n]
  } else {
    BigInt::pow(10N, BigInt::from_int(n))
  }
}

///| `10^n` as `Int64` if it fits, `None` if `n >= 19` (10^19 overflows
/// Int64.MAX). The fast-path arithmetic routines use this to choose whether
/// they can align coefficients without leaving the Int64 lane.
let pow10_int64_table : FixedArray[Int64] = [
  1L, 10L, 100L, 1000L, 10000L, 100000L, 1000000L, 10000000L, 100000000L,
  1000000000L, 10000000000L, 100000000000L, 1000000000000L,
  10000000000000L, 100000000000000L, 1000000000000000L, 10000000000000000L,
  100000000000000000L, 1000000000000000000L,
]

///|
fn pow10_int64(n : Int) -> Int64? {
  if n >= 0 && n < pow10_int64_table.length() {
    Some(pow10_int64_table[n])
  } else {
    None
  }
}

///| Try to extract a non-negative `Int64` from a `BigInt` if it fits in 63
/// bits. Returns `None` for values past `Int64.MAX`. The arithmetic ops use
/// this to opt into a fast path for small operands.
fn fits_int64(b : BigInt) -> Int64? {
  if b.bit_length() < 63 {
    Some(b.to_int64())
  } else {
    None
  }
}

///| Multiply two non-negative `Int64`s and report overflow with `None`.
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

///| Add two non-negative `Int64`s and report overflow with `None`.
fn checked_add_i64(a : Int64, b : Int64) -> Int64? {
  if a > 9223372036854775807L - b {
    None
  } else {
    Some(a + b)
  }
}
