///| Re-import the decimal package's types into this per-op test package.
/// `pub using` keeps the embedded `.decTest` data referring to `Decimal`,
/// `Context`, and friends without the `@decimal.` prefix.
pub using @decimal {
  type Decimal,
  type Class,
  type ParseError,
  type Context,
  type Rounding,
  type Flags,
}

///| Re-export the dectest runner's entry points so the per-op test file can
/// call them without the `@dectest.` prefix.
pub using @dectest {
  type TestCase,
  parse_dectest,
  run_cases,
  run_cases_with_flags,
}
