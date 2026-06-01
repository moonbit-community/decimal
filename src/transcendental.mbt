// ---------------------------------------------------------------------------
// Transcendentals: exp / ln / log10 / power.
//
// Each operation produces a correctly-rounded result by driving the
// fixed-point integer kernels in `mathfn.mbt` (`dexp` / `dlog` / `dlog10` /
// `dpower`) inside a Ziv loop: compute to a few guard digits, and if the
// value sits exactly on a rounding boundary, widen the working precision by 3
// and retry until it rounds unambiguously. `finalize` then rounds to the
// context precision and raises Inexact / Rounded / Overflow / Underflow.
//
//   exp(x)   : analytic over/underflow screen, else `dexp`.
//   ln(x)    : `dlog`, seeded by `ln_exp_bound`.
//   log10(x) : exact for powers of ten, else `dlog10`.
//   power    : 0/1/inf and integer special cases handled directly (exact
//              square-and-multiply for in-range integer exponents); the
//              general case is `dpower = dexp(y * dlog(x))`.
//
// `exp` / `ln` / `log10` always round half-even; `power` respects the context
// rounding mode. All four refuse contexts wider than the `MAX_MATH` limit
// (signalling Invalid_context), which also bounds the work they can do.
// ---------------------------------------------------------------------------

///|
/// `MAX_MATH`: the largest `precision` (and the bound on
/// `|e_max|` / `|e_min|`) for which the series-based mathematical functions
/// `exp` / `ln` / `log10` / `power` are defined. Beyond it the working
/// precision needed to round correctly would be unbounded, so GDA requires
/// the operation to refuse with `Invalid_context` rather than diverge.
const MAX_MATH : Int = 999_999

///|
/// True when `ctx` is too extreme for the series-based math functions:
/// `precision`, `e_max`, or `e_min` lies outside the `±MAX_MATH` window.
/// Such a context cannot bound the working precision the algorithms need,
/// so the op must signal `Invalid_context` and return NaN.
fn math_context_invalid(ctx : Context) -> Bool {
  ctx.precision > MAX_MATH || ctx.e_max > MAX_MATH || ctx.e_min < -MAX_MATH
}

///|
/// True when a finite operand is outside the math functions' domain: with
/// `ed = exponent + digits` (one more than the
/// adjusted exponent), reject when `digits > MAX_MATH`, `ed > MAX_MATH + 1`, or
/// `ed < 2*(1 - MAX_MATH)`. The window is deliberately asymmetric — large
/// negative exponents are tolerated almost twice as far as large positive ones.
/// Such an operand can't be handled in bounded work, so the series-based
/// functions reject it with `Invalid_operation`.
fn operand_out_of_math_range(d : Decimal) -> Bool {
  let digits = digit_count(d.coefficient)
  let ed = d.exponent + digits
  digits > MAX_MATH || ed > MAX_MATH + 1 || ed < 2 * (1 - MAX_MATH)
}

///|
/// Shared entry guard for the unary math functions (`exp` / `ln` / `log10`):
/// propagate a NaN operand (signalling and quietening on sNaN), then reject an
/// over-wide context with `Invalid_context`. Returns `Some(result)` when the
/// caller should short-circuit, `None` to continue with the real computation.
fn math_precheck(x : Decimal, ctx : Context) -> Decimal? {
  match x.class {
    SNaN => Some(quiet_snan(x, ctx))
    QNaN => Some(x)
    _ =>
      if math_context_invalid(ctx) {
        ctx.raise_invalid_context()
        Some(Decimal::nan())
      } else {
        None
      }
  }
}

///|
/// GDA `exp`: e raised to the operand.
pub fn Decimal::exp(self : Decimal, ctx : Context) -> (Decimal, Flags) {
  let ctx = { ..ctx, flags: Flags::new() }
  (self.exp_raw(ctx), ctx.flags)
}

///|
/// Internal worker for `exp`: returns the value, raising into `ctx.flags`.
fn Decimal::exp_raw(self : Decimal, ctx : Context) -> Decimal {
  match math_precheck(self, ctx) {
    Some(d) => return d
    None => ()
  }
  match self.class {
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
        exp_finite(self, ctx)
      }
    _ => abort("Decimal::exp: NaN handled above")
  }
}

///|
/// Number of decimal digits of a non-negative `Int` (`len(str(n))`).
fn int_digits(n : Int) -> Int {
  bigint_digits(BigInt::from_int(n))
}

///|
/// Finite non-zero `exp`.
///
/// Only a narrow band of adjusted exponents needs real work: outside it the
/// result either overflows, underflows to zero, or is indistinguishable from
/// 1 at the target precision. Those four boundary cases are produced directly
/// (as a value `finalize` will round and flag correctly); the general band runs
/// the correctly-rounded `dexp` kernel inside a Ziv loop that widens precision
/// until the result rounds unambiguously. The result is transcendental, hence
/// always inexact — `finalize` raises `Inexact` / `Rounded` for us, which is
/// why even `exp(1E-40) = 1.000000000` reports them.
fn exp_finite(x : Decimal, ctx : Context) -> Decimal {
  let p = ctx.precision
  let adj = adjusted_exponent(x)
  let etiny = ctx.etiny()
  let result : Decimal = if !x.negative && adj > int_digits((ctx.e_max + 1) * 3) {
    // overflow: a value above e_max that finalize turns into ±Infinity.
    { class: Finite, negative: false, coefficient: 1N, exponent: ctx.e_max + 1 }
  } else if x.negative && adj > int_digits((-etiny + 1) * 3) {
    // underflow: a value below etiny that finalize rounds to 0.
    { class: Finite, negative: false, coefficient: 1N, exponent: etiny - 1 }
  } else if !x.negative && adj < -p {
    // just above 1: 1 + 10^-p, so finalize rounds to 1 and raises Inexact.
    { class: Finite, negative: false, coefficient: pow10(p) + 1N, exponent: -p }
  } else if x.negative && adj < -p - 1 {
    // just below 1: (p+1) nines = 1 - 10^-(p+1); finalize rounds up to 1.
    {
      class: Finite,
      negative: false,
      coefficient: pow10(p + 1) - 1N,
      exponent: -p - 1,
    }
  } else {
    // General case: correctly-rounded dexp inside a Ziv loop.
    let c = if x.negative { -x.coefficient } else { x.coefficient }
    let (coeff, exp) = for extra = 3 {
      let (coeff, exp) = dexp(c, x.exponent, p + extra)
      // Roundable with any mode once coeff is not a multiple of the half-ulp.
      if ziv_roundable(coeff, p) {
        break (coeff, exp)
      } else {
        continue extra + 3
      }
    }
    { class: Finite, negative: false, coefficient: coeff, exponent: exp }
  }
  // exp always rounds half-even; flags accumulate into the shared Flags.
  result.finalize_raw({ ..ctx, rounding: HalfEven })
}

///|
/// Lexicographic `<` on two ASCII digit strings, needed by the `ln` / `log10`
/// exponent-bound estimates. (A shorter
/// string that is a prefix of a longer one compares less.)
fn dstr_lt(a : String, b : String) -> Bool {
  let la = a.length()
  let lb = b.length()
  let n = if la < lb { la } else { lb }
  for i = 0 {
    if i >= n {
      break la < lb
    } else {
      let ca = a[i].to_int()
      let cb = b[i].to_int()
      if ca != cb {
        break ca < cb
      } else {
        continue i + 1
      }
    }
  }
}

///|
/// GDA `ln`: natural logarithm. ln(1) = 0; ln(x) for finite x > 0 uses
/// the atanh series plus range reduction; ln(0) = -Infinity (with
/// `Division_by_zero` raised); ln of negative or NaN is the usual
/// propagation / invalid.
pub fn Decimal::ln(self : Decimal, ctx : Context) -> (Decimal, Flags) {
  let ctx = { ..ctx, flags: Flags::new() }
  (self.ln_raw(ctx), ctx.flags)
}

///|
/// Internal worker for `ln`: returns the value, raising into `ctx.flags`.
fn Decimal::ln_raw(self : Decimal, ctx : Context) -> Decimal {
  match math_precheck(self, ctx) {
    Some(d) => return d
    None => ()
  }
  match self.class {
    Infinity => if self.negative { invalid_nan(ctx) } else { self }
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
        ln_finite(self, ctx)
      }
    _ => abort("Decimal::ln: NaN handled above")
  }
}

///|
/// True iff `x` is exactly the value 1 — regardless of how it's
/// represented (`1`, `1.0`, `1E+0`, `1.00000`). Cheaper than `compare` for
/// the early-exit `ln(1) = 0` and `power(1, y) = 1` checks.
fn is_one(x : Decimal) -> Bool {
  if x.negative || !(x.class is Finite) || x.exponent > 0 {
    return false
  }
  // x = 1 means coefficient = 10^(-exponent), which has exactly `1 - exponent`
  // digits. Check the digit count first: this both rejects most operands
  // cheaply and bounds `-exponent` to the coefficient's width, so we never
  // materialise a `pow10` larger than the coefficient (a tiny value like
  // `1E-999999999` would otherwise build a billion-digit power of ten here).
  digit_count(x.coefficient) == 1 - x.exponent &&
  x.coefficient == pow10(-x.exponent)
}

///|
/// Finite-positive `ln` (x != 1). Runs the correctly-rounded `dlog` kernel
/// inside a Ziv loop: start at `p - ln_exp_bound(x) + 2` fractional places
/// (enough that the leading digit of the result is captured) and widen by 3
/// until the value rounds unambiguously, then finalize half-even. The result
/// is irrational, hence always inexact.
fn ln_finite(x : Decimal, ctx : Context) -> Decimal {
  let p = ctx.precision
  let c = x.coefficient
  let e = x.exponent
  let (coeff, places) = for places = p - ln_exp_bound(x) + 2 {
    let coeff = dlog(c, e, places)
    if ziv_roundable(coeff, p) {
      break (coeff, places)
    } else {
      continue places + 3
    }
  }
  (
    {
      class: Finite,
      negative: coeff < 0N,
      coefficient: abs_big(coeff),
      exponent: -places,
    } : Decimal).finalize_raw({ ..ctx, rounding: HalfEven })
}

///|
/// Lower bound `r` on the adjusted exponent of `ln(x)` (i.e. `|ln(x)| >=
/// 10^r`), used to seed the Ziv loop's working precision. Uses the bounds
/// `1 - 1/x <= ln(x) <= x - 1` for `0.1 <= x <= 10`.
fn ln_exp_bound(x : Decimal) -> Int {
  let adj = adjusted_exponent(x)
  if adj >= 1 {
    return int_digits(adj * 23 / 10) - 1
  }
  if adj <= -2 {
    return int_digits((-1 - adj) * 23 / 10) - 1
  }
  let c = x.coefficient
  let e = x.exponent
  if adj == 0 {
    // 1 < x < 10
    let num = (c - pow10(-e)).to_string()
    let den = c.to_string()
    num.length() - den.length() - (if dstr_lt(num, den) { 1 } else { 0 })
  } else {
    // adj == -1: 0.1 <= x < 1
    e + (pow10(-e) - c).to_string().length() - 1
  }
}

///|
/// GDA `log10`: common (base-10) logarithm. Built as `ln(x) / ln(10)`
/// at workp precision; falls back to the closed-form result for exact
/// powers of ten.
pub fn Decimal::log10(self : Decimal, ctx : Context) -> (Decimal, Flags) {
  let ctx = { ..ctx, flags: Flags::new() }
  (self.log10_raw(ctx), ctx.flags)
}

///|
/// Internal worker for `log10`: returns the value, raising into `ctx.flags`.
fn Decimal::log10_raw(self : Decimal, ctx : Context) -> Decimal {
  match math_precheck(self, ctx) {
    Some(d) => return d
    None => ()
  }
  match self.class {
    Infinity => if self.negative { invalid_nan(ctx) } else { self }
    Finite =>
      if self.coefficient.is_zero() {
        // GDA: log10(0) = -Infinity, no flag (matches ln(0)).
        signed_infinity(true)
      } else if self.negative {
        invalid_nan(ctx)
      } else {
        log10_finite(self, ctx)
      }
    _ => abort("Decimal::log10: NaN handled above")
  }
}

///|
/// Finite-positive `log10`. Exact powers of ten short-circuit to their
/// integer logarithm (the adjusted exponent); otherwise the correctly-rounded
/// `dlog10` kernel runs inside a Ziv loop, mirroring `ln_finite`.
fn log10_finite(x : Decimal, ctx : Context) -> Decimal {
  match power_of_ten_log(x) {
    // log10(10^k) = k; still finalized so it fits precision (may round).
    Some(k) =>
      return Decimal::of_int(k).finalize_raw({ ..ctx, rounding: HalfEven })
    None => ()
  }
  let p = ctx.precision
  let c = x.coefficient
  let e = x.exponent
  let (coeff, places) = for places = p - log10_exp_bound(x) + 2 {
    let coeff = dlog10(c, e, places)
    if ziv_roundable(coeff, p) {
      break (coeff, places)
    } else {
      continue places + 3
    }
  }
  (
    {
      class: Finite,
      negative: coeff < 0N,
      coefficient: abs_big(coeff),
      exponent: -places,
    } : Decimal).finalize_raw({ ..ctx, rounding: HalfEven })
}

///|
/// Lower bound on the adjusted exponent of `log10(x)`, seeding the Ziv loop.
fn log10_exp_bound(x : Decimal) -> Int {
  let adj = adjusted_exponent(x)
  if adj >= 1 {
    return int_digits(adj) - 1
  }
  if adj <= -2 {
    return int_digits(-1 - adj) - 1
  }
  let c = x.coefficient
  let e = x.exponent
  if adj == 0 {
    // 1 < x < 10
    let num = (c - pow10(-e)).to_string()
    let den = (231N * c).to_string()
    num.length() - den.length() - (if dstr_lt(num, den) { 1 } else { 0 }) + 2
  } else {
    // adj == -1: 0.1 <= x < 1
    let num = (pow10(-e) - c).to_string()
    num.length() + e - (if dstr_lt(num, "231") { 1 } else { 0 }) - 1
  }
}

///|
/// For a positive finite `x = c · 10^e`, return `Some(k)` iff `c` is a
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

///|
/// GDA `power`: `self ^ other`. Integer exponents use square-and-multiply
/// for exactness; non-integer exponents use `exp(other · ln(self))`.
/// Domain rules: power(0, 0) = 1; power(±0, neg) = ±Infinity with
/// `Division_by_zero`; power(neg, non-integer) = NaN.
pub fn Decimal::power(
  self : Decimal,
  other : Decimal,
  ctx : Context,
) -> (Decimal, Flags) {
  let ctx = { ..ctx, flags: Flags::new() }
  (self.power_raw(other, ctx), ctx.flags)
}

///|
/// Internal worker for `power`: returns the value, raising into `ctx.flags`.
fn Decimal::power_raw(
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

///|
/// Infinity ^ finite (GDA §monadic power, infinite first operand).
///
/// * `Inf^0 = 1` (including `-Inf^0` and `-Inf^-0`).
/// * A negative base (`-Inf`) raised to a non-integer is `NaN`
///   (`Invalid_operation`) — the result would not be real.
/// * `Inf^negative` → signed `0`; `Inf^positive` → signed `Infinity`. The
///   sign is negative only when the base is negative and the exponent is an
///   odd integer (`-Inf^-1 = -0`, `-Inf^1 = -Infinity`, `-Inf^2 = +Infinity`).
fn power_infinity_finite(x : Decimal, y : Decimal, ctx : Context) -> Decimal {
  if y.coefficient.is_zero() {
    return Decimal::one()
  }
  if x.negative && !is_integer(y) {
    return invalid_nan(ctx)
  }
  let neg = x.negative && is_odd_integer(y)
  if y.negative {
    finite_zero(0, neg)
  } else {
    signed_infinity(neg)
  }
}

///|
/// Finite ^ infinity.
///
/// * `0^(+Inf) = +0`, `0^(-Inf) = +Infinity` — `power` does *not* raise
///   `Division_by_zero` (unlike `divide`).
/// * A negative finite base raised to `±Infinity` is `NaN`
///   (`Invalid_operation`): the sign would oscillate, so the limit is undefined.
/// * `1^(±Inf) = 1` — but returned rounded to precision with `Inexact` /
///   `Rounded` (the infinite exponent makes the result a limit).
/// * Otherwise the result is `+0` or `+Infinity` by whether `|x| > 1` agrees
///   with the exponent's sign.
fn power_finite_infinity(x : Decimal, y : Decimal, ctx : Context) -> Decimal {
  if x.coefficient.is_zero() {
    return if y.negative { signed_infinity(false) } else { Decimal::zero() }
  }
  if x.negative {
    return invalid_nan(ctx)
  }
  if is_one_abs(x) {
    return power_one_infinity(ctx)
  }
  let mag_above_one = magnitude_above_one(x)
  if mag_above_one == y.negative {
    Decimal::zero()
  } else {
    signed_infinity(false)
  }
}

///|
/// `1 ^ ±Infinity`: the value is exactly 1, but it is rounded to the
/// context precision and flags `Inexact` / `Rounded` (the infinite exponent
/// makes the result a limit). With no precision cap it is just `1`.
fn power_one_infinity(ctx : Context) -> Decimal {
  if ctx.precision <= 0 {
    return Decimal::one()
  }
  ctx.raise_inexact()
  ctx.raise_rounded()
  {
    class: Finite,
    negative: false,
    coefficient: pow10(ctx.precision - 1),
    exponent: -(ctx.precision - 1),
  }
}

///|
/// Infinity ^ Infinity.
fn power_infinity_infinity(x : Decimal, y : Decimal, ctx : Context) -> Decimal {
  // A negative base (`-Inf`) raised to `±Infinity` is undefined → NaN.
  if x.negative {
    return invalid_nan(ctx)
  }
  // `+Inf^(-Inf) = +0`, `+Inf^(+Inf) = +Infinity`.
  if y.negative {
    Decimal::zero()
  } else {
    signed_infinity(false)
  }
}

///|
/// Finite ^ finite.
fn power_finite(x : Decimal, y : Decimal, ctx : Context) -> Decimal {
  let p = ctx.precision
  // GDA: 0^0 is NaN + Invalid_operation (the limit is indeterminate).
  if x.coefficient.is_zero() && y.coefficient.is_zero() {
    return invalid_nan(ctx)
  }
  // x^0 = 1 for any finite non-zero x.
  if y.coefficient.is_zero() {
    return Decimal::one()
  }
  let y_int = integer_value(y)
  let y_is_int = is_integer(y)
  // The result is negative only for a negative base raised to an odd integer.
  let result_neg = x.negative &&
    (match y_int {
      Some(n) => n % 2 != 0
      None => false
    })
  // A negative base raised to a non-integer is invalid (the result is complex).
  // `(-0)^non-integer` falls through to the zero handling below.
  if x.negative && !y_is_int && !x.coefficient.is_zero() {
    return invalid_nan(ctx)
  }
  // From here on work with the magnitude; the sign is `result_neg`.
  let ax : Decimal = { ..x, negative: false }
  // power(±0, y≠0): negative y → signed Infinity, positive y → signed zero.
  // `power` does not raise Division_by_zero (unlike `divide`).
  if ax.coefficient.is_zero() {
    return if y.negative {
      signed_infinity(result_neg)
    } else {
      finite_zero(0, result_neg)
    }
  }
  // Integer exponents within the exact path's range (a positive value up
  // to 999_999_999, or a negative one down to -1_999_999_997) compute under the
  // usual context bounds; any other exponent routes through the ln/exp series,
  // which is gated behind the `MAX_MATH` context restriction. Reject an
  // over-wide context for those cases up front — this is also what stops
  // `power(1, 1.1)` at precision 100_000_000 from evaluating ln to a hundred
  // million digits.
  let in_int_range = match y_int {
    Some(n) => n >= -1_999_999_997 && n <= 999_999_999
    None => false
  }
  if !in_int_range {
    // An over-wide context can't bound the working precision → Invalid_context.
    if math_context_invalid(ctx) {
      ctx.raise_invalid_context()
      return Decimal::nan()
    }
    // An operand whose adjusted exponent or width exceeds MAX_MATH is out of
    // the math functions' domain → Invalid_operation.
    if operand_out_of_math_range(ax) || operand_out_of_math_range(y) {
      return invalid_nan(ctx)
    }
  }
  // `1^y = 1`, but the exponent and flags depend on `y` (GDA §power).
  if is_one(ax) {
    return power_one(x.exponent, y, y_int, y_is_int, result_neg, ctx)
  }
  // Crude overflow / underflow screen: with `bound = log10_exp_bound(x) +
  // adjusted(y)`, the result's order of magnitude is around `10^bound`, so a
  // large `bound` means the value overflows e_max or underflows past etiny.
  // This both shortcuts extreme inputs and, crucially, propagates the
  // Overflow / Underflow flags that an internal working context would swallow.
  let etiny = ctx.etiny()
  let bound = log10_exp_bound(ax) + adjusted_exponent(y)
  let overflowing = (adjusted_exponent(ax) >= 0) == !y.negative
  if overflowing {
    if bound >= int_digits(ctx.e_max) {
      return (
        {
          class: Finite,
          negative: result_neg,
          coefficient: 1N,
          exponent: ctx.e_max + 1,
        } : Decimal).finalize_raw(ctx)
    }
  } else if bound >= int_digits(-etiny) {
    return (
      {
        class: Finite,
        negative: result_neg,
        coefficient: 1N,
        exponent: etiny - 1,
      } : Decimal).finalize_raw(ctx)
  }
  // In-range integer exponent → exact square-and-multiply (sign handled by the
  // repeated multiply, matching `result_neg`).
  match y_int {
    Some(n) =>
      if in_int_range {
        let r = power_int(x, n, ctx)
        // `power_int` evaluates in a wide internal context, so it returns the
        // right *value* but the caller's Overflow / Underflow signals were
        // absorbed there. A finite non-zero base to a finite power can only
        // land on Infinity by overflowing e_max or on zero by underflowing
        // past etiny, so re-raise exactly those signals here (the squaring runs
        // in a wide internal context that absorbed them).
        if r.class is Infinity {
          ctx.raise_overflow()
          ctx.raise_inexact()
          ctx.raise_rounded()
        } else if r.coefficient.is_zero() {
          ctx.raise_underflow()
          ctx.raise_subnormal()
          ctx.raise_inexact()
          ctx.raise_rounded()
        }
        return r
      }
    None => ()
  }
  // General case: correctly-rounded `x^y` via the `dpower` kernel in a Ziv loop
  // that widens precision until the result rounds unambiguously. `power`
  // respects the context rounding mode (unlike exp / ln / log10).
  let yc = if y.negative { -y.coefficient } else { y.coefficient }
  let (coeff, exp) = for extra = 3 {
    let (coeff, exp) = dpower(
      ax.coefficient,
      ax.exponent,
      yc,
      y.exponent,
      p + extra,
    )
    if ziv_roundable(coeff, p) {
      break (coeff, exp)
    } else {
      continue extra + 3
    }
  }
  (
    { class: Finite, negative: result_neg, coefficient: coeff, exponent: exp } :
    Decimal).finalize_raw(ctx)
}

///|
/// `1^y`: the value is always 1, but GDA fixes the exponent (and the flags)
/// from `y`. For an integer `y` the ideal exponent is `self.exp * int(y)`
/// (clamped at `1 - precision`, raising `Rounded` if it clamps); for a
/// non-integer `y` the result is `1.000…0` at `1 - precision` with `Inexact`
/// and `Rounded`.
fn power_one(
  self_exp : Int,
  y : Decimal,
  y_int : Int?,
  y_is_int : Bool,
  result_neg : Bool,
  ctx : Context,
) -> Decimal {
  let p = ctx.precision
  let exp = if y_is_int {
    let multiplier = if y.negative {
      0
    } else {
      match y_int {
        Some(n) => if n > p { p } else { n }
        None => p // huge positive integer: clamp the multiplier to precision
      }
    }
    let e = self_exp * multiplier
    if e < 1 - p {
      ctx.raise_rounded()
      1 - p
    } else {
      e
    }
  } else {
    ctx.raise_inexact()
    ctx.raise_rounded()
    1 - p
  }
  // value 1 = 10^(-exp) * 10^exp, rendered with -exp trailing zeros.
  {
    class: Finite,
    negative: result_neg,
    coefficient: pow10(-exp),
    exponent: exp,
  }
}

///|
/// Integer-power via square-and-multiply, with negative exponents
/// expressed as `1 / power(x, |n|)`.
fn power_int(x : Decimal, n : Int, ctx : Context) -> Decimal {
  if n == 0 {
    return Decimal::one()
  }
  // Wide exponent range so an intermediate (e.g. `base^|n|` for a negative
  // exponent) stays finite and the reciprocal can underflow to a representable
  // subnormal rather than spuriously hitting 0. The bound is kept below
  // `Int.max / 2` so summing two in-range exponents never overflows `Int`;
  // genuinely overflowing results trip it and become ±Infinity, which the
  // caller turns into the right signals.
  let workctx = Context::new(
    precision=ctx.precision + 10,
    rounding=HalfEven,
    e_max=1_050_000_000,
    e_min=-1_050_000_000,
  )
  let mut base = x
  let mut result = Decimal::one()
  let mut exp = if n < 0 { -n } else { n }
  while exp > 0 {
    if exp % 2 == 1 {
      result = Decimal::multiply_raw(result, base, workctx)
    }
    exp = exp / 2
    if exp > 0 {
      base = Decimal::multiply_raw(base, base, workctx)
    }
  }
  if n < 0 {
    result = Decimal::divide_raw(Decimal::one(), result, workctx)
  }
  result.finalize_raw(ctx)
}

///|
/// Return `Some(n)` iff `y` is exactly representable as an `Int` —
/// non-negative or negative integer with no fractional part.
fn integer_value(y : Decimal) -> Int? {
  if !(y.class is Finite) {
    return None
  }
  if y.exponent >= 0 {
    bigint_to_int(y.coefficient * pow10(y.exponent), y.negative)
  } else if y.coefficient.is_zero() {
    Some(0)
  } else if -y.exponent >= digit_count(y.coefficient) {
    // More fractional places than the coefficient has digits ⇒ it cannot be
    // divisible by 10^(-exp), so the value is fractional. Checking this first
    // avoids building a huge `pow10` for a tiny operand like `1E-999999999`.
    None
  } else {
    // Integer iff the coefficient is divisible by 10^(-exp).
    let factor = pow10(-y.exponent)
    if (y.coefficient % factor).is_zero() {
      bigint_to_int(y.coefficient / factor, y.negative)
    } else {
      None
    }
  }
}

///|
/// True iff `y` is an integer (no fractional part), for any magnitude.
/// Unlike `integer_value` this never overflows — it only asks the
/// yes/no question, used by `power(-Inf, y)` to reject non-integer
/// exponents on a negative base.
fn is_integer(y : Decimal) -> Bool {
  if !(y.class is Finite) {
    return false
  }
  if y.exponent >= 0 {
    return true
  }
  if y.coefficient.is_zero() {
    return true
  }
  // See `integer_value`: more fractional places than digits ⇒ not an integer
  // (and avoids a huge `pow10`).
  if -y.exponent >= digit_count(y.coefficient) {
    return false
  }
  (y.coefficient % pow10(-y.exponent)).is_zero()
}

///|
/// True iff `y` is an odd integer. Used by `power(Inf, y)` to decide
/// whether the result inherits `Inf`'s sign.
fn is_odd_integer(y : Decimal) -> Bool {
  match integer_value(y) {
    Some(n) => n % 2 != 0
    None => false
  }
}

///|
/// True iff `|x| == 1` (any representation).
fn is_one_abs(x : Decimal) -> Bool {
  is_one({ ..x, negative: false })
}

///|
/// True iff `|x| > 1` for finite non-zero x.
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
