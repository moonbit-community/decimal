///| `abs` cases from `abs.decTest`, filtered to those that need
/// neither rounding nor a GDA `#` null operand. `Invalid_operation`
/// raised for sNaN inputs is dropped until a `Context` is wired up.
let abs_subset : String =
  #|absx001 abs '1'      -> '1'
  #|absx002 abs '-1'     -> '1'
  #|absx003 abs '1.00'   -> '1.00'
  #|absx004 abs '-1.00'  -> '1.00'
  #|absx005 abs '0'      -> '0'
  #|absx006 abs '0.00'   -> '0.00'
  #|absx007 abs '00.0'   -> '0.0'
  #|absx008 abs '00.00'  -> '0.00'
  #|absx009 abs '00'     -> '0'
  #|absx010 abs '-2'     -> '2'
  #|absx011 abs '2'      -> '2'
  #|absx012 abs '-2.00'  -> '2.00'
  #|absx013 abs '2.00'   -> '2.00'
  #|absx014 abs '-0'     -> '0'
  #|absx015 abs '-0.00'  -> '0.00'
  #|absx016 abs '-00.0'  -> '0.0'
  #|absx017 abs '-00.00' -> '0.00'
  #|absx018 abs '-00'    -> '0'
  #|absx020 abs '-2000000' -> '2000000'
  #|absx021 abs '2000000'  -> '2000000'
  #|absx022 abs '-2000000' -> '2000000'
  #|absx023 abs '2000000'  -> '2000000'
  #|absx030 abs '+0.1'            -> '0.1'
  #|absx031 abs '-0.1'            -> '0.1'
  #|absx032 abs '+0.01'           -> '0.01'
  #|absx033 abs '-0.01'           -> '0.01'
  #|absx034 abs '+0.001'          -> '0.001'
  #|absx035 abs '-0.001'          -> '0.001'
  #|absx036 abs '+0.000001'       -> '0.000001'
  #|absx037 abs '-0.000001'       -> '0.000001'
  #|absx038 abs '+0.000000000001' -> '1E-12'
  #|absx039 abs '-0.000000000001' -> '1E-12'
  #|absx040 abs '2.1'     ->  '2.1'
  #|absx041 abs '-100'    ->  '100'
  #|absx042 abs '101.5'   ->  '101.5'
  #|absx043 abs '-101.5'  ->  '101.5'
  #|absx060 abs '-56267E-10'  -> '0.0000056267'
  #|absx061 abs '-56267E-5'   -> '0.56267'
  #|absx062 abs '-56267E-2'   -> '562.67'
  #|absx063 abs '-56267E-1'   -> '5626.7'
  #|absx065 abs '-56267E-0'   -> '56267'
  #|absx210 abs  1.00E-999        ->   1.00E-999
  #|absx230 abs -1.00E-999        ->   1.00E-999
  #|absx321 abs 12345678000  -> 12345678000
  #|absx322 abs 1234567800   -> 1234567800
  #|absx323 abs 1234567890   -> 1234567890
  #|absx324 abs 1234567891   -> 1234567891
  #|absx325 abs 12345678901  -> 12345678901
  #|absx326 abs 1234567896   -> 1234567896
  #|absx520 abs 'Inf'    -> 'Infinity'
  #|absx521 abs '-Inf'   -> 'Infinity'
  #|absx522 abs   NaN    ->  NaN
  #|absx523 abs  sNaN    ->  NaN   Invalid_operation
  #|absx524 abs   NaN22  ->  NaN22
  #|absx525 abs  sNaN33  ->  NaN33 Invalid_operation
  #|absx526 abs  -NaN22  -> -NaN22
  #|absx527 abs -sNaN33  -> -NaN33 Invalid_operation

///|
test "abs.decTest absx subset round-trips through parse + abs + toSci" {
  let cases = parse_dectest(abs_subset)
  assert_eq(cases.length(), 57)
  let (failures, _) = run_cases_with_flags(cases)
  if failures.length() > 0 {
    let buf = StringBuilder::new()
    buf.write_string("\{failures.length()} of \{cases.length()} cases failed:\n")
    for f in failures {
      buf.write_string("  ")
      buf.write_string(f)
      buf.write_char('\n')
    }
    abort(buf.to_string())
  }
}
