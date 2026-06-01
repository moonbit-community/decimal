// Malformed-operand cases: a non-numeric operand to any operation yields a
// quiet NaN with Conversion_syntax, per GDA `to-number`. These exercise the
// harness's operand-parse → conversion_syntax routing (the cases the op
// corpora omit because they need exactly this path).
///|
let conversion_syntax_cases : String =
  #|precision: 9
  #|rounding: half_even
  #|csyn001 add        1.2.3     1      ->  NaN  Conversion_syntax
  #|csyn002 add        1         hello  ->  NaN  Conversion_syntax
  #|csyn003 subtract   ++5       1      ->  NaN  Conversion_syntax
  #|csyn004 multiply   1         1e     ->  NaN  Conversion_syntax
  #|csyn005 divide     0x10      2      ->  NaN  Conversion_syntax
  #|csyn006 compare    1         1..2   ->  NaN  Conversion_syntax
  #|csyn007 squareroot 1.2.3            ->  NaN  Conversion_syntax
  #|csyn008 fma        1         2.3.4  3  ->  NaN  Conversion_syntax

///|
test "malformed operands route to NaN + Conversion_syntax" {
  let cases = parse_dectest(conversion_syntax_cases)
  let (failures, skipped) = run_cases_with_flags(cases)
  assert_eq(skipped, 0)
  if failures.length() > 0 {
    let buf = StringBuilder::new()
    for f in failures {
      buf.write_string(f)
      buf.write_char('\n')
    }
    abort(buf.to_string())
  }
}
