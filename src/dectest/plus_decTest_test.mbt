///| `plus` cases from `plus.decTest`, filtered to those that need
/// neither rounding nor a GDA `#` null operand. `Invalid_operation`
/// raised for sNaN inputs is dropped until a `Context` is wired up.
let plus_subset : String =
  #|plux001 plus '1'      -> '1'
  #|plux002 plus '-1'     -> '-1'
  #|plux003 plus '1.00'   -> '1.00'
  #|plux004 plus '-1.00'  -> '-1.00'
  #|plux005 plus '0'      -> '0'
  #|plux006 plus '0.00'   -> '0.00'
  #|plux007 plus '00.0'   -> '0.0'
  #|plux008 plus '00.00'  -> '0.00'
  #|plux009 plus '00'     -> '0'
  #|plux010 plus '-2'     -> '-2'
  #|plux011 plus '2'      -> '2'
  #|plux012 plus '-2.00'  -> '-2.00'
  #|plux013 plus '2.00'   -> '2.00'
  #|plux014 plus '-0'     -> '0'
  #|plux015 plus '-0.00'  -> '0.00'
  #|plux016 plus '-00.0'  -> '0.0'
  #|plux017 plus '-00.00' -> '0.00'
  #|plux018 plus '-00'    -> '0'
  #|plux020 plus '-2000000' -> '-2000000'
  #|plux021 plus '2000000'  -> '2000000'
  #|plux022 plus '-2000000' -> '-2000000'
  #|plux023 plus '2000000'  -> '2000000'
  #|plux060 plus '56267E-10'   -> '0.0000056267'
  #|plux061 plus '56267E-5'    -> '0.56267'
  #|plux062 plus '56267E-2'    -> '562.67'
  #|plux063 plus '56267E-1'    -> '5626.7'
  #|plux065 plus '56267E-0'    -> '56267'
  #|plux066 plus '56267E+0'    -> '56267'
  #|plux067 plus '56267E+1'    -> '5.6267E+5'
  #|plux068 plus '56267E+2'    -> '5.6267E+6'
  #|plux069 plus '56267E+3'    -> '5.6267E+7'
  #|plux070 plus '56267E+4'    -> '5.6267E+8'
  #|plux071 plus '56267E+5'    -> '5.6267E+9'
  #|plux072 plus '56267E+6'    -> '5.6267E+10'
  #|plux080 plus '-56267E-10'  -> '-0.0000056267'
  #|plux081 plus '-56267E-5'   -> '-0.56267'
  #|plux082 plus '-56267E-2'   -> '-562.67'
  #|plux083 plus '-56267E-1'   -> '-5626.7'
  #|plux085 plus '-56267E-0'   -> '-56267'
  #|plux086 plus '-56267E+0'   -> '-56267'
  #|plux087 plus '-56267E+1'   -> '-5.6267E+5'
  #|plux088 plus '-56267E+2'   -> '-5.6267E+6'
  #|plux089 plus '-56267E+3'   -> '-5.6267E+7'
  #|plux090 plus '-56267E+4'   -> '-5.6267E+8'
  #|plux091 plus '-56267E+5'   -> '-5.6267E+9'
  #|plux092 plus '-56267E+6'   -> '-5.6267E+10'
  #|plux120 plus '-0E3'   -> '0E+3'
  #|plux121 plus '-0E2'   -> '0E+2'
  #|plux122 plus '-0E1'   -> '0E+1'
  #|plux123 plus '-0E0'   -> '0'
  #|plux124 plus '+0E0'   -> '0'
  #|plux125 plus '+0E1'   -> '0E+1'
  #|plux126 plus '+0E2'   -> '0E+2'
  #|plux127 plus '+0E3'   -> '0E+3'
  #|plux130 plus '-5E3'   -> '-5E+3'
  #|plux131 plus '-5E8'   -> '-5E+8'
  #|plux132 plus '-5E13'  -> '-5E+13'
  #|plux133 plus '-5E18'  -> '-5E+18'
  #|plux134 plus '+5E3'   -> '5E+3'
  #|plux135 plus '+5E8'   -> '5E+8'
  #|plux136 plus '+5E13'  -> '5E+13'
  #|plux137 plus '+5E18'  -> '5E+18'
  #|plux150 plus 'Inf'    -> 'Infinity'
  #|plux151 plus '-Inf'   -> '-Infinity'
  #|plux152 plus   NaN    ->  NaN
  #|plux153 plus  sNaN    ->  NaN   Invalid_operation
  #|plux154 plus   NaN77  ->  NaN77
  #|plux155 plus  sNaN88  ->  NaN88 Invalid_operation
  #|plux156 plus  -NaN    -> -NaN
  #|plux157 plus -sNaN    -> -NaN   Invalid_operation
  #|plux158 plus  -NaN77  -> -NaN77
  #|plux159 plus -sNaN88  -> -NaN88 Invalid_operation
  #|plux210 plus  1.00E-999        ->   1.00E-999
  #|plux230 plus -1.00E-999        ->  -1.00E-999
  #|plux252 plus 0E-398     -> 0E-398
  #|plux321 plus 12345678000  -> 12345678000
  #|plux322 plus 1234567800   -> 1234567800
  #|plux323 plus 1234567890   -> 1234567890
  #|plux324 plus 1234567891   -> 1234567891
  #|plux325 plus 12345678901  -> 12345678901
  #|plux326 plus 1234567896   -> 1234567896

///|
test "plus.decTest plusx subset round-trips through parse + plus + toSci" {
  let cases = parse_dectest(plus_subset)
  assert_eq(cases.length(), 81)
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
