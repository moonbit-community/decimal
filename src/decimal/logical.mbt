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
