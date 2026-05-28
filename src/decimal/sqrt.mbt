// ---------------------------------------------------------------------------
// Square root.
//
// The algorithm follows the spirit of Hull-Abrham 1985 (used by decNumber
// and apd) but operates directly on the BigInt coefficient instead of
// running Newton iteration in a variable-precision Decimal context:
//
//   1. Scale the coefficient by a power of ten so that the integer square
//      root will land at `precision + 1` digits (one guard digit).
//   2. Pick the scaling so the result exponent comes out integer (i.e.
//      `(input_exp - shift)` is even).
//   3. Compute integer sqrt via Newton on the scaled coefficient.
//   4. Use the guard digit to drive a half-even round to `precision`.
//   5. Re-finalise under the caller context (overflow / clamp / etiny).
// ---------------------------------------------------------------------------

///| GDA `sqrt` / IEEE-754 squareRoot.
///
/// * sqrt(NaN): propagates.
/// * sqrt(+Inf): +Inf.
/// * sqrt(-Inf), sqrt(-x) for non-zero finite x: NaN + Invalid_operation.
/// * sqrt(±0): ±0 with the GDA "ideal exponent" `floor(x.exponent / 2)`.
/// * sqrt(finite positive): Newton-style integer sqrt, half-even rounded
///   to `precision` digits.
pub fn Decimal::sqrt(self : Decimal, ctx : Context) -> Decimal {
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
        let ideal = floor_div2(self.exponent)
        ({ ..self, exponent: ideal } : Decimal).finalize(ctx)
      } else if self.negative {
        invalid_nan(ctx)
      } else {
        sqrt_finite(self, ctx).finalize(ctx)
      }
  }
}

///| Finite positive sqrt body. Returns an unfinalised result; the caller
/// re-runs finalize so exponent-range and clamp rules apply uniformly.
fn sqrt_finite(x : Decimal, ctx : Context) -> Decimal {
  if ctx.precision <= 0 {
    // sqrt at unbounded precision is generally inexact (sqrt(2), sqrt(3),
    // ...) — declare Invalid_operation rather than spin forever. Callers
    // that want exact sqrt must specify precision.
    return invalid_nan(ctx)
  }
  let coef = x.coefficient
  let exp = x.exponent
  let n = digit_count(coef)
  // Two candidate shifts that get `result_coef` to `precision + 1` digits:
  // 2*(p+1) - n and 2*(p+1) - 1 - n. Pick whichever makes `(exp - shift)`
  // even (so the result exponent is integer), preferring non-negative.
  let target = 2 * (ctx.precision + 1)
  let s_even = target - n
  let s_odd = target - 1 - n
  let shift = if (exp - s_even) % 2 == 0 {
    s_even
  } else {
    s_odd
  }
  let shift = if shift < 0 { 0 } else { shift }
  // Re-check parity after the clamp; if still odd, bump shift up by 1.
  let (shift_final, _) = if (exp - shift) % 2 == 0 {
    (shift, 0)
  } else {
    (shift + 1, 0)
  }
  let scaled = coef * pow10(shift_final)
  let guarded = isqrt(scaled)
  // `guarded` should have `precision + 1` digits; round half-even to
  // `precision` based on the last digit and whether the truncation lost
  // anything.
  let result_exp = (exp - shift_final) / 2
  let nd = digit_count(guarded)
  if nd <= ctx.precision {
    // Already at precision (rare — happens when the input was already a
    // perfect square at sub-precision width).
    return {
      class: Finite,
      negative: false,
      coefficient: guarded,
      exponent: result_exp,
    }
  }
  // Drop the guard digit with half-even rounding.
  let drop = nd - ctx.precision
  let divisor = pow10(drop)
  let kept = guarded / divisor
  let dropped_digit = (guarded / pow10(drop - 1) % 10N).to_int()
  let rest_nonzero =
    !(guarded % pow10(drop - 1)).is_zero() || guarded * guarded != scaled
  let round_up = if dropped_digit > 5 {
    true
  } else if dropped_digit < 5 {
    false
  } else if rest_nonzero {
    true
  } else {
    (kept % 2N).to_int() != 0
  }
  let candidate = if round_up { kept + 1N } else { kept }
  let cap = pow10(ctx.precision)
  let (final_coef, extra) = if candidate >= cap {
    (candidate / 10N, 1)
  } else {
    (candidate, 0)
  }
  let inexact = !(guarded * guarded == scaled)
  let result_final_exp = result_exp + drop + extra
  if inexact {
    ctx.raise_inexact()
    ctx.raise_rounded()
    return {
      class: Finite,
      negative: false,
      coefficient: final_coef,
      exponent: result_final_exp,
    }
  }
  // Exact result: strip trailing zeros down to the GDA "ideal exponent"
  // `floor(x.exp / 2)` so `sqrt(1) = 1` rather than `1.00000000`.
  let ideal_exp = floor_div2(exp)
  let (stripped_coef, stripped_exp) = strip_trailing_zeros_to(
    final_coef, result_final_exp, ideal_exp,
  )
  {
    class: Finite,
    negative: false,
    coefficient: stripped_coef,
    exponent: stripped_exp,
  }
}

///| Integer square root via Newton's method, returning `floor(sqrt(n))`.
/// Convergence is quadratic, so even for thousand-digit inputs the loop
/// terminates in a few dozen iterations.
fn isqrt(n : BigInt) -> BigInt {
  if n.compare(2N) < 0 {
    return n
  }
  // Initial overestimate: 10^ceil(digit_count(n) / 2). Newton converges
  // from above, so a too-large guess is fine; an undershoot would oscillate.
  let d = digit_count(n)
  let mut x = pow10(d / 2 + 1)
  while true {
    let q = n / x
    let y = (x + q) / 2N
    if y.compare(x) >= 0 {
      return x
    }
    x = y
  }
  x
}

///| `floor(n / 2)` on a possibly-negative `Int`. Rust-style division
/// rounds toward zero, which gives the wrong result for negative odd
/// inputs; we adjust by one when needed so the GDA "ideal exponent"
/// (`floor(x.exponent / 2)`) is computed correctly even for `sqrt(0E-3)`.
fn floor_div2(n : Int) -> Int {
  if n >= 0 {
    n / 2
  } else {
    -((-n + 1) / 2)
  }
}
