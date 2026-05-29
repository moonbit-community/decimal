///| Re-import the decimal package's types into this per-op test package.
pub using @decimal {
  type Decimal,
  type Class,
  type ParseError,
  type Context,
  type Rounding,
  type Flags,
}

pub using @dectest { type TestCase, parse_dectest, run_cases, run_cases_with_flags }
