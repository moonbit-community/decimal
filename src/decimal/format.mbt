///|
/// Convert a `Decimal` to its GDA canonical *to-scientific-string* form.
///
/// Algorithm follows §10.3 of the General Decimal Arithmetic specification:
///
/// * Infinities render as `Infinity` (with sign).
/// * NaNs render as `NaN[payload]` or `sNaN[payload]` (with sign).
/// * Finite numbers render in plain notation when `exponent <= 0` and the
///   adjusted exponent `exponent + (digit_count - 1)` is `>= -6`, otherwise
///   in scientific notation `d.dddE+nnn` / `d.dddE-nnn` with a mandatory sign
///   on the exponent.
pub fn Decimal::to_sci_string(self : Decimal) -> String {
  let sign = if self.negative { "-" } else { "" }
  match self.class {
    Infinity => sign + "Infinity"
    QNaN => sign + "NaN" + nan_payload_string(self.coefficient)
    SNaN => sign + "sNaN" + nan_payload_string(self.coefficient)
    Finite => sign + finite_to_sci(self.coefficient, self.exponent)
  }
}

///|
/// `coefficient.to_string()` for non-zero payloads, empty otherwise.
fn nan_payload_string(payload : BigInt) -> String {
  if payload.is_zero() {
    ""
  } else {
    payload.to_string()
  }
}

///|
/// Render the magnitude of a finite decimal (without leading sign).
fn finite_to_sci(coefficient : BigInt, exponent : Int) -> String {
  let coeff = coefficient.to_string()
  let n = coeff.length()
  let adjusted = exponent + n - 1
  if exponent <= 0 && adjusted >= -6 {
    plain_form(coeff, n, exponent)
  } else {
    sci_form(coeff, n, adjusted)
  }
}

///|
/// Plain notation: `exponent <= 0` and `adjusted >= -6`.
fn plain_form(coeff : String, n : Int, exponent : Int) -> String {
  let neg_exp = -exponent
  if exponent == 0 {
    coeff
  } else if neg_exp < n {
    // Decimal point falls inside the coefficient digits.
    let split = n - neg_exp
    coeff[:split].to_owned() + "." + coeff[split:].to_owned()
  } else {
    // Decimal point needs leading zeros: "0." + (neg_exp - n) zeros + coeff.
    "0." + "0".repeat(neg_exp - n) + coeff
  }
}

///|
/// Scientific notation: `d[.ddd]E±n`. Exponent always carries an explicit
/// sign per GDA.
fn sci_form(coeff : String, n : Int, adjusted : Int) -> String {
  let mantissa = if n == 1 {
    coeff
  } else {
    coeff[:1].to_owned() + "." + coeff[1:].to_owned()
  }
  let exp_sign = if adjusted >= 0 { "+" } else { "-" }
  mantissa + "E" + exp_sign + adjusted.abs().to_string()
}
