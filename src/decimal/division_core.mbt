///| Truncated integer division for finite non-zero divisor.
///
/// Short-circuits via the adjusted exponents: if `|a| < |b|` the integer
/// quotient is zero, and we return before scaling — important when the
/// operands' exponents differ by a billion. If the upper bound on the
/// quotient digit count is implausibly large we surface `NaN` (GDA's
/// `Division_impossible`) instead of attempting an intractable BigInt op.
fn divide_int_finite(a : Decimal, b : Decimal) -> Decimal {
  let adj_a = adjusted_exponent(a)
  let adj_b = adjusted_exponent(b)
  if adj_a < adj_b {
    return {
      class: Finite,
      negative: a.negative != b.negative,
      coefficient: 0N,
      exponent: 0,
    }
  }
  // `adj_a - adj_b + 1` upper-bounds the digit count of the integer quotient.
  // 100_000 digits is well past any precision a Context would set, so further
  // computation is pointless and the GDA outcome here is Division_impossible.
  if adj_a - adj_b + 1 > 100_000 {
    return Decimal::nan()
  }
  let (an, bn) = align_for_int_div(
    a.coefficient, a.exponent, b.coefficient, b.exponent,
  )
  {
    class: Finite,
    negative: a.negative != b.negative,
    coefficient: an / bn,
    exponent: 0,
  }
}

///| Exact finite remainder: `a - divide_int_finite(a, b) * b`, with the final
/// subtract performed under the caller context so precision rules apply only
/// at the public result boundary.
fn remainder_finite(a : Decimal, b : Decimal, ctx : Context) -> Decimal {
  let exact_ctx = Context::exact()
  let quot = divide_int_finite(a, b)
  let prod = Decimal::multiply(quot, b, exact_ctx)
  let result = Decimal::subtract(a, prod, ctx)
  if result.class is Finite && result.coefficient.is_zero() {
    { ..result, negative: a.negative }
  } else {
    result
  }
}
