///| `multiply` cases from `multiply.decTest`, restricted to the half_up
/// rounding mode and precision >= 9 sections; filtered to those without
/// conditions we don't yet model or a GDA `#` null operand.
let multiply_subset : String =
  #|mulx000 multiply 2      2 -> 4
  #|mulx001 multiply 2      3 -> 6
  #|mulx002 multiply 5      1 -> 5
  #|mulx003 multiply 5      2 -> 10
  #|mulx004 multiply 1.20   2 -> 2.40
  #|mulx005 multiply 1.20   0 -> 0.00
  #|mulx006 multiply 1.20  -2 -> -2.40
  #|mulx007 multiply -1.20  2 -> -2.40
  #|mulx008 multiply -1.20  0 -> -0.00
  #|mulx009 multiply -1.20 -2 -> 2.40
  #|mulx010 multiply 5.09 7.1 -> 36.139
  #|mulx011 multiply 2.5    4 -> 10.0
  #|mulx012 multiply 2.50   4 -> 10.00
  #|mulx015 multiply 2.50   4 -> 10.00
  #|mulx160 multiply 999999999999 9765625 -> 9765624999990234375
  #|mulx021 multiply  0      0     ->  0
  #|mulx022 multiply  0     -0     -> -0
  #|mulx023 multiply -0      0     -> -0
  #|mulx024 multiply -0     -0     ->  0
  #|mulx025 multiply -0.0   -0.0   ->  0.00
  #|mulx026 multiply -0.0   -0.0   ->  0.00
  #|mulx027 multiply -0.0   -0.0   ->  0.00
  #|mulx028 multiply -0.0   -0.0   ->  0.00
  #|mulx030 multiply  5.00   1E-3  ->  0.00500
  #|mulx031 multiply  00.00  0.000 ->  0.00000
  #|mulx032 multiply  00.00  0E-3  ->  0.00000     -- rhs is 0
  #|mulx033 multiply  0E-3   00.00 ->  0.00000     -- lhs is 0
  #|mulx034 multiply -5.00   1E-3  -> -0.00500
  #|mulx035 multiply -00.00  0.000 -> -0.00000
  #|mulx036 multiply -00.00  0E-3  -> -0.00000     -- rhs is 0
  #|mulx037 multiply -0E-3   00.00 -> -0.00000     -- lhs is 0
  #|mulx038 multiply  5.00  -1E-3  -> -0.00500
  #|mulx039 multiply  00.00 -0.000 -> -0.00000
  #|mulx040 multiply  00.00 -0E-3  -> -0.00000     -- rhs is 0
  #|mulx041 multiply  0E-3  -00.00 -> -0.00000     -- lhs is 0
  #|mulx042 multiply -5.00  -1E-3  ->  0.00500
  #|mulx043 multiply -00.00 -0.000 ->  0.00000
  #|mulx044 multiply -00.00 -0E-3  ->  0.00000     -- rhs is 0
  #|mulx045 multiply -0E-3  -00.00 ->  0.00000     -- lhs is 0
  #|mulx050 multiply 1.20 3        -> 3.60
  #|mulx051 multiply 7    3        -> 21
  #|mulx052 multiply 0.9  0.8      -> 0.72
  #|mulx053 multiply 0.9  -0       -> -0.0
  #|mulx060 multiply 123.45 1e7  ->  1.2345E+9
  #|mulx061 multiply 123.45 1e8  ->  1.2345E+10
  #|mulx062 multiply 123.45 1e+9 ->  1.2345E+11
  #|mulx063 multiply 123.45 1e10 ->  1.2345E+12
  #|mulx064 multiply 123.45 1e11 ->  1.2345E+13
  #|mulx065 multiply 123.45 1e12 ->  1.2345E+14
  #|mulx066 multiply 123.45 1e13 ->  1.2345E+15
  #|mulx080 multiply 0.1 123456789          -> 12345678.9
  #|mulx084 multiply 0.1 123456789          -> 12345678.9
  #|mulx090 multiply 123456789          0.1 -> 12345678.9
  #|mulx094 multiply 123456789          0.1 -> 12345678.9
  #|mulx101 multiply 9 9   -> 81
  #|mulx102 multiply 9 90   -> 810
  #|mulx103 multiply 9 900   -> 8100
  #|mulx104 multiply 9 9000   -> 81000
  #|mulx105 multiply 9 90000   -> 810000
  #|mulx106 multiply 9 900000   -> 8100000
  #|mulx107 multiply 9 9000000   -> 81000000
  #|mulx108 multiply 9 90000000   -> 810000000
  #|mulx109 multiply 9 900000000   -> 8100000000
  #|mulx110 multiply 9 9000000000   -> 81000000000
  #|mulx111 multiply 9 90000000000   -> 810000000000
  #|mulx112 multiply 9 900000000000   -> 8100000000000
  #|mulx113 multiply 9 9000000000000   -> 81000000000000
  #|mulx114 multiply 9 90000000000000   -> 810000000000000
  #|mulx115 multiply 9 900000000000000   -> 8100000000000000
  #|mulx116 multiply 9 9000000000000000   -> 81000000000000000
  #|mulx117 multiply 9 90000000000000000   -> 810000000000000000
  #|mulx118 multiply 9 900000000000000000   -> 8100000000000000000
  #|mulx119 multiply 9 9000000000000000000   -> 81000000000000000000
  #|mulx120 multiply 9 90000000000000000000   -> 810000000000000000000
  #|mulx121 multiply 9 900000000000000000000   -> 8100000000000000000000
  #|mulx122 multiply 9 9000000000000000000000   -> 81000000000000000000000
  #|mulx123 multiply 9 90000000000000000000000   -> 810000000000000000000000
  #|mulx131 multiply 3 3   -> 9
  #|mulx132 multiply 3 30   -> 90
  #|mulx133 multiply 3 300   -> 900
  #|mulx134 multiply 3 3000   -> 9000
  #|mulx135 multiply 3 30000   -> 90000
  #|mulx136 multiply 3 300000   -> 900000
  #|mulx137 multiply 3 3000000   -> 9000000
  #|mulx138 multiply 3 30000000   -> 90000000
  #|mulx139 multiply 3 300000000   -> 900000000
  #|mulx140 multiply 3 3000000000   -> 9000000000
  #|mulx141 multiply 3 30000000000   -> 90000000000
  #|mulx142 multiply 3 300000000000   -> 900000000000
  #|mulx143 multiply 3 3000000000000   -> 9000000000000
  #|mulx144 multiply 3 30000000000000   -> 90000000000000
  #|mulx145 multiply 3 300000000000000   -> 900000000000000
  #|mulx146 multiply 3 3000000000000000   -> 9000000000000000
  #|mulx147 multiply 3 30000000000000000   -> 90000000000000000
  #|mulx148 multiply 3 300000000000000000   -> 900000000000000000
  #|mulx149 multiply 3 3000000000000000000   -> 9000000000000000000
  #|mulx150 multiply 3 30000000000000000000   -> 90000000000000000000
  #|mulx151 multiply 3 300000000000000000000   -> 900000000000000000000
  #|mulx152 multiply 3 3000000000000000000000   -> 9000000000000000000000
  #|mulx153 multiply 3 30000000000000000000000   -> 90000000000000000000000
  #|mulx170 multiply 1 9e999999999    -> 9E+999999999
  #|mulx171 multiply 1 9.9e999999999  -> 9.9E+999999999
  #|mulx172 multiply 1 9.99e999999999 -> 9.99E+999999999
  #|mulx173 multiply 9e999999999    1 -> 9E+999999999
  #|mulx174 multiply 9.9e999999999  1 -> 9.9E+999999999
  #|mulx176 multiply 9.99e999999999 1 -> 9.99E+999999999
  #|mulx177 multiply 1 9.99999999e999999999 -> 9.99999999E+999999999
  #|mulx178 multiply 9.99999999e999999999 1 -> 9.99999999E+999999999
  #|mulx180 multiply 0.1 9e-999999998   -> 9E-999999999
  #|mulx181 multiply 0.1 99e-999999998  -> 9.9E-999999998
  #|mulx182 multiply 0.1 999e-999999998 -> 9.99E-999999997
  #|mulx183 multiply 0.1 9e-999999998     -> 9E-999999999
  #|mulx184 multiply 0.1 99e-999999998    -> 9.9E-999999998
  #|mulx185 multiply 0.1 999e-999999998   -> 9.99E-999999997
  #|mulx186 multiply 0.1 999e-999999997   -> 9.99E-999999996
  #|mulx187 multiply 0.1 9999e-999999997  -> 9.999E-999999995
  #|mulx188 multiply 0.1 99999e-999999997 -> 9.9999E-999999994
  #|mulx190 multiply 1 9e-999999998   -> 9E-999999998
  #|mulx191 multiply 1 99e-999999998  -> 9.9E-999999997
  #|mulx192 multiply 1 999e-999999998 -> 9.99E-999999996
  #|mulx193 multiply 9e-999999998   1 -> 9E-999999998
  #|mulx194 multiply 99e-999999998  1 -> 9.9E-999999997
  #|mulx195 multiply 999e-999999998 1 -> 9.99E-999999996
  #|mulx196 multiply 1e-599999999 1e-400000000 -> 1E-999999999
  #|mulx197 multiply 1e-600000000 1e-399999999 -> 1E-999999999
  #|mulx198 multiply 1.2e-599999999 1.2e-400000000 -> 1.44E-999999999
  #|mulx199 multiply 1.2e-600000000 1.2e-399999999 -> 1.44E-999999999
  #|mulx201 multiply 1e599999999 1e400000000 -> 1E+999999999
  #|mulx202 multiply 1e600000000 1e399999999 -> 1E+999999999
  #|mulx203 multiply 1.2e599999999 1.2e400000000 -> 1.44E+999999999
  #|mulx204 multiply 1.2e600000000 1.2e399999999 -> 1.44E+999999999
  #|mulx301 multiply 9 9   -> 81
  #|mulx302 multiply 9 90   -> 810
  #|mulx303 multiply 9 900   -> 8100
  #|mulx304 multiply 9 9000   -> 81000
  #|mulx305 multiply 9 90000   -> 810000
  #|mulx306 multiply 9 900000   -> 8100000
  #|mulx307 multiply 9 9000000   -> 81000000
  #|mulx308 multiply 9 90000000   -> 810000000
  #|mulx541 multiply  0    -1     -> -0
  #|mulx542 multiply -0    -1     ->  0
  #|mulx543 multiply  0     1     ->  0
  #|mulx544 multiply -0     1     -> -0
  #|mulx545 multiply -1     0     -> -0
  #|mulx546 multiply -1    -0     ->  0
  #|mulx547 multiply  1     0     ->  0
  #|mulx548 multiply  1    -0     -> -0
  #|mulx551 multiply  0.0  -1     -> -0.0
  #|mulx552 multiply -0.0  -1     ->  0.0
  #|mulx553 multiply  0.0   1     ->  0.0
  #|mulx554 multiply -0.0   1     -> -0.0
  #|mulx555 multiply -1.0   0     -> -0.0
  #|mulx556 multiply -1.0  -0     ->  0.0
  #|mulx557 multiply  1.0   0     ->  0.0
  #|mulx558 multiply  1.0  -0     -> -0.0
  #|mulx561 multiply  0    -1.0   -> -0.0
  #|mulx562 multiply -0    -1.0   ->  0.0
  #|mulx563 multiply  0     1.0   ->  0.0
  #|mulx564 multiply -0     1.0   -> -0.0
  #|mulx565 multiply -1     0.0   -> -0.0
  #|mulx566 multiply -1    -0.0   ->  0.0
  #|mulx567 multiply  1     0.0   ->  0.0
  #|mulx568 multiply  1    -0.0   -> -0.0
  #|mulx571 multiply  0.0  -1.0   -> -0.00
  #|mulx572 multiply -0.0  -1.0   ->  0.00
  #|mulx573 multiply  0.0   1.0   ->  0.00
  #|mulx574 multiply -0.0   1.0   -> -0.00
  #|mulx575 multiply -1.0   0.0   -> -0.00
  #|mulx576 multiply -1.0  -0.0   ->  0.00
  #|mulx577 multiply  1.0   0.0   ->  0.00
  #|mulx578 multiply  1.0  -0.0   -> -0.00
  #|mulx580 multiply  Inf  -Inf   -> -Infinity
  #|mulx581 multiply  Inf  -1000  -> -Infinity
  #|mulx582 multiply  Inf  -1     -> -Infinity
  #|mulx583 multiply  Inf  -0     ->  NaN  Invalid_operation
  #|mulx584 multiply  Inf   0     ->  NaN  Invalid_operation
  #|mulx585 multiply  Inf   1     ->  Infinity
  #|mulx586 multiply  Inf   1000  ->  Infinity
  #|mulx587 multiply  Inf   Inf   ->  Infinity
  #|mulx588 multiply -1000  Inf   -> -Infinity
  #|mulx589 multiply -Inf   Inf   -> -Infinity
  #|mulx590 multiply -1     Inf   -> -Infinity
  #|mulx591 multiply -0     Inf   ->  NaN  Invalid_operation
  #|mulx592 multiply  0     Inf   ->  NaN  Invalid_operation
  #|mulx593 multiply  1     Inf   ->  Infinity
  #|mulx594 multiply  1000  Inf   ->  Infinity
  #|mulx595 multiply  Inf   Inf   ->  Infinity
  #|mulx600 multiply -Inf  -Inf   ->  Infinity
  #|mulx601 multiply -Inf  -1000  ->  Infinity
  #|mulx602 multiply -Inf  -1     ->  Infinity
  #|mulx603 multiply -Inf  -0     ->  NaN  Invalid_operation
  #|mulx604 multiply -Inf   0     ->  NaN  Invalid_operation
  #|mulx605 multiply -Inf   1     -> -Infinity
  #|mulx606 multiply -Inf   1000  -> -Infinity
  #|mulx607 multiply -Inf   Inf   -> -Infinity
  #|mulx608 multiply -1000  Inf   -> -Infinity
  #|mulx609 multiply -Inf  -Inf   ->  Infinity
  #|mulx610 multiply -1    -Inf   ->  Infinity
  #|mulx611 multiply -0    -Inf   ->  NaN  Invalid_operation
  #|mulx612 multiply  0    -Inf   ->  NaN  Invalid_operation
  #|mulx613 multiply  1    -Inf   -> -Infinity
  #|mulx614 multiply  1000 -Inf   -> -Infinity
  #|mulx615 multiply  Inf  -Inf   -> -Infinity
  #|mulx621 multiply  NaN -Inf    ->  NaN
  #|mulx622 multiply  NaN -1000   ->  NaN
  #|mulx623 multiply  NaN -1      ->  NaN
  #|mulx624 multiply  NaN -0      ->  NaN
  #|mulx625 multiply  NaN  0      ->  NaN
  #|mulx626 multiply  NaN  1      ->  NaN
  #|mulx627 multiply  NaN  1000   ->  NaN
  #|mulx628 multiply  NaN  Inf    ->  NaN
  #|mulx629 multiply  NaN  NaN    ->  NaN
  #|mulx630 multiply -Inf  NaN    ->  NaN
  #|mulx631 multiply -1000 NaN    ->  NaN
  #|mulx632 multiply -1    NaN    ->  NaN
  #|mulx633 multiply -0    NaN    ->  NaN
  #|mulx634 multiply  0    NaN    ->  NaN
  #|mulx635 multiply  1    NaN    ->  NaN
  #|mulx636 multiply  1000 NaN    ->  NaN
  #|mulx637 multiply  Inf  NaN    ->  NaN
  #|mulx641 multiply  sNaN -Inf   ->  NaN  Invalid_operation
  #|mulx642 multiply  sNaN -1000  ->  NaN  Invalid_operation
  #|mulx643 multiply  sNaN -1     ->  NaN  Invalid_operation
  #|mulx644 multiply  sNaN -0     ->  NaN  Invalid_operation
  #|mulx645 multiply  sNaN  0     ->  NaN  Invalid_operation
  #|mulx646 multiply  sNaN  1     ->  NaN  Invalid_operation
  #|mulx647 multiply  sNaN  1000  ->  NaN  Invalid_operation
  #|mulx648 multiply  sNaN  NaN   ->  NaN  Invalid_operation
  #|mulx649 multiply  sNaN sNaN   ->  NaN  Invalid_operation
  #|mulx650 multiply  NaN  sNaN   ->  NaN  Invalid_operation
  #|mulx651 multiply -Inf  sNaN   ->  NaN  Invalid_operation
  #|mulx652 multiply -1000 sNaN   ->  NaN  Invalid_operation
  #|mulx653 multiply -1    sNaN   ->  NaN  Invalid_operation
  #|mulx654 multiply -0    sNaN   ->  NaN  Invalid_operation
  #|mulx655 multiply  0    sNaN   ->  NaN  Invalid_operation
  #|mulx656 multiply  1    sNaN   ->  NaN  Invalid_operation
  #|mulx657 multiply  1000 sNaN   ->  NaN  Invalid_operation
  #|mulx658 multiply  Inf  sNaN   ->  NaN  Invalid_operation
  #|mulx659 multiply  NaN  sNaN   ->  NaN  Invalid_operation
  #|mulx661 multiply  NaN9 -Inf   ->  NaN9
  #|mulx662 multiply  NaN8  999   ->  NaN8
  #|mulx663 multiply  NaN71 Inf   ->  NaN71
  #|mulx664 multiply  NaN6  NaN5  ->  NaN6
  #|mulx665 multiply -Inf   NaN4  ->  NaN4
  #|mulx666 multiply -999   NaN33 ->  NaN33
  #|mulx667 multiply  Inf   NaN2  ->  NaN2
  #|mulx671 multiply  sNaN99 -Inf    ->  NaN99 Invalid_operation
  #|mulx672 multiply  sNaN98 -11     ->  NaN98 Invalid_operation
  #|mulx673 multiply  sNaN97  NaN    ->  NaN97 Invalid_operation
  #|mulx674 multiply  sNaN16 sNaN94  ->  NaN16 Invalid_operation
  #|mulx675 multiply  NaN95  sNaN93  ->  NaN93 Invalid_operation
  #|mulx676 multiply -Inf    sNaN92  ->  NaN92 Invalid_operation
  #|mulx677 multiply  088    sNaN91  ->  NaN91 Invalid_operation
  #|mulx678 multiply  Inf    sNaN90  ->  NaN90 Invalid_operation
  #|mulx679 multiply  NaN    sNaN89  ->  NaN89 Invalid_operation
  #|mulx681 multiply -NaN9 -Inf   -> -NaN9
  #|mulx682 multiply -NaN8  999   -> -NaN8
  #|mulx683 multiply -NaN71 Inf   -> -NaN71
  #|mulx684 multiply -NaN6 -NaN5  -> -NaN6
  #|mulx685 multiply -Inf  -NaN4  -> -NaN4
  #|mulx686 multiply -999  -NaN33 -> -NaN33
  #|mulx687 multiply  Inf  -NaN2  -> -NaN2
  #|mulx691 multiply -sNaN99 -Inf    -> -NaN99 Invalid_operation
  #|mulx692 multiply -sNaN98 -11     -> -NaN98 Invalid_operation
  #|mulx693 multiply -sNaN97  NaN    -> -NaN97 Invalid_operation
  #|mulx694 multiply -sNaN16 -sNaN94 -> -NaN16 Invalid_operation
  #|mulx695 multiply -NaN95  -sNaN93 -> -NaN93 Invalid_operation
  #|mulx696 multiply -Inf    -sNaN92 -> -NaN92 Invalid_operation
  #|mulx697 multiply  088    -sNaN91 -> -NaN91 Invalid_operation
  #|mulx698 multiply  Inf    -sNaN90 -> -NaN90 Invalid_operation
  #|mulx699 multiply -NaN    -sNaN89 -> -NaN89 Invalid_operation
  #|mulx701 multiply -NaN  -Inf   -> -NaN
  #|mulx702 multiply -NaN   999   -> -NaN
  #|mulx703 multiply -NaN   Inf   -> -NaN
  #|mulx704 multiply -NaN  -NaN   -> -NaN
  #|mulx705 multiply -Inf  -NaN0  -> -NaN
  #|mulx706 multiply -999  -NaN   -> -NaN
  #|mulx707 multiply  Inf  -NaN   -> -NaN
  #|mulx711 multiply -sNaN   -Inf    -> -NaN Invalid_operation
  #|mulx712 multiply -sNaN   -11     -> -NaN Invalid_operation
  #|mulx713 multiply -sNaN00  NaN    -> -NaN Invalid_operation
  #|mulx714 multiply -sNaN   -sNaN   -> -NaN Invalid_operation
  #|mulx715 multiply -NaN    -sNaN   -> -NaN Invalid_operation
  #|mulx716 multiply -Inf    -sNaN   -> -NaN Invalid_operation
  #|mulx717 multiply  088    -sNaN   -> -NaN Invalid_operation
  #|mulx718 multiply  Inf    -sNaN   -> -NaN Invalid_operation
  #|mulx719 multiply -NaN    -sNaN   -> -NaN Invalid_operation
  #|mulx740 multiply 1e-599999999 1e-400000000 -> 1E-999999999
  #|mulx743 multiply 9e-999999998 0.1  -> 9E-999999999
  #|mulx746 multiply 1e599999999 1e400000000 -> 1E+999999999
  #|mulx749 multiply 9e999999998 10   -> 9.0E+999999999
  #|mulx906 multiply  9.999999999999999E-383  1                       -> 9.999999999999999E-383
  #|mulx907 multiply                       1  0.09999999999999999     -> 0.09999999999999999
  #|mulx1001  multiply 130E-2  120E-2 -> 1.5600
  #|mulx1002  multiply 130E-2  12E-1  -> 1.560
  #|mulx1003  multiply 130E-2  1E0    -> 1.30
  #|mulx1004  multiply 1E2     1E4    -> 1E+6

///|
test "multiply.decTest subset round-trips through parse + multiply + toSci" {
  let cases = parse_dectest(multiply_subset)
  assert_eq(cases.length(), 297)
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
    abort("multiply.decTest failures")
  }
}
