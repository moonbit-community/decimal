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
