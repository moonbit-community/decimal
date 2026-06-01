// Numeric Eq / Compare / Hash and engineering-string rendering.

///|
test "numeric equality across cohorts, signs, and specials" {
  // Same value, different cohorts — equal.
  assert_true(Decimal::parse("1.0") == Decimal::parse("1.00"))
  assert_true(Decimal::parse("1") == Decimal::parse("1.000"))
  assert_true(Decimal::parse("1.5E+3") == Decimal::parse("1500"))
  // Signed zeros — equal.
  assert_true(Decimal::parse("-0") == Decimal::parse("0"))
  assert_true(Decimal::parse("0E+3") == Decimal::parse("0"))
  // NaN reflexive (so Eq is lawful with Hash); distinct values unequal.
  assert_true(Decimal::parse("NaN") == Decimal::parse("NaN"))
  assert_false(Decimal::parse("1") == Decimal::parse("2"))
  assert_true(Decimal::parse("Infinity") == Decimal::parse("Infinity"))
  assert_false(Decimal::parse("Infinity") == Decimal::parse("-Infinity"))
}

///|
test "total order: sort puts NaN lowest, then by numeric value" {
  let xs = [
    Decimal::parse("2"),
    Decimal::parse("NaN"),
    Decimal::parse("0.5"),
    Decimal::parse("1.0"),
    Decimal::parse("-3"),
    Decimal::parse("-Infinity"),
  ]
  xs.sort()
  let rendered = xs
    .map(d => d.to_sci_string())
    .fold(init="", (acc, x) => if acc == "" { x } else { acc + "," + x })
  inspect(rendered, content="NaN,-Infinity,-3,0.5,1.0,2")
}

///|
test "hash agrees with numeric equality (usable as a map key)" {
  let m : Map[Decimal, Int] = {}
  m[Decimal::parse("1.0")] = 42
  // Different cohort of the same value finds the entry.
  assert_true(m.get(Decimal::parse("1.00")) is Some(42))
  assert_true(m.get(Decimal::parse("1")) is Some(42))
  // Signed-zero cohorts collapse to one key.
  m[Decimal::parse("-0")] = 7
  assert_true(m.get(Decimal::parse("0E+5")) is Some(7))
  assert_true(m.get(Decimal::parse("2")) is None)
}

///|
test "to_eng_string: exponent snaps to a multiple of three" {
  inspect(Decimal::parse("7E-7").to_eng_string(), content="700E-9")
  inspect(Decimal::parse("123E+1").to_eng_string(), content="1.23E+3")
  inspect(Decimal::parse("1.5E+10").to_eng_string(), content="15E+9")
  inspect(Decimal::parse("0.0000001").to_eng_string(), content="100E-9")
  // No exponent needed — same as to_sci_string.
  inspect(Decimal::parse("1.234").to_eng_string(), content="1.234")
  inspect(Decimal::parse("-7E-7").to_eng_string(), content="-700E-9")
  inspect(Decimal::parse("Infinity").to_eng_string(), content="Infinity")
  inspect(Decimal::parse("NaN").to_eng_string(), content="NaN")
}
