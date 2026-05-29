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
/// Multiply `n` by `10^shift` in `Int64`, returning `None` on overflow.
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
