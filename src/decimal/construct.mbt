// Small constructors and sign helpers shared by arithmetic operations.

fn signed_infinity(negative : Bool) -> Decimal {
  { class: Infinity, negative, coefficient: 0N, exponent: 0 }
}

fn finite_zero(exponent : Int, negative : Bool) -> Decimal {
  { class: Finite, negative, coefficient: 0N, exponent }
}

fn xor_sign(a : Decimal, b : Decimal) -> Bool {
  a.negative != b.negative
}
