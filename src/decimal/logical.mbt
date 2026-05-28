// ---------------------------------------------------------------------------
// Digit-wise logical ops on operands whose coefficient is a bit-string
// (every digit ∈ {0, 1}, no fractional digits, no sign).
//
// These are oddly-specified in the GDA spec — they treat the *decimal*
// coefficient as a wide bit field, not the underlying binary value. The
// representation makes them fit alongside the other decimal ops without
// needing a separate "integer bit-string" type.
// ---------------------------------------------------------------------------

///| GDA `logical-and`: digit-wise AND of two bit-string Decimals.
pub fn Decimal::logical_and(
  self : Decimal,
  other : Decimal,
  ctx : Context,
) -> Decimal {
  logical_binary(self, other, ctx, fn(a, b) { if a == 1 && b == 1 { 1 } else { 0 } })
}

///| GDA `logical-or`: digit-wise OR.
pub fn Decimal::logical_or(
  self : Decimal,
  other : Decimal,
  ctx : Context,
) -> Decimal {
  logical_binary(self, other, ctx, fn(a, b) { if a == 1 || b == 1 { 1 } else { 0 } })
}

///| GDA `logical-xor`: digit-wise XOR.
pub fn Decimal::logical_xor(
  self : Decimal,
  other : Decimal,
  ctx : Context,
) -> Decimal {
  logical_binary(self, other, ctx, fn(a, b) { if a != b { 1 } else { 0 } })
}

///| GDA `logical-invert`: digit-wise NOT, width set by `ctx.precision`
/// (or the operand's natural width when precision is 0). Unlike the binary
/// ops, invert *needs* the operand to be left-padded to the full precision
/// width — otherwise `invert(10)` at precision 9 would render as `01`
/// rather than `111111101`.
pub fn Decimal::logical_invert(self : Decimal, ctx : Context) -> Decimal {
  if !valid_logical_operand(self) {
    return invalid_nan(ctx)
  }
  let bits = logical_digits(self, ctx)
  match bits {
    None => invalid_nan(ctx)
    Some(s) => {
      // Pad on the left to precision width so the inverted result has the
      // expected leading-1s for short inputs (per GDA's invert semantics).
      let padded = if ctx.precision > 0 && s.length() < ctx.precision {
        let buf = StringBuilder::new()
        for _ in 0..<(ctx.precision - s.length()) {
          buf.write_char('0')
        }
        buf.write_string(s)
        buf.to_string()
      } else {
        s
      }
      let buf = StringBuilder::new()
      let n = padded.length()
      for i in 0..<n {
        if padded[i].to_int() == 0x30 {
          buf.write_char('1')
        } else {
          buf.write_char('0')
        }
      }
      build_logical_result(buf.to_string())
    }
  }
}

///| Shared body for AND / OR / XOR: validate, align widths, apply `op`
/// per-digit, build the result.
fn logical_binary(
  a : Decimal,
  b : Decimal,
  ctx : Context,
  op : (Int, Int) -> Int,
) -> Decimal {
  if !valid_logical_operand(a) || !valid_logical_operand(b) {
    return invalid_nan(ctx)
  }
  let a_bits = logical_digits(a, ctx)
  let b_bits = logical_digits(b, ctx)
  match (a_bits, b_bits) {
    (Some(sa), Some(sb)) => {
      // Right-align: pad the shorter on the left so positions correspond.
      let na = sa.length()
      let nb = sb.length()
      let width = if na > nb { na } else { nb }
      let buf = StringBuilder::new()
      for i in 0..<width {
        let ai = i - (width - na)
        let bi = i - (width - nb)
        let av = if ai >= 0 { sa[ai].to_int() - 0x30 } else { 0 }
        let bv = if bi >= 0 { sb[bi].to_int() - 0x30 } else { 0 }
        let d = op(av, bv)
        buf.write_char(if d == 1 { '1' } else { '0' })
      }
      build_logical_result(buf.to_string())
    }
    _ => invalid_nan(ctx)
  }
}

///| The operand must be a finite, non-negative, exponent-0 Decimal. Any
/// other class / sign / exponent yields `Invalid_operation` per GDA.
fn valid_logical_operand(d : Decimal) -> Bool {
  d.class is Finite && !d.negative && d.exponent == 0
}

///| Stringify the operand's coefficient and truncate to the rightmost
/// `ctx.precision` digits (or leave as-is when precision is 0). Returns
/// `None` if any digit is outside `{0, 1}` — the caller raises
/// `Invalid_operation` in that case.
fn logical_digits(d : Decimal, ctx : Context) -> String? {
  let mut s = d.coefficient.to_string()
  if ctx.precision > 0 && s.length() > ctx.precision {
    s = s[s.length() - ctx.precision:].to_owned()
  }
  for i in 0..<s.length() {
    let c = s[i].to_int()
    if c != 0x30 && c != 0x31 { // '0', '1'
      return None
    }
  }
  Some(s)
}

///| GDA `rotate`: cyclically rotate the digits of `self` (treated as a
/// precision-width unsigned integer) by `other` positions — left for
/// positive, right for negative. The first operand may carry any decimal
/// digit (unlike the logical ops); only the second has the integer-in-
/// `[-precision, precision]` constraint.
pub fn Decimal::rotate(
  self : Decimal,
  other : Decimal,
  ctx : Context,
) -> Decimal {
  rotate_or_shift(self, other, ctx, true)
}

///| GDA `shift`: shift the digits of `self` (precision-width) by `other`
/// positions; positions shifted past either end are discarded, vacated
/// positions are filled with zeros.
pub fn Decimal::shift(
  self : Decimal,
  other : Decimal,
  ctx : Context,
) -> Decimal {
  rotate_or_shift(self, other, ctx, false)
}

///| Shared body. NaN/Inf routing comes first (Infinity in the first
/// operand passes through; an Infinity rhs is `Invalid_operation`); for
/// finite/finite, the body lays the first operand's coefficient out as a
/// precision-width digit string and dispatches to the cyclic or non-cyclic
/// digit-mover. The first operand's sign and exponent are preserved on
/// the result — rotate/shift only ever touch the coefficient.
fn rotate_or_shift(
  a : Decimal,
  b : Decimal,
  ctx : Context,
  is_rotate : Bool,
) -> Decimal {
  match propagate_nan(a, b, ctx) {
    Some(d) => return d
    None => ()
  }
  match (a.class, b.class) {
    (Infinity, Finite) => return a
    (_, Infinity) => return invalid_nan(ctx)
    _ => ()
  }
  let shift = match shift_amount(b, ctx) {
    Some(n) => n
    None => return invalid_nan(ctx)
  }
  if ctx.precision <= 0 {
    return invalid_nan(ctx)
  }
  let width = ctx.precision
  let mut s = a.coefficient.to_string()
  if s.length() > width {
    s = s[s.length() - width:].to_owned()
  }
  if s.length() < width {
    let pad = StringBuilder::new()
    for _ in 0..<(width - s.length()) {
      pad.write_char('0')
    }
    pad.write_string(s)
    s = pad.to_string()
  }
  let moved = if is_rotate {
    rotate_digits(s, shift, width)
  } else {
    shift_digits(s, shift, width)
  }
  let mut start = 0
  while start < moved.length() - 1 && moved[start].to_int() == 0x30 {
    start = start + 1
  }
  let trimmed = if start == 0 { moved } else { moved[start:].to_owned() }
  let coef = BigInt::from_string(trimmed)
  { class: Finite, negative: a.negative, coefficient: coef, exponent: a.exponent }
}

///| `b` must be a finite non-fractional integer (exponent 0) whose
/// magnitude does not exceed `ctx.precision`. Returns the signed shift
/// amount in `Some`, or `None` to signal `Invalid_operation`.
fn shift_amount(b : Decimal, ctx : Context) -> Int? {
  if !(b.class is Finite) {
    return None
  }
  if b.exponent != 0 {
    return None
  }
  let mag = fits_int64(b.coefficient)
  match mag {
    None => None
    Some(n) =>
      if n > ctx.precision.to_int64() {
        None
      } else {
        let signed = if b.negative { -n.to_int() } else { n.to_int() }
        Some(signed)
      }
  }
}

///| Cyclically rotate `s` by `shift` positions — positive shift moves the
/// leftmost digits past the right edge; negative shift goes the other way.
fn rotate_digits(s : String, shift : Int, width : Int) -> String {
  // Normalise shift into `[0, width)`.
  let mut k = shift % width
  if k < 0 {
    k = k + width
  }
  if k == 0 {
    return s
  }
  // Left rotate by k: take s[k:] + s[:k].
  let buf = StringBuilder::new()
  buf.write_string(s[k:].to_owned())
  buf.write_string(s[:k].to_owned())
  buf.to_string()
}

///| Non-cyclic shift. Positive shift moves digits left (off the left
/// edge); negative shift moves them right (off the right edge). Vacated
/// positions are filled with `'0'`.
fn shift_digits(s : String, shift : Int, width : Int) -> String {
  if shift >= width || shift <= -width {
    let buf = StringBuilder::new()
    for _ in 0..<width {
      buf.write_char('0')
    }
    return buf.to_string()
  }
  if shift == 0 {
    return s
  }
  if shift > 0 {
    // Left shift: take s[shift:] then pad shift zeros on the right.
    let buf = StringBuilder::new()
    buf.write_string(s[shift:].to_owned())
    for _ in 0..<shift {
      buf.write_char('0')
    }
    buf.to_string()
  } else {
    // Right shift: pad |shift| zeros on the left, take s[:width - |shift|].
    let abs = -shift
    let buf = StringBuilder::new()
    for _ in 0..<abs {
      buf.write_char('0')
    }
    buf.write_string(s[:width - abs].to_owned())
    buf.to_string()
  }
}

///| Drop leading zeros from a bit-string, then build a finite Decimal
/// with the resulting coefficient at exponent 0. An all-zero bit-string
/// yields `0`.
fn build_logical_result(s : String) -> Decimal {
  let mut start = 0
  while start < s.length() - 1 && s[start].to_int() == 0x30 {
    start = start + 1
  }
  let trimmed = if start == 0 { s } else { s[start:].to_owned() }
  let coef = BigInt::from_string(trimmed)
  { class: Finite, negative: false, coefficient: coef, exponent: 0 }
}
