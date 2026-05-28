///| First 40 cases from `ln.decTest`.
let ln_subset : String =
  #|precision:   16
  #|rounding:    half_even
  #|maxExponent: 384
  #|minexponent: -383
  #|precision: 9
  #|lnxs001 ln  0                 -> -Infinity
  #|lnxs002 ln  1.000             ->   0
  #|lnxs003 ln  2.71828183        ->   1.00000000         Inexact Rounded
  #|lnxs004 ln  10                ->   2.30258509         Inexact Rounded
  #|lnxs005 ln +Infinity          ->  Infinity
  #|precision:   16
  #|lnx0001 ln  0                 -> -Infinity
  #|lnx0002 ln  1E-9              -> -20.72326583694641   Inexact Rounded
  #|lnx0003 ln  0.0007            ->  -7.264430222920869  Inexact Rounded
  #|lnx0004 ln  0.1               ->  -2.302585092994046  Inexact Rounded
  #|lnx0005 ln  0.7               ->  -0.3566749439387324 Inexact Rounded
  #|lnx0006 ln  1                 ->   0
  #|lnx0007 ln  1.000             ->   0
  #|lnx0008 ln  1.5               ->   0.4054651081081644 Inexact Rounded
  #|lnx0009 ln  2                 ->   0.6931471805599453 Inexact Rounded
  #|lnx0010 ln  2.718281828459045 ->   0.9999999999999999 Inexact Rounded
  #|lnx0011 ln  2.718281828459046 ->   1.000000000000000  Inexact Rounded
  #|lnx0012 ln  2.718281828459047 ->   1.000000000000001  Inexact Rounded
  #|lnx0013 ln  10                ->   2.302585092994046  Inexact Rounded
  #|lnx0014 ln  10.5              ->   2.351375257163478  Inexact Rounded
  #|lnx0015 ln  9999              ->   9.210240366975849  Inexact Rounded
  #|lnx0016 ln  1E6               ->  13.81551055796427   Inexact Rounded
  #|lnx0017 ln  1E+9              ->  20.72326583694641   Inexact Rounded
  #|lnx0018 ln +Infinity          ->  Infinity
  #|lnx0021 ln -1E-9              -> NaN Invalid_operation
  #|lnx0022 ln -0.0007            -> NaN Invalid_operation
  #|lnx0023 ln -0.1               -> NaN Invalid_operation
  #|lnx0024 ln -0.7               -> NaN Invalid_operation
  #|lnx0025 ln -1                 -> NaN Invalid_operation
  #|lnx0026 ln -1.5               -> NaN Invalid_operation
  #|lnx0027 ln -2                 -> NaN Invalid_operation
  #|lnx0029 ln -10.5              -> NaN Invalid_operation
  #|lnx0028 ln -9999              -> NaN Invalid_operation
  #|lnx0030 ln -2.718281828459045 -> NaN Invalid_operation
  #|lnx0031 ln -2.718281828459046 -> NaN Invalid_operation
  #|lnx0032 ln -0                 -> -Infinity
  #|lnx0033 ln -0E+17             -> -Infinity
  #|lnx0034 ln -0E-17             -> -Infinity
  #|lnx0041 ln  0                 -> -Infinity
  #|lnx0042 ln  0E+17             -> -Infinity
  #|lnx0043 ln  0E-17             -> -Infinity

///|
test "ln.decTest subset" {
  let cases = parse_dectest(ln_subset)
  assert_eq(cases.length(), 40)
  let (failures, _) = run_cases(cases)
  if failures.length() > 0 {
    println("\{failures.length()} of \{cases.length()} cases failed:")
    let limit = if failures.length() < 30 { failures.length() } else { 30 }
    for i in 0..<limit {
      println("  \{failures[i]}")
    }
    if failures.length() > limit {
      println("  ... \{failures.length() - limit} more")
    }
    abort("ln.decTest failures")
  }
}
