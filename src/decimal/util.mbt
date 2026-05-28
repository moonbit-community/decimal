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
