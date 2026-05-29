///| First 30 cases from `log10.decTest`.
let log10_subset : String =
  #|precision:   16
  #|rounding:    half_even
  #|maxExponent: 384
  #|minexponent: -383
  #|precision:   9
  #|logxs000 log10  0                 -> -Infinity
  #|logxs001 log10  0.001             -> -3
  #|logxs002 log10  1                 ->  0
  #|logxs003 log10  2                 ->  0.301029996         Inexact Rounded
  #|logxs004 log10  10                ->  1
  #|logxs005 log10  70                ->  1.84509804          Inexact Rounded
  #|logxs006 log10 +Infinity          ->  Infinity
  #|precision:   16
  #|logx0000 log10  0                 -> -Infinity
  #|logx0001 log10  7E-1000           -> -999.1549019599857   Inexact Rounded
  #|logx0002 log10  1.1E-9            -> -8.958607314841775   Inexact Rounded
  #|logx0003 log10  0.0007            -> -3.154901959985743   Inexact Rounded
  #|logx0004 log10  0.11              -> -0.9586073148417750  Inexact Rounded
  #|logx0005 log10  0.7               -> -0.1549019599857432  Inexact Rounded
  #|logx0006 log10  1                 ->  0
  #|logx0007 log10  1.5               ->  0.1760912590556812  Inexact Rounded
  #|logx0008 log10  2                 ->  0.3010299956639812  Inexact Rounded
  #|logx0009 log10  2.718281828459045 ->  0.4342944819032518  Inexact Rounded
  #|logx0010 log10  2.718281828459046 ->  0.4342944819032519  Inexact Rounded
  #|logx0011 log10  2.718281828459047 ->  0.4342944819032521  Inexact Rounded
  #|logx0012 log10  7                 ->  0.8450980400142568  Inexact Rounded
  #|logx0013 log10  10                ->  1
  #|logx0014 log10  10.5              ->  1.021189299069938   Inexact Rounded
  #|logx0015 log10  11                ->  1.041392685158225   Inexact Rounded
  #|logx0016 log10  70                ->  1.845098040014257   Inexact Rounded
  #|logx0017 log10  9999              ->  3.999956568380192   Inexact Rounded
  #|logx0018 log10  1.21E6            ->  6.082785370316450   Inexact Rounded
  #|logx0019 log10  1.1E+9            ->  9.041392685158225   Inexact Rounded
  #|logx0020 log10  7E+1000           ->  1000.845098040014   Inexact Rounded
  #|logx0021 log10 +Infinity          ->  Infinity
  #|logx0031 log10 -1E-9              -> NaN Invalid_operation

///|
test "log10.decTest subset" {
  let cases = parse_dectest(log10_subset)
  assert_eq(cases.length(), 30)
  let (failures, _) = run_cases_with_flags(cases)
  if failures.length() > 0 {
    println("\{failures.length()} of \{cases.length()} cases failed:")
    let limit = if failures.length() < 30 { failures.length() } else { 30 }
    for i in 0..<limit {
      println("  \{failures[i]}")
    }
    if failures.length() > limit {
      println("  ... \{failures.length() - limit} more")
    }
    abort("log10.decTest failures")
  }
}
