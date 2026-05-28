///| Multiply `n` by `10^shift` in `Int64`, returning `None` on overflow.
/// `shift == 0` is the identity short-circuit; `shift >= 19` always
/// overflows since `10^19 > Int64.MAX`.
fn scale_up_i64(n : Int64, shift : Int) -> Int64? {
  if shift == 0 || n == 0L {
    return Some(n)
  }
  match pow10_int64(shift) {
    Some(factor) => checked_mul_i64(n, factor)
    None => None
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
