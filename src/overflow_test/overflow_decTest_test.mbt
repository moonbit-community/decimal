///| Overflow-relevant cases from `add.decTest` / `subtract.decTest` /
/// `multiply.decTest`, organised by source file so the context directives
/// (precision, rounding, maxExponent, minExponent) match how each file
/// scopes them. Validates that finalize's overflow gate produces
/// `Infinity` / `-Infinity` under the half-aware rounding modes, caps at
/// the largest representable finite under truncation modes, and that
/// just-under-the-limit results pass through unchanged.
///
/// Subnormal-tagged neighbours are NOT included here — they need
/// finalize's underflow / subnormal branch which depends on quantize.
let overflow_subset_add : String =
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

///| `subtract.decTest` overflow cluster (subx710–727). Exercises both the
/// Infinity branch (half_up) and the largest-finite branch (down) of
/// apply_overflow.
let overflow_subset_subtract : String =
  #|precision: 9
  #|maxexponent: 999999999
  #|minexponent: -999999999
  #|rounding: down
  #|subx710 subtract 1E+999999999    -9E+999999999   -> 9.99999999E+999999999 Overflow Inexact Rounded
  #|subx711 subtract 9E+999999999    -1E+999999999   -> 9.99999999E+999999999 Overflow Inexact Rounded
  #|rounding: half_up
  #|subx712 subtract 1E+999999999    -9E+999999999   -> Infinity Overflow Inexact Rounded
  #|subx713 subtract 9E+999999999    -1E+999999999   -> Infinity Overflow Inexact Rounded
  #|subx716 subtract -1E+999999999   +9E+999999999   -> -Infinity Overflow Inexact Rounded
  #|subx717 subtract -9E+999999999   +1E+999999999   -> -Infinity Overflow Inexact Rounded
  #|precision: 3
  #|subx720 subtract 1  9.999E+999999999   -> -Infinity Inexact Overflow Rounded
  #|subx721 subtract 1 -9.999E+999999999   ->  Infinity Inexact Overflow Rounded
  #|subx722 subtract    9.999E+999999999 1 ->  Infinity Inexact Overflow Rounded
  #|subx723 subtract   -9.999E+999999999 1 -> -Infinity Inexact Overflow Rounded

///| `multiply.decTest` overflow cluster (mulx730–752). Both half_up paths
/// to ±Infinity. mulx745+ exercises overflow from multiplying two
/// large-exponent operands.
let overflow_subset_multiply : String =
  #|precision: 9
  #|maxexponent: 999999999
  #|minexponent: -999999999
  #|rounding: half_up
  #|mulx730 multiply +1.23456789012345E-0 9E+999999999 -> Infinity Inexact Overflow Rounded
  #|mulx731 multiply 9E+999999999 +1.23456789012345E-0 -> Infinity Inexact Overflow Rounded
  #|mulx735 multiply -1.23456789012345E-0 9E+999999999 -> -Infinity Inexact Overflow Rounded
  #|mulx736 multiply 9E+999999999 -1.23456789012345E-0 -> -Infinity Inexact Overflow Rounded
  #|mulx745 multiply 1e599999999 1e400000001 -> Infinity Overflow Inexact Rounded
  #|mulx747 multiply 1e600000000 1e400000000 -> Infinity Overflow Inexact Rounded
  #|mulx748 multiply 9e999999998 100  -> Infinity Overflow Inexact Rounded
  #|mulx750 multiply 100  9e999999998 -> Infinity Overflow Inexact Rounded
  #|mulx751 multiply  1e+777777777  1e+411111111 ->  Infinity Overflow Inexact Rounded
  #|mulx752 multiply  1e+777777777 -1e+411111111 -> -Infinity Overflow Inexact Rounded

///| Shared body — parse, run, abort with diagnostics on failure.
fn run_overflow_subset(
  label : String,
  subset : String,
  expected : Int,
) -> Unit raise {
  let cases = parse_dectest(subset)
  assert_eq(cases.length(), expected)
  let (failures, _) = run_cases(cases)
  if failures.length() > 0 {
    println("\{label}: \{failures.length()} of \{cases.length()} cases failed:")
    let limit = if failures.length() < 20 { failures.length() } else { 20 }
    for i in 0..<limit {
      println("  \{failures[i]}")
    }
    if failures.length() > limit {
      println("  ... \{failures.length() - limit} more")
    }
    abort("\{label}.decTest failures")
  }
}

///|
test "overflow add subset routes finite overflow to ±Infinity under half_up" {
  run_overflow_subset("add", overflow_subset_add, 10)
}

///|
test "overflow subtract subset covers both half_up→Infinity and down→largest-finite" {
  run_overflow_subset("subtract", overflow_subset_subtract, 10)
}

///|
test "overflow multiply subset routes large×large to ±Infinity" {
  run_overflow_subset("multiply", overflow_subset_multiply, 10)
}
