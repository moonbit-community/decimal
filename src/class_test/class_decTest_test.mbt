///|
/// First 80 cases from `class.decTest`. The op returns a category label
/// string (+Normal / +Subnormal / +Zero / -Zero / -Subnormal / -Normal /
/// +Infinity / -Infinity / NaN / sNaN) rather than a Decimal value.
let class_subset : String =
  #|precision:   9
  #|maxExponent: 999
  #|minExponent: -999
  #|extended:    1
  #|clamp:       1
  #|rounding:    half_even
  #|clasx001  class    0                        -> +Zero
  #|clasx002  class    0.00                     -> +Zero
  #|clasx003  class    0E+5                     -> +Zero
  #|clasx004  class    1E-1007                  -> +Subnormal
  #|clasx005  class  0.1E-999                   -> +Subnormal
  #|clasx006  class  0.99999999E-999            -> +Subnormal
  #|clasx007  class  1.00000000E-999            -> +Normal
  #|clasx008  class   1E-999                    -> +Normal
  #|clasx009  class   1E-100                    -> +Normal
  #|clasx010  class   1E-10                     -> +Normal
  #|clasx012  class   1E-1                      -> +Normal
  #|clasx013  class   1                         -> +Normal
  #|clasx014  class   2.50                      -> +Normal
  #|clasx015  class   100.100                   -> +Normal
  #|clasx016  class   1E+30                     -> +Normal
  #|clasx017  class   1E+999                    -> +Normal
  #|clasx018  class   9.99999999E+999           -> +Normal
  #|clasx019  class   Inf                       -> +Infinity
  #|clasx021  class   -0                        -> -Zero
  #|clasx022  class   -0.00                     -> -Zero
  #|clasx023  class   -0E+5                     -> -Zero
  #|clasx024  class   -1E-1007                  -> -Subnormal
  #|clasx025  class  -0.1E-999                  -> -Subnormal
  #|clasx026  class  -0.99999999E-999           -> -Subnormal
  #|clasx027  class  -1.00000000E-999           -> -Normal
  #|clasx028  class  -1E-999                    -> -Normal
  #|clasx029  class  -1E-100                    -> -Normal
  #|clasx030  class  -1E-10                     -> -Normal
  #|clasx032  class  -1E-1                      -> -Normal
  #|clasx033  class  -1                         -> -Normal
  #|clasx034  class  -2.50                      -> -Normal
  #|clasx035  class  -100.100                   -> -Normal
  #|clasx036  class  -1E+30                     -> -Normal
  #|clasx037  class  -1E+999                    -> -Normal
  #|clasx038  class  -9.99999999E+999           -> -Normal
  #|clasx039  class  -Inf                       -> -Infinity
  #|clasx041  class   NaN                       -> NaN
  #|clasx042  class  -NaN                       -> NaN
  #|clasx043  class  +NaN12345                  -> NaN
  #|clasx044  class   sNaN                      -> sNaN
  #|clasx045  class  -sNaN                      -> sNaN
  #|clasx046  class  +sNaN12345                 -> sNaN
  #|precision:   16
  #|maxExponent: 384
  #|minExponent: -383
  #|clamp:       1
  #|rounding:    half_even
  #|clasx201  class    0                        -> +Zero
  #|clasx202  class    0.00                     -> +Zero
  #|clasx203  class    0E+5                     -> +Zero
  #|clasx204  class    1E-396                   -> +Subnormal
  #|clasx205  class  0.1E-383                   -> +Subnormal
  #|clasx206  class  0.999999999999999E-383     -> +Subnormal
  #|clasx207  class  1.000000000000000E-383     -> +Normal
  #|clasx208  class   1E-383                    -> +Normal
  #|clasx209  class   1E-100                    -> +Normal
  #|clasx210  class   1E-10                     -> +Normal
  #|clasx212  class   1E-1                      -> +Normal
  #|clasx213  class   1                         -> +Normal
  #|clasx214  class   2.50                      -> +Normal
  #|clasx215  class   100.100                   -> +Normal
  #|clasx216  class   1E+30                     -> +Normal
  #|clasx217  class   1E+384                    -> +Normal
  #|clasx218  class   9.999999999999999E+384    -> +Normal
  #|clasx219  class   Inf                       -> +Infinity
  #|clasx221  class   -0                        -> -Zero
  #|clasx222  class   -0.00                     -> -Zero
  #|clasx223  class   -0E+5                     -> -Zero
  #|clasx224  class   -1E-396                   -> -Subnormal
  #|clasx225  class  -0.1E-383                  -> -Subnormal
  #|clasx226  class  -0.999999999999999E-383    -> -Subnormal
  #|clasx227  class  -1.000000000000000E-383    -> -Normal
  #|clasx228  class  -1E-383                    -> -Normal
  #|clasx229  class  -1E-100                    -> -Normal
  #|clasx230  class  -1E-10                     -> -Normal
  #|clasx232  class  -1E-1                      -> -Normal
  #|clasx233  class  -1                         -> -Normal
  #|clasx234  class  -2.50                      -> -Normal
  #|clasx235  class  -100.100                   -> -Normal
  #|clasx236  class  -1E+30                     -> -Normal
  #|clasx237  class  -1E+384                    -> -Normal
  #|clasx238  class  -9.999999999999999E+384    -> -Normal
  #|clasx239  class  -Inf                       -> -Infinity
  #|clasx241  class   NaN                       -> NaN
  #|clasx242  class  -NaN                       -> NaN

///|
test "class.decTest subset" {
  let cases = parse_dectest(class_subset)
  assert_eq(cases.length(), 80)
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
    abort("class.decTest failures")
  }
}

///|
test "is_normal gates on the lower exponent bound only" {
  let ctx = @decimal.Context::new(precision=9, e_max=9, e_min=-9)
  let big = @decimal.Decimal::parse("1E+20") catch {
    _ => @decimal.Decimal::zero()
  }
  let tiny = @decimal.Decimal::parse("1E-20") catch {
    _ => @decimal.Decimal::zero()
  }
  // adjusted exponent 20 exceeds e_max, but a finite non-zero value there is
  // still Normal — is_normal imposes no upper bound (only adj >= e_min).
  assert_true(big.is_normal(ctx))
  // below e_min the value is subnormal, not normal.
  assert_false(tiny.is_normal(ctx))
}
