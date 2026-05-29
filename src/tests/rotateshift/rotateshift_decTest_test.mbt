///|
/// Full `rotate.decTest` corpus (IBM General Decimal
/// Arithmetic testcases), embedded verbatim.
let rotate_subset : String =
  #|------------------------------------------------------------------------
  #|-- rotate.decTest -- rotate coefficient left or right                 --
  #|-- Copyright (c) IBM Corporation, 1981, 2008.  All rights reserved.   --
  #|------------------------------------------------------------------------
  #|-- Please see the document "General Decimal Arithmetic Testcases"     --
  #|-- at http://www2.hursley.ibm.com/decimal for the description of      --
  #|-- these testcases.                                                   --
  #|--                                                                    --
  #|-- These testcases are experimental ('beta' versions), and they       --
  #|-- may contain errors.  They are offered on an as-is basis.  In       --
  #|-- particular, achieving the same results as the tests here is not    --
  #|-- a guarantee that an implementation complies with any Standard      --
  #|-- or specification.  The tests are not exhaustive.                   --
  #|--                                                                    --
  #|-- Please send comments, suggestions, and corrections to the author:  --
  #|--   Mike Cowlishaw, IBM Fellow                                       --
  #|--   IBM UK, PO Box 31, Birmingham Road, Warwick CV34 5JL, UK         --
  #|--   mfc@uk.ibm.com                                                   --
  #|------------------------------------------------------------------------
  #|version: 2.59
  #|
  #|extended:    1
  #|precision:   9
  #|rounding:    half_up
  #|maxExponent: 999
  #|minExponent: -999
  #|
  #|-- Sanity check
  #|rotx001 rotate          0    0  ->  0
  #|rotx002 rotate          0    2  ->  0
  #|rotx003 rotate          1    2  ->  100
  #|rotx004 rotate         34    8  ->  400000003
  #|rotx005 rotate          1    9  ->  1
  #|rotx006 rotate          1   -1  ->  100000000
  #|rotx007 rotate  123456789   -1  ->  912345678
  #|rotx008 rotate  123456789   -8  ->  234567891
  #|rotx009 rotate  123456789   -9  ->  123456789
  #|rotx010 rotate          0   -2  ->  0
  #|
  #|-- rhs must be an integer
  #|rotx011 rotate        1    1.5    -> NaN Invalid_operation
  #|rotx012 rotate        1    1.0    -> NaN Invalid_operation
  #|rotx013 rotate        1    0.1    -> NaN Invalid_operation
  #|rotx014 rotate        1    0.0    -> NaN Invalid_operation
  #|rotx015 rotate        1    1E+1   -> NaN Invalid_operation
  #|rotx016 rotate        1    1E+99  -> NaN Invalid_operation
  #|rotx017 rotate        1    Inf    -> NaN Invalid_operation
  #|rotx018 rotate        1    -Inf   -> NaN Invalid_operation
  #|-- and |rhs| <= precision
  #|rotx020 rotate        1    -1000  -> NaN Invalid_operation
  #|rotx021 rotate        1    -10    -> NaN Invalid_operation
  #|rotx022 rotate        1     10    -> NaN Invalid_operation
  #|rotx023 rotate        1     1000  -> NaN Invalid_operation
  #|
  #|-- full pattern
  #|rotx030 rotate  123456789          -9   -> 123456789
  #|rotx031 rotate  123456789          -8   -> 234567891
  #|rotx032 rotate  123456789          -7   -> 345678912
  #|rotx033 rotate  123456789          -6   -> 456789123
  #|rotx034 rotate  123456789          -5   -> 567891234
  #|rotx035 rotate  123456789          -4   -> 678912345
  #|rotx036 rotate  123456789          -3   -> 789123456
  #|rotx037 rotate  123456789          -2   -> 891234567
  #|rotx038 rotate  123456789          -1   -> 912345678
  #|rotx039 rotate  123456789          -0   -> 123456789
  #|rotx040 rotate  123456789          +0   -> 123456789
  #|rotx041 rotate  123456789          +1   -> 234567891
  #|rotx042 rotate  123456789          +2   -> 345678912
  #|rotx043 rotate  123456789          +3   -> 456789123
  #|rotx044 rotate  123456789          +4   -> 567891234
  #|rotx045 rotate  123456789          +5   -> 678912345
  #|rotx046 rotate  123456789          +6   -> 789123456
  #|rotx047 rotate  123456789          +7   -> 891234567
  #|rotx048 rotate  123456789          +8   -> 912345678
  #|rotx049 rotate  123456789          +9   -> 123456789
  #|
  #|-- zeros
  #|rotx060 rotate  0E-10              +9   ->   0E-10
  #|rotx061 rotate  0E-10              -9   ->   0E-10
  #|rotx062 rotate  0.000              +9   ->   0.000
  #|rotx063 rotate  0.000              -9   ->   0.000
  #|rotx064 rotate  0E+10              +9   ->   0E+10
  #|rotx065 rotate  0E+10              -9   ->   0E+10
  #|rotx066 rotate -0E-10              +9   ->  -0E-10
  #|rotx067 rotate -0E-10              -9   ->  -0E-10
  #|rotx068 rotate -0.000              +9   ->  -0.000
  #|rotx069 rotate -0.000              -9   ->  -0.000
  #|rotx070 rotate -0E+10              +9   ->  -0E+10
  #|rotx071 rotate -0E+10              -9   ->  -0E+10
  #|
  #|-- Nmax, Nmin, Ntiny
  #|rotx141 rotate  9.99999999E+999     -1  -> 9.99999999E+999
  #|rotx142 rotate  9.99999999E+999     -8  -> 9.99999999E+999
  #|rotx143 rotate  9.99999999E+999      1  -> 9.99999999E+999
  #|rotx144 rotate  9.99999999E+999      8  -> 9.99999999E+999
  #|rotx145 rotate  1E-999              -1  -> 1.00000000E-991
  #|rotx146 rotate  1E-999              -8  -> 1.0E-998
  #|rotx147 rotate  1E-999               1  -> 1.0E-998
  #|rotx148 rotate  1E-999               8  -> 1.00000000E-991
  #|rotx151 rotate  1.00000000E-999     -1  -> 1.0000000E-1000
  #|rotx152 rotate  1.00000000E-999     -8  -> 1E-1007
  #|rotx153 rotate  1.00000000E-999      1  -> 1E-1007
  #|rotx154 rotate  1.00000000E-999      8  -> 1.0000000E-1000
  #|rotx155 rotate  9.00000000E-999     -1  -> 9.0000000E-1000
  #|rotx156 rotate  9.00000000E-999     -8  -> 9E-1007
  #|rotx157 rotate  9.00000000E-999      1  -> 9E-1007
  #|rotx158 rotate  9.00000000E-999      8  -> 9.0000000E-1000
  #|rotx160 rotate  1E-1007             -1  -> 1.00000000E-999
  #|rotx161 rotate  1E-1007             -8  -> 1.0E-1006
  #|rotx162 rotate  1E-1007              1  -> 1.0E-1006
  #|rotx163 rotate  1E-1007              8  -> 1.00000000E-999
  #|--  negatives
  #|rotx171 rotate -9.99999999E+999     -1  -> -9.99999999E+999
  #|rotx172 rotate -9.99999999E+999     -8  -> -9.99999999E+999
  #|rotx173 rotate -9.99999999E+999      1  -> -9.99999999E+999
  #|rotx174 rotate -9.99999999E+999      8  -> -9.99999999E+999
  #|rotx175 rotate -1E-999              -1  -> -1.00000000E-991
  #|rotx176 rotate -1E-999              -8  -> -1.0E-998
  #|rotx177 rotate -1E-999               1  -> -1.0E-998
  #|rotx178 rotate -1E-999               8  -> -1.00000000E-991
  #|rotx181 rotate -1.00000000E-999     -1  -> -1.0000000E-1000
  #|rotx182 rotate -1.00000000E-999     -8  -> -1E-1007
  #|rotx183 rotate -1.00000000E-999      1  -> -1E-1007
  #|rotx184 rotate -1.00000000E-999      8  -> -1.0000000E-1000
  #|rotx185 rotate -9.00000000E-999     -1  -> -9.0000000E-1000
  #|rotx186 rotate -9.00000000E-999     -8  -> -9E-1007
  #|rotx187 rotate -9.00000000E-999      1  -> -9E-1007
  #|rotx188 rotate -9.00000000E-999      8  -> -9.0000000E-1000
  #|rotx190 rotate -1E-1007             -1  -> -1.00000000E-999
  #|rotx191 rotate -1E-1007             -8  -> -1.0E-1006
  #|rotx192 rotate -1E-1007              1  -> -1.0E-1006
  #|rotx193 rotate -1E-1007              8  -> -1.00000000E-999
  #|
  #|-- more negatives (of sanities)
  #|rotx201 rotate         -0    0  ->  -0
  #|rotx202 rotate         -0    2  ->  -0
  #|rotx203 rotate         -1    2  ->  -100
  #|rotx204 rotate         -1    8  ->  -100000000
  #|rotx205 rotate         -1    9  ->  -1
  #|rotx206 rotate         -1   -1  ->  -100000000
  #|rotx207 rotate -123456789   -1  ->  -912345678
  #|rotx208 rotate -123456789   -8  ->  -234567891
  #|rotx209 rotate -123456789   -9  ->  -123456789
  #|rotx210 rotate         -0   -2  ->  -0
  #|
  #|-- Specials; NaNs are handled as usual
  #|rotx781 rotate -Inf  -8     -> -Infinity
  #|rotx782 rotate -Inf  -1     -> -Infinity
  #|rotx783 rotate -Inf  -0     -> -Infinity
  #|rotx784 rotate -Inf   0     -> -Infinity
  #|rotx785 rotate -Inf   1     -> -Infinity
  #|rotx786 rotate -Inf   8     -> -Infinity
  #|rotx787 rotate -1000 -Inf   -> NaN Invalid_operation
  #|rotx788 rotate -Inf  -Inf   -> NaN Invalid_operation
  #|rotx789 rotate -1    -Inf   -> NaN Invalid_operation
  #|rotx790 rotate -0    -Inf   -> NaN Invalid_operation
  #|rotx791 rotate  0    -Inf   -> NaN Invalid_operation
  #|rotx792 rotate  1    -Inf   -> NaN Invalid_operation
  #|rotx793 rotate  1000 -Inf   -> NaN Invalid_operation
  #|rotx794 rotate  Inf  -Inf   -> NaN Invalid_operation
  #|
  #|rotx800 rotate  Inf  -Inf   -> NaN Invalid_operation
  #|rotx801 rotate  Inf  -8     -> Infinity
  #|rotx802 rotate  Inf  -1     -> Infinity
  #|rotx803 rotate  Inf  -0     -> Infinity
  #|rotx804 rotate  Inf   0     -> Infinity
  #|rotx805 rotate  Inf   1     -> Infinity
  #|rotx806 rotate  Inf   8     -> Infinity
  #|rotx807 rotate  Inf   Inf   -> NaN Invalid_operation
  #|rotx808 rotate -1000  Inf   -> NaN Invalid_operation
  #|rotx809 rotate -Inf   Inf   -> NaN Invalid_operation
  #|rotx810 rotate -1     Inf   -> NaN Invalid_operation
  #|rotx811 rotate -0     Inf   -> NaN Invalid_operation
  #|rotx812 rotate  0     Inf   -> NaN Invalid_operation
  #|rotx813 rotate  1     Inf   -> NaN Invalid_operation
  #|rotx814 rotate  1000  Inf   -> NaN Invalid_operation
  #|rotx815 rotate  Inf   Inf   -> NaN Invalid_operation
  #|
  #|rotx821 rotate  NaN -Inf    ->  NaN
  #|rotx822 rotate  NaN -1000   ->  NaN
  #|rotx823 rotate  NaN -1      ->  NaN
  #|rotx824 rotate  NaN -0      ->  NaN
  #|rotx825 rotate  NaN  0      ->  NaN
  #|rotx826 rotate  NaN  1      ->  NaN
  #|rotx827 rotate  NaN  1000   ->  NaN
  #|rotx828 rotate  NaN  Inf    ->  NaN
  #|rotx829 rotate  NaN  NaN    ->  NaN
  #|rotx830 rotate -Inf  NaN    ->  NaN
  #|rotx831 rotate -1000 NaN    ->  NaN
  #|rotx832 rotate -1    NaN    ->  NaN
  #|rotx833 rotate -0    NaN    ->  NaN
  #|rotx834 rotate  0    NaN    ->  NaN
  #|rotx835 rotate  1    NaN    ->  NaN
  #|rotx836 rotate  1000 NaN    ->  NaN
  #|rotx837 rotate  Inf  NaN    ->  NaN
  #|
  #|
  #|
  #|rotx841 rotate  sNaN -Inf   ->  NaN  Invalid_operation
  #|rotx842 rotate  sNaN -1000  ->  NaN  Invalid_operation
  #|rotx843 rotate  sNaN -1     ->  NaN  Invalid_operation
  #|rotx844 rotate  sNaN -0     ->  NaN  Invalid_operation
  #|rotx845 rotate  sNaN  0     ->  NaN  Invalid_operation
  #|rotx846 rotate  sNaN  1     ->  NaN  Invalid_operation
  #|rotx847 rotate  sNaN  1000  ->  NaN  Invalid_operation
  #|rotx848 rotate  sNaN  NaN   ->  NaN  Invalid_operation
  #|rotx849 rotate  sNaN sNaN   ->  NaN  Invalid_operation
  #|rotx850 rotate  NaN  sNaN   ->  NaN  Invalid_operation
  #|rotx851 rotate -Inf  sNaN   ->  NaN  Invalid_operation
  #|rotx852 rotate -1000 sNaN   ->  NaN  Invalid_operation
  #|rotx853 rotate -1    sNaN   ->  NaN  Invalid_operation
  #|rotx854 rotate -0    sNaN   ->  NaN  Invalid_operation
  #|rotx855 rotate  0    sNaN   ->  NaN  Invalid_operation
  #|rotx856 rotate  1    sNaN   ->  NaN  Invalid_operation
  #|rotx857 rotate  1000 sNaN   ->  NaN  Invalid_operation
  #|rotx858 rotate  Inf  sNaN   ->  NaN  Invalid_operation
  #|rotx859 rotate  NaN  sNaN   ->  NaN  Invalid_operation
  #|
  #|-- propagating NaNs
  #|rotx861 rotate  NaN1   -Inf    ->  NaN1
  #|rotx862 rotate +NaN2   -1000   ->  NaN2
  #|rotx863 rotate  NaN3    1000   ->  NaN3
  #|rotx864 rotate  NaN4    Inf    ->  NaN4
  #|rotx865 rotate  NaN5   +NaN6   ->  NaN5
  #|rotx866 rotate -Inf     NaN7   ->  NaN7
  #|rotx867 rotate -1000    NaN8   ->  NaN8
  #|rotx868 rotate  1000    NaN9   ->  NaN9
  #|rotx869 rotate  Inf    +NaN10  ->  NaN10
  #|rotx871 rotate  sNaN11  -Inf   ->  NaN11  Invalid_operation
  #|rotx872 rotate  sNaN12  -1000  ->  NaN12  Invalid_operation
  #|rotx873 rotate  sNaN13   1000  ->  NaN13  Invalid_operation
  #|rotx874 rotate  sNaN14   NaN17 ->  NaN14  Invalid_operation
  #|rotx875 rotate  sNaN15  sNaN18 ->  NaN15  Invalid_operation
  #|rotx876 rotate  NaN16   sNaN19 ->  NaN19  Invalid_operation
  #|rotx877 rotate -Inf    +sNaN20 ->  NaN20  Invalid_operation
  #|rotx878 rotate -1000    sNaN21 ->  NaN21  Invalid_operation
  #|rotx879 rotate  1000    sNaN22 ->  NaN22  Invalid_operation
  #|rotx880 rotate  Inf     sNaN23 ->  NaN23  Invalid_operation
  #|rotx881 rotate +NaN25  +sNaN24 ->  NaN24  Invalid_operation
  #|rotx882 rotate -NaN26    NaN28 -> -NaN26
  #|rotx883 rotate -sNaN27  sNaN29 -> -NaN27  Invalid_operation
  #|rotx884 rotate  1000    -NaN30 -> -NaN30
  #|rotx885 rotate  1000   -sNaN31 -> -NaN31  Invalid_operation
  #|
  #|-- payload decapitate
  #|precision: 5
  #|rotx886 rotate  11 -sNaN1234567890 -> -NaN67890  Invalid_operation

///|
/// Full `shift.decTest` corpus (IBM General Decimal
/// Arithmetic testcases), embedded verbatim.
let shift_subset : String =
  #|------------------------------------------------------------------------
  #|-- shift.decTest -- shift coefficient left or right                   --
  #|-- Copyright (c) IBM Corporation, 1981, 2008.  All rights reserved.   --
  #|------------------------------------------------------------------------
  #|-- Please see the document "General Decimal Arithmetic Testcases"     --
  #|-- at http://www2.hursley.ibm.com/decimal for the description of      --
  #|-- these testcases.                                                   --
  #|--                                                                    --
  #|-- These testcases are experimental ('beta' versions), and they       --
  #|-- may contain errors.  They are offered on an as-is basis.  In       --
  #|-- particular, achieving the same results as the tests here is not    --
  #|-- a guarantee that an implementation complies with any Standard      --
  #|-- or specification.  The tests are not exhaustive.                   --
  #|--                                                                    --
  #|-- Please send comments, suggestions, and corrections to the author:  --
  #|--   Mike Cowlishaw, IBM Fellow                                       --
  #|--   IBM UK, PO Box 31, Birmingham Road, Warwick CV34 5JL, UK         --
  #|--   mfc@uk.ibm.com                                                   --
  #|------------------------------------------------------------------------
  #|version: 2.59
  #|
  #|extended:    1
  #|precision:   9
  #|rounding:    half_up
  #|maxExponent: 999
  #|minExponent: -999
  #|
  #|-- Sanity check
  #|shix001 shift          0    0  ->  0
  #|shix002 shift          0    2  ->  0
  #|shix003 shift          1    2  ->  100
  #|shix004 shift          1    8  ->  100000000
  #|shix005 shift          1    9  ->  0
  #|shix006 shift          1   -1  ->  0
  #|shix007 shift  123456789   -1  ->  12345678
  #|shix008 shift  123456789   -8  ->  1
  #|shix009 shift  123456789   -9  ->  0
  #|shix010 shift          0   -2  ->  0
  #|
  #|-- rhs must be an integer
  #|shix011 shift        1    1.5    -> NaN Invalid_operation
  #|shix012 shift        1    1.0    -> NaN Invalid_operation
  #|shix013 shift        1    0.1    -> NaN Invalid_operation
  #|shix014 shift        1    0.0    -> NaN Invalid_operation
  #|shix015 shift        1    1E+1   -> NaN Invalid_operation
  #|shix016 shift        1    1E+99  -> NaN Invalid_operation
  #|shix017 shift        1    Inf    -> NaN Invalid_operation
  #|shix018 shift        1    -Inf   -> NaN Invalid_operation
  #|-- and |rhs| <= precision
  #|shix020 shift        1    -1000  -> NaN Invalid_operation
  #|shix021 shift        1    -10    -> NaN Invalid_operation
  #|shix022 shift        1     10    -> NaN Invalid_operation
  #|shix023 shift        1     1000  -> NaN Invalid_operation
  #|
  #|-- full shifting pattern
  #|shix030 shift  123456789          -9   -> 0
  #|shix031 shift  123456789          -8   -> 1
  #|shix032 shift  123456789          -7   -> 12
  #|shix033 shift  123456789          -6   -> 123
  #|shix034 shift  123456789          -5   -> 1234
  #|shix035 shift  123456789          -4   -> 12345
  #|shix036 shift  123456789          -3   -> 123456
  #|shix037 shift  123456789          -2   -> 1234567
  #|shix038 shift  123456789          -1   -> 12345678
  #|shix039 shift  123456789          -0   -> 123456789
  #|shix040 shift  123456789          +0   -> 123456789
  #|shix041 shift  123456789          +1   -> 234567890
  #|shix042 shift  123456789          +2   -> 345678900
  #|shix043 shift  123456789          +3   -> 456789000
  #|shix044 shift  123456789          +4   -> 567890000
  #|shix045 shift  123456789          +5   -> 678900000
  #|shix046 shift  123456789          +6   -> 789000000
  #|shix047 shift  123456789          +7   -> 890000000
  #|shix048 shift  123456789          +8   -> 900000000
  #|shix049 shift  123456789          +9   -> 0
  #|
  #|-- from examples
  #|shix051 shift 34        8   ->  '400000000'
  #|shix052 shift 12        9   ->  '0'
  #|shix053 shift 123456789 -2  ->  '1234567'
  #|shix054 shift 123456789 0   ->  '123456789'
  #|shix055 shift 123456789 +2  ->  '345678900'
  #|
  #|-- zeros
  #|shix060 shift  0E-10              +9   ->   0E-10
  #|shix061 shift  0E-10              -9   ->   0E-10
  #|shix062 shift  0.000              +9   ->   0.000
  #|shix063 shift  0.000              -9   ->   0.000
  #|shix064 shift  0E+10              +9   ->   0E+10
  #|shix065 shift  0E+10              -9   ->   0E+10
  #|shix066 shift -0E-10              +9   ->  -0E-10
  #|shix067 shift -0E-10              -9   ->  -0E-10
  #|shix068 shift -0.000              +9   ->  -0.000
  #|shix069 shift -0.000              -9   ->  -0.000
  #|shix070 shift -0E+10              +9   ->  -0E+10
  #|shix071 shift -0E+10              -9   ->  -0E+10
  #|
  #|-- Nmax, Nmin, Ntiny
  #|shix141 shift  9.99999999E+999     -1  -> 9.9999999E+998
  #|shix142 shift  9.99999999E+999     -8  -> 9E+991
  #|shix143 shift  9.99999999E+999      1  -> 9.99999990E+999
  #|shix144 shift  9.99999999E+999      8  -> 9.00000000E+999
  #|shix145 shift  1E-999              -1  -> 0E-999
  #|shix146 shift  1E-999              -8  -> 0E-999
  #|shix147 shift  1E-999               1  -> 1.0E-998
  #|shix148 shift  1E-999               8  -> 1.00000000E-991
  #|shix151 shift  1.00000000E-999     -1  -> 1.0000000E-1000
  #|shix152 shift  1.00000000E-999     -8  -> 1E-1007
  #|shix153 shift  1.00000000E-999      1  -> 0E-1007
  #|shix154 shift  1.00000000E-999      8  -> 0E-1007
  #|shix155 shift  9.00000000E-999     -1  -> 9.0000000E-1000
  #|shix156 shift  9.00000000E-999     -8  -> 9E-1007
  #|shix157 shift  9.00000000E-999      1  -> 0E-1007
  #|shix158 shift  9.00000000E-999      8  -> 0E-1007
  #|shix160 shift  1E-1007             -1  -> 0E-1007
  #|shix161 shift  1E-1007             -8  -> 0E-1007
  #|shix162 shift  1E-1007              1  -> 1.0E-1006
  #|shix163 shift  1E-1007              8  -> 1.00000000E-999
  #|--  negatives
  #|shix171 shift -9.99999999E+999     -1  -> -9.9999999E+998
  #|shix172 shift -9.99999999E+999     -8  -> -9E+991
  #|shix173 shift -9.99999999E+999      1  -> -9.99999990E+999
  #|shix174 shift -9.99999999E+999      8  -> -9.00000000E+999
  #|shix175 shift -1E-999              -1  -> -0E-999
  #|shix176 shift -1E-999              -8  -> -0E-999
  #|shix177 shift -1E-999               1  -> -1.0E-998
  #|shix178 shift -1E-999               8  -> -1.00000000E-991
  #|shix181 shift -1.00000000E-999     -1  -> -1.0000000E-1000
  #|shix182 shift -1.00000000E-999     -8  -> -1E-1007
  #|shix183 shift -1.00000000E-999      1  -> -0E-1007
  #|shix184 shift -1.00000000E-999      8  -> -0E-1007
  #|shix185 shift -9.00000000E-999     -1  -> -9.0000000E-1000
  #|shix186 shift -9.00000000E-999     -8  -> -9E-1007
  #|shix187 shift -9.00000000E-999      1  -> -0E-1007
  #|shix188 shift -9.00000000E-999      8  -> -0E-1007
  #|shix190 shift -1E-1007             -1  -> -0E-1007
  #|shix191 shift -1E-1007             -8  -> -0E-1007
  #|shix192 shift -1E-1007              1  -> -1.0E-1006
  #|shix193 shift -1E-1007              8  -> -1.00000000E-999
  #|
  #|-- more negatives (of sanities)
  #|shix201 shift         -0    0  ->  -0
  #|shix202 shift         -0    2  ->  -0
  #|shix203 shift         -1    2  ->  -100
  #|shix204 shift         -1    8  ->  -100000000
  #|shix205 shift         -1    9  ->  -0
  #|shix206 shift         -1   -1  ->  -0
  #|shix207 shift -123456789   -1  ->  -12345678
  #|shix208 shift -123456789   -8  ->  -1
  #|shix209 shift -123456789   -9  ->  -0
  #|shix210 shift         -0   -2  ->  -0
  #|shix211 shift         -0   -0  ->  -0
  #|
  #|
  #|-- Specials; NaNs are handled as usual
  #|shix781 shift -Inf  -8     -> -Infinity
  #|shix782 shift -Inf  -1     -> -Infinity
  #|shix783 shift -Inf  -0     -> -Infinity
  #|shix784 shift -Inf   0     -> -Infinity
  #|shix785 shift -Inf   1     -> -Infinity
  #|shix786 shift -Inf   8     -> -Infinity
  #|shix787 shift -1000 -Inf   -> NaN Invalid_operation
  #|shix788 shift -Inf  -Inf   -> NaN Invalid_operation
  #|shix789 shift -1    -Inf   -> NaN Invalid_operation
  #|shix790 shift -0    -Inf   -> NaN Invalid_operation
  #|shix791 shift  0    -Inf   -> NaN Invalid_operation
  #|shix792 shift  1    -Inf   -> NaN Invalid_operation
  #|shix793 shift  1000 -Inf   -> NaN Invalid_operation
  #|shix794 shift  Inf  -Inf   -> NaN Invalid_operation
  #|
  #|shix800 shift  Inf  -Inf   -> NaN Invalid_operation
  #|shix801 shift  Inf  -8     -> Infinity
  #|shix802 shift  Inf  -1     -> Infinity
  #|shix803 shift  Inf  -0     -> Infinity
  #|shix804 shift  Inf   0     -> Infinity
  #|shix805 shift  Inf   1     -> Infinity
  #|shix806 shift  Inf   8     -> Infinity
  #|shix807 shift  Inf   Inf   -> NaN Invalid_operation
  #|shix808 shift -1000  Inf   -> NaN Invalid_operation
  #|shix809 shift -Inf   Inf   -> NaN Invalid_operation
  #|shix810 shift -1     Inf   -> NaN Invalid_operation
  #|shix811 shift -0     Inf   -> NaN Invalid_operation
  #|shix812 shift  0     Inf   -> NaN Invalid_operation
  #|shix813 shift  1     Inf   -> NaN Invalid_operation
  #|shix814 shift  1000  Inf   -> NaN Invalid_operation
  #|shix815 shift  Inf   Inf   -> NaN Invalid_operation
  #|
  #|shix821 shift  NaN -Inf    ->  NaN
  #|shix822 shift  NaN -1000   ->  NaN
  #|shix823 shift  NaN -1      ->  NaN
  #|shix824 shift  NaN -0      ->  NaN
  #|shix825 shift  NaN  0      ->  NaN
  #|shix826 shift  NaN  1      ->  NaN
  #|shix827 shift  NaN  1000   ->  NaN
  #|shix828 shift  NaN  Inf    ->  NaN
  #|shix829 shift  NaN  NaN    ->  NaN
  #|shix830 shift -Inf  NaN    ->  NaN
  #|shix831 shift -1000 NaN    ->  NaN
  #|shix832 shift -1    NaN    ->  NaN
  #|shix833 shift -0    NaN    ->  NaN
  #|shix834 shift  0    NaN    ->  NaN
  #|shix835 shift  1    NaN    ->  NaN
  #|shix836 shift  1000 NaN    ->  NaN
  #|shix837 shift  Inf  NaN    ->  NaN
  #|
  #|shix841 shift  sNaN -Inf   ->  NaN  Invalid_operation
  #|shix842 shift  sNaN -1000  ->  NaN  Invalid_operation
  #|shix843 shift  sNaN -1     ->  NaN  Invalid_operation
  #|shix844 shift  sNaN -0     ->  NaN  Invalid_operation
  #|shix845 shift  sNaN  0     ->  NaN  Invalid_operation
  #|shix846 shift  sNaN  1     ->  NaN  Invalid_operation
  #|shix847 shift  sNaN  1000  ->  NaN  Invalid_operation
  #|shix848 shift  sNaN  NaN   ->  NaN  Invalid_operation
  #|shix849 shift  sNaN sNaN   ->  NaN  Invalid_operation
  #|shix850 shift  NaN  sNaN   ->  NaN  Invalid_operation
  #|shix851 shift -Inf  sNaN   ->  NaN  Invalid_operation
  #|shix852 shift -1000 sNaN   ->  NaN  Invalid_operation
  #|shix853 shift -1    sNaN   ->  NaN  Invalid_operation
  #|shix854 shift -0    sNaN   ->  NaN  Invalid_operation
  #|shix855 shift  0    sNaN   ->  NaN  Invalid_operation
  #|shix856 shift  1    sNaN   ->  NaN  Invalid_operation
  #|shix857 shift  1000 sNaN   ->  NaN  Invalid_operation
  #|shix858 shift  Inf  sNaN   ->  NaN  Invalid_operation
  #|shix859 shift  NaN  sNaN   ->  NaN  Invalid_operation
  #|
  #|-- propagating NaNs
  #|shix861 shift  NaN1   -Inf    ->  NaN1
  #|shix862 shift +NaN2   -1000   ->  NaN2
  #|shix863 shift  NaN3    1000   ->  NaN3
  #|shix864 shift  NaN4    Inf    ->  NaN4
  #|shix865 shift  NaN5   +NaN6   ->  NaN5
  #|shix866 shift -Inf     NaN7   ->  NaN7
  #|shix867 shift -1000    NaN8   ->  NaN8
  #|shix868 shift  1000    NaN9   ->  NaN9
  #|shix869 shift  Inf    +NaN10  ->  NaN10
  #|shix871 shift  sNaN11  -Inf   ->  NaN11  Invalid_operation
  #|shix872 shift  sNaN12  -1000  ->  NaN12  Invalid_operation
  #|shix873 shift  sNaN13   1000  ->  NaN13  Invalid_operation
  #|shix874 shift  sNaN14   NaN17 ->  NaN14  Invalid_operation
  #|shix875 shift  sNaN15  sNaN18 ->  NaN15  Invalid_operation
  #|shix876 shift  NaN16   sNaN19 ->  NaN19  Invalid_operation
  #|shix877 shift -Inf    +sNaN20 ->  NaN20  Invalid_operation
  #|shix878 shift -1000    sNaN21 ->  NaN21  Invalid_operation
  #|shix879 shift  1000    sNaN22 ->  NaN22  Invalid_operation
  #|shix880 shift  Inf     sNaN23 ->  NaN23  Invalid_operation
  #|shix881 shift +NaN25  +sNaN24 ->  NaN24  Invalid_operation
  #|shix882 shift -NaN26    NaN28 -> -NaN26
  #|shix883 shift -sNaN27  sNaN29 -> -NaN27  Invalid_operation
  #|shix884 shift  1000    -NaN30 -> -NaN30
  #|shix885 shift  1000   -sNaN31 -> -NaN31  Invalid_operation

///|
fn run_subset(label : String, subset : String) -> Unit {
  let cases = parse_dectest(subset)
  guard cases.length() > 0 else { abort("\{label}.decTest: no cases parsed") }
  let (failures, skipped) = run_cases_with_flags(cases)
  // Skipped cases are those the harness sets aside: interchange-format /
  // null-operand syntax (`NN#value`, bare `#`) and the few reference-specific
  // divergences. Surfaced here, never silently dropped.
  if skipped > 0 {
    println(
      "\{label}: \{skipped} cases skipped (format-encoding / reference-specific)",
    )
  }
  if failures.length() > 0 {
    println("\{label}: \{failures.length()} of \{cases.length()} cases failed:")
    let limit = if failures.length() < 30 { failures.length() } else { 30 }
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
test "rotate.decTest subset" {
  run_subset("rotate", rotate_subset)
}

///|
test "shift.decTest subset" {
  run_subset("shift", shift_subset)
}
