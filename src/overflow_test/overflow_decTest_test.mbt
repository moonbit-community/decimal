///| Overflow-relevant cases from `add.decTest` (the addx890-907 range plus a
/// few near-overflow neighbours). Validates that finalize's overflow gate
/// produces `Infinity` / `-Infinity` under the half-aware rounding modes
/// and that just-under-the-limit results pass through unchanged.
///
/// Subnormal-tagged neighbours (addx892–895, 898–901, 915–) are NOT
/// included here — they need the underflow / subnormal branch of finalize
/// which depends on quantize and will land in a dedicated subnormal_test
/// package later.
let overflow_subset : String =
  #|precision: 9
  #|rounding: half_up
  #|maxexponent: 999999999
  #|minexponent: -999999999
  #|addx890 add 1E+999999999     9E+999999999   -> Infinity Overflow Inexact Rounded
  #|addx891 add 9E+999999999     1E+999999999   -> Infinity Overflow Inexact Rounded
  #|addx896 add -1E+999999999   -9E+999999999   -> -Infinity Overflow Inexact Rounded
  #|addx897 add -9E+999999999   -1E+999999999   -> -Infinity Overflow Inexact Rounded
  #|addx902 add -1E+999999999   +9E+999999999   ->  8E+999999999
  #|addx903 add -9E+999999999   +1E+999999999   -> -8E+999999999
  #|precision: 3
  #|addx904 add      0 -9.999E+999999999   -> -Infinity Inexact Overflow Rounded
  #|addx905 add        -9.999E+999999999 0 -> -Infinity Inexact Overflow Rounded
  #|addx906 add      0  9.999E+999999999   ->  Infinity Inexact Overflow Rounded
  #|addx907 add         9.999E+999999999 0 ->  Infinity Inexact Overflow Rounded

///|
test "overflow.decTest subset routes finite overflow to ±Infinity under half_up" {
  let cases = parse_dectest(overflow_subset)
  assert_eq(cases.length(), 10)
  let (failures, _) = run_cases(cases)
  if failures.length() > 0 {
    println("\{failures.length()} of \{cases.length()} cases failed:")
    let limit = if failures.length() < 20 { failures.length() } else { 20 }
    for i in 0..<limit {
      println("  \{failures[i]}")
    }
    if failures.length() > limit {
      println("  ... \{failures.length() - limit} more")
    }
    abort("overflow.decTest failures")
  }
}
