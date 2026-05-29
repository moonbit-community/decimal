// ---------------------------------------------------------------------------
// Transcendentals: exp / ln / log10 / power.
//
// Implementation strategy: compute everything in a higher-precision
// "scratch" context so the user-level precision is the rounding target,
// not the working precision. Each op falls back to Decimal arithmetic
// primitives (multiply / divide / add) at the scratch precision; the
// final result is finalised under the user's context.
//
// For exp we use range reduction (halve the argument until |x| ≤ 1) plus
// Taylor series. ln, log10, and power compose on top of exp:
//
//   ln(x)    : Newton on f(y) = exp(y) - x, with FP64 bootstrap.
//   log10(x) : ln(x) / ln(10), with ln(10) computed once at workp.
//   power    : square-and-multiply for integer exponents; exp(y · ln(x))
//              otherwise.
// ---------------------------------------------------------------------------

///| GDA `exp`: e raised to the operand.
pub fn Decimal::exp(self : Decimal, ctx : Context) -> Decimal {
  match self.class {
    SNaN => quiet_snan(self, ctx)
    QNaN => self
    Infinity =>
      if self.negative {
        // exp(-Inf) = +0
        { class: Finite, negative: false, coefficient: 0N, exponent: 0 }
      } else {
        self
      }
    Finite =>
      if self.coefficient.is_zero() {
        Decimal::one()
      } else {
        exp_finite(self, ctx).finalize(ctx)
      }
  }
}

///| Finite-positive / negative exp. Range-reduces the operand to `|x| ≤ 1`
/// via halving, computes Taylor at scratch precision, then re-squares.
fn exp_finite(x : Decimal, ctx : Context) -> Decimal {
  let workp = ctx.precision + 10
  let workctx = Context::new(precision=workp, rounding=HalfEven)
  // Halve `x` until its magnitude drops below 1.
  let mut reduced = x
  let mut halvings = 0
  while reduced_magnitude_above_one(reduced) {
    reduced = Decimal::divide(reduced, Decimal::of_int(2), workctx)
    halvings = halvings + 1
    // Safety bound — `exp` for adjusted-exponent > ~20 is already overflow
    // territory at typical precisions; the user's context will catch it.
    if halvings > 200 {
      break
    }
  }
  let mut result = exp_taylor(reduced, workctx, workp)
  // Re-square `halvings` times: exp(2x) = exp(x)².
  while halvings > 0 {
    result = Decimal::multiply(result, result, workctx)
    halvings = halvings - 1
  }
  result
}

///| True iff `|x| > 1`. Compares adjusted exponent / coefficient without
/// fully materialising the comparison.
fn reduced_magnitude_above_one(x : Decimal) -> Bool {
  if !(x.class is Finite) {
    return false
  }
  if x.coefficient.is_zero() {
    return false
  }
  let adj = adjusted_exponent(x)
  if adj > 0 {
    return true
  }
  if adj < 0 {
    return false
  }
  // adj == 0: `1.xxx` style. True iff coef > pow10(digits-1).
  let n = digit_count(x.coefficient)
  x.coefficient > pow10(n - 1)
}

///| Taylor series for exp(x) at the working precision. Iterates the
/// recurrence `term_k = term_{k-1} · x / k` until the term's magnitude
/// falls below the user-requested precision floor (with a 10-digit guard).
fn exp_taylor(x : Decimal, ctx : Context, workp : Int) -> Decimal {
  let mut sum = Decimal::one()
  let mut term = Decimal::one()
  let mut k = 1
  // Bound by `precision · 10` as a runaway guard; in practice exp(|x|≤1)
  // at precision 9 converges in well under 50 terms.
  let max_iter = workp * 10 + 50
  while k <= max_iter {
    term = Decimal::divide(
      Decimal::multiply(term, x, ctx),
      Decimal::of_int(k),
      ctx,
    )
    sum = Decimal::add(sum, term, ctx)
    if term_below_precision_floor(term, sum, workp) {
      break
    }
    k = k + 1
  }
  sum
}

///| True iff `term`'s adjusted exponent is far enough below `sum`'s that
/// further terms can't perturb the rounded result. Uses a guard of
/// `workp + 5` so transient cancellations in the Taylor tail don't fool
/// the termination heuristic.
fn term_below_precision_floor(
  term : Decimal,
  sum : Decimal,
  workp : Int,
) -> Bool {
  if !(term.class is Finite) || term.coefficient.is_zero() {
    return true
  }
  if !(sum.class is Finite) || sum.coefficient.is_zero() {
    return false
  }
  let term_adj = adjusted_exponent(term)
  let sum_adj = adjusted_exponent(sum)
  sum_adj - term_adj > workp + 5
}

///| GDA `ln`: natural logarithm. ln(1) = 0; ln(x) for finite x > 0 uses
/// the atanh series plus range reduction; ln(0) = -Infinity (with
/// `Division_by_zero` raised); ln of negative or NaN is the usual
/// propagation / invalid.
pub fn Decimal::ln(self : Decimal, ctx : Context) -> Decimal {
  match self.class {
    SNaN => quiet_snan(self, ctx)
    QNaN => self
    Infinity =>
      if self.negative {
        invalid_nan(ctx)
      } else {
        self
      }
    Finite =>
      if self.coefficient.is_zero() {
        // GDA: ln(0) = -Infinity, no flag raised. (Math-wise this is a
        // limit, not a "1/0"-style division-by-zero, so unlike some C
        // libraries' log we don't signal Division_by_zero.)
        signed_infinity(true)
      } else if self.negative {
        invalid_nan(ctx)
      } else if is_one(self) {
        Decimal::zero()
      } else {
        ln_finite(self, ctx).finalize(ctx)
      }
  }
}

///| True iff `x` is exactly the value 1 — regardless of how it's
/// represented (`1`, `1.0`, `1E+0`, `1.00000`). Cheaper than `compare` for
/// the early-exit `ln(1) = 0` and `power(1, y) = 1` checks.
fn is_one(x : Decimal) -> Bool {
  if x.negative {
    return false
  }
  if !(x.class is Finite) {
    return false
  }
  // x = 1 means coefficient * 10^exponent = 1, i.e. coefficient = 10^(-exponent).
  if x.exponent > 0 {
    return false
  }
  let target = pow10(-x.exponent)
  x.coefficient == target
}

///| Finite-positive ln. Halves the operand (`ln(x) = ln(x/2) + ln(2)`)
/// until `x ∈ [√½, √2)`, applies the atanh series at workp precision,
/// then composes back via the halving count and a precomputed `ln(2)`.
fn ln_finite(x : Decimal, ctx : Context) -> Decimal {
  let workp = ctx.precision + 10
  let workctx = Context::new(precision=workp, rounding=HalfEven)
  let ln2 = ln_two(workctx, workp)
  // Reduce |adjusted_exponent(x)| to 0 first via halving — gives the
  // overall scale; we'll add k·ln(2) at the end.
  let mut reduced = x
  let mut k = 0
  // Halve while reduced > ~1.5.
  while reduced_above_one_and_a_half(reduced) {
    reduced = Decimal::divide(reduced, Decimal::of_int(2), workctx)
    k = k + 1
    if k > 10000 {
      break
    }
  }
  // Double while reduced < ~0.7.
  while reduced_below_two_thirds(reduced) {
    reduced = Decimal::multiply(reduced, Decimal::of_int(2), workctx)
    k = k - 1
    if k < -10000 {
      break
    }
  }
  let ln_reduced = ln_atanh_series(reduced, workctx, workp)
  let k_ln2 = Decimal::multiply(Decimal::of_int(k), ln2, workctx)
  Decimal::add(ln_reduced, k_ln2, workctx)
}

///| `ln(x) = 2 · (t + t³/3 + t⁵/5 + ...)` where `t = (x - 1) / (x + 1)`.
/// Converges quickly when `x` is close to 1 — the range-reduced operand
/// from `ln_finite` lives in `[√½, √2)`, so `|t| ≤ ~0.17`.
fn ln_atanh_series(x : Decimal, ctx : Context, workp : Int) -> Decimal {
  let one = Decimal::one()
  let t = Decimal::divide(
    Decimal::subtract(x, one, ctx),
    Decimal::add(x, one, ctx),
    ctx,
  )
  let t_sq = Decimal::multiply(t, t, ctx)
  let mut term = t
  let mut sum = t
  let mut k = 1
  let max_iter = workp * 10 + 50
  while k <= max_iter {
    term = Decimal::multiply(term, t_sq, ctx)
    let denom = Decimal::of_int(2 * k + 1)
    let contribution = Decimal::divide(term, denom, ctx)
    sum = Decimal::add(sum, contribution, ctx)
    if term_below_precision_floor(contribution, sum, workp) {
      break
    }
    k = k + 1
  }
  Decimal::multiply(sum, Decimal::of_int(2), ctx)
}

///| Compute `ln(2)` at workp precision via `2 · artanh(1/3)`. Each
/// successive term shrinks by a factor of 1/9, so termination is fast.
fn ln_two(ctx : Context, workp : Int) -> Decimal {
  // t = 1/3 ⇒ ln(2) = 2 · (1/3 + (1/3)³/3 + (1/3)⁵/5 + ...).
  let one = Decimal::one()
  let three = Decimal::of_int(3)
  let t = Decimal::divide(one, three, ctx)
  let t_sq = Decimal::multiply(t, t, ctx)
  let mut term = t
  let mut sum = t
  let mut k = 1
  let max_iter = workp * 5 + 50
  while k <= max_iter {
    term = Decimal::multiply(term, t_sq, ctx)
    let denom = Decimal::of_int(2 * k + 1)
    let contribution = Decimal::divide(term, denom, ctx)
    sum = Decimal::add(sum, contribution, ctx)
    if term_below_precision_floor(contribution, sum, workp) {
      break
    }
    k = k + 1
  }
  Decimal::multiply(sum, Decimal::of_int(2), ctx)
}

///| `true` for finite operands whose magnitude is above ~1.5 — used by
/// `ln_finite` to decide whether to halve.
fn reduced_above_one_and_a_half(x : Decimal) -> Bool {
  if !(x.class is Finite) || x.coefficient.is_zero() {
    return false
  }
  // Compare x to 3/2 = 1.5 using the adjusted exponent / coefficient.
  // For adj > 0: x > 10 > 1.5.
  // For adj < 0: x < 1 < 1.5.
  let adj = adjusted_exponent(x)
  if adj > 0 {
    return true
  }
  if adj < 0 {
    return false
  }
  // adj == 0: 1.xxx style. Compare leading digits to 1.5.
  let n = digit_count(x.coefficient)
  // x's value = coefficient × 10^exponent; for adj == 0 we have exponent =
  // 1 - n, so the value is coefficient / 10^(n-1). Compare to 1.5 by
  // comparing coefficient to 1.5 × 10^(n-1) = 15 × 10^(n-2).
  if n == 1 {
    x.coefficient >= 2N
  } else {
    x.coefficient >= 15N * pow10(n - 2)
  }
}

///| GDA `log10`: common (base-10) logarithm. Built as `ln(x) / ln(10)`
/// at workp precision; falls back to the closed-form result for exact
/// powers of ten.
pub fn Decimal::log10(self : Decimal, ctx : Context) -> Decimal {
  match self.class {
    SNaN => quiet_snan(self, ctx)
    QNaN => self
    Infinity =>
      if self.negative {
        invalid_nan(ctx)
      } else {
        self
      }
    Finite =>
      if self.coefficient.is_zero() {
        // GDA: log10(0) = -Infinity, no flag (matches ln(0)).
        signed_infinity(true)
      } else if self.negative {
        invalid_nan(ctx)
      } else {
        log10_finite(self, ctx).finalize(ctx)
      }
  }
}

///| Compute `log10(x) = ln(x) / ln(10)` at scratch precision. Exact
/// power-of-ten inputs short-circuit to the integer logarithm rather
/// than threading through the Taylor series, since the inexact path
/// produces precision-bounded trailing zeros that mask the exactness.
fn log10_finite(x : Decimal, ctx : Context) -> Decimal {
  match power_of_ten_log(x) {
    Some(k) => return Decimal::of_int(k)
    None => ()
  }
  let workp = ctx.precision + 10
  let workctx = Context::new(precision=workp, rounding=HalfEven)
  let ln_x = ln_finite(x, workctx)
  let ln10 = ln_finite(Decimal::of_int(10), workctx)
  Decimal::divide(ln_x, ln10, workctx)
}

///| For a positive finite `x = c · 10^e`, return `Some(k)` iff `c` is a
/// power of ten (so `x = 10^(k_c + e)` for some `k_c`). Used by log10
/// to recognise the exact-result cases.
fn power_of_ten_log(x : Decimal) -> Int? {
  if x.coefficient.is_zero() {
    return None
  }
  let n = digit_count(x.coefficient)
  if x.coefficient == pow10(n - 1) {
    Some(n - 1 + x.exponent)
  } else {
    None
  }
}

///| GDA `power`: `self ^ other`. Integer exponents use square-and-multiply
/// for exactness; non-integer exponents use `exp(other · ln(self))`.
/// Domain rules: power(0, 0) = 1; power(±0, neg) = ±Infinity with
/// `Division_by_zero`; power(neg, non-integer) = NaN.
pub fn Decimal::power(
  self : Decimal,
  other : Decimal,
  ctx : Context,
) -> Decimal {
  match propagate_nan(self, other, ctx) {
    Some(d) => return d
    None => ()
  }
  // Special-value combinations follow GDA §5.4.4 closely.
  match (self.class, other.class) {
    (Infinity, Finite) => power_infinity_finite(self, other, ctx)
    (Finite, Infinity) => power_finite_infinity(self, other, ctx)
    (Infinity, Infinity) => power_infinity_infinity(self, other, ctx)
    (Finite, Finite) => power_finite(self, other, ctx)
    _ => abort("Decimal::power: unreachable class combination")
  }
}

///| Infinity ^ finite.
fn power_infinity_finite(
  x : Decimal,
  y : Decimal,
  _ctx : Context,
) -> Decimal {
  if y.coefficient.is_zero() {
    return Decimal::one()
  }
  if y.negative {
    // Inf^(neg) = 0; sign positive (since (Inf)^anything is ≥ 0 for
    // integer-or-large-y, and the negative-x integer-only rule still
    // produces a positive result for even exponents).
    return Decimal::zero()
  }
  // Inf^positive = Inf; preserve sign of x when y is an odd integer,
  // else +Inf.
  let sign_negative = x.negative && is_odd_integer(y)
  signed_infinity(sign_negative)
}

///| Finite ^ infinity. Result is 0 or Inf depending on whether |x| > 1.
fn power_finite_infinity(
  x : Decimal,
  y : Decimal,
  ctx : Context,
) -> Decimal {
  if x.coefficient.is_zero() {
    // 0^(+Inf) = 0; 0^(-Inf) = +Inf with Division_by_zero
    if y.negative {
      ctx.raise_division_by_zero()
      return signed_infinity(false)
    }
    return Decimal::zero()
  }
  if is_one_abs(x) {
    // 1^Inf and (-1)^Inf are NaN; GDA Invalid_operation.
    return invalid_nan(ctx)
  }
  let mag_above_one = magnitude_above_one(x)
  // x positive, |x| > 1: x^(+Inf) = +Inf, x^(-Inf) = +0
  // x positive, |x| < 1: x^(+Inf) = +0, x^(-Inf) = +Inf
  // Mirror for x negative magnitude (sign vanishes — x^Inf isn't well-defined for negative base anyway)
  if mag_above_one == y.negative {
    Decimal::zero()
  } else {
    signed_infinity(false)
  }
}

///| Infinity ^ Infinity.
fn power_infinity_infinity(
  x : Decimal,
  y : Decimal,
  ctx : Context,
) -> Decimal {
  let _ = ctx
  if y.negative {
    Decimal::zero()
  } else {
    signed_infinity(x.negative)
  }
}

///| Finite ^ finite.
fn power_finite(x : Decimal, y : Decimal, ctx : Context) -> Decimal {
  // Special cases first.
  if x.coefficient.is_zero() && y.coefficient.is_zero() {
    // GDA: 0^0 is NaN + Invalid_operation (the math convention is
    // indeterminate, IEEE-754 picks 1; GDA picks NaN).
    return invalid_nan(ctx)
  }
  if y.coefficient.is_zero() {
    return Decimal::one()
  }
  if x.coefficient.is_zero() {
    if y.negative {
      ctx.raise_division_by_zero()
      return signed_infinity(false)
    }
    return Decimal::zero()
  }
  // Integer y → exact square-and-multiply, preserving sign for odd y.
  match integer_value(y) {
    Some(n) => return power_int(x, n, ctx)
    None => ()
  }
  // Non-integer y on a negative base is invalid.
  if x.negative {
    return invalid_nan(ctx)
  }
  // General case: x^y = exp(y * ln(x)).
  let workp = ctx.precision + 10
  let workctx = Context::new(precision=workp, rounding=HalfEven)
  let ln_x = ln_finite(x, workctx)
  let prod = Decimal::multiply(y, ln_x, workctx)
  Decimal::exp(prod, ctx)
}

///| Integer-power via square-and-multiply, with negative exponents
/// expressed as `1 / power(x, |n|)`.
fn power_int(x : Decimal, n : Int, ctx : Context) -> Decimal {
  if n == 0 {
    return Decimal::one()
  }
  let workp = ctx.precision + 10
  let workctx = Context::new(precision=workp, rounding=HalfEven)
  let mut base = x
  let mut result = Decimal::one()
  let mut exp = if n < 0 { -n } else { n }
  while exp > 0 {
    if exp % 2 == 1 {
      result = Decimal::multiply(result, base, workctx)
    }
    exp = exp / 2
    if exp > 0 {
      base = Decimal::multiply(base, base, workctx)
    }
  }
  if n < 0 {
    result = Decimal::divide(Decimal::one(), result, workctx)
  }
  result.finalize(ctx)
}

///| Return `Some(n)` iff `y` is exactly representable as an `Int` —
/// non-negative or negative integer with no fractional part.
fn integer_value(y : Decimal) -> Int? {
  if !(y.class is Finite) {
    return None
  }
  if y.exponent >= 0 {
    let scaled = y.coefficient * pow10(y.exponent)
    match fits_int64(scaled) {
      Some(v) =>
        if v.compare(2147483647L) <= 0 {
          Some(if y.negative { -v.to_int() } else { v.to_int() })
        } else {
          None
        }
      None => None
    }
  } else {
    // Has fractional digits? exponent < 0 means coef × 10^exp where
    // |exp| digits are fractional. Integer iff coefficient is divisible
    // by 10^(-exp).
    let factor = pow10(-y.exponent)
    if (y.coefficient % factor).is_zero() {
      let int_coef = y.coefficient / factor
      match fits_int64(int_coef) {
        Some(v) =>
          if v.compare(2147483647L) <= 0 {
            Some(if y.negative { -v.to_int() } else { v.to_int() })
          } else {
            None
          }
        None => None
      }
    } else {
      None
    }
  }
}

///| True iff `y` is an odd integer. Used by `power(Inf, y)` to decide
/// whether the result inherits `Inf`'s sign.
fn is_odd_integer(y : Decimal) -> Bool {
  match integer_value(y) {
    Some(n) => n % 2 != 0
    None => false
  }
}

///| True iff `|x| == 1` (any representation).
fn is_one_abs(x : Decimal) -> Bool {
  is_one({ ..x, negative: false })
}

///| True iff `|x| > 1` for finite non-zero x.
fn magnitude_above_one(x : Decimal) -> Bool {
  let adj = adjusted_exponent(x)
  if adj > 0 {
    return true
  }
  if adj < 0 {
    return false
  }
  // adj == 0: 1.xxx; magnitude > 1 iff coefficient > 10^(digits-1).
  let n = digit_count(x.coefficient)
  x.coefficient > pow10(n - 1)
}

///| `true` for finite operands whose magnitude is below ~0.7. Mirrors
/// `reduced_above_one_and_a_half` for the doubling-loop bound.
fn reduced_below_two_thirds(x : Decimal) -> Bool {
  if !(x.class is Finite) || x.coefficient.is_zero() {
    return false
  }
  let adj = adjusted_exponent(x)
  if adj < -1 {
    return true
  }
  if adj > -1 {
    return false
  }
  // adj == -1: 0.xxx, value in [0.1, 1). Compare to 0.7 = 7 × 10^-1.
  let n = digit_count(x.coefficient)
  // Value = coefficient × 10^exponent, exponent = -n, so value =
  // coefficient / 10^n. Compare to 0.7 by comparing to 7 × 10^(n-1).
  x.coefficient < 7N * pow10(n - 1)
}
