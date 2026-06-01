// ---------------------------------------------------------------------------
// IEEE 754 / GDA decimal32, decimal64, and decimal128 interchange encodings.
//
// The public API uses uppercase hexadecimal in network byte order. The bit
// layout is the DPD interchange format from the Decimal Encoding
// Specification: sign, combination field, exponent continuation, then DPD
// coefficient-continuation declets.
// ---------------------------------------------------------------------------

///|
priv struct InterchangeFormat {
  bits : Int
  precision : Int
  ecbits : Int
  bias : Int
  context : Context
}

///|
let format32 : InterchangeFormat = {
  bits: 32,
  precision: 7,
  ecbits: 6,
  bias: 101,
  context: Context::decimal32(),
}

///|
let format64 : InterchangeFormat = {
  bits: 64,
  precision: 16,
  ecbits: 8,
  bias: 398,
  context: Context::decimal64(),
}

///|
let format128 : InterchangeFormat = {
  bits: 128,
  precision: 34,
  ecbits: 12,
  bias: 6176,
  context: Context::decimal128(),
}

///|
/// Encode `self` as a decimal32 DPD interchange payload in network-byte-order
/// hexadecimal. The value is first rounded/clamped to the decimal32 format
/// using `rounding` (default: half-even); any conditions raised by that format
/// conversion are returned with the hex string.
pub fn Decimal::to_decimal32_hex(
  self : Decimal,
  rounding? : Rounding = HalfEven,
) -> (String, Flags) {
  encode_interchange(self, format32, rounding)
}

///|
/// Encode `self` as a decimal64 DPD interchange payload.
pub fn Decimal::to_decimal64_hex(
  self : Decimal,
  rounding? : Rounding = HalfEven,
) -> (String, Flags) {
  encode_interchange(self, format64, rounding)
}

///|
/// Encode `self` as a decimal128 DPD interchange payload.
pub fn Decimal::to_decimal128_hex(
  self : Decimal,
  rounding? : Rounding = HalfEven,
) -> (String, Flags) {
  encode_interchange(self, format128, rounding)
}

///|
/// Decode a decimal32 DPD interchange payload from network-byte-order
/// hexadecimal. Returns `None` if the string is not exactly 8 hex digits.
pub fn Decimal::from_decimal32_hex(hex : String) -> Decimal? {
  decode_interchange(hex, format32)
}

///|
/// Decode a decimal64 DPD interchange payload from network-byte-order
/// hexadecimal. Returns `None` if the string is not exactly 16 hex digits.
pub fn Decimal::from_decimal64_hex(hex : String) -> Decimal? {
  decode_interchange(hex, format64)
}

///|
/// Decode a decimal128 DPD interchange payload from network-byte-order
/// hexadecimal. Returns `None` if the string is not exactly 32 hex digits.
pub fn Decimal::from_decimal128_hex(hex : String) -> Decimal? {
  decode_interchange(hex, format128)
}

///|
fn encode_interchange(
  d : Decimal,
  fmt : InterchangeFormat,
  rounding : Rounding,
) -> (String, Flags) {
  let ctx = { ..fmt.context, rounding, flags: Flags::new() }
  let rounded = d.finalize_raw(ctx)
  (interchange_bits(rounded, fmt).to_fixed_hex(fmt.bits / 4), ctx.flags)
}

///|
fn interchange_bits(d : Decimal, fmt : InterchangeFormat) -> BigInt {
  let sign = if d.negative { 1N } else { 0N }
  match d.class {
    Infinity => (sign << (fmt.bits - 1)) | (30N << (fmt.bits - 6))
    QNaN | SNaN => {
      let sn = if d.class is SNaN { 1N } else { 0N }
      let payload = encode_coefficient_continuation(d.coefficient, fmt)
      (sign << (fmt.bits - 1)) |
      (31N << (fmt.bits - 6)) |
      (sn << (fmt.bits - 7)) |
      payload
    }
    Finite => {
      let encoded_exp = d.exponent + fmt.bias
      let exp_msb = encoded_exp >> fmt.ecbits
      let exp_cont = encoded_exp - (exp_msb << fmt.ecbits)
      let digits = left_pad_digits(d.coefficient.to_string(), fmt.precision)
      let msd = digit_at(digits, 0)
      let comb = if msd <= 7 {
        (exp_msb << 3) | msd
      } else {
        24 | (exp_msb << 1) | (msd - 8)
      }
      let coeff_cont = encode_digit_string_continuation(digits, fmt)
      (sign << (fmt.bits - 1)) |
      (BigInt::from_int(comb) << (fmt.bits - 6)) |
      (BigInt::from_int(exp_cont) << (fmt.bits - 6 - fmt.ecbits)) |
      coeff_cont
    }
  }
}

///|
fn decode_interchange(hex : String, fmt : InterchangeFormat) -> Decimal? {
  guard hex.length() == fmt.bits / 4 else { return None }
  guard parse_hex_bigint(hex) is Some(bits) else { return None }
  let sign = get_bits(bits, fmt.bits, 0, 1) == 1
  let comb = get_bits(bits, fmt.bits, 1, 5)
  if comb == 30 {
    return Some(signed_infinity(sign))
  }
  let exp_cont = get_bits(bits, fmt.bits, 6, fmt.ecbits)
  if comb == 31 {
    let signaling = ((exp_cont >> (fmt.ecbits - 1)) & 1) == 1
    let payload = decode_coefficient_continuation(bits, fmt, msd=0)
    return Some(
      if signaling {
        Decimal::snan(payload~, negative=sign)
      } else {
        Decimal::nan(payload~, negative=sign)
      },
    )
  }
  let (exp_msb, msd) = if comb >> 3 != 3 {
    (comb >> 3, comb & 7)
  } else {
    ((comb >> 1) & 3, 8 + (comb & 1))
  }
  let encoded_exp = (exp_msb << fmt.ecbits) | exp_cont
  let exponent = encoded_exp - fmt.bias
  let coefficient = decode_coefficient_continuation(bits, fmt, msd~)
  Some({ class: Finite, negative: sign, coefficient, exponent })
}

///|
fn encode_coefficient_continuation(
  coefficient : BigInt,
  fmt : InterchangeFormat,
) -> BigInt {
  let digits = left_pad_digits(coefficient.to_string(), fmt.precision)
  encode_digit_string_continuation(digits, fmt)
}

///|
fn encode_digit_string_continuation(
  digits : String,
  fmt : InterchangeFormat,
) -> BigInt {
  let groups = (fmt.precision - 1) / 3
  let mut out = 0N
  for g in 0..<groups {
    let i = 1 + g * 3
    let declet = dpd_encode3(
      digit_at(digits, i),
      digit_at(digits, i + 1),
      digit_at(digits, i + 2),
    )
    out = (out << 10) | BigInt::from_int(declet)
  }
  out
}

///|
fn decode_coefficient_continuation(
  bits : BigInt,
  fmt : InterchangeFormat,
  msd~ : Int,
) -> BigInt {
  let groups = (fmt.precision - 1) / 3
  let buf = StringBuilder::new()
  buf.write_char((0x30 + msd).unsafe_to_char())
  for g in 0..<groups {
    let offset = 6 + fmt.ecbits + g * 10
    let declet = get_bits(bits, fmt.bits, offset, 10)
    let (a, b, c) = dpd_decode3(declet)
    buf.write_char((0x30 + a).unsafe_to_char())
    buf.write_char((0x30 + b).unsafe_to_char())
    buf.write_char((0x30 + c).unsafe_to_char())
  }
  BigInt::from_string(buf.to_string())
}

///|
fn dpd_encode3(d0 : Int, d1 : Int, d2 : Int) -> Int {
  let a = (d0 >> 3) & 1
  let b = (d0 >> 2) & 1
  let c = (d0 >> 1) & 1
  let d = d0 & 1
  let e = (d1 >> 3) & 1
  let f = (d1 >> 2) & 1
  let g = (d1 >> 1) & 1
  let h = d1 & 1
  let i = (d2 >> 3) & 1
  let j = (d2 >> 2) & 1
  let k = (d2 >> 1) & 1
  let m = d2 & 1
  let p = b | (a & j) | (a & f & i)
  let q = c | (a & k) | (a & g & i)
  let r = d
  let s = (f & (1 - (a | i))) | ((1 - a) & e & j) | (e & i)
  let t = g | ((1 - a) & e & k) | (a & i)
  let u = h
  let v = a | e | i
  let w = a | (e & i) | ((1 - e) & j)
  let x = e | (a & i) | ((1 - a) & k)
  let y = m
  (p << 9) |
  (q << 8) |
  (r << 7) |
  (s << 6) |
  (t << 5) |
  (u << 4) |
  (v << 3) |
  (w << 2) |
  (x << 1) |
  y
}

///|
fn dpd_decode3(code : Int) -> (Int, Int, Int) {
  let p = (code >> 9) & 1
  let q = (code >> 8) & 1
  let r = (code >> 7) & 1
  let s = (code >> 6) & 1
  let t = (code >> 5) & 1
  let u = (code >> 4) & 1
  let v = (code >> 3) & 1
  let w = (code >> 2) & 1
  let x = (code >> 1) & 1
  let y = code & 1
  let nv = 1 - v
  let nw = 1 - w
  let nx = 1 - x
  let ns = 1 - s
  let nt = 1 - t
  let a = v & w & (ns | t | nx)
  let b = p & (nv | nw | (s & nt & x))
  let c = q & (nv | nw | (s & nt & x))
  let d = r
  let e = v & ((nw & x) | (nt & x) | (s & x))
  let f = (s & (nv | nx)) | (p & ns & t & v & w & x)
  let g = (t & (nv | nx)) | (q & ns & t & w)
  let h = u
  let i = v & ((nw & nx) | (w & x & (s | t)))
  let j = (nv & w) | (s & v & nw & x) | (p & w & (nx | (s & nt)))
  let k = (nv & x) | (t & nw & x) | (q & v & w & (nx | (s & nt)))
  let m = y
  (
    (a << 3) | (b << 2) | (c << 1) | d,
    (e << 3) | (f << 2) | (g << 1) | h,
    (i << 3) | (j << 2) | (k << 1) | m,
  )
}

///|
fn get_bits(bits : BigInt, total : Int, offset : Int, len : Int) -> Int {
  let shift = total - offset - len
  (bits >> shift).land((1N << len) - 1N).to_int()
}

///|
fn parse_hex_bigint(hex : String) -> BigInt? {
  let mut out = 0N
  for i in 0..<hex.length() {
    guard hex_digit(char_at(hex, i)) is Some(n) else { return None }
    out = (out << 4) | BigInt::from_int(n)
  }
  Some(out)
}

///|
fn hex_digit(c : Char) -> Int? {
  if c >= '0' && c <= '9' {
    Some(c.to_int() - '0'.to_int())
  } else if c >= 'a' && c <= 'f' {
    Some(c.to_int() - 'a'.to_int() + 10)
  } else if c >= 'A' && c <= 'F' {
    Some(c.to_int() - 'A'.to_int() + 10)
  } else {
    None
  }
}

///|
fn BigInt::to_fixed_hex(self : BigInt, width : Int) -> String {
  let buf = StringBuilder::new()
  for i in 0..<width {
    let shift = (width - i - 1) * 4
    let nibble = (self >> shift).land(15N).to_int()
    let code = if nibble < 10 { 0x30 + nibble } else { 0x41 + nibble - 10 }
    buf.write_char(code.unsafe_to_char())
  }
  buf.to_string()
}

///|
fn left_pad_digits(s : String, width : Int) -> String {
  if s.length() >= width {
    return s
  }
  let buf = StringBuilder::new()
  for _ in 0..<(width - s.length()) {
    buf.write_char('0')
  }
  buf.write_string(s)
  buf.to_string()
}

///|
fn digit_at(s : String, i : Int) -> Int {
  char_at(s, i).to_int() - '0'.to_int()
}
