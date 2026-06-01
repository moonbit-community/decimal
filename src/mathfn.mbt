// ---------------------------------------------------------------------------
// Correctly-rounded integer kernels for the mathematical functions
// (exp / ln / log10 / power).
//
// They work on the `BigInt` coefficient directly — rather
// than threading a variable-precision `Decimal` through a Taylor loop — gives
// results that are correctly rounded to the requested number of places (error
// of at most 1 in the last computed digit), and handles operands of any
// magnitude in O(1) range reduction (the exponent enters as `e * log(10)`,
// never as a halving/doubling loop).
//
// MoonBit's `BigInt` `>>` is an arithmetic (floor) shift and `land` is
// two's-complement bitwise-and, which is what these routines need; only `/`
// and `%` need care (they truncate toward zero, while the fixed-point algebra
// below assumes floor semantics), which `floor_div` / `div_nearest` correct for.
// Iteration is written
// with MoonBit's tail-recursive `for`-binder loops rather than mutable state.
// ---------------------------------------------------------------------------

///|
/// Absolute value of a `BigInt`.
fn abs_big(b : BigInt) -> BigInt {
  if b < 0N {
    -b
  } else {
    b
  }
}

///|
/// Number of decimal digits in the magnitude `|b|` (zero counts as one digit).
fn bigint_digits(b : BigInt) -> Int {
  digit_count(abs_big(b))
}

///|
/// Bit length of the magnitude `|n|` (zero -> 0).
fn nbits(n : BigInt) -> Int {
  n.bit_length()
}

///|
/// Floor division `floor(a / b)` for `b > 0`. MoonBit's `/` truncates toward
/// zero, so it differs from the floor only when `a < 0`, which this corrects.
fn floor_div(a : BigInt, b : BigInt) -> BigInt {
  let q = a / b
  // Reuse the quotient to recover the truncated remainder (a - q*b) rather
  // than running a second full division for `a % b`.
  if a - q * b < 0N {
    q - 1N
  } else {
    q
  }
}

///|
/// Closest integer to `a / b` for `b > 0`, rounding to even on a tie.
fn div_nearest(a : BigInt, b : BigInt) -> BigInt {
  let q = floor_div(a, b)
  let r = a - q * b // floor remainder, 0 <= r < b
  if ((r << 1) + q.land(1N)).compare(b) > 0 {
    q + 1N
  } else {
    q
  }
}

///|
/// Closest integer to `x / 2^shift` (shift >= 0), rounding to even on a tie.
fn rshift_nearest(x : BigInt, shift : Int) -> BigInt {
  let b = 1N << shift
  let q = x >> shift
  if ((x.land(b - 1N) << 1) + q.land(1N)).compare(b) > 0 {
    q + 1N
  } else {
    q
  }
}

///|
/// Closest integer to `sqrt(n)` (n > 0), Newton-refined from `a0 > 0`.
fn sqrt_nearest(n : BigInt, a0 : BigInt) -> BigInt {
  for a = a0, b = 0N {
    if a != b {
      continue (a - floor_div(-n, a)) >> 1, a
    } else {
      break a
    }
  }
}

///|
/// Number of terms for the fixed-point Taylor series at precision `M` (with
/// `digits = len(str(M))`) and reduction parameter `L`: `ceil(10*digits/(3L))`.
fn taylor_terms(digits : Int, l : Int) -> Int {
  (10 * digits + 3 * l - 1) / (3 * l)
}

///|
/// Integer approximation to `M * log(x / M)` (x, M > 0). For `L = 8` and
/// `0.1 <= x/M <= 10` the absolute error is at most 22.
fn ilog(x : BigInt, m : BigInt, l : Int) -> BigInt {
  // Argument reduction via `log1p(y) = 2*log1p(y/(1+sqrt(1+y)))`, in
  // fixed-point: `y` represents `2^R * y_real * M` after R reductions.
  let (y, r) = for y = x - m, r = 0 {
    if (r <= l && (abs_big(y) << (l - r)).compare(m) >= 0) ||
      (r > l && (abs_big(y) >> (r - l)).compare(m) >= 0) {
      let s = sqrt_nearest(m * (m + rshift_nearest(y, r)), m)
      continue div_nearest((m * y) << 1, m + s), r + 1
    } else {
      break (y, r)
    }
  }
  // Taylor series for log1p, evaluated by Horner over T terms.
  let t = taylor_terms(bigint_digits(m), l)
  let yshift = rshift_nearest(y, r)
  let w = for k = t - 1, w = div_nearest(m, BigInt::from_int(t)) {
    if k > 0 {
      continue k - 1,
        div_nearest(m, BigInt::from_int(k)) - div_nearest(yshift * w, m)
    } else {
      break w
    }
  }
  div_nearest(w * y, m)
}

///|
/// Integer approximation to `M * exp(x / M)` (M > 0, x/M small). For
/// `0 <= x/M <= 2.4` the absolute error is bounded by 60.
fn iexp(x : BigInt, m : BigInt, l : Int) -> BigInt {
  // Reduce by a power R of 2 so |x/2^R/M| < 2^-L, sum the expm1 Taylor series,
  // then square back up R times via `expm1(2x) = expm1(x)*(expm1(x)+2)`.
  let r = nbits(floor_div(x << l, m))
  let t = taylor_terms(bigint_digits(m), l)
  let mshift0 = m << r
  let y0 = for i = t - 1, y = div_nearest(x, BigInt::from_int(t)) {
    if i > 0 {
      continue i - 1,
        div_nearest(x * (mshift0 + y), mshift0 * BigInt::from_int(i))
    } else {
      break y
    }
  }
  let y = for k = r - 1, y = y0 {
    if k >= 0 {
      let mshift = m << (k + 2)
      continue k - 1, div_nearest(y * (y + mshift), mshift)
    } else {
      break y
    }
  }
  m + y
}

///|
/// True iff the last `count` characters of `s` are all the digit '0'.
fn suffix_all_zeros(s : String, count : Int) -> Bool {
  let n = s.length()
  for i = n - count {
    if i >= n {
      break true
    } else if i >= 0 && s[i].to_int() != 0x30 {
      break false
    } else {
      continue i + 1
    }
  }
}

///|
/// Cache of reliable leading digits of `log(10) = 2.302585...` (truncated,
/// never rounded). Seeded with 47 digits and grown on demand; mirrors
/// grown on demand. Without it, every `dlog` / `dexp` would recompute
/// `log(10)` from scratch — the dominant cost in `power`.
let log10_cache : Ref[String] = {
  val: "23025850929940456840179914546843642076011014886",
}

///|
/// `floor(10^p * log(10))` for `p >= 0` — the digits of `log(10)` needed by
/// `ln` / `log10` / `power`. Served from `log10_cache`, extending it via `ilog`
/// when more digits are wanted (computing until the truncation point is
/// reliable, i.e. the trailing guard digits are not all zero).
fn log10_digits(p : Int) -> BigInt {
  let cached = log10_cache.val
  if p + 1 > cached.length() {
    let s = for extra = 3 {
      let m = pow10(p + extra + 2)
      // ~ 10^(p+extra) * log(10), i.e. 2.302585... * 10^(p+extra).
      let cand = div_nearest(ilog(10N * m, m, 8), 100N).to_string()
      if suffix_all_zeros(cand, extra) {
        continue extra + 3
      } else {
        break cand
      }
    }
    // Keep all reliable digits: drop trailing zeros and the next digit.
    log10_cache.val = reliable_prefix(s)
  }
  BigInt::from_string(log10_cache.val[0:p + 1].to_owned())
}

///|
/// Strip trailing '0' characters from `s`, then drop one further digit — the
/// remaining prefix is the part of `s` known to be correct.
fn reliable_prefix(s : String) -> String {
  let end = for i = s.length() {
    if i > 0 && s[i - 1].to_int() == 0x30 {
      continue i - 1
    } else {
      break i
    }
  }
  s[0:if end > 0 { end - 1 } else { 0 }].to_owned()
}

///|
/// Integer approximation to `10^p * log(c * 10^e)` (c > 0), error <= 1.
/// Assumes `c * 10^e != 1`. Uses `log(c*10^e) = log(d) + f*log(10)` after
/// writing `c*10^e = d*10^f` with `d` near 1 — so the magnitude `f` is read
/// off directly, never iterated.
fn dlog(c : BigInt, e : Int, p_in : Int) -> BigInt {
  let p = p_in + 2
  let l = bigint_digits(c)
  let f = e + l - (if e + l >= 1 { 1 } else { 0 })
  let log_d = if p > 0 {
    let k = e + p - f
    let cc = if k >= 0 { c * pow10(k) } else { div_nearest(c, pow10(-k)) }
    ilog(cc, pow10(p), 8)
  } else {
    0N
  }
  let f_log_ten = if f != 0 {
    let extra = bigint_digits(BigInt::from_int(f)) - 1
    if p + extra >= 0 {
      div_nearest(BigInt::from_int(f) * log10_digits(p + extra), pow10(extra))
    } else {
      0N
    }
  } else {
    0N
  }
  div_nearest(f_log_ten + log_d, 100N)
}

///|
/// Integer approximation to `10^p * log10(c * 10^e)` (c > 0), error <= 1.
/// Assumes `c * 10^e != 1`.
fn dlog10(c : BigInt, e : Int, p_in : Int) -> BigInt {
  let p = p_in + 2
  let l = bigint_digits(c)
  let f = e + l - (if e + l >= 1 { 1 } else { 0 })
  if p > 0 {
    let m = pow10(p)
    let k = e + p - f
    let cc = if k >= 0 { c * pow10(k) } else { div_nearest(c, pow10(-k)) }
    let log_d = div_nearest(ilog(cc, m, 8) * m, log10_digits(p))
    let log_tenpower = BigInt::from_int(f) * m
    div_nearest(log_tenpower + log_d, 100N)
  } else {
    div_nearest(div_nearest(BigInt::from_int(f), pow10(-p)), 100N)
  }
}

///|
/// Approximation to `exp(c * 10^e)` with `p` digits of precision. Returns
/// `(d, f)` with `10^(p-1) <= d <= 10^p` and `(d-1)*10^f < exp(c*10^e) <
/// (d+1)*10^f` — i.e. `d` carries an error of at most 1.
fn dexp(c : BigInt, e : Int, p_in : Int) -> (BigInt, Int) {
  let p = p_in + 2
  // extra precision for log(10) = adjusted exponent of c*10^e (if positive).
  let adj = e + bigint_digits(c) - 1
  let extra = if adj > 0 { adj } else { 0 }
  let q = p + extra
  let shift = e + q
  let cshift = if shift >= 0 {
    c * pow10(shift)
  } else {
    floor_div(c, pow10(-shift))
  }
  let logd = log10_digits(q)
  let quot = floor_div(cshift, logd)
  let rem = div_nearest(cshift - quot * logd, pow10(extra))
  let coeff = div_nearest(iexp(rem, pow10(p), 8), 1000N)
  (coeff, quot.to_int() - p + 3)
}

///|
/// Ziv stopping test for a correctly-rounded result: true once `coeff` (a
/// value computed to a few guard digits beyond precision `p`) is far enough
/// from a rounding boundary to round the same way under any mode — i.e. it is
/// not a multiple of half a ulp at `p`. While this is false the caller widens
/// the working precision and recomputes.
fn ziv_roundable(coeff : BigInt, p : Int) -> Bool {
  !(abs_big(coeff) % (5N * pow10(bigint_digits(coeff) - p - 1))).is_zero()
}

///|
/// Approximation to `x^y` where `x = xc*10^xe > 0` (and != 1) and
/// `y = yc*10^ye != 0`. Returns `(c, e)` with `10^(p-1) <= c <= 10^p` and
/// `(c-1)*10^e < x^y < (c+1)*10^e`.
fn dpower(
  xc : BigInt,
  xe : Int,
  yc : BigInt,
  ye : Int,
  p : Int,
) -> (BigInt, Int) {
  let b = bigint_digits(yc) + ye
  let lxc = dlog(xc, xe, p + b + 1)
  let shift = ye - b
  let pc = if shift >= 0 {
    lxc * yc * pow10(shift)
  } else {
    div_nearest(lxc * yc, pow10(-shift))
  }
  if pc.is_zero() {
    // Prefer a result that is not exactly 1, so power can round correctly.
    if (bigint_digits(xc) + xe >= 1) == (yc > 0N) {
      (pow10(p - 1) + 1N, 1 - p)
    } else {
      (pow10(p) - 1N, -p)
    }
  } else {
    let (coeff, exp) = dexp(pc, -(p + 1), p + 1)
    (div_nearest(coeff, 10N), exp + 1)
  }
}
