// ---------------------------------------------------------------------------
// Square root.
//
// The algorithm operates directly on the BigInt coefficient instead of
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

///|
/// GDA `sqrt` / IEEE-754 squareRoot.
///
/// * sqrt(NaN): propagates.
/// * sqrt(+Inf): +Inf.
/// * sqrt(-Inf), sqrt(-x) for non-zero finite x: NaN + Invalid_operation.
/// * sqrt(±0): ±0 with the GDA "ideal exponent" `floor(x.exponent / 2)`.
/// * sqrt(finite positive): Newton-style integer sqrt, half-even rounded
///   to `precision` digits.
pub fn Decimal::sqrt(self : Decimal, ctx : Context) -> (Decimal, Flags) {
  let ctx = { ..ctx, flags: Flags::new() }
  (self.sqrt_raw(ctx), ctx.flags)
}

///|
/// Internal worker for `sqrt`: returns the value, raising into `ctx.flags`.
fn Decimal::sqrt_raw(self : Decimal, ctx : Context) -> Decimal {
  match self.class {
    SNaN => quiet_snan(self, ctx)
    QNaN => self
    Infinity => if self.negative { invalid_nan(ctx) } else { self }
    Finite =>
      if self.coefficient.is_zero() {
        let ideal = floor_div2(self.exponent)
        ({ ..self, exponent: ideal } : Decimal).finalize_raw(ctx)
      } else if self.negative {
        invalid_nan(ctx)
      } else {
        sqrt_finite(self, ctx)
      }
  }
}

///|
/// Finite positive sqrt body:
///
/// 1. Scale the coefficient so the integer square root lands at exactly
///    `precision + 1` digits — multiply by `10^(2·shift)` (or divide, noting
///    whether anything was lost) and halve the exponent. The parity dance on
///    the input exponent keeps the result exponent an integer.
/// 2. Take the integer square root of the scaled coefficient.
/// 3. If the result is exact, scale it straight back to the ideal exponent
///    `floor(x.exp / 2)`. Otherwise nudge an integer-sqrt that lands on a
///    multiple of 5 up by one — this guarantees the subsequent half-even
///    round can never be fooled by a false tie (the true root is never
///    exactly halfway, so a residue digit of 0 or 5 must round up).
/// 4. `finalize` under half-even (sqrt always rounds half-even, regardless of
///    the context's rounding mode) to drop the guard digit and raise
///    `Inexact` / `Rounded`.
fn sqrt_finite(x : Decimal, ctx : Context) -> Decimal {
  if ctx.precision <= 0 {
    // sqrt at unbounded precision is generally inexact (sqrt(2), sqrt(3),
    // ...) — declare Invalid_operation rather than spin forever. Callers
    // that want exact sqrt must specify precision.
    return invalid_nan(ctx)
  }
  let prec = ctx.precision + 1
  let exp = x.exponent
  let coef = x.coefficient
  let mut e = floor_div2(exp)
  // Odd exponent: fold one factor of 10 into the coefficient so the remaining
  // exponent is even and `e = exp / 2` exactly. The digit-length estimate `l`
  // is then half the (padded) coefficient width.
  let mut c = coef
  let l = if exp % 2 != 0 {
    c = c * 10N
    digit_count(coef) / 2 + 1
  } else {
    (digit_count(coef) + 1) / 2
  }
  let shift = prec - l
  let exact_pre = if shift >= 0 {
    c = c * pow10(2 * shift)
    true
  } else {
    let divisor = pow10(-2 * shift)
    let r = c % divisor
    c = c / divisor
    r.is_zero()
  }
  e = e - shift
  let mut n = isqrt(c)
  let exact = exact_pre && n * n == c
  if exact {
    n = if shift >= 0 { n / pow10(shift) } else { n * pow10(-shift) }
    e = e + shift
  } else if (n % 5N).is_zero() {
    n = n + 1N
  }
  // sqrt always rounds half-even; finalize applies precision + exponent-range
  // rules and raises Inexact / Rounded. Flags accumulate into the shared
  // Flags object, so they still surface on the caller's context.
  let he_ctx = { ..ctx, rounding: HalfEven }
  Decimal::finalize_raw(
    { class: Finite, negative: false, coefficient: n, exponent: e },
    he_ctx,
  )
}

///|
/// Integer square root via Newton's method, returning `floor(sqrt(n))`.
/// Convergence is quadratic, so even for thousand-digit inputs the loop
/// terminates in a few dozen iterations.
fn isqrt(n : BigInt) -> BigInt {
  if n < 2N {
    return n
  }
  // Newton from the overestimate 10^ceil(digit_count(n)/2): the iterates
  // decrease monotonically to floor(sqrt(n)), so we stop once a step no
  // longer decreases. (A too-large start is safe; an undershoot would
  // oscillate.)
  let d = digit_count(n)
  for x = pow10(d / 2 + 1) {
    let y = (x + n / x) >> 1
    if y >= x {
      break x
    } else {
      continue y
    }
  }
}

///|
/// `floor(n / 2)` on a possibly-negative `Int`. The built-in `/` truncates
/// toward zero, which gives the wrong result for negative odd inputs; we
/// adjust by one when needed so the GDA "ideal exponent"
/// (`floor(x.exponent / 2)`) is computed correctly even for `sqrt(0E-3)`.
fn floor_div2(n : Int) -> Int {
  if n >= 0 {
    n / 2
  } else {
    -((-n + 1) / 2)
  }
}
