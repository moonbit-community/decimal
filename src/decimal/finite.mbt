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

fn min_exponent(a : Decimal, b : Decimal) -> Int {
  if a.exponent <= b.exponent {
    a.exponent
  } else {
    b.exponent
  }
}

fn adjusted_exponent(d : Decimal) -> Int {
  d.exponent + digit_count(d.coefficient) - 1
}

fn adjusted_exponent_parts(coeff : BigInt, exponent : Int) -> Int {
  exponent + digit_count(coeff) - 1
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
