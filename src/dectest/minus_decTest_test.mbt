///|
/// `minus` cases from `minus.decTest`, filtered to those that do not need
/// rounding and that have a concrete operand (GDA's `#` "null operand" tests
/// don't fit our `Decimal::minus` signature). The `Invalid_operation` flag
/// that GDA prescribes for sNaN inputs is silently dropped — the runner
/// compares the result string only until a `Context` carrying flags lands.
let minus_subset : String =
  #|minx001 minus '1'      -> '-1'
  #|minx002 minus '-1'     -> '1'
  #|minx003 minus '1.00'   -> '-1.00'
  #|minx004 minus '-1.00'  -> '1.00'
  #|minx005 minus '0'      -> '0'
  #|minx006 minus '0.00'   -> '0.00'
  #|minx007 minus '00.0'   -> '0.0'
  #|minx008 minus '00.00'  -> '0.00'
  #|minx009 minus '00'     -> '0'
  #|minx010 minus '-2'     -> '2'
  #|minx011 minus '2'      -> '-2'
  #|minx012 minus '-2.00'  -> '2.00'
  #|minx013 minus '2.00'   -> '-2.00'
  #|minx014 minus '-0'     -> '0'
  #|minx015 minus '-0.00'  -> '0.00'
  #|minx016 minus '-00.0'  -> '0.0'
  #|minx017 minus '-00.00' -> '0.00'
  #|minx018 minus '-00'    -> '0'
  #|minx020 minus '-0E3'   -> '0E+3'
  #|minx021 minus '-0E2'   -> '0E+2'
  #|minx022 minus '-0E1'   -> '0E+1'
  #|minx023 minus '-0E0'   -> '0'
  #|minx024 minus '+0E0'   -> '0'
  #|minx025 minus '+0E1'   -> '0E+1'
  #|minx026 minus '+0E2'   -> '0E+2'
  #|minx027 minus '+0E3'   -> '0E+3'
  #|minx030 minus '-5E3'   -> '5E+3'
  #|minx031 minus '-5E8'   -> '5E+8'
  #|minx032 minus '-5E13'  -> '5E+13'
  #|minx033 minus '-5E18'  -> '5E+18'
  #|minx034 minus '+5E3'   -> '-5E+3'
  #|minx035 minus '+5E8'   -> '-5E+8'
  #|minx036 minus '+5E13'  -> '-5E+13'
  #|minx037 minus '+5E18'  -> '-5E+18'
  #|minx050 minus '-2000000' -> '2000000'
  #|minx051 minus '2000000'  -> '-2000000'
  #|minx052 minus '-2000000' -> '2000000'
  #|minx053 minus '2000000'  -> '-2000000'
  #|minx060 minus '56267E-10'   -> '-0.0000056267'
  #|minx061 minus '56267E-5'    -> '-0.56267'
  #|minx062 minus '56267E-2'    -> '-562.67'
  #|minx063 minus '56267E-1'    -> '-5626.7'
  #|minx065 minus '56267E-0'    -> '-56267'
  #|minx066 minus '56267E+0'    -> '-56267'
  #|minx067 minus '56267E+1'    -> '-5.6267E+5'
  #|minx068 minus '56267E+2'    -> '-5.6267E+6'
  #|minx069 minus '56267E+3'    -> '-5.6267E+7'
  #|minx070 minus '56267E+4'    -> '-5.6267E+8'
  #|minx071 minus '56267E+5'    -> '-5.6267E+9'
  #|minx072 minus '56267E+6'    -> '-5.6267E+10'
  #|minx080 minus '-56267E-10'  -> '0.0000056267'
  #|minx081 minus '-56267E-5'   -> '0.56267'
  #|minx082 minus '-56267E-2'   -> '562.67'
  #|minx083 minus '-56267E-1'   -> '5626.7'
  #|minx085 minus '-56267E-0'   -> '56267'
  #|minx086 minus '-56267E+0'   -> '56267'
  #|minx087 minus '-56267E+1'   -> '5.6267E+5'
  #|minx088 minus '-56267E+2'   -> '5.6267E+6'
  #|minx089 minus '-56267E+3'   -> '5.6267E+7'
  #|minx090 minus '-56267E+4'   -> '5.6267E+8'
  #|minx091 minus '-56267E+5'   -> '5.6267E+9'
  #|minx092 minus '-56267E+6'   -> '5.6267E+10'
  #|minx110 minus  1.00E-999        ->  -1.00E-999
  #|minx130 minus -1.00E-999        ->   1.00E-999
  #|minx321 minus 12345678000  -> -12345678000
  #|minx322 minus 1234567800   -> -1234567800
  #|minx323 minus 1234567890   -> -1234567890
  #|minx324 minus 1234567891   -> -1234567891
  #|minx325 minus 12345678901  -> -12345678901
  #|minx326 minus 1234567896   -> -1234567896
  #|minx420 minus 'Inf'    -> '-Infinity'
  #|minx421 minus '-Inf'   -> 'Infinity'
  #|minx422 minus   NaN    ->  NaN
  #|minx423 minus  sNaN    ->  NaN    Invalid_operation
  #|minx424 minus   NaN255 ->  NaN255
  #|minx425 minus  sNaN256 ->  NaN256 Invalid_operation
  #|minx426 minus  -NaN    -> -NaN
  #|minx427 minus -sNaN    -> -NaN    Invalid_operation
  #|minx428 minus  -NaN255 -> -NaN255
  #|minx429 minus -sNaN256 -> -NaN256 Invalid_operation

///|
test "minus.decTest minx subset round-trips through parse + minus + toSci" {
  let cases = parse_dectest(minus_subset)
  assert_eq(cases.length(), 80)
  let (failures, _) = run_cases_with_flags(cases)
  if failures.length() > 0 {
    let buf = StringBuilder::new()
    buf.write_string(
      "\{failures.length()} of \{cases.length()} cases failed:\n",
    )
    for f in failures {
      buf.write_string("  ")
      buf.write_string(f)
      buf.write_char('\n')
    }
    abort(buf.to_string())
  }
}
