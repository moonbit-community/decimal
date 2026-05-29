///|
/// Full `nextplus.decTest` corpus (IBM General Decimal
/// Arithmetic testcases), embedded verbatim.
let nextplus_subset : String =
  #|------------------------------------------------------------------------
  #|-- nextplus.decTest -- decimal next that is greater [754r nextup]     --
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
  #|maxExponent: 384
  #|minexponent: -383
  #|
  #|nextp001 nextplus  0.999999995 ->   0.999999996
  #|nextp002 nextplus  0.999999996 ->   0.999999997
  #|nextp003 nextplus  0.999999997 ->   0.999999998
  #|nextp004 nextplus  0.999999998 ->   0.999999999
  #|nextp005 nextplus  0.999999999 ->   1.00000000
  #|nextp006 nextplus  1.00000000  ->   1.00000001
  #|nextp007 nextplus  1.0         ->   1.00000001
  #|nextp008 nextplus  1           ->   1.00000001
  #|nextp009 nextplus  1.00000001  ->   1.00000002
  #|nextp010 nextplus  1.00000002  ->   1.00000003
  #|nextp011 nextplus  1.00000003  ->   1.00000004
  #|nextp012 nextplus  1.00000004  ->   1.00000005
  #|nextp013 nextplus  1.00000005  ->   1.00000006
  #|nextp014 nextplus  1.00000006  ->   1.00000007
  #|nextp015 nextplus  1.00000007  ->   1.00000008
  #|nextp016 nextplus  1.00000008  ->   1.00000009
  #|nextp017 nextplus  1.00000009  ->   1.00000010
  #|nextp018 nextplus  1.00000010  ->   1.00000011
  #|nextp019 nextplus  1.00000011  ->   1.00000012
  #|
  #|nextp021 nextplus -0.999999995 ->  -0.999999994
  #|nextp022 nextplus -0.999999996 ->  -0.999999995
  #|nextp023 nextplus -0.999999997 ->  -0.999999996
  #|nextp024 nextplus -0.999999998 ->  -0.999999997
  #|nextp025 nextplus -0.999999999 ->  -0.999999998
  #|nextp026 nextplus -1.00000000  ->  -0.999999999
  #|nextp027 nextplus -1.0         ->  -0.999999999
  #|nextp028 nextplus -1           ->  -0.999999999
  #|nextp029 nextplus -1.00000001  ->  -1.00000000
  #|nextp030 nextplus -1.00000002  ->  -1.00000001
  #|nextp031 nextplus -1.00000003  ->  -1.00000002
  #|nextp032 nextplus -1.00000004  ->  -1.00000003
  #|nextp033 nextplus -1.00000005  ->  -1.00000004
  #|nextp034 nextplus -1.00000006  ->  -1.00000005
  #|nextp035 nextplus -1.00000007  ->  -1.00000006
  #|nextp036 nextplus -1.00000008  ->  -1.00000007
  #|nextp037 nextplus -1.00000009  ->  -1.00000008
  #|nextp038 nextplus -1.00000010  ->  -1.00000009
  #|nextp039 nextplus -1.00000011  ->  -1.00000010
  #|nextp040 nextplus -1.00000012  ->  -1.00000011
  #|
  #|-- input operand is >precision
  #|nextp041 nextplus  1.00000010998  ->   1.00000011
  #|nextp042 nextplus  1.00000010999  ->   1.00000011
  #|nextp043 nextplus  1.00000011000  ->   1.00000012
  #|nextp044 nextplus  1.00000011001  ->   1.00000012
  #|nextp045 nextplus  1.00000011002  ->   1.00000012
  #|nextp046 nextplus  1.00000011002  ->   1.00000012
  #|nextp047 nextplus  1.00000011052  ->   1.00000012
  #|nextp048 nextplus  1.00000011552  ->   1.00000012
  #|nextp049 nextplus -1.00000010998  ->  -1.00000010
  #|nextp050 nextplus -1.00000010999  ->  -1.00000010
  #|nextp051 nextplus -1.00000011000  ->  -1.00000010
  #|nextp052 nextplus -1.00000011001  ->  -1.00000011
  #|nextp053 nextplus -1.00000011002  ->  -1.00000011
  #|nextp054 nextplus -1.00000011002  ->  -1.00000011
  #|nextp055 nextplus -1.00000011052  ->  -1.00000011
  #|nextp056 nextplus -1.00000011552  ->  -1.00000011
  #|-- ultra-tiny inputs
  #|nextp060 nextplus  1E-99999       ->   1E-391
  #|nextp061 nextplus  1E-999999999   ->   1E-391
  #|nextp062 nextplus  1E-391         ->   2E-391
  #|nextp063 nextplus -1E-99999       ->  -0E-391
  #|nextp064 nextplus -1E-999999999   ->  -0E-391
  #|nextp065 nextplus -1E-391         ->  -0E-391
  #|
  #|-- Zeros
  #|nextp100 nextplus  0           ->  1E-391
  #|nextp101 nextplus  0.00        ->  1E-391
  #|nextp102 nextplus  0E-300      ->  1E-391
  #|nextp103 nextplus  0E+300      ->  1E-391
  #|nextp104 nextplus  0E+30000    ->  1E-391
  #|nextp105 nextplus -0           ->  1E-391
  #|nextp106 nextplus -0.00        ->  1E-391
  #|nextp107 nextplus -0E-300      ->  1E-391
  #|nextp108 nextplus -0E+300      ->  1E-391
  #|nextp109 nextplus -0E+30000    ->  1E-391
  #|
  #|maxExponent: 999
  #|minexponent: -999
  #|precision: 9
  #|-- specials
  #|nextp150 nextplus   Inf    ->  Infinity
  #|nextp151 nextplus  -Inf    -> -9.99999999E+999
  #|nextp152 nextplus   NaN    ->  NaN
  #|nextp153 nextplus  sNaN    ->  NaN   Invalid_operation
  #|nextp154 nextplus   NaN77  ->  NaN77
  #|nextp155 nextplus  sNaN88  ->  NaN88 Invalid_operation
  #|nextp156 nextplus  -NaN    -> -NaN
  #|nextp157 nextplus -sNaN    -> -NaN   Invalid_operation
  #|nextp158 nextplus  -NaN77  -> -NaN77
  #|nextp159 nextplus -sNaN88  -> -NaN88 Invalid_operation
  #|
  #|-- Nmax, Nmin, Ntiny, subnormals
  #|nextp170 nextplus  9.99999999E+999   -> Infinity
  #|nextp171 nextplus  9.99999998E+999   -> 9.99999999E+999
  #|nextp172 nextplus  1E-999            -> 1.00000001E-999
  #|nextp173 nextplus  1.00000000E-999   -> 1.00000001E-999
  #|nextp174 nextplus  9E-1007           -> 1.0E-1006
  #|nextp175 nextplus  9.9E-1006         -> 1.00E-1005
  #|nextp176 nextplus  9.9999E-1003      -> 1.00000E-1002
  #|nextp177 nextplus  9.9999999E-1000   -> 1.00000000E-999
  #|nextp178 nextplus  9.9999998E-1000   -> 9.9999999E-1000
  #|nextp179 nextplus  9.9999997E-1000   -> 9.9999998E-1000
  #|nextp180 nextplus  0E-1007           -> 1E-1007
  #|nextp181 nextplus  1E-1007           -> 2E-1007
  #|nextp182 nextplus  2E-1007           -> 3E-1007
  #|
  #|nextp183 nextplus  -0E-1007          ->  1E-1007
  #|nextp184 nextplus  -1E-1007          -> -0E-1007
  #|nextp185 nextplus  -2E-1007          -> -1E-1007
  #|nextp186 nextplus  -10E-1007         -> -9E-1007
  #|nextp187 nextplus  -100E-1007        -> -9.9E-1006
  #|nextp188 nextplus  -100000E-1007     -> -9.9999E-1003
  #|nextp189 nextplus  -1.0000E-999      -> -9.9999999E-1000
  #|nextp190 nextplus  -1.00000000E-999  -> -9.9999999E-1000
  #|nextp191 nextplus  -1E-999           -> -9.9999999E-1000
  #|nextp192 nextplus  -9.99999998E+999  -> -9.99999997E+999
  #|nextp193 nextplus  -9.99999999E+999  -> -9.99999998E+999
  #|
  #|-- Null tests
  #|nextp900 nextplus  # -> NaN Invalid_operation

///|
/// Full `nextminus.decTest` corpus (IBM General Decimal
/// Arithmetic testcases), embedded verbatim.
let nextminus_subset : String =
  #|------------------------------------------------------------------------
  #|-- nextminus.decTest -- decimal next that is less [754r nextdown]     --
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
  #|maxExponent: 384
  #|minexponent: -383
  #|
  #|nextm001 nextminus  0.999999995 ->   0.999999994
  #|nextm002 nextminus  0.999999996 ->   0.999999995
  #|nextm003 nextminus  0.999999997 ->   0.999999996
  #|nextm004 nextminus  0.999999998 ->   0.999999997
  #|nextm005 nextminus  0.999999999 ->   0.999999998
  #|nextm006 nextminus  1.00000000  ->   0.999999999
  #|nextm007 nextminus  1.0         ->   0.999999999
  #|nextm008 nextminus  1           ->   0.999999999
  #|nextm009 nextminus  1.00000001  ->   1.00000000
  #|nextm010 nextminus  1.00000002  ->   1.00000001
  #|nextm011 nextminus  1.00000003  ->   1.00000002
  #|nextm012 nextminus  1.00000004  ->   1.00000003
  #|nextm013 nextminus  1.00000005  ->   1.00000004
  #|nextm014 nextminus  1.00000006  ->   1.00000005
  #|nextm015 nextminus  1.00000007  ->   1.00000006
  #|nextm016 nextminus  1.00000008  ->   1.00000007
  #|nextm017 nextminus  1.00000009  ->   1.00000008
  #|nextm018 nextminus  1.00000010  ->   1.00000009
  #|nextm019 nextminus  1.00000011  ->   1.00000010
  #|nextm020 nextminus  1.00000012  ->   1.00000011
  #|
  #|nextm021 nextminus -0.999999995 ->  -0.999999996
  #|nextm022 nextminus -0.999999996 ->  -0.999999997
  #|nextm023 nextminus -0.999999997 ->  -0.999999998
  #|nextm024 nextminus -0.999999998 ->  -0.999999999
  #|nextm025 nextminus -0.999999999 ->  -1.00000000
  #|nextm026 nextminus -1.00000000  ->  -1.00000001
  #|nextm027 nextminus -1.0         ->  -1.00000001
  #|nextm028 nextminus -1           ->  -1.00000001
  #|nextm029 nextminus -1.00000001  ->  -1.00000002
  #|nextm030 nextminus -1.00000002  ->  -1.00000003
  #|nextm031 nextminus -1.00000003  ->  -1.00000004
  #|nextm032 nextminus -1.00000004  ->  -1.00000005
  #|nextm033 nextminus -1.00000005  ->  -1.00000006
  #|nextm034 nextminus -1.00000006  ->  -1.00000007
  #|nextm035 nextminus -1.00000007  ->  -1.00000008
  #|nextm036 nextminus -1.00000008  ->  -1.00000009
  #|nextm037 nextminus -1.00000009  ->  -1.00000010
  #|nextm038 nextminus -1.00000010  ->  -1.00000011
  #|nextm039 nextminus -1.00000011  ->  -1.00000012
  #|
  #|-- input operand is >precision
  #|nextm041 nextminus  1.00000010998  ->   1.00000010
  #|nextm042 nextminus  1.00000010999  ->   1.00000010
  #|nextm043 nextminus  1.00000011000  ->   1.00000010
  #|nextm044 nextminus  1.00000011001  ->   1.00000011
  #|nextm045 nextminus  1.00000011002  ->   1.00000011
  #|nextm046 nextminus  1.00000011002  ->   1.00000011
  #|nextm047 nextminus  1.00000011052  ->   1.00000011
  #|nextm048 nextminus  1.00000011552  ->   1.00000011
  #|nextm049 nextminus -1.00000010998  ->  -1.00000011
  #|nextm050 nextminus -1.00000010999  ->  -1.00000011
  #|nextm051 nextminus -1.00000011000  ->  -1.00000012
  #|nextm052 nextminus -1.00000011001  ->  -1.00000012
  #|nextm053 nextminus -1.00000011002  ->  -1.00000012
  #|nextm054 nextminus -1.00000011002  ->  -1.00000012
  #|nextm055 nextminus -1.00000011052  ->  -1.00000012
  #|nextm056 nextminus -1.00000011552  ->  -1.00000012
  #|-- ultra-tiny inputs
  #|nextm060 nextminus  1E-99999       ->   0E-391
  #|nextm061 nextminus  1E-999999999   ->   0E-391
  #|nextm062 nextminus  1E-391         ->   0E-391
  #|nextm063 nextminus -1E-99999       ->  -1E-391
  #|nextm064 nextminus -1E-999999999   ->  -1E-391
  #|nextm065 nextminus -1E-391         ->  -2E-391
  #|
  #|-- Zeros
  #|nextm100 nextminus -0           -> -1E-391
  #|nextm101 nextminus  0           -> -1E-391
  #|nextm102 nextminus  0.00        -> -1E-391
  #|nextm103 nextminus -0.00        -> -1E-391
  #|nextm104 nextminus  0E-300      -> -1E-391
  #|nextm105 nextminus  0E+300      -> -1E-391
  #|nextm106 nextminus  0E+30000    -> -1E-391
  #|nextm107 nextminus -0E+30000    -> -1E-391
  #|
  #|precision: 9
  #|maxExponent: 999
  #|minexponent: -999
  #|-- specials
  #|nextm150 nextminus   Inf    ->  9.99999999E+999
  #|nextm151 nextminus  -Inf    -> -Infinity
  #|nextm152 nextminus   NaN    ->  NaN
  #|nextm153 nextminus  sNaN    ->  NaN   Invalid_operation
  #|nextm154 nextminus   NaN77  ->  NaN77
  #|nextm155 nextminus  sNaN88  ->  NaN88 Invalid_operation
  #|nextm156 nextminus  -NaN    -> -NaN
  #|nextm157 nextminus -sNaN    -> -NaN   Invalid_operation
  #|nextm158 nextminus  -NaN77  -> -NaN77
  #|nextm159 nextminus -sNaN88  -> -NaN88 Invalid_operation
  #|
  #|-- Nmax, Nmin, Ntiny, subnormals
  #|nextm170 nextminus  9.99999999E+999   -> 9.99999998E+999
  #|nextm171 nextminus  9.99999998E+999   -> 9.99999997E+999
  #|nextm172 nextminus  1E-999            -> 9.9999999E-1000
  #|nextm173 nextminus  1.00000000E-999   -> 9.9999999E-1000
  #|nextm174 nextminus  9E-1007           -> 8E-1007
  #|nextm175 nextminus  9.9E-1006         -> 9.8E-1006
  #|nextm176 nextminus  9.9999E-1003      -> 9.9998E-1003
  #|nextm177 nextminus  9.9999999E-1000   -> 9.9999998E-1000
  #|nextm178 nextminus  9.9999998E-1000   -> 9.9999997E-1000
  #|nextm179 nextminus  9.9999997E-1000   -> 9.9999996E-1000
  #|nextm180 nextminus  0E-1007           -> -1E-1007
  #|nextm181 nextminus  1E-1007           -> 0E-1007
  #|nextm182 nextminus  2E-1007           -> 1E-1007
  #|
  #|nextm183 nextminus  -0E-1007          -> -1E-1007
  #|nextm184 nextminus  -1E-1007          -> -2E-1007
  #|nextm185 nextminus  -2E-1007          -> -3E-1007
  #|nextm186 nextminus  -10E-1007         -> -1.1E-1006
  #|nextm187 nextminus  -100E-1007        -> -1.01E-1005
  #|nextm188 nextminus  -100000E-1007     -> -1.00001E-1002
  #|nextm189 nextminus  -1.0000E-999      -> -1.00000001E-999
  #|nextm190 nextminus  -1.00000000E-999  -> -1.00000001E-999
  #|nextm191 nextminus  -1E-999           -> -1.00000001E-999
  #|nextm192 nextminus  -9.99999998E+999  -> -9.99999999E+999
  #|nextm193 nextminus  -9.99999999E+999  -> -Infinity
  #|
  #|-- Null tests
  #|nextm900 nextminus  # -> NaN Invalid_operation

///|
/// Full `nexttoward.decTest` corpus (IBM General Decimal
/// Arithmetic testcases), embedded verbatim.
let nexttoward_subset : String =
  #|------------------------------------------------------------------------
  #|-- nexttoward.decTest -- decimal next toward rhs [754r nextafter]     --
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
  #|maxExponent: 384
  #|minexponent: -383
  #|
  #|-- Sanity check with a scattering of numerics
  #|nextt001 nexttoward   10    10   ->  10
  #|nextt002 nexttoward  -10   -10   -> -10
  #|nextt003 nexttoward   1     10   ->  1.00000001
  #|nextt004 nexttoward   1    -10   ->  0.999999999
  #|nextt005 nexttoward  -1     10   -> -0.999999999
  #|nextt006 nexttoward  -1    -10   -> -1.00000001
  #|nextt007 nexttoward   0     10   ->  1E-391       Underflow Subnormal Inexact Rounded
  #|nextt008 nexttoward   0    -10   -> -1E-391       Underflow Subnormal Inexact Rounded
  #|nextt009 nexttoward   9.99999999E+384 +Infinity ->  Infinity Overflow Inexact Rounded
  #|nextt010 nexttoward  -9.99999999E+384 -Infinity -> -Infinity Overflow Inexact Rounded
  #|
  #|------- lhs=rhs
  #|-- finites
  #|nextt101 nexttoward          7       7 ->  7
  #|nextt102 nexttoward         -7      -7 -> -7
  #|nextt103 nexttoward         75      75 ->  75
  #|nextt104 nexttoward        -75     -75 -> -75
  #|nextt105 nexttoward       7.50     7.5 ->  7.50
  #|nextt106 nexttoward      -7.50   -7.50 -> -7.50
  #|nextt107 nexttoward       7.500 7.5000 ->  7.500
  #|nextt108 nexttoward      -7.500   -7.5 -> -7.500
  #|
  #|-- zeros
  #|nextt111 nexttoward          0       0 ->  0
  #|nextt112 nexttoward         -0      -0 -> -0
  #|nextt113 nexttoward       0E+4       0 ->  0E+4
  #|nextt114 nexttoward      -0E+4      -0 -> -0E+4
  #|nextt115 nexttoward     0.0000 0.00000 ->  0.0000
  #|nextt116 nexttoward    -0.0000   -0.00 -> -0.0000
  #|nextt117 nexttoward      0E-141      0 ->  0E-141
  #|nextt118 nexttoward     -0E-141   -000 -> -0E-141
  #|
  #|-- full coefficients, alternating bits
  #|nextt121 nexttoward   268268268    268268268 ->   268268268
  #|nextt122 nexttoward  -268268268   -268268268 ->  -268268268
  #|nextt123 nexttoward   134134134    134134134 ->   134134134
  #|nextt124 nexttoward  -134134134   -134134134 ->  -134134134
  #|
  #|-- Nmax, Nmin, Ntiny
  #|nextt131 nexttoward  9.99999999E+384  9.99999999E+384   ->   9.99999999E+384
  #|nextt132 nexttoward  1E-383           1E-383            ->   1E-383
  #|nextt133 nexttoward  1.00000000E-383  1.00000000E-383   ->   1.00000000E-383
  #|nextt134 nexttoward  1E-391           1E-391            ->   1E-391
  #|
  #|nextt135 nexttoward  -1E-391          -1E-391           ->  -1E-391
  #|nextt136 nexttoward  -1.00000000E-383 -1.00000000E-383  ->  -1.00000000E-383
  #|nextt137 nexttoward  -1E-383          -1E-383           ->  -1E-383
  #|nextt138 nexttoward  -9.99999999E+384 -9.99999999E+384  ->  -9.99999999E+384
  #|
  #|------- lhs<rhs
  #|nextt201 nexttoward  0.999999995 Infinity ->   0.999999996
  #|nextt202 nexttoward  0.999999996 Infinity ->   0.999999997
  #|nextt203 nexttoward  0.999999997 Infinity ->   0.999999998
  #|nextt204 nexttoward  0.999999998 Infinity ->   0.999999999
  #|nextt205 nexttoward  0.999999999 Infinity ->   1.00000000
  #|nextt206 nexttoward  1.00000000  Infinity ->   1.00000001
  #|nextt207 nexttoward  1.0         Infinity ->   1.00000001
  #|nextt208 nexttoward  1           Infinity ->   1.00000001
  #|nextt209 nexttoward  1.00000001  Infinity ->   1.00000002
  #|nextt210 nexttoward  1.00000002  Infinity ->   1.00000003
  #|nextt211 nexttoward  1.00000003  Infinity ->   1.00000004
  #|nextt212 nexttoward  1.00000004  Infinity ->   1.00000005
  #|nextt213 nexttoward  1.00000005  Infinity ->   1.00000006
  #|nextt214 nexttoward  1.00000006  Infinity ->   1.00000007
  #|nextt215 nexttoward  1.00000007  Infinity ->   1.00000008
  #|nextt216 nexttoward  1.00000008  Infinity ->   1.00000009
  #|nextt217 nexttoward  1.00000009  Infinity ->   1.00000010
  #|nextt218 nexttoward  1.00000010  Infinity ->   1.00000011
  #|nextt219 nexttoward  1.00000011  Infinity ->   1.00000012
  #|
  #|nextt221 nexttoward -0.999999995 Infinity ->  -0.999999994
  #|nextt222 nexttoward -0.999999996 Infinity ->  -0.999999995
  #|nextt223 nexttoward -0.999999997 Infinity ->  -0.999999996
  #|nextt224 nexttoward -0.999999998 Infinity ->  -0.999999997
  #|nextt225 nexttoward -0.999999999 Infinity ->  -0.999999998
  #|nextt226 nexttoward -1.00000000  Infinity ->  -0.999999999
  #|nextt227 nexttoward -1.0         Infinity ->  -0.999999999
  #|nextt228 nexttoward -1           Infinity ->  -0.999999999
  #|nextt229 nexttoward -1.00000001  Infinity ->  -1.00000000
  #|nextt230 nexttoward -1.00000002  Infinity ->  -1.00000001
  #|nextt231 nexttoward -1.00000003  Infinity ->  -1.00000002
  #|nextt232 nexttoward -1.00000004  Infinity ->  -1.00000003
  #|nextt233 nexttoward -1.00000005  Infinity ->  -1.00000004
  #|nextt234 nexttoward -1.00000006  Infinity ->  -1.00000005
  #|nextt235 nexttoward -1.00000007  Infinity ->  -1.00000006
  #|nextt236 nexttoward -1.00000008  Infinity ->  -1.00000007
  #|nextt237 nexttoward -1.00000009  Infinity ->  -1.00000008
  #|nextt238 nexttoward -1.00000010  Infinity ->  -1.00000009
  #|nextt239 nexttoward -1.00000011  Infinity ->  -1.00000010
  #|nextt240 nexttoward -1.00000012  Infinity ->  -1.00000011
  #|
  #|-- input operand is >precision
  #|nextt241 nexttoward  1.00000010998  Infinity ->   1.00000011
  #|nextt242 nexttoward  1.00000010999  Infinity ->   1.00000011
  #|nextt243 nexttoward  1.00000011000  Infinity ->   1.00000012
  #|nextt244 nexttoward  1.00000011001  Infinity ->   1.00000012
  #|nextt245 nexttoward  1.00000011002  Infinity ->   1.00000012
  #|nextt246 nexttoward  1.00000011002  Infinity ->   1.00000012
  #|nextt247 nexttoward  1.00000011052  Infinity ->   1.00000012
  #|nextt248 nexttoward  1.00000011552  Infinity ->   1.00000012
  #|nextt249 nexttoward -1.00000010998  Infinity ->  -1.00000010
  #|nextt250 nexttoward -1.00000010999  Infinity ->  -1.00000010
  #|nextt251 nexttoward -1.00000011000  Infinity ->  -1.00000010
  #|nextt252 nexttoward -1.00000011001  Infinity ->  -1.00000011
  #|nextt253 nexttoward -1.00000011002  Infinity ->  -1.00000011
  #|nextt254 nexttoward -1.00000011002  Infinity ->  -1.00000011
  #|nextt255 nexttoward -1.00000011052  Infinity ->  -1.00000011
  #|nextt256 nexttoward -1.00000011552  Infinity ->  -1.00000011
  #|-- ultra-tiny inputs
  #|nextt260 nexttoward  1E-99999       Infinity ->   1E-391          Underflow Subnormal Inexact Rounded
  #|nextt261 nexttoward  1E-999999999   Infinity ->   1E-391          Underflow Subnormal Inexact Rounded
  #|nextt262 nexttoward  1E-391         Infinity ->   2E-391          Underflow Subnormal Inexact Rounded
  #|nextt263 nexttoward -1E-99999       Infinity ->  -0E-391          Underflow Subnormal Inexact Rounded Clamped
  #|nextt264 nexttoward -1E-999999999   Infinity ->  -0E-391          Underflow Subnormal Inexact Rounded Clamped
  #|nextt265 nexttoward -1E-391         Infinity ->  -0E-391          Underflow Subnormal Inexact Rounded Clamped
  #|
  #|-- Zeros
  #|nextt300 nexttoward  0           Infinity ->  1E-391              Underflow Subnormal Inexact Rounded
  #|nextt301 nexttoward  0.00        Infinity ->  1E-391              Underflow Subnormal Inexact Rounded
  #|nextt302 nexttoward  0E-300      Infinity ->  1E-391              Underflow Subnormal Inexact Rounded
  #|nextt303 nexttoward  0E+300      Infinity ->  1E-391              Underflow Subnormal Inexact Rounded
  #|nextt304 nexttoward  0E+30000    Infinity ->  1E-391              Underflow Subnormal Inexact Rounded
  #|nextt305 nexttoward -0           Infinity ->  1E-391              Underflow Subnormal Inexact Rounded
  #|nextt306 nexttoward -0.00        Infinity ->  1E-391              Underflow Subnormal Inexact Rounded
  #|nextt307 nexttoward -0E-300      Infinity ->  1E-391              Underflow Subnormal Inexact Rounded
  #|nextt308 nexttoward -0E+300      Infinity ->  1E-391              Underflow Subnormal Inexact Rounded
  #|nextt309 nexttoward -0E+30000    Infinity ->  1E-391              Underflow Subnormal Inexact Rounded
  #|
  #|-- specials
  #|nextt350 nexttoward   Inf    Infinity ->  Infinity
  #|nextt351 nexttoward  -Inf    Infinity -> -9.99999999E+384
  #|nextt352 nexttoward   NaN    Infinity ->  NaN
  #|nextt353 nexttoward  sNaN    Infinity ->  NaN   Invalid_operation
  #|nextt354 nexttoward   NaN77  Infinity ->  NaN77
  #|nextt355 nexttoward  sNaN88  Infinity ->  NaN88 Invalid_operation
  #|nextt356 nexttoward  -NaN    Infinity -> -NaN
  #|nextt357 nexttoward -sNaN    Infinity -> -NaN   Invalid_operation
  #|nextt358 nexttoward  -NaN77  Infinity -> -NaN77
  #|nextt359 nexttoward -sNaN88  Infinity -> -NaN88 Invalid_operation
  #|
  #|-- Nmax, Nmin, Ntiny, subnormals
  #|maxExponent: 999
  #|minexponent: -999
  #|nextt370 nexttoward  9.99999999E+999   Infinity -> Infinity        Overflow Inexact Rounded
  #|nextt371 nexttoward  9.99999998E+999   Infinity -> 9.99999999E+999
  #|nextt372 nexttoward  1E-999            Infinity -> 1.00000001E-999
  #|nextt373 nexttoward  1.00000000E-999   Infinity -> 1.00000001E-999
  #|nextt374 nexttoward  0.999999999E-999  Infinity -> 1.00000000E-999
  #|nextt375 nexttoward  0.99999999E-999   Infinity -> 1.00000000E-999
  #|nextt376 nexttoward  9E-1007           Infinity -> 1.0E-1006       Underflow Subnormal Inexact Rounded
  #|nextt377 nexttoward  9.9E-1006         Infinity -> 1.00E-1005      Underflow Subnormal Inexact Rounded
  #|nextt378 nexttoward  9.9999E-1003      Infinity -> 1.00000E-1002   Underflow Subnormal Inexact Rounded
  #|nextt379 nexttoward  9.9999998E-1000   Infinity -> 9.9999999E-1000 Underflow Subnormal Inexact Rounded
  #|nextt380 nexttoward  9.9999997E-1000   Infinity -> 9.9999998E-1000 Underflow Subnormal Inexact Rounded
  #|nextt381 nexttoward  0E-1007           Infinity -> 1E-1007         Underflow Subnormal Inexact Rounded
  #|nextt382 nexttoward  1E-1007           Infinity -> 2E-1007         Underflow Subnormal Inexact Rounded
  #|nextt383 nexttoward  2E-1007           Infinity -> 3E-1007         Underflow Subnormal Inexact Rounded
  #|
  #|nextt385 nexttoward  -0E-1007          Infinity ->  1E-1007        Underflow Subnormal Inexact Rounded
  #|nextt386 nexttoward  -1E-1007          Infinity -> -0E-1007        Underflow Subnormal Inexact Rounded Clamped
  #|nextt387 nexttoward  -2E-1007          Infinity -> -1E-1007        Underflow Subnormal Inexact Rounded
  #|nextt388 nexttoward  -10E-1007         Infinity -> -9E-1007        Underflow Subnormal Inexact Rounded
  #|nextt389 nexttoward  -100E-1007        Infinity -> -9.9E-1006      Underflow Subnormal Inexact Rounded
  #|nextt390 nexttoward  -100000E-1007     Infinity -> -9.9999E-1003   Underflow Subnormal Inexact Rounded
  #|nextt391 nexttoward  -1.0000E-999      Infinity -> -9.9999999E-1000  Underflow Subnormal Inexact Rounded
  #|nextt392 nexttoward  -1.00000000E-999  Infinity -> -9.9999999E-1000  Underflow Subnormal Inexact Rounded
  #|nextt393 nexttoward  -1E-999           Infinity -> -9.9999999E-1000  Underflow Subnormal Inexact Rounded
  #|nextt394 nexttoward  -9.99999998E+999  Infinity -> -9.99999997E+999
  #|nextt395 nexttoward  -9.99999999E+999  Infinity -> -9.99999998E+999
  #|
  #|------- lhs>rhs
  #|maxExponent: 384
  #|minexponent: -383
  #|nextt401 nexttoward  0.999999995  -Infinity ->   0.999999994
  #|nextt402 nexttoward  0.999999996  -Infinity ->   0.999999995
  #|nextt403 nexttoward  0.999999997  -Infinity ->   0.999999996
  #|nextt404 nexttoward  0.999999998  -Infinity ->   0.999999997
  #|nextt405 nexttoward  0.999999999  -Infinity ->   0.999999998
  #|nextt406 nexttoward  1.00000000   -Infinity ->   0.999999999
  #|nextt407 nexttoward  1.0          -Infinity ->   0.999999999
  #|nextt408 nexttoward  1            -Infinity ->   0.999999999
  #|nextt409 nexttoward  1.00000001   -Infinity ->   1.00000000
  #|nextt410 nexttoward  1.00000002   -Infinity ->   1.00000001
  #|nextt411 nexttoward  1.00000003   -Infinity ->   1.00000002
  #|nextt412 nexttoward  1.00000004   -Infinity ->   1.00000003
  #|nextt413 nexttoward  1.00000005   -Infinity ->   1.00000004
  #|nextt414 nexttoward  1.00000006   -Infinity ->   1.00000005
  #|nextt415 nexttoward  1.00000007   -Infinity ->   1.00000006
  #|nextt416 nexttoward  1.00000008   -Infinity ->   1.00000007
  #|nextt417 nexttoward  1.00000009   -Infinity ->   1.00000008
  #|nextt418 nexttoward  1.00000010   -Infinity ->   1.00000009
  #|nextt419 nexttoward  1.00000011   -Infinity ->   1.00000010
  #|nextt420 nexttoward  1.00000012   -Infinity ->   1.00000011
  #|
  #|nextt421 nexttoward -0.999999995  -Infinity ->  -0.999999996
  #|nextt422 nexttoward -0.999999996  -Infinity ->  -0.999999997
  #|nextt423 nexttoward -0.999999997  -Infinity ->  -0.999999998
  #|nextt424 nexttoward -0.999999998  -Infinity ->  -0.999999999
  #|nextt425 nexttoward -0.999999999  -Infinity ->  -1.00000000
  #|nextt426 nexttoward -1.00000000   -Infinity ->  -1.00000001
  #|nextt427 nexttoward -1.0          -Infinity ->  -1.00000001
  #|nextt428 nexttoward -1            -Infinity ->  -1.00000001
  #|nextt429 nexttoward -1.00000001   -Infinity ->  -1.00000002
  #|nextt430 nexttoward -1.00000002   -Infinity ->  -1.00000003
  #|nextt431 nexttoward -1.00000003   -Infinity ->  -1.00000004
  #|nextt432 nexttoward -1.00000004   -Infinity ->  -1.00000005
  #|nextt433 nexttoward -1.00000005   -Infinity ->  -1.00000006
  #|nextt434 nexttoward -1.00000006   -Infinity ->  -1.00000007
  #|nextt435 nexttoward -1.00000007   -Infinity ->  -1.00000008
  #|nextt436 nexttoward -1.00000008   -Infinity ->  -1.00000009
  #|nextt437 nexttoward -1.00000009   -Infinity ->  -1.00000010
  #|nextt438 nexttoward -1.00000010   -Infinity ->  -1.00000011
  #|nextt439 nexttoward -1.00000011   -Infinity ->  -1.00000012
  #|
  #|-- input operand is >precision
  #|nextt441 nexttoward  1.00000010998   -Infinity ->   1.00000010
  #|nextt442 nexttoward  1.00000010999   -Infinity ->   1.00000010
  #|nextt443 nexttoward  1.00000011000   -Infinity ->   1.00000010
  #|nextt444 nexttoward  1.00000011001   -Infinity ->   1.00000011
  #|nextt445 nexttoward  1.00000011002   -Infinity ->   1.00000011
  #|nextt446 nexttoward  1.00000011002   -Infinity ->   1.00000011
  #|nextt447 nexttoward  1.00000011052   -Infinity ->   1.00000011
  #|nextt448 nexttoward  1.00000011552   -Infinity ->   1.00000011
  #|nextt449 nexttoward -1.00000010998   -Infinity ->  -1.00000011
  #|nextt450 nexttoward -1.00000010999   -Infinity ->  -1.00000011
  #|nextt451 nexttoward -1.00000011000   -Infinity ->  -1.00000012
  #|nextt452 nexttoward -1.00000011001   -Infinity ->  -1.00000012
  #|nextt453 nexttoward -1.00000011002   -Infinity ->  -1.00000012
  #|nextt454 nexttoward -1.00000011002   -Infinity ->  -1.00000012
  #|nextt455 nexttoward -1.00000011052   -Infinity ->  -1.00000012
  #|nextt456 nexttoward -1.00000011552   -Infinity ->  -1.00000012
  #|-- ultra-tiny inputs
  #|nextt460 nexttoward  1E-99999        -Infinity ->   0E-391     Underflow Subnormal Inexact Rounded Clamped
  #|nextt461 nexttoward  1E-999999999    -Infinity ->   0E-391     Underflow Subnormal Inexact Rounded Clamped
  #|nextt462 nexttoward  1E-391          -Infinity ->   0E-391     Underflow Subnormal Inexact Rounded Clamped
  #|nextt463 nexttoward -1E-99999        -Infinity ->  -1E-391     Underflow Subnormal Inexact Rounded
  #|nextt464 nexttoward -1E-999999999    -Infinity ->  -1E-391     Underflow Subnormal Inexact Rounded
  #|nextt465 nexttoward -1E-391          -Infinity ->  -2E-391     Underflow Subnormal Inexact Rounded
  #|
  #|-- Zeros
  #|nextt500 nexttoward -0            -Infinity -> -1E-391         Underflow Subnormal Inexact Rounded
  #|nextt501 nexttoward  0            -Infinity -> -1E-391         Underflow Subnormal Inexact Rounded
  #|nextt502 nexttoward  0.00         -Infinity -> -1E-391         Underflow Subnormal Inexact Rounded
  #|nextt503 nexttoward -0.00         -Infinity -> -1E-391         Underflow Subnormal Inexact Rounded
  #|nextt504 nexttoward  0E-300       -Infinity -> -1E-391         Underflow Subnormal Inexact Rounded
  #|nextt505 nexttoward  0E+300       -Infinity -> -1E-391         Underflow Subnormal Inexact Rounded
  #|nextt506 nexttoward  0E+30000     -Infinity -> -1E-391         Underflow Subnormal Inexact Rounded
  #|nextt507 nexttoward -0E+30000     -Infinity -> -1E-391         Underflow Subnormal Inexact Rounded
  #|nextt508 nexttoward  0.00         -0.0000   -> -0.00
  #|
  #|-- specials
  #|nextt550 nexttoward   Inf     -Infinity ->  9.99999999E+384
  #|nextt551 nexttoward  -Inf     -Infinity -> -Infinity
  #|nextt552 nexttoward   NaN     -Infinity ->  NaN
  #|nextt553 nexttoward  sNaN     -Infinity ->  NaN   Invalid_operation
  #|nextt554 nexttoward   NaN77   -Infinity ->  NaN77
  #|nextt555 nexttoward  sNaN88   -Infinity ->  NaN88 Invalid_operation
  #|nextt556 nexttoward  -NaN     -Infinity -> -NaN
  #|nextt557 nexttoward -sNaN     -Infinity -> -NaN   Invalid_operation
  #|nextt558 nexttoward  -NaN77   -Infinity -> -NaN77
  #|nextt559 nexttoward -sNaN88   -Infinity -> -NaN88 Invalid_operation
  #|
  #|-- Nmax, Nmin, Ntiny, subnormals
  #|maxExponent: 999
  #|minexponent: -999
  #|nextt570 nexttoward  9.99999999E+999    -Infinity -> 9.99999998E+999
  #|nextt571 nexttoward  9.99999998E+999    -Infinity -> 9.99999997E+999
  #|nextt572 nexttoward  1E-999             -Infinity -> 9.9999999E-1000 Underflow Subnormal Inexact Rounded
  #|nextt573 nexttoward  1.00000000E-999    -Infinity -> 9.9999999E-1000 Underflow Subnormal Inexact Rounded
  #|nextt574 nexttoward  9E-1007            -Infinity -> 8E-1007         Underflow Subnormal Inexact Rounded
  #|nextt575 nexttoward  9.9E-1006          -Infinity -> 9.8E-1006       Underflow Subnormal Inexact Rounded
  #|nextt576 nexttoward  9.9999E-1003       -Infinity -> 9.9998E-1003    Underflow Subnormal Inexact Rounded
  #|nextt577 nexttoward  9.9999999E-1000    -Infinity -> 9.9999998E-1000 Underflow Subnormal Inexact Rounded
  #|nextt578 nexttoward  9.9999998E-1000    -Infinity -> 9.9999997E-1000 Underflow Subnormal Inexact Rounded
  #|nextt579 nexttoward  9.9999997E-1000    -Infinity -> 9.9999996E-1000 Underflow Subnormal Inexact Rounded
  #|nextt580 nexttoward  0E-1007            -Infinity -> -1E-1007        Underflow Subnormal Inexact Rounded
  #|nextt581 nexttoward  1E-1007            -Infinity -> 0E-1007         Underflow Subnormal Inexact Rounded Clamped
  #|nextt582 nexttoward  2E-1007            -Infinity -> 1E-1007         Underflow Subnormal Inexact Rounded
  #|
  #|nextt583 nexttoward  -0E-1007           -Infinity -> -1E-1007        Underflow Subnormal Inexact Rounded
  #|nextt584 nexttoward  -1E-1007           -Infinity -> -2E-1007        Underflow Subnormal Inexact Rounded
  #|nextt585 nexttoward  -2E-1007           -Infinity -> -3E-1007        Underflow Subnormal Inexact Rounded
  #|nextt586 nexttoward  -10E-1007          -Infinity -> -1.1E-1006      Underflow Subnormal Inexact Rounded
  #|nextt587 nexttoward  -100E-1007         -Infinity -> -1.01E-1005     Underflow Subnormal Inexact Rounded
  #|nextt588 nexttoward  -100000E-1007      -Infinity -> -1.00001E-1002  Underflow Subnormal Inexact Rounded
  #|nextt589 nexttoward  -1.0000E-999       -Infinity -> -1.00000001E-999
  #|nextt590 nexttoward  -1.00000000E-999   -Infinity -> -1.00000001E-999
  #|nextt591 nexttoward  -1E-999            -Infinity -> -1.00000001E-999
  #|nextt592 nexttoward  -9.99999998E+999   -Infinity -> -9.99999999E+999
  #|nextt593 nexttoward  -9.99999999E+999   -Infinity -> -Infinity Overflow Inexact Rounded
  #|
  #|
  #|
  #|
  #|------- Specials
  #|maxExponent: 384
  #|minexponent: -383
  #|nextt780 nexttoward -Inf  -Inf   -> -Infinity
  #|nextt781 nexttoward -Inf  -1000  -> -9.99999999E+384
  #|nextt782 nexttoward -Inf  -1     -> -9.99999999E+384
  #|nextt783 nexttoward -Inf  -0     -> -9.99999999E+384
  #|nextt784 nexttoward -Inf   0     -> -9.99999999E+384
  #|nextt785 nexttoward -Inf   1     -> -9.99999999E+384
  #|nextt786 nexttoward -Inf   1000  -> -9.99999999E+384
  #|nextt787 nexttoward -1000 -Inf   -> -1000.00001
  #|nextt788 nexttoward -Inf  -Inf   -> -Infinity
  #|nextt789 nexttoward -1    -Inf   -> -1.00000001
  #|nextt790 nexttoward -0    -Inf   -> -1E-391           Underflow Subnormal Inexact Rounded
  #|nextt791 nexttoward  0    -Inf   -> -1E-391           Underflow Subnormal Inexact Rounded
  #|nextt792 nexttoward  1    -Inf   ->  0.999999999
  #|nextt793 nexttoward  1000 -Inf   ->  999.999999
  #|nextt794 nexttoward  Inf  -Inf   ->  9.99999999E+384
  #|
  #|nextt800 nexttoward  Inf  -Inf   ->  9.99999999E+384
  #|nextt801 nexttoward  Inf  -1000  ->  9.99999999E+384
  #|nextt802 nexttoward  Inf  -1     ->  9.99999999E+384
  #|nextt803 nexttoward  Inf  -0     ->  9.99999999E+384
  #|nextt804 nexttoward  Inf   0     ->  9.99999999E+384
  #|nextt805 nexttoward  Inf   1     ->  9.99999999E+384
  #|nextt806 nexttoward  Inf   1000  ->  9.99999999E+384
  #|nextt807 nexttoward  Inf   Inf   ->  Infinity
  #|nextt808 nexttoward -1000  Inf   -> -999.999999
  #|nextt809 nexttoward -Inf   Inf   -> -9.99999999E+384
  #|nextt810 nexttoward -1     Inf   -> -0.999999999
  #|nextt811 nexttoward -0     Inf   ->  1E-391           Underflow Subnormal Inexact Rounded
  #|nextt812 nexttoward  0     Inf   ->  1E-391           Underflow Subnormal Inexact Rounded
  #|nextt813 nexttoward  1     Inf   ->  1.00000001
  #|nextt814 nexttoward  1000  Inf   ->  1000.00001
  #|nextt815 nexttoward  Inf   Inf   ->  Infinity
  #|
  #|nextt821 nexttoward  NaN -Inf    ->  NaN
  #|nextt822 nexttoward  NaN -1000   ->  NaN
  #|nextt823 nexttoward  NaN -1      ->  NaN
  #|nextt824 nexttoward  NaN -0      ->  NaN
  #|nextt825 nexttoward  NaN  0      ->  NaN
  #|nextt826 nexttoward  NaN  1      ->  NaN
  #|nextt827 nexttoward  NaN  1000   ->  NaN
  #|nextt828 nexttoward  NaN  Inf    ->  NaN
  #|nextt829 nexttoward  NaN  NaN    ->  NaN
  #|nextt830 nexttoward -Inf  NaN    ->  NaN
  #|nextt831 nexttoward -1000 NaN    ->  NaN
  #|nextt832 nexttoward -1    NaN    ->  NaN
  #|nextt833 nexttoward -0    NaN    ->  NaN
  #|nextt834 nexttoward  0    NaN    ->  NaN
  #|nextt835 nexttoward  1    NaN    ->  NaN
  #|nextt836 nexttoward  1000 NaN    ->  NaN
  #|nextt837 nexttoward  Inf  NaN    ->  NaN
  #|
  #|nextt841 nexttoward  sNaN -Inf   ->  NaN  Invalid_operation
  #|nextt842 nexttoward  sNaN -1000  ->  NaN  Invalid_operation
  #|nextt843 nexttoward  sNaN -1     ->  NaN  Invalid_operation
  #|nextt844 nexttoward  sNaN -0     ->  NaN  Invalid_operation
  #|nextt845 nexttoward  sNaN  0     ->  NaN  Invalid_operation
  #|nextt846 nexttoward  sNaN  1     ->  NaN  Invalid_operation
  #|nextt847 nexttoward  sNaN  1000  ->  NaN  Invalid_operation
  #|nextt848 nexttoward  sNaN  NaN   ->  NaN  Invalid_operation
  #|nextt849 nexttoward  sNaN sNaN   ->  NaN  Invalid_operation
  #|nextt850 nexttoward  NaN  sNaN   ->  NaN  Invalid_operation
  #|nextt851 nexttoward -Inf  sNaN   ->  NaN  Invalid_operation
  #|nextt852 nexttoward -1000 sNaN   ->  NaN  Invalid_operation
  #|nextt853 nexttoward -1    sNaN   ->  NaN  Invalid_operation
  #|nextt854 nexttoward -0    sNaN   ->  NaN  Invalid_operation
  #|nextt855 nexttoward  0    sNaN   ->  NaN  Invalid_operation
  #|nextt856 nexttoward  1    sNaN   ->  NaN  Invalid_operation
  #|nextt857 nexttoward  1000 sNaN   ->  NaN  Invalid_operation
  #|nextt858 nexttoward  Inf  sNaN   ->  NaN  Invalid_operation
  #|nextt859 nexttoward  NaN  sNaN   ->  NaN  Invalid_operation
  #|
  #|-- propagating NaNs
  #|nextt861 nexttoward  NaN1   -Inf    ->  NaN1
  #|nextt862 nexttoward +NaN2   -1000   ->  NaN2
  #|nextt863 nexttoward  NaN3    1000   ->  NaN3
  #|nextt864 nexttoward  NaN4    Inf    ->  NaN4
  #|nextt865 nexttoward  NaN5   +NaN6   ->  NaN5
  #|nextt866 nexttoward -Inf     NaN7   ->  NaN7
  #|nextt867 nexttoward -1000    NaN8   ->  NaN8
  #|nextt868 nexttoward  1000    NaN9   ->  NaN9
  #|nextt869 nexttoward  Inf    +NaN10  ->  NaN10
  #|nextt871 nexttoward  sNaN11  -Inf   ->  NaN11  Invalid_operation
  #|nextt872 nexttoward  sNaN12  -1000  ->  NaN12  Invalid_operation
  #|nextt873 nexttoward  sNaN13   1000  ->  NaN13  Invalid_operation
  #|nextt874 nexttoward  sNaN14   NaN17 ->  NaN14  Invalid_operation
  #|nextt875 nexttoward  sNaN15  sNaN18 ->  NaN15  Invalid_operation
  #|nextt876 nexttoward  NaN16   sNaN19 ->  NaN19  Invalid_operation
  #|nextt877 nexttoward -Inf    +sNaN20 ->  NaN20  Invalid_operation
  #|nextt878 nexttoward -1000    sNaN21 ->  NaN21  Invalid_operation
  #|nextt879 nexttoward  1000    sNaN22 ->  NaN22  Invalid_operation
  #|nextt880 nexttoward  Inf     sNaN23 ->  NaN23  Invalid_operation
  #|nextt881 nexttoward +NaN25  +sNaN24 ->  NaN24  Invalid_operation
  #|nextt882 nexttoward -NaN26    NaN28 -> -NaN26
  #|nextt883 nexttoward -sNaN27  sNaN29 -> -NaN27  Invalid_operation
  #|nextt884 nexttoward  1000    -NaN30 -> -NaN30
  #|nextt885 nexttoward  1000   -sNaN31 -> -NaN31  Invalid_operation
  #|
  #|-- Null tests
  #|nextt900 nexttoward 1  # -> NaN Invalid_operation
  #|nextt901 nexttoward #  1 -> NaN Invalid_operation

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
test "nextplus.decTest subset" {
  run_subset("nextplus", nextplus_subset)
}

///|
test "nextminus.decTest subset" {
  run_subset("nextminus", nextminus_subset)
}

///|
test "nexttoward.decTest subset" {
  run_subset("nexttoward", nexttoward_subset)
}
