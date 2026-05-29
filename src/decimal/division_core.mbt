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

///| True finite division with precision-driven rounding. Follows apd's `Quo`
/// algorithm:
///
/// 1. Adjust dividend and divisor so the dividend's coefficient has the
///    same digit count as the divisor and is ≥ it (so the quotient will be
///    at least one digit).
/// 2. Pre-multiply the dividend by `10^(precision - 1)` so the integer
///    `quo_rem` yields exactly `precision` quotient digits.
/// 3. Decide rounding from the remainder via `2·rem vs divisor` (apd's
///    `half` indicator: `-1` below half, `0` exactly half, `+1` above
///    half).
///
/// The final exponent recomposes the three sources of scale:
/// `(a.exp - b.exp) - adj_coeffs - adj_exp10`, where `adj_coeffs` is the
/// digit-alignment shift from step 1 and `adj_exp10 = precision - 1` is
/// step 2.
fn divide_finite(a : Decimal, b : Decimal, ctx : Context) -> Decimal {
  let neg = a.negative != b.negative
  let shift_exp = a.exponent - b.exponent
  // 0 / x = signed zero with the ideal exponent.
  if a.coefficient.is_zero() {
    return finite_zero(shift_exp, neg)
  }
  // precision == 0: try exact division. If non-exact, GDA's Division_impossible
  // (signalled here as Invalid_operation + NaN) — there's no terminating
  // precision to stop at for a repeating decimal.
  if ctx.precision == 0 {
    let (an, bn) = align_for_int_div(
      a.coefficient, a.exponent, b.coefficient, b.exponent,
    )
    let rem = an % bn
    if !rem.is_zero() {
      return invalid_nan(ctx)
    }
    return {
      class: Finite,
      negative: neg,
      coefficient: an / bn,
      exponent: 0,
    }
  }
  let mut dividend = a.coefficient
  let mut divisor = b.coefficient
  let nd_dividend = digit_count(dividend)
  let nd_divisor = digit_count(divisor)
  let nd_diff = nd_dividend - nd_divisor
  if nd_diff < 0 {
    dividend = dividend * pow10(-nd_diff)
  } else if nd_diff > 0 {
    divisor = divisor * pow10(nd_diff)
  }
  let mut adj_coeffs = -nd_diff
  // After equal-digit-count alignment the dividend may still be < divisor
  // (e.g. 1.23 vs 2.34); one more ×10 guarantees dividend ≥ divisor.
  if dividend < divisor {
    dividend = dividend * 10N
    adj_coeffs = adj_coeffs + 1
  }
  // Pre-multiply by 10^(precision - 1) to give the integer quo_rem a
  // result with `precision` digits. When the natural result would land in
  // the subnormal range, cap the pre-multiplier so the algorithm rounds
  // directly to etiny — avoiding the double-rounding bias from doing one
  // pass at precision and another at etiny.
  let etiny = ctx.e_min - ctx.precision + 1
  let exp_budget = shift_exp - adj_coeffs - etiny
  let adj_exp10 = if exp_budget < ctx.precision - 1 {
    if exp_budget < 0 { 0 } else { exp_budget }
  } else {
    ctx.precision - 1
  }
  if adj_exp10 > 0 {
    dividend = dividend * pow10(adj_exp10)
  }
  let mut quot = dividend / divisor
  let rem = dividend % divisor
  let mut final_exp = shift_exp - adj_coeffs - adj_exp10
  if !rem.is_zero() {
    ctx.raise_inexact()
    ctx.raise_rounded()
    let cmp = (rem * 2N).compare(divisor)
    let round_up = decide_div_round(quot, neg, cmp, ctx.rounding)
    if round_up {
      quot = quot + 1N
    }
  } else {
    // GDA §4.3.4: an exact divide result is normalised — trailing zeros are
    // stripped until the exponent reaches `ideal_exp = a.exp - b.exp`.
    // Without this, `divide(2, 2)` would render as `1.00000000` (precision
    // trailing zeros from the scaling step) rather than `1`.
    let (s_coef, s_exp) = strip_trailing_zeros_to(quot, final_exp, shift_exp)
    quot = s_coef
    final_exp = s_exp
    // When the natural quotient had more digits than precision allowed,
    // the scaling factors compressed those LSDs into the exponent (e.g.
    // `12345678000 / 1 = 1.23456780E+10` — the two trailing zeros of the
    // natural value land in the exponent, not the coefficient). That's a
    // precision-induced rounding even though rem is zero, so Rounded
    // fires. `final_exp > shift_exp` is the signal.
    if final_exp > shift_exp {
      ctx.raise_rounded()
    }
  }
  { class: Finite, negative: neg, coefficient: quot, exponent: final_exp }
}

///| Strip trailing zeros from `coef` while raising the exponent, but not
/// past `target_exp`. Used by divide to normalise exact results down to
/// the `ideal_exp = a.exp - b.exp` GDA convention.
fn strip_trailing_zeros_to(
  coef : BigInt,
  exp : Int,
  target_exp : Int,
) -> (BigInt, Int) {
  let mut c = coef
  let mut e = exp
  while e < target_exp && !c.is_zero() {
    let quot = c / 10N
    if quot * 10N != c {
      break
    }
    c = quot
    e = e + 1
  }
  (c, e)
}

///| Decide whether the precision-truncated quotient should round up by
/// one. `cmp` is `(2·rem).compare(divisor)`: `-1` if the remainder is less
/// than half the divisor, `0` if exactly half, `+1` if more than half.
///
/// This mirrors `round_decision` from rounding.mbt but takes the half
/// indicator pre-computed (rather than picking it out of a `dropped` value).
fn decide_div_round(
  quot : BigInt,
  negative : Bool,
  cmp : Int,
  mode : Rounding,
) -> Bool {
  match mode {
    Down => false
    Up => true
    HalfUp => cmp >= 0
    HalfDown => cmp > 0
    HalfEven =>
      if cmp > 0 {
        true
      } else if cmp < 0 {
        false
      } else {
        (quot % 2N).to_int() != 0
      }
    Ceiling => !negative
    Floor => negative
    ZeroFiveUp => {
      let last = (quot % 10N).to_int()
      last == 0 || last == 5
    }
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
