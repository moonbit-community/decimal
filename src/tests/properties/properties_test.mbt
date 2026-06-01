// Law-based property tests over a representative sample of values.

///|
/// A spread of decimals: integers, fractions, cohorts, signed zeros, large /
/// small exponents, and every special.
fn sample() -> Array[Decimal] raise {
  [
    "0", "-0", "1", "-1", "1.0", "1.00", "1.5", "-2.50", "123", "0.001", "1E+4",
    "1.234E+9", "-9.99E-7", "9999999999999999", "Infinity", "-Infinity", "NaN", "NaN42",
    "sNaN",
  ].map(Decimal::parse)
}

///|
test "json round-trips through the GDA string" {
  for d in sample() {
    let back : Decimal = @json.from_json(d.to_json())
    assert_true(back == d)
  }
}

///|
test "to_json is the scientific string, quoted" {
  assert_true(Decimal::parse("1.50").to_json() == "1.50".to_json())
  assert_true(Decimal::parse("-0").to_json() == "-0".to_json())
  assert_true(Decimal::parse("Infinity").to_json() == "Infinity".to_json())
}

///|
test "from_json rejects non-strings and bad literals" {
  assert_true((try? (@json.from_json(1.5.to_json()) : Decimal)) is Err(_))
  assert_true(
    (try? (@json.from_json("not a number".to_json()) : Decimal)) is Err(_),
  )
}

///|
/// parse → render → parse → render is stable (cohort and sign preserved).
test "parse/to_sci_string round-trip is idempotent" {
  for d in sample() {
    let s = d.to_sci_string()
    assert_eq(Decimal::parse(s).to_sci_string(), s)
  }
}

///|
fn mk_flags(inexact~ : Bool, overflow~ : Bool, clamped~ : Bool) -> Flags {
  let f = Flags::new()
  f.inexact = inexact
  f.overflow = overflow
  f.clamped = clamped
  f
}

///|
test "Flags::combine is a monoid (identity + associativity)" {
  let samples = [
    Flags::new(),
    mk_flags(inexact=true, overflow=false, clamped=false),
    mk_flags(inexact=false, overflow=true, clamped=true),
    mk_flags(inexact=true, overflow=true, clamped=false),
  ]
  let id = Flags::new()
  for a in samples {
    // Identity: a · e == a == e · a.
    assert_true(a.combine(id) == a)
    assert_true(id.combine(a) == a)
    // Idempotence (union of a set with itself).
    assert_true(a.combine(a) == a)
    for b in samples {
      // Commutativity (set union).
      assert_true(a.combine(b) == b.combine(a))
      for c in samples {
        // Associativity.
        assert_true(a.combine(b).combine(c) == a.combine(b.combine(c)))
      }
    }
  }
}

///|
test "Compare is a total order consistent with Eq" {
  let xs = sample()
  for a in xs {
    // Reflexive.
    assert_true(a == a)
    assert_false(a < a)
    for b in xs {
      // Eq agrees with the order: equal iff neither is below the other.
      assert_eq(a == b, !(a < b) && !(b < a))
      // Antisymmetry / duality of < and >.
      assert_eq(a < b, b > a)
      // Exactly one of <, ==, > holds (trichotomy).
      let lt = a < b
      let gt = a > b
      let eq = a == b
      assert_true(lt || gt || eq)
      assert_false(lt && gt)
      assert_false(lt && eq)
      assert_false(gt && eq)
    }
  }
}

///|
test "Compare orders NaN below everything and numeric values by value" {
  let nan = Decimal::parse("NaN")
  let neg_inf = Decimal::parse("-Infinity")
  let half = Decimal::parse("0.5")
  let two = Decimal::parse("2")
  assert_true(nan < neg_inf)
  assert_true(neg_inf < half)
  assert_true(half < two)
  // Cohorts compare equal (numeric, not structural).
  assert_true(Decimal::parse("1.0") == Decimal::parse("1.00"))
  assert_false(Decimal::parse("1.0") < Decimal::parse("1.00"))
}
