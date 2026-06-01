///|
/// Magnitude an exponent literal is clamped to once it exceeds every
/// representable range. Chosen above any context's `e_max` (which never
/// exceeds `999_999_999`) yet far enough below `Int.max` that the later
/// `exp - frac_digits` arithmetic and sign flip cannot wrap.
const EXPONENT_SATURATION : Int = 1_999_999_999

///|
/// Errors raised by `Decimal::parse`.
pub(all) suberror ParseError {
  /// Input was empty.
  Empty
  /// A digit was required at this position but not found.
  ExpectedDigit(position~ : Int)
  /// Exponent body was missing or malformed.
  InvalidExponent(position~ : Int)
  /// Unexpected character left over after a valid decimal was consumed.
  TrailingGarbage(position~ : Int)
  /// A keyword (Inf/Infinity/NaN/sNaN) was started but not completed.
  BadKeyword(position~ : Int)
} derive(Eq)

///|
pub impl Show for ParseError with fn to_string(self) {
  match self {
    Empty => "Empty"
    ExpectedDigit(position~) => "ExpectedDigit(position=\{position})"
    InvalidExponent(position~) => "InvalidExponent(position=\{position})"
    TrailingGarbage(position~) => "TrailingGarbage(position=\{position})"
    BadKeyword(position~) => "BadKeyword(position=\{position})"
  }
}

///|
/// Parse a decimal literal, following the General Decimal Arithmetic grammar:
///
/// ```text
/// numeric-string  ::= [sign] numeric-value
///                   | [sign] nan
/// numeric-value   ::= decimal-part [exponent-part]
///                   | infinity
/// decimal-part    ::= digits '.' [digits]
///                   | ['.'] digits
/// exponent-part   ::= ('e' | 'E') [sign] digits
/// infinity        ::= 'Infinity' | 'Inf'         -- case-insensitive
/// nan             ::= 'NaN' [digits]             -- case-insensitive
///                   | 'sNaN' [digits]
/// ```
///
/// Rejects: empty input, lone `.`, exponent with no digits, leading/trailing
/// whitespace, underscores. NaN payloads are parsed into `Decimal.coefficient`.
pub fn Decimal::parse(input : String) -> Decimal raise ParseError {
  let n = input.length()
  if n == 0 {
    raise Empty
  }
  let mut i = 0
  let negative = match char_at(input, 0) {
    '+' => {
      i = 1
      false
    }
    '-' => {
      i = 1
      true
    }
    _ => false
  }
  if i >= n {
    raise ExpectedDigit(position=i)
  }
  // Dispatch on the leading character after the sign. Special values
  // (Infinity/NaN/sNaN) start with letters; finite numbers with a digit or '.'.
  match char_at(input, i) {
    'i' | 'I' => parse_infinity(input, i, negative)
    'n' | 'N' => parse_nan(input, i, negative, signaling=false)
    's' | 'S' => parse_nan(input, i, negative, signaling=true)
    _ => parse_finite(input, i, negative)
  }
}

///|
/// Parse "Inf" or "Infinity", case-insensitive, expecting the cursor to point
/// at the leading 'i'.
fn parse_infinity(
  input : String,
  start : Int,
  negative : Bool,
) -> Decimal raise ParseError {
  let n = input.length()
  if !match_ci(input, start, "inf") {
    raise BadKeyword(position=start)
  }
  let after_inf = start + 3
  let endpos = if match_ci(input, after_inf, "inity") {
    after_inf + 5
  } else {
    after_inf
  }
  if endpos != n {
    raise TrailingGarbage(position=endpos)
  }
  { class: Infinity, negative, coefficient: 0N, exponent: 0 }
}

///|
/// Parse "NaN" with optional decimal payload.
fn parse_nan(
  input : String,
  start : Int,
  negative : Bool,
  signaling~ : Bool,
) -> Decimal raise ParseError {
  let kw = if signaling { "snan" } else { "nan" }
  let n = input.length()
  if !match_ci(input, start, kw) {
    raise BadKeyword(position=start)
  }
  let mut i = start + kw.length()
  let payload_buf = StringBuilder::new()
  let payload_len = consume_digits(input, i, payload_buf)
  i = i + payload_len
  if i != n {
    raise TrailingGarbage(position=i)
  }
  let payload = if payload_len == 0 {
    0N
  } else {
    BigInt::from_string(payload_buf.to_string())
  }
  {
    class: if signaling {
      SNaN
    } else {
      QNaN
    },
    negative,
    coefficient: payload,
    exponent: 0,
  }
}

///|
/// Parse the finite-number branch of the grammar starting at `start`.
fn parse_finite(
  input : String,
  start : Int,
  negative : Bool,
) -> Decimal raise ParseError {
  let n = input.length()
  let digits = StringBuilder::new()
  let mut i = start
  let int_digits = consume_digits(input, i, digits)
  i = i + int_digits
  let mut frac_digits = 0
  if i < n && char_at(input, i) == '.' {
    i = i + 1
    frac_digits = consume_digits(input, i, digits)
    i = i + frac_digits
  }
  if int_digits == 0 && frac_digits == 0 {
    raise ExpectedDigit(position=i)
  }
  let mut exp = 0
  if i < n && (char_at(input, i) == 'e' || char_at(input, i) == 'E') {
    let exp_start = i
    i = i + 1
    let exp_negative = if i < n {
      match char_at(input, i) {
        '+' => {
          i = i + 1
          false
        }
        '-' => {
          i = i + 1
          true
        }
        _ => false
      }
    } else {
      false
    }
    let exp_digits_start = i
    // Saturate rather than wrap: an exponent magnitude beyond every
    // representable range is clamped to a sentinel that is still well above
    // any context's e_max yet safely inside `Int`. Without this, a colossal
    // exponent like `1e-12345678903` would overflow `Int` and could wrap back
    // into a valid range, turning a should-be-`NaN` into a finite result. The
    // guard is evaluated before the multiply so the overflow never happens.
    let mut exp_overflow = false
    while i < n && is_digit(char_at(input, i)) {
      if !exp_overflow {
        let d = char_at(input, i).to_int() - '0'.to_int()
        if exp > (EXPONENT_SATURATION - d) / 10 {
          exp_overflow = true
        } else {
          exp = exp * 10 + d
        }
      }
      i = i + 1
    }
    if i == exp_digits_start {
      raise InvalidExponent(position=exp_start)
    }
    if exp_overflow {
      exp = EXPONENT_SATURATION
    }
    if exp_negative {
      exp = -exp
    }
  }
  if i != n {
    raise TrailingGarbage(position=i)
  }
  let coefficient = BigInt::from_string(digits.to_string())
  { class: Finite, negative, coefficient, exponent: exp - frac_digits }
}

///|
/// Consume a run of ASCII digits starting at `start`, appending each to
/// `buf`. Returns the number of digits consumed.
fn consume_digits(input : String, start : Int, buf : StringBuilder) -> Int {
  let n = input.length()
  let mut i = start
  while i < n && is_digit(char_at(input, i)) {
    buf.write_char(char_at(input, i))
    i = i + 1
  }
  i - start
}

///|
fn is_digit(c : Char) -> Bool {
  c >= '0' && c <= '9'
}

///|
/// ASCII case-insensitive prefix match: does `input[start..]` start with
/// `word`? `word` is assumed to be lowercase ASCII.
fn match_ci(input : String, start : Int, word : String) -> Bool {
  let n = input.length()
  let w = word.length()
  if start + w > n {
    return false
  }
  // `word` is a lowercase literal, so lower-case the input char in Int space
  // and compare codes directly.
  for k = 0 {
    if k >= w {
      break true
    }
    let a = char_at(input, start + k).to_int()
    let a_lower = if a >= 0x41 && a <= 0x5A { a + 32 } else { a }
    if a_lower != char_at(word, k).to_int() {
      break false
    }
    continue k + 1
  }
}

///|
/// GDA `to-number`: convert a string to a `Decimal` under a context, returning
/// the result paired with the `Flags` raised. This is the flag-based companion
/// to `parse`: on a malformed string it returns a quiet `NaN` and raises
/// `conversion_syntax` (rather than raising `ParseError`); on a valid string it
/// rounds the parsed value to the context and reports any `inexact` / `rounded`
/// / range flags. Use `parse` when a syntax error should be a catchable
/// `ParseError`; use this when you want GDA's NaN-plus-`conversion_syntax`
/// behaviour.
pub fn Decimal::of_string(s : String, ctx : Context) -> (Decimal, Flags) {
  Decimal::parse(s).finalize(ctx) catch {
    _ => {
      let flags = Flags::new()
      flags.conversion_syntax = true
      (Decimal::nan(), flags)
    }
  }
}
