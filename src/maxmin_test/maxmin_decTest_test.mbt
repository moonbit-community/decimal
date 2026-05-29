///|
/// Full `max.decTest` corpus (IBM General Decimal
/// Arithmetic testcases), embedded verbatim.
let max_subset : String =
  #|------------------------------------------------------------------------
  #|-- max.decTest -- decimal maximum                                     --
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
  #|-- we assume that base comparison is tested in compare.decTest, so
  #|-- these mainly cover special cases and rounding
  #|
  #|extended:    1
  #|precision:   9
  #|rounding:    half_up
  #|maxExponent: 384
  #|minexponent: -383
  #|
  #|-- sanity checks
  #|maxx001 max  -2  -2  -> -2
  #|maxx002 max  -2  -1  -> -1
  #|maxx003 max  -2   0  ->  0
  #|maxx004 max  -2   1  ->  1
  #|maxx005 max  -2   2  ->  2
  #|maxx006 max  -1  -2  -> -1
  #|maxx007 max  -1  -1  -> -1
  #|maxx008 max  -1   0  ->  0
  #|maxx009 max  -1   1  ->  1
  #|maxx010 max  -1   2  ->  2
  #|maxx011 max   0  -2  ->  0
  #|maxx012 max   0  -1  ->  0
  #|maxx013 max   0   0  ->  0
  #|maxx014 max   0   1  ->  1
  #|maxx015 max   0   2  ->  2
  #|maxx016 max   1  -2  ->  1
  #|maxx017 max   1  -1  ->  1
  #|maxx018 max   1   0  ->  1
  #|maxx019 max   1   1  ->  1
  #|maxx020 max   1   2  ->  2
  #|maxx021 max   2  -2  ->  2
  #|maxx022 max   2  -1  ->  2
  #|maxx023 max   2   0  ->  2
  #|maxx025 max   2   1  ->  2
  #|maxx026 max   2   2  ->  2
  #|
  #|-- extended zeros
  #|maxx030 max   0     0   ->  0
  #|maxx031 max   0    -0   ->  0
  #|maxx032 max   0    -0.0 ->  0
  #|maxx033 max   0     0.0 ->  0
  #|maxx034 max  -0     0   ->  0    -- note: -0 = 0, but 0 chosen
  #|maxx035 max  -0    -0   -> -0
  #|maxx036 max  -0    -0.0 -> -0.0
  #|maxx037 max  -0     0.0 ->  0.0
  #|maxx038 max   0.0   0   ->  0
  #|maxx039 max   0.0  -0   ->  0.0
  #|maxx040 max   0.0  -0.0 ->  0.0
  #|maxx041 max   0.0   0.0 ->  0.0
  #|maxx042 max  -0.0   0   ->  0
  #|maxx043 max  -0.0  -0   -> -0.0
  #|maxx044 max  -0.0  -0.0 -> -0.0
  #|maxx045 max  -0.0   0.0 ->  0.0
  #|
  #|maxx050 max  -0E1   0E1 ->  0E+1
  #|maxx051 max  -0E2   0E2 ->  0E+2
  #|maxx052 max  -0E2   0E1 ->  0E+1
  #|maxx053 max  -0E1   0E2 ->  0E+2
  #|maxx054 max   0E1  -0E1 ->  0E+1
  #|maxx055 max   0E2  -0E2 ->  0E+2
  #|maxx056 max   0E2  -0E1 ->  0E+2
  #|maxx057 max   0E1  -0E2 ->  0E+1
  #|
  #|maxx058 max   0E1   0E1 ->  0E+1
  #|maxx059 max   0E2   0E2 ->  0E+2
  #|maxx060 max   0E2   0E1 ->  0E+2
  #|maxx061 max   0E1   0E2 ->  0E+2
  #|maxx062 max  -0E1  -0E1 -> -0E+1
  #|maxx063 max  -0E2  -0E2 -> -0E+2
  #|maxx064 max  -0E2  -0E1 -> -0E+1
  #|maxx065 max  -0E1  -0E2 -> -0E+1
  #|
  #|-- Specials
  #|precision: 9
  #|maxx090 max  Inf  -Inf   ->  Infinity
  #|maxx091 max  Inf  -1000  ->  Infinity
  #|maxx092 max  Inf  -1     ->  Infinity
  #|maxx093 max  Inf  -0     ->  Infinity
  #|maxx094 max  Inf   0     ->  Infinity
  #|maxx095 max  Inf   1     ->  Infinity
  #|maxx096 max  Inf   1000  ->  Infinity
  #|maxx097 max  Inf   Inf   ->  Infinity
  #|maxx098 max -1000  Inf   ->  Infinity
  #|maxx099 max -Inf   Inf   ->  Infinity
  #|maxx100 max -1     Inf   ->  Infinity
  #|maxx101 max -0     Inf   ->  Infinity
  #|maxx102 max  0     Inf   ->  Infinity
  #|maxx103 max  1     Inf   ->  Infinity
  #|maxx104 max  1000  Inf   ->  Infinity
  #|maxx105 max  Inf   Inf   ->  Infinity
  #|
  #|maxx120 max -Inf  -Inf   -> -Infinity
  #|maxx121 max -Inf  -1000  -> -1000
  #|maxx122 max -Inf  -1     -> -1
  #|maxx123 max -Inf  -0     -> -0
  #|maxx124 max -Inf   0     ->  0
  #|maxx125 max -Inf   1     ->  1
  #|maxx126 max -Inf   1000  ->  1000
  #|maxx127 max -Inf   Inf   ->  Infinity
  #|maxx128 max -Inf  -Inf   ->  -Infinity
  #|maxx129 max -1000 -Inf   ->  -1000
  #|maxx130 max -1    -Inf   ->  -1
  #|maxx131 max -0    -Inf   ->  -0
  #|maxx132 max  0    -Inf   ->  0
  #|maxx133 max  1    -Inf   ->  1
  #|maxx134 max  1000 -Inf   ->  1000
  #|maxx135 max  Inf  -Inf   ->  Infinity
  #|
  #|-- 2004.08.02 754r chooses number over NaN in mixed cases
  #|maxx141 max  NaN -Inf    -> -Infinity
  #|maxx142 max  NaN -1000   -> -1000
  #|maxx143 max  NaN -1      -> -1
  #|maxx144 max  NaN -0      -> -0
  #|maxx145 max  NaN  0      ->  0
  #|maxx146 max  NaN  1      ->  1
  #|maxx147 max  NaN  1000   ->  1000
  #|maxx148 max  NaN  Inf    ->  Infinity
  #|maxx149 max  NaN  NaN    ->  NaN
  #|maxx150 max -Inf  NaN    -> -Infinity
  #|maxx151 max -1000 NaN    -> -1000
  #|maxx152 max -1    NaN    -> -1
  #|maxx153 max -0    NaN    -> -0
  #|maxx154 max  0    NaN    ->  0
  #|maxx155 max  1    NaN    ->  1
  #|maxx156 max  1000 NaN    ->  1000
  #|maxx157 max  Inf  NaN    ->  Infinity
  #|
  #|maxx161 max  sNaN -Inf   ->  NaN  Invalid_operation
  #|maxx162 max  sNaN -1000  ->  NaN  Invalid_operation
  #|maxx163 max  sNaN -1     ->  NaN  Invalid_operation
  #|maxx164 max  sNaN -0     ->  NaN  Invalid_operation
  #|maxx165 max  sNaN  0     ->  NaN  Invalid_operation
  #|maxx166 max  sNaN  1     ->  NaN  Invalid_operation
  #|maxx167 max  sNaN  1000  ->  NaN  Invalid_operation
  #|maxx168 max  sNaN  NaN   ->  NaN  Invalid_operation
  #|maxx169 max  sNaN sNaN   ->  NaN  Invalid_operation
  #|maxx170 max  NaN  sNaN   ->  NaN  Invalid_operation
  #|maxx171 max -Inf  sNaN   ->  NaN  Invalid_operation
  #|maxx172 max -1000 sNaN   ->  NaN  Invalid_operation
  #|maxx173 max -1    sNaN   ->  NaN  Invalid_operation
  #|maxx174 max -0    sNaN   ->  NaN  Invalid_operation
  #|maxx175 max  0    sNaN   ->  NaN  Invalid_operation
  #|maxx176 max  1    sNaN   ->  NaN  Invalid_operation
  #|maxx177 max  1000 sNaN   ->  NaN  Invalid_operation
  #|maxx178 max  Inf  sNaN   ->  NaN  Invalid_operation
  #|maxx179 max  NaN  sNaN   ->  NaN  Invalid_operation
  #|
  #|-- propagating NaNs
  #|maxx181 max  NaN9  -Inf   -> -Infinity
  #|maxx182 max  NaN8     9   ->  9
  #|maxx183 max -NaN7   Inf   ->  Infinity
  #|
  #|maxx184 max -NaN1   NaN11 -> -NaN1
  #|maxx185 max  NaN2   NaN12 ->  NaN2
  #|maxx186 max -NaN13 -NaN7  -> -NaN13
  #|maxx187 max  NaN14 -NaN5  ->  NaN14
  #|
  #|maxx188 max -Inf    NaN4  -> -Infinity
  #|maxx189 max -9     -NaN3  -> -9
  #|maxx190 max  Inf    NaN2  ->  Infinity
  #|
  #|maxx191 max  sNaN99 -Inf    ->  NaN99 Invalid_operation
  #|maxx192 max  sNaN98 -1      ->  NaN98 Invalid_operation
  #|maxx193 max -sNaN97  NaN    -> -NaN97 Invalid_operation
  #|maxx194 max  sNaN96 sNaN94  ->  NaN96 Invalid_operation
  #|maxx195 max  NaN95  sNaN93  ->  NaN93 Invalid_operation
  #|maxx196 max -Inf    sNaN92  ->  NaN92 Invalid_operation
  #|maxx197 max  0      sNaN91  ->  NaN91 Invalid_operation
  #|maxx198 max  Inf   -sNaN90  -> -NaN90 Invalid_operation
  #|maxx199 max  NaN    sNaN89  ->  NaN89 Invalid_operation
  #|
  #|-- rounding checks
  #|maxexponent: 999
  #|minexponent: -999
  #|precision: 9
  #|maxx201 max 12345678000 1  -> 1.23456780E+10 Rounded
  #|maxx202 max 1 12345678000  -> 1.23456780E+10 Rounded
  #|maxx203 max 1234567800  1  -> 1.23456780E+9 Rounded
  #|maxx204 max 1 1234567800   -> 1.23456780E+9 Rounded
  #|maxx205 max 1234567890  1  -> 1.23456789E+9 Rounded
  #|maxx206 max 1 1234567890   -> 1.23456789E+9 Rounded
  #|maxx207 max 1234567891  1  -> 1.23456789E+9 Inexact Rounded
  #|maxx208 max 1 1234567891   -> 1.23456789E+9 Inexact Rounded
  #|maxx209 max 12345678901 1  -> 1.23456789E+10 Inexact Rounded
  #|maxx210 max 1 12345678901  -> 1.23456789E+10 Inexact Rounded
  #|maxx211 max 1234567896  1  -> 1.23456790E+9 Inexact Rounded
  #|maxx212 max 1 1234567896   -> 1.23456790E+9 Inexact Rounded
  #|maxx213 max -1234567891  1 -> 1
  #|maxx214 max 1 -1234567891  -> 1
  #|maxx215 max -12345678901 1 -> 1
  #|maxx216 max 1 -12345678901 -> 1
  #|maxx217 max -1234567896  1 -> 1
  #|maxx218 max 1 -1234567896  -> 1
  #|
  #|precision: 15
  #|maxx221 max 12345678000 1  -> 12345678000
  #|maxx222 max 1 12345678000  -> 12345678000
  #|maxx223 max 1234567800  1  -> 1234567800
  #|maxx224 max 1 1234567800   -> 1234567800
  #|maxx225 max 1234567890  1  -> 1234567890
  #|maxx226 max 1 1234567890   -> 1234567890
  #|maxx227 max 1234567891  1  -> 1234567891
  #|maxx228 max 1 1234567891   -> 1234567891
  #|maxx229 max 12345678901 1  -> 12345678901
  #|maxx230 max 1 12345678901  -> 12345678901
  #|maxx231 max 1234567896  1  -> 1234567896
  #|maxx232 max 1 1234567896   -> 1234567896
  #|maxx233 max -1234567891  1 -> 1
  #|maxx234 max 1 -1234567891  -> 1
  #|maxx235 max -12345678901 1 -> 1
  #|maxx236 max 1 -12345678901 -> 1
  #|maxx237 max -1234567896  1 -> 1
  #|maxx238 max 1 -1234567896  -> 1
  #|
  #|-- from examples
  #|maxx280 max '3'   '2'  ->  '3'
  #|maxx281 max '-10' '3'  ->  '3'
  #|maxx282 max '1.0' '1'  ->  '1'
  #|maxx283 max '1' '1.0'  ->  '1'
  #|maxx284 max '7' 'NaN'  ->  '7'
  #|
  #|-- overflow and underflow tests ...
  #|maxExponent: 999999999
  #|minexponent: -999999999
  #|maxx330 max +1.23456789012345E-0 9E+999999999 ->  9E+999999999
  #|maxx331 max 9E+999999999 +1.23456789012345E-0 ->  9E+999999999
  #|maxx332 max +0.100 9E-999999999               ->  0.100
  #|maxx333 max 9E-999999999 +0.100               ->  0.100
  #|maxx335 max -1.23456789012345E-0 9E+999999999 ->  9E+999999999
  #|maxx336 max 9E+999999999 -1.23456789012345E-0 ->  9E+999999999
  #|maxx337 max -0.100 9E-999999999               ->  9E-999999999
  #|maxx338 max 9E-999999999 -0.100               ->  9E-999999999
  #|
  #|maxx339 max 1e-599999999 1e-400000001   ->  1E-400000001
  #|maxx340 max 1e-599999999 1e-400000000   ->  1E-400000000
  #|maxx341 max 1e-600000000 1e-400000000   ->  1E-400000000
  #|maxx342 max 9e-999999998 0.01           ->  0.01
  #|maxx343 max 9e-999999998 0.1            ->  0.1
  #|maxx344 max 0.01 9e-999999998           ->  0.01
  #|maxx345 max 1e599999999 1e400000001     ->  1E+599999999
  #|maxx346 max 1e599999999 1e400000000     ->  1E+599999999
  #|maxx347 max 1e600000000 1e400000000     ->  1E+600000000
  #|maxx348 max 9e999999998 100             ->  9E+999999998
  #|maxx349 max 9e999999998 10              ->  9E+999999998
  #|maxx350 max 100  9e999999998            ->  9E+999999998
  #|-- signs
  #|maxx351 max  1e+777777777  1e+411111111 ->  1E+777777777
  #|maxx352 max  1e+777777777 -1e+411111111 ->  1E+777777777
  #|maxx353 max -1e+777777777  1e+411111111 ->  1E+411111111
  #|maxx354 max -1e+777777777 -1e+411111111 -> -1E+411111111
  #|maxx355 max  1e-777777777  1e-411111111 ->  1E-411111111
  #|maxx356 max  1e-777777777 -1e-411111111 ->  1E-777777777
  #|maxx357 max -1e-777777777  1e-411111111 ->  1E-411111111
  #|maxx358 max -1e-777777777 -1e-411111111 -> -1E-777777777
  #|
  #|-- expanded list from min/max 754r purple prose
  #|-- [explicit tests for exponent ordering]
  #|maxx401 max  Inf    1.1     ->  Infinity
  #|maxx402 max  1.1    1       ->  1.1
  #|maxx403 max  1      1.0     ->  1
  #|maxx404 max  1.0    0.1     ->  1.0
  #|maxx405 max  0.1    0.10    ->  0.1
  #|maxx406 max  0.10   0.100   ->  0.10
  #|maxx407 max  0.10   0       ->  0.10
  #|maxx408 max  0      0.0     ->  0
  #|maxx409 max  0.0   -0       ->  0.0
  #|maxx410 max  0.0   -0.0     ->  0.0
  #|maxx411 max  0.00  -0.0     ->  0.00
  #|maxx412 max  0.0   -0.00    ->  0.0
  #|maxx413 max  0     -0.0     ->  0
  #|maxx414 max  0     -0       ->  0
  #|maxx415 max -0.0   -0       -> -0.0
  #|maxx416 max -0     -0.100   -> -0
  #|maxx417 max -0.100 -0.10    -> -0.100
  #|maxx418 max -0.10  -0.1     -> -0.10
  #|maxx419 max -0.1   -1.0     -> -0.1
  #|maxx420 max -1.0   -1       -> -1.0
  #|maxx421 max -1     -1.1     -> -1
  #|maxx423 max -1.1   -Inf     -> -1.1
  #|-- same with operands reversed
  #|maxx431 max  1.1    Inf     ->  Infinity
  #|maxx432 max  1      1.1     ->  1.1
  #|maxx433 max  1.0    1       ->  1
  #|maxx434 max  0.1    1.0     ->  1.0
  #|maxx435 max  0.10   0.1     ->  0.1
  #|maxx436 max  0.100  0.10    ->  0.10
  #|maxx437 max  0      0.10    ->  0.10
  #|maxx438 max  0.0    0       ->  0
  #|maxx439 max -0      0.0     ->  0.0
  #|maxx440 max -0.0    0.0     ->  0.0
  #|maxx441 max -0.0    0.00    ->  0.00
  #|maxx442 max -0.00   0.0     ->  0.0
  #|maxx443 max -0.0    0       ->  0
  #|maxx444 max -0      0       ->  0
  #|maxx445 max -0     -0.0     -> -0.0
  #|maxx446 max -0.100 -0       -> -0
  #|maxx447 max -0.10  -0.100   -> -0.100
  #|maxx448 max -0.1   -0.10    -> -0.10
  #|maxx449 max -1.0   -0.1     -> -0.1
  #|maxx450 max -1     -1.0     -> -1.0
  #|maxx451 max -1.1   -1       -> -1
  #|maxx453 max -Inf   -1.1     -> -1.1
  #|-- largies
  #|maxx460 max  1000   1E+3    ->  1E+3
  #|maxx461 max  1E+3   1000    ->  1E+3
  #|maxx462 max  1000  -1E+3    ->  1000
  #|maxx463 max  1E+3  -1000    ->  1E+3
  #|maxx464 max -1000   1E+3    ->  1E+3
  #|maxx465 max -1E+3   1000    ->  1000
  #|maxx466 max -1000  -1E+3    -> -1000
  #|maxx467 max -1E+3  -1000    -> -1000
  #|
  #|-- rounding (results treated as though plus)
  #|maxexponent: 999999999
  #|minexponent: -999999999
  #|precision: 3
  #|
  #|maxx470 max  1      .5     ->  1
  #|maxx471 max  10     5      ->  10
  #|maxx472 max  100    50     ->  100
  #|maxx473 max  1000   500    ->  1.00E+3 Rounded
  #|maxx474 max  10000  5000   ->  1.00E+4 Rounded
  #|maxx475 max  6      .5     ->  6
  #|maxx476 max  66     5      ->  66
  #|maxx477 max  666    50     ->  666
  #|maxx478 max  6666   500    ->  6.67E+3 Rounded Inexact
  #|maxx479 max  66666  5000   ->  6.67E+4 Rounded Inexact
  #|maxx480 max  33333  5000   ->  3.33E+4 Rounded Inexact
  #|maxx481 max  .5     1      ->  1
  #|maxx482 max  .5     10     ->  10
  #|maxx483 max  .5     100    ->  100
  #|maxx484 max  .5     1000   ->  1.00E+3 Rounded
  #|maxx485 max  .5     10000  ->  1.00E+4 Rounded
  #|maxx486 max  .5     6      ->  6
  #|maxx487 max  .5     66     ->  66
  #|maxx488 max  .5     666    ->  666
  #|maxx489 max  .5     6666   ->  6.67E+3 Rounded Inexact
  #|maxx490 max  .5     66666  ->  6.67E+4 Rounded Inexact
  #|maxx491 max  .5     33333  ->  3.33E+4 Rounded Inexact
  #|
  #|-- overflow tests
  #|maxexponent: 999999999
  #|minexponent: -999999999
  #|precision: 3
  #|maxx500 max 9.999E+999999999  0 ->  Infinity Inexact Overflow Rounded
  #|maxx501 max -9.999E+999999999 0 ->  0
  #|
  #|-- subnormals and underflow
  #|precision: 3
  #|maxexponent: 999
  #|minexponent: -999
  #|maxx510 max  1.00E-999       0  ->   1.00E-999
  #|maxx511 max  0.1E-999        0  ->   1E-1000   Subnormal
  #|maxx512 max  0.10E-999       0  ->   1.0E-1000 Subnormal
  #|maxx513 max  0.100E-999      0  ->   1.0E-1000 Subnormal Rounded
  #|maxx514 max  0.01E-999       0  ->   1E-1001   Subnormal
  #|-- next is rounded to Nmin
  #|maxx515 max  0.999E-999      0  ->   1.00E-999 Inexact Rounded Subnormal Underflow
  #|maxx516 max  0.099E-999      0  ->   1.0E-1000 Inexact Rounded Subnormal Underflow
  #|maxx517 max  0.009E-999      0  ->   1E-1001   Inexact Rounded Subnormal Underflow
  #|maxx518 max  0.001E-999      0  ->   0E-1001   Inexact Rounded Subnormal Underflow Clamped
  #|maxx519 max  0.0009E-999     0  ->   0E-1001   Inexact Rounded Subnormal Underflow Clamped
  #|maxx520 max  0.0001E-999     0  ->   0E-1001   Inexact Rounded Subnormal Underflow Clamped
  #|
  #|maxx530 max -1.00E-999       0  ->   0
  #|maxx531 max -0.1E-999        0  ->   0
  #|maxx532 max -0.10E-999       0  ->   0
  #|maxx533 max -0.100E-999      0  ->   0
  #|maxx534 max -0.01E-999       0  ->   0
  #|maxx535 max -0.999E-999      0  ->   0
  #|maxx536 max -0.099E-999      0  ->   0
  #|maxx537 max -0.009E-999      0  ->   0
  #|maxx538 max -0.001E-999      0  ->   0
  #|maxx539 max -0.0009E-999     0  ->   0
  #|maxx540 max -0.0001E-999     0  ->   0
  #|
  #|-- misalignment traps for little-endian
  #|precision: 9
  #|maxx551 max      1.0       0.1  -> 1.0
  #|maxx552 max      0.1       1.0  -> 1.0
  #|maxx553 max     10.0       0.1  -> 10.0
  #|maxx554 max      0.1      10.0  -> 10.0
  #|maxx555 max      100       1.0  -> 100
  #|maxx556 max      1.0       100  -> 100
  #|maxx557 max     1000      10.0  -> 1000
  #|maxx558 max     10.0      1000  -> 1000
  #|maxx559 max    10000     100.0  -> 10000
  #|maxx560 max    100.0     10000  -> 10000
  #|maxx661 max   100000    1000.0  -> 100000
  #|maxx662 max   1000.0    100000  -> 100000
  #|maxx663 max  1000000   10000.0  -> 1000000
  #|maxx664 max  10000.0   1000000  -> 1000000
  #|
  #|-- payload decapitate
  #|precision: 5
  #|maxx670 max      11 -sNaN12345678901 -> -NaN78901  Invalid_operation
  #|
  #|-- Null tests
  #|maxx900 max 10  #  -> NaN Invalid_operation
  #|maxx901 max  # 10  -> NaN Invalid_operation

///|
/// Full `min.decTest` corpus (IBM General Decimal
/// Arithmetic testcases), embedded verbatim.
let min_subset : String =
  #|------------------------------------------------------------------------
  #|-- min.decTest -- decimal minimum                                     --
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
  #|-- we assume that base comparison is tested in compare.decTest, so
  #|-- these mainly cover special cases and rounding
  #|
  #|extended:    1
  #|precision:   9
  #|rounding:    half_up
  #|maxExponent: 384
  #|minexponent: -383
  #|
  #|-- sanity checks
  #|mnmx001 min  -2  -2  -> -2
  #|mnmx002 min  -2  -1  -> -2
  #|mnmx003 min  -2   0  -> -2
  #|mnmx004 min  -2   1  -> -2
  #|mnmx005 min  -2   2  -> -2
  #|mnmx006 min  -1  -2  -> -2
  #|mnmx007 min  -1  -1  -> -1
  #|mnmx008 min  -1   0  -> -1
  #|mnmx009 min  -1   1  -> -1
  #|mnmx010 min  -1   2  -> -1
  #|mnmx011 min   0  -2  -> -2
  #|mnmx012 min   0  -1  -> -1
  #|mnmx013 min   0   0  ->  0
  #|mnmx014 min   0   1  ->  0
  #|mnmx015 min   0   2  ->  0
  #|mnmx016 min   1  -2  -> -2
  #|mnmx017 min   1  -1  -> -1
  #|mnmx018 min   1   0  ->  0
  #|mnmx019 min   1   1  ->  1
  #|mnmx020 min   1   2  ->  1
  #|mnmx021 min   2  -2  -> -2
  #|mnmx022 min   2  -1  -> -1
  #|mnmx023 min   2   0  ->  0
  #|mnmx025 min   2   1  ->  1
  #|mnmx026 min   2   2  ->  2
  #|
  #|-- extended zeros
  #|mnmx030 min   0     0   ->  0
  #|mnmx031 min   0    -0   -> -0
  #|mnmx032 min   0    -0.0 -> -0.0
  #|mnmx033 min   0     0.0 ->  0.0
  #|mnmx034 min  -0     0   -> -0
  #|mnmx035 min  -0    -0   -> -0
  #|mnmx036 min  -0    -0.0 -> -0
  #|mnmx037 min  -0     0.0 -> -0
  #|mnmx038 min   0.0   0   ->  0.0
  #|mnmx039 min   0.0  -0   -> -0
  #|mnmx040 min   0.0  -0.0 -> -0.0
  #|mnmx041 min   0.0   0.0 ->  0.0
  #|mnmx042 min  -0.0   0   -> -0.0
  #|mnmx043 min  -0.0  -0   -> -0
  #|mnmx044 min  -0.0  -0.0 -> -0.0
  #|mnmx045 min  -0.0   0.0 -> -0.0
  #|
  #|mnmx046 min   0E1  -0E1 -> -0E+1
  #|mnmx047 min  -0E1   0E2 -> -0E+1
  #|mnmx048 min   0E2   0E1 ->  0E+1
  #|mnmx049 min   0E1   0E2 ->  0E+1
  #|mnmx050 min  -0E3  -0E2 -> -0E+3
  #|mnmx051 min  -0E2  -0E3 -> -0E+3
  #|
  #|-- Specials
  #|precision: 9
  #|mnmx090 min  Inf  -Inf   -> -Infinity
  #|mnmx091 min  Inf  -1000  -> -1000
  #|mnmx092 min  Inf  -1     -> -1
  #|mnmx093 min  Inf  -0     -> -0
  #|mnmx094 min  Inf   0     ->  0
  #|mnmx095 min  Inf   1     ->  1
  #|mnmx096 min  Inf   1000  ->  1000
  #|mnmx097 min  Inf   Inf   ->  Infinity
  #|mnmx098 min -1000  Inf   -> -1000
  #|mnmx099 min -Inf   Inf   -> -Infinity
  #|mnmx100 min -1     Inf   -> -1
  #|mnmx101 min -0     Inf   -> -0
  #|mnmx102 min  0     Inf   ->  0
  #|mnmx103 min  1     Inf   ->  1
  #|mnmx104 min  1000  Inf   ->  1000
  #|mnmx105 min  Inf   Inf   ->  Infinity
  #|
  #|mnmx120 min -Inf  -Inf   -> -Infinity
  #|mnmx121 min -Inf  -1000  -> -Infinity
  #|mnmx122 min -Inf  -1     -> -Infinity
  #|mnmx123 min -Inf  -0     -> -Infinity
  #|mnmx124 min -Inf   0     -> -Infinity
  #|mnmx125 min -Inf   1     -> -Infinity
  #|mnmx126 min -Inf   1000  -> -Infinity
  #|mnmx127 min -Inf   Inf   -> -Infinity
  #|mnmx128 min -Inf  -Inf   -> -Infinity
  #|mnmx129 min -1000 -Inf   -> -Infinity
  #|mnmx130 min -1    -Inf   -> -Infinity
  #|mnmx131 min -0    -Inf   -> -Infinity
  #|mnmx132 min  0    -Inf   -> -Infinity
  #|mnmx133 min  1    -Inf   -> -Infinity
  #|mnmx134 min  1000 -Inf   -> -Infinity
  #|mnmx135 min  Inf  -Inf   -> -Infinity
  #|
  #|-- 2004.08.02 754r chooses number over NaN in mixed cases
  #|mnmx141 min  NaN -Inf    ->  -Infinity
  #|mnmx142 min  NaN -1000   ->  -1000
  #|mnmx143 min  NaN -1      ->  -1
  #|mnmx144 min  NaN -0      ->  -0
  #|mnmx145 min  NaN  0      ->  0
  #|mnmx146 min  NaN  1      ->  1
  #|mnmx147 min  NaN  1000   ->  1000
  #|mnmx148 min  NaN  Inf    ->  Infinity
  #|mnmx149 min  NaN  NaN    ->  NaN
  #|mnmx150 min -Inf  NaN    -> -Infinity
  #|mnmx151 min -1000 NaN    -> -1000
  #|mnmx152 min -1   -NaN    -> -1
  #|mnmx153 min -0    NaN    -> -0
  #|mnmx154 min  0   -NaN    ->  0
  #|mnmx155 min  1    NaN    ->  1
  #|mnmx156 min  1000 NaN    ->  1000
  #|mnmx157 min  Inf  NaN    ->  Infinity
  #|
  #|mnmx161 min  sNaN -Inf   ->  NaN  Invalid_operation
  #|mnmx162 min  sNaN -1000  ->  NaN  Invalid_operation
  #|mnmx163 min  sNaN -1     ->  NaN  Invalid_operation
  #|mnmx164 min  sNaN -0     ->  NaN  Invalid_operation
  #|mnmx165 min -sNaN  0     -> -NaN  Invalid_operation
  #|mnmx166 min -sNaN  1     -> -NaN  Invalid_operation
  #|mnmx167 min  sNaN  1000  ->  NaN  Invalid_operation
  #|mnmx168 min  sNaN  NaN   ->  NaN  Invalid_operation
  #|mnmx169 min  sNaN sNaN   ->  NaN  Invalid_operation
  #|mnmx170 min  NaN  sNaN   ->  NaN  Invalid_operation
  #|mnmx171 min -Inf  sNaN   ->  NaN  Invalid_operation
  #|mnmx172 min -1000 sNaN   ->  NaN  Invalid_operation
  #|mnmx173 min -1    sNaN   ->  NaN  Invalid_operation
  #|mnmx174 min -0    sNaN   ->  NaN  Invalid_operation
  #|mnmx175 min  0    sNaN   ->  NaN  Invalid_operation
  #|mnmx176 min  1    sNaN   ->  NaN  Invalid_operation
  #|mnmx177 min  1000 sNaN   ->  NaN  Invalid_operation
  #|mnmx178 min  Inf  sNaN   ->  NaN  Invalid_operation
  #|mnmx179 min  NaN  sNaN   ->  NaN  Invalid_operation
  #|
  #|-- propagating NaNs
  #|mnmx181 min  NaN9   -Inf   -> -Infinity
  #|mnmx182 min -NaN8    9990  ->  9990
  #|mnmx183 min  NaN71   Inf   ->  Infinity
  #|
  #|mnmx184 min  NaN1    NaN54 ->  NaN1
  #|mnmx185 min  NaN22  -NaN53 ->  NaN22
  #|mnmx186 min -NaN3    NaN6  -> -NaN3
  #|mnmx187 min -NaN44   NaN7  -> -NaN44
  #|
  #|mnmx188 min -Inf     NaN41 -> -Infinity
  #|mnmx189 min -9999   -NaN33 -> -9999
  #|mnmx190 min  Inf     NaN2  ->  Infinity
  #|
  #|mnmx191 min  sNaN99 -Inf    ->  NaN99 Invalid_operation
  #|mnmx192 min  sNaN98 -11     ->  NaN98 Invalid_operation
  #|mnmx193 min -sNaN97  NaN8   -> -NaN97 Invalid_operation
  #|mnmx194 min  sNaN69 sNaN94  ->  NaN69 Invalid_operation
  #|mnmx195 min  NaN95  sNaN93  ->  NaN93 Invalid_operation
  #|mnmx196 min -Inf    sNaN92  ->  NaN92 Invalid_operation
  #|mnmx197 min  088    sNaN91  ->  NaN91 Invalid_operation
  #|mnmx198 min  Inf   -sNaN90  -> -NaN90 Invalid_operation
  #|mnmx199 min  NaN    sNaN86  ->  NaN86 Invalid_operation
  #|
  #|-- rounding checks -- chosen is rounded, or not
  #|maxExponent: 999
  #|minexponent: -999
  #|precision: 9
  #|mnmx201 min -12345678000 1  -> -1.23456780E+10 Rounded
  #|mnmx202 min 1 -12345678000  -> -1.23456780E+10 Rounded
  #|mnmx203 min -1234567800  1  -> -1.23456780E+9 Rounded
  #|mnmx204 min 1 -1234567800   -> -1.23456780E+9 Rounded
  #|mnmx205 min -1234567890  1  -> -1.23456789E+9 Rounded
  #|mnmx206 min 1 -1234567890   -> -1.23456789E+9 Rounded
  #|mnmx207 min -1234567891  1  -> -1.23456789E+9 Inexact Rounded
  #|mnmx208 min 1 -1234567891   -> -1.23456789E+9 Inexact Rounded
  #|mnmx209 min -12345678901 1  -> -1.23456789E+10 Inexact Rounded
  #|mnmx210 min 1 -12345678901  -> -1.23456789E+10 Inexact Rounded
  #|mnmx211 min -1234567896  1  -> -1.23456790E+9 Inexact Rounded
  #|mnmx212 min 1 -1234567896   -> -1.23456790E+9 Inexact Rounded
  #|mnmx213 min 1234567891  1   -> 1
  #|mnmx214 min 1 1234567891    -> 1
  #|mnmx215 min 12345678901 1   -> 1
  #|mnmx216 min 1 12345678901   -> 1
  #|mnmx217 min 1234567896  1   -> 1
  #|mnmx218 min 1 1234567896    -> 1
  #|
  #|precision: 15
  #|mnmx221 min -12345678000 1  -> -12345678000
  #|mnmx222 min 1 -12345678000  -> -12345678000
  #|mnmx223 min -1234567800  1  -> -1234567800
  #|mnmx224 min 1 -1234567800   -> -1234567800
  #|mnmx225 min -1234567890  1  -> -1234567890
  #|mnmx226 min 1 -1234567890   -> -1234567890
  #|mnmx227 min -1234567891  1  -> -1234567891
  #|mnmx228 min 1 -1234567891   -> -1234567891
  #|mnmx229 min -12345678901 1  -> -12345678901
  #|mnmx230 min 1 -12345678901  -> -12345678901
  #|mnmx231 min -1234567896  1  -> -1234567896
  #|mnmx232 min 1 -1234567896   -> -1234567896
  #|mnmx233 min 1234567891  1   -> 1
  #|mnmx234 min 1 1234567891    -> 1
  #|mnmx235 min 12345678901 1   -> 1
  #|mnmx236 min 1 12345678901   -> 1
  #|mnmx237 min 1234567896  1   -> 1
  #|mnmx238 min 1 1234567896    -> 1
  #|
  #|-- from examples
  #|mnmx280 min '3'   '2'  ->  '2'
  #|mnmx281 min '-10' '3'  ->  '-10'
  #|mnmx282 min '1.0' '1'  ->  '1.0'
  #|mnmx283 min '1' '1.0'  ->  '1.0'
  #|mnmx284 min '7' 'NaN'  ->  '7'
  #|
  #|-- overflow and underflow tests .. subnormal results [inputs] now allowed
  #|maxExponent: 999999999
  #|minexponent: -999999999
  #|mnmx330 min -1.23456789012345E-0 -9E+999999999 -> -9E+999999999
  #|mnmx331 min -9E+999999999 -1.23456789012345E-0 -> -9E+999999999
  #|mnmx332 min -0.100 -9E-999999999               -> -0.100
  #|mnmx333 min -9E-999999999 -0.100               -> -0.100
  #|mnmx335 min +1.23456789012345E-0 -9E+999999999 -> -9E+999999999
  #|mnmx336 min -9E+999999999 1.23456789012345E-0  -> -9E+999999999
  #|mnmx337 min +0.100 -9E-999999999               -> -9E-999999999
  #|mnmx338 min -9E-999999999 0.100                -> -9E-999999999
  #|
  #|mnmx339 min -1e-599999999 -1e-400000001   ->  -1E-400000001
  #|mnmx340 min -1e-599999999 -1e-400000000   ->  -1E-400000000
  #|mnmx341 min -1e-600000000 -1e-400000000   ->  -1E-400000000
  #|mnmx342 min -9e-999999998 -0.01           ->  -0.01
  #|mnmx343 min -9e-999999998 -0.1            ->  -0.1
  #|mnmx344 min -0.01         -9e-999999998   ->  -0.01
  #|mnmx345 min -1e599999999  -1e400000001    ->  -1E+599999999
  #|mnmx346 min -1e599999999  -1e400000000    ->  -1E+599999999
  #|mnmx347 min -1e600000000  -1e400000000    ->  -1E+600000000
  #|mnmx348 min -9e999999998  -100            ->  -9E+999999998
  #|mnmx349 min -9e999999998  -10             ->  -9E+999999998
  #|mnmx350 min -100          -9e999999998    ->  -9E+999999998
  #|-- signs
  #|mnmx351 min -1e+777777777 -1e+411111111 -> -1E+777777777
  #|mnmx352 min -1e+777777777 +1e+411111111 -> -1E+777777777
  #|mnmx353 min +1e+777777777 -1e+411111111 -> -1E+411111111
  #|mnmx354 min +1e+777777777 +1e+411111111 ->  1E+411111111
  #|mnmx355 min -1e-777777777 -1e-411111111 -> -1E-411111111
  #|mnmx356 min -1e-777777777 +1e-411111111 -> -1E-777777777
  #|mnmx357 min +1e-777777777 -1e-411111111 -> -1E-411111111
  #|mnmx358 min +1e-777777777 +1e-411111111 ->  1E-777777777
  #|
  #|-- expanded list from min/max 754r purple prose
  #|-- [explicit tests for exponent ordering]
  #|mnmx401 min  Inf    1.1     ->  1.1
  #|mnmx402 min  1.1    1       ->  1
  #|mnmx403 min  1      1.0     ->  1.0
  #|mnmx404 min  1.0    0.1     ->  0.1
  #|mnmx405 min  0.1    0.10    ->  0.10
  #|mnmx406 min  0.10   0.100   ->  0.100
  #|mnmx407 min  0.10   0       ->  0
  #|mnmx408 min  0      0.0     ->  0.0
  #|mnmx409 min  0.0   -0       -> -0
  #|mnmx410 min  0.0   -0.0     -> -0.0
  #|mnmx411 min  0.00  -0.0     -> -0.0
  #|mnmx412 min  0.0   -0.00    -> -0.00
  #|mnmx413 min  0     -0.0     -> -0.0
  #|mnmx414 min  0     -0       -> -0
  #|mnmx415 min -0.0   -0       -> -0
  #|mnmx416 min -0     -0.100   -> -0.100
  #|mnmx417 min -0.100 -0.10    -> -0.10
  #|mnmx418 min -0.10  -0.1     -> -0.1
  #|mnmx419 min -0.1   -1.0     -> -1.0
  #|mnmx420 min -1.0   -1       -> -1
  #|mnmx421 min -1     -1.1     -> -1.1
  #|mnmx423 min -1.1   -Inf     -> -Infinity
  #|-- same with operands reversed
  #|mnmx431 min  1.1    Inf     ->  1.1
  #|mnmx432 min  1      1.1     ->  1
  #|mnmx433 min  1.0    1       ->  1.0
  #|mnmx434 min  0.1    1.0     ->  0.1
  #|mnmx435 min  0.10   0.1     ->  0.10
  #|mnmx436 min  0.100  0.10    ->  0.100
  #|mnmx437 min  0      0.10    ->  0
  #|mnmx438 min  0.0    0       ->  0.0
  #|mnmx439 min -0      0.0     -> -0
  #|mnmx440 min -0.0    0.0     -> -0.0
  #|mnmx441 min -0.0    0.00    -> -0.0
  #|mnmx442 min -0.00   0.0     -> -0.00
  #|mnmx443 min -0.0    0       -> -0.0
  #|mnmx444 min -0      0       -> -0
  #|mnmx445 min -0     -0.0     -> -0
  #|mnmx446 min -0.100 -0       -> -0.100
  #|mnmx447 min -0.10  -0.100   -> -0.10
  #|mnmx448 min -0.1   -0.10    -> -0.1
  #|mnmx449 min -1.0   -0.1     -> -1.0
  #|mnmx450 min -1     -1.0     -> -1
  #|mnmx451 min -1.1   -1       -> -1.1
  #|mnmx453 min -Inf   -1.1     -> -Infinity
  #|-- largies
  #|mnmx460 min  1000   1E+3    ->  1000
  #|mnmx461 min  1E+3   1000    ->  1000
  #|mnmx462 min  1000  -1E+3    -> -1E+3
  #|mnmx463 min  1E+3  -1000    -> -1000
  #|mnmx464 min -1000   1E+3    -> -1000
  #|mnmx465 min -1E+3   1000    -> -1E+3
  #|mnmx466 min -1000  -1E+3    -> -1E+3
  #|mnmx467 min -1E+3  -1000    -> -1E+3
  #|
  #|-- rounding (results treated as though plus)
  #|maxexponent: 999999999
  #|minexponent: -999999999
  #|precision: 3
  #|
  #|mnmx470 min  1      5      ->  1
  #|mnmx471 min  10     50     ->  10
  #|mnmx472 min  100    500    ->  100
  #|mnmx473 min  1000   5000   ->  1.00E+3 Rounded
  #|mnmx474 min  10000  50000  ->  1.00E+4 Rounded
  #|mnmx475 min  6      50     ->  6
  #|mnmx476 min  66     500    ->  66
  #|mnmx477 min  666    5000   ->  666
  #|mnmx478 min  6666   50000  ->  6.67E+3 Rounded Inexact
  #|mnmx479 min  66666  500000 ->  6.67E+4 Rounded Inexact
  #|mnmx480 min  33333  500000 ->  3.33E+4 Rounded Inexact
  #|mnmx481 min  75401  1      ->  1
  #|mnmx482 min  75402  10     ->  10
  #|mnmx483 min  75403  100    ->  100
  #|mnmx484 min  75404  1000   ->  1.00E+3 Rounded
  #|mnmx485 min  75405  10000  ->  1.00E+4 Rounded
  #|mnmx486 min  75406  6      ->  6
  #|mnmx487 min  75407  66     ->  66
  #|mnmx488 min  75408  666    ->  666
  #|mnmx489 min  75409  6666   ->  6.67E+3 Rounded Inexact
  #|mnmx490 min  75410  66666  ->  6.67E+4 Rounded Inexact
  #|mnmx491 min  75411  33333  ->  3.33E+4 Rounded Inexact
  #|
  #|
  #|-- overflow tests
  #|maxexponent: 999999999
  #|minexponent: -999999999
  #|precision: 3
  #|mnmx500 min 9.999E+999999999  0 ->  0
  #|mnmx501 min -9.999E+999999999 0 -> -Infinity Inexact Overflow Rounded
  #|
  #|-- subnormals and underflow
  #|precision: 3
  #|maxexponent: 999
  #|minexponent: -999
  #|mnmx510 min  1.00E-999       0  ->   0
  #|mnmx511 min  0.1E-999        0  ->   0
  #|mnmx512 min  0.10E-999       0  ->   0
  #|mnmx513 min  0.100E-999      0  ->   0
  #|mnmx514 min  0.01E-999       0  ->   0
  #|mnmx515 min  0.999E-999      0  ->   0
  #|mnmx516 min  0.099E-999      0  ->   0
  #|mnmx517 min  0.009E-999      0  ->   0
  #|mnmx518 min  0.001E-999      0  ->   0
  #|mnmx519 min  0.0009E-999     0  ->   0
  #|mnmx520 min  0.0001E-999     0  ->   0
  #|
  #|mnmx530 min -1.00E-999       0  ->  -1.00E-999
  #|mnmx531 min -0.1E-999        0  ->  -1E-1000   Subnormal
  #|mnmx532 min -0.10E-999       0  ->  -1.0E-1000 Subnormal
  #|mnmx533 min -0.100E-999      0  ->  -1.0E-1000 Subnormal Rounded
  #|mnmx534 min -0.01E-999       0  ->  -1E-1001   Subnormal
  #|-- next is rounded to Nmin
  #|mnmx535 min -0.999E-999      0  ->  -1.00E-999 Inexact Rounded Subnormal Underflow
  #|mnmx536 min -0.099E-999      0  ->  -1.0E-1000 Inexact Rounded Subnormal Underflow
  #|mnmx537 min -0.009E-999      0  ->  -1E-1001   Inexact Rounded Subnormal Underflow
  #|mnmx538 min -0.001E-999      0  ->  -0E-1001   Inexact Rounded Subnormal Underflow Clamped
  #|mnmx539 min -0.0009E-999     0  ->  -0E-1001   Inexact Rounded Subnormal Underflow Clamped
  #|mnmx540 min -0.0001E-999     0  ->  -0E-1001   Inexact Rounded Subnormal Underflow Clamped
  #|
  #|-- misalignment traps for little-endian
  #|precision: 9
  #|mnmx551 min      1.0       0.1  -> 0.1
  #|mnmx552 min      0.1       1.0  -> 0.1
  #|mnmx553 min     10.0       0.1  -> 0.1
  #|mnmx554 min      0.1      10.0  -> 0.1
  #|mnmx555 min      100       1.0  -> 1.0
  #|mnmx556 min      1.0       100  -> 1.0
  #|mnmx557 min     1000      10.0  -> 10.0
  #|mnmx558 min     10.0      1000  -> 10.0
  #|mnmx559 min    10000     100.0  -> 100.0
  #|mnmx560 min    100.0     10000  -> 100.0
  #|mnmx561 min   100000    1000.0  -> 1000.0
  #|mnmx562 min   1000.0    100000  -> 1000.0
  #|mnmx563 min  1000000   10000.0  -> 10000.0
  #|mnmx564 min  10000.0   1000000  -> 10000.0
  #|
  #|-- Null tests
  #|mnm900 min 10  # -> NaN Invalid_operation
  #|mnm901 min  # 10 -> NaN Invalid_operation

///|
/// Full `maxmag.decTest` corpus (IBM General Decimal
/// Arithmetic testcases), embedded verbatim.
let maxmag_subset : String =
  #|------------------------------------------------------------------------
  #|-- maxmag.decTest -- decimal maximum by magnitude                     --
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
  #|-- we assume that base comparison is tested in compare.decTest, so
  #|-- these mainly cover special cases and rounding
  #|
  #|extended:    1
  #|precision:   9
  #|rounding:    half_up
  #|maxExponent: 384
  #|minexponent: -383
  #|
  #|-- sanity checks
  #|mxgx001 maxmag  -2  -2  -> -2
  #|mxgx002 maxmag  -2  -1  -> -2
  #|mxgx003 maxmag  -2   0  -> -2
  #|mxgx004 maxmag  -2   1  -> -2
  #|mxgx005 maxmag  -2   2  ->  2
  #|mxgx006 maxmag  -1  -2  -> -2
  #|mxgx007 maxmag  -1  -1  -> -1
  #|mxgx008 maxmag  -1   0  -> -1
  #|mxgx009 maxmag  -1   1  ->  1
  #|mxgx010 maxmag  -1   2  ->  2
  #|mxgx011 maxmag   0  -2  -> -2
  #|mxgx012 maxmag   0  -1  -> -1
  #|mxgx013 maxmag   0   0  ->  0
  #|mxgx014 maxmag   0   1  ->  1
  #|mxgx015 maxmag   0   2  ->  2
  #|mxgx016 maxmag   1  -2  -> -2
  #|mxgx017 maxmag   1  -1  ->  1
  #|mxgx018 maxmag   1   0  ->  1
  #|mxgx019 maxmag   1   1  ->  1
  #|mxgx020 maxmag   1   2  ->  2
  #|mxgx021 maxmag   2  -2  ->  2
  #|mxgx022 maxmag   2  -1  ->  2
  #|mxgx023 maxmag   2   0  ->  2
  #|mxgx025 maxmag   2   1  ->  2
  #|mxgx026 maxmag   2   2  ->  2
  #|
  #|-- extended zeros
  #|mxgx030 maxmag   0     0   ->  0
  #|mxgx031 maxmag   0    -0   ->  0
  #|mxgx032 maxmag   0    -0.0 ->  0
  #|mxgx033 maxmag   0     0.0 ->  0
  #|mxgx034 maxmag  -0     0   ->  0    -- note: -0 = 0, but 0 chosen
  #|mxgx035 maxmag  -0    -0   -> -0
  #|mxgx036 maxmag  -0    -0.0 -> -0.0
  #|mxgx037 maxmag  -0     0.0 ->  0.0
  #|mxgx038 maxmag   0.0   0   ->  0
  #|mxgx039 maxmag   0.0  -0   ->  0.0
  #|mxgx040 maxmag   0.0  -0.0 ->  0.0
  #|mxgx041 maxmag   0.0   0.0 ->  0.0
  #|mxgx042 maxmag  -0.0   0   ->  0
  #|mxgx043 maxmag  -0.0  -0   -> -0.0
  #|mxgx044 maxmag  -0.0  -0.0 -> -0.0
  #|mxgx045 maxmag  -0.0   0.0 ->  0.0
  #|
  #|mxgx050 maxmag  -0E1   0E1 ->  0E+1
  #|mxgx051 maxmag  -0E2   0E2 ->  0E+2
  #|mxgx052 maxmag  -0E2   0E1 ->  0E+1
  #|mxgx053 maxmag  -0E1   0E2 ->  0E+2
  #|mxgx054 maxmag   0E1  -0E1 ->  0E+1
  #|mxgx055 maxmag   0E2  -0E2 ->  0E+2
  #|mxgx056 maxmag   0E2  -0E1 ->  0E+2
  #|mxgx057 maxmag   0E1  -0E2 ->  0E+1
  #|
  #|mxgx058 maxmag   0E1   0E1 ->  0E+1
  #|mxgx059 maxmag   0E2   0E2 ->  0E+2
  #|mxgx060 maxmag   0E2   0E1 ->  0E+2
  #|mxgx061 maxmag   0E1   0E2 ->  0E+2
  #|mxgx062 maxmag  -0E1  -0E1 -> -0E+1
  #|mxgx063 maxmag  -0E2  -0E2 -> -0E+2
  #|mxgx064 maxmag  -0E2  -0E1 -> -0E+1
  #|mxgx065 maxmag  -0E1  -0E2 -> -0E+1
  #|
  #|-- Specials
  #|precision: 9
  #|mxgx090 maxmag  Inf  -Inf   ->  Infinity
  #|mxgx091 maxmag  Inf  -1000  ->  Infinity
  #|mxgx092 maxmag  Inf  -1     ->  Infinity
  #|mxgx093 maxmag  Inf  -0     ->  Infinity
  #|mxgx094 maxmag  Inf   0     ->  Infinity
  #|mxgx095 maxmag  Inf   1     ->  Infinity
  #|mxgx096 maxmag  Inf   1000  ->  Infinity
  #|mxgx097 maxmag  Inf   Inf   ->  Infinity
  #|mxgx098 maxmag -1000  Inf   ->  Infinity
  #|mxgx099 maxmag -Inf   Inf   ->  Infinity
  #|mxgx100 maxmag -1     Inf   ->  Infinity
  #|mxgx101 maxmag -0     Inf   ->  Infinity
  #|mxgx102 maxmag  0     Inf   ->  Infinity
  #|mxgx103 maxmag  1     Inf   ->  Infinity
  #|mxgx104 maxmag  1000  Inf   ->  Infinity
  #|mxgx105 maxmag  Inf   Inf   ->  Infinity
  #|
  #|mxgx120 maxmag -Inf  -Inf   -> -Infinity
  #|mxgx121 maxmag -Inf  -1000  -> -Infinity
  #|mxgx122 maxmag -Inf  -1     -> -Infinity
  #|mxgx123 maxmag -Inf  -0     -> -Infinity
  #|mxgx124 maxmag -Inf   0     -> -Infinity
  #|mxgx125 maxmag -Inf   1     -> -Infinity
  #|mxgx126 maxmag -Inf   1000  -> -Infinity
  #|mxgx127 maxmag -Inf   Inf   ->  Infinity
  #|mxgx128 maxmag -Inf  -Inf   -> -Infinity
  #|mxgx129 maxmag -1000 -Inf   -> -Infinity
  #|mxgx130 maxmag -1    -Inf   -> -Infinity
  #|mxgx131 maxmag -0    -Inf   -> -Infinity
  #|mxgx132 maxmag  0    -Inf   -> -Infinity
  #|mxgx133 maxmag  1    -Inf   -> -Infinity
  #|mxgx134 maxmag  1000 -Inf   -> -Infinity
  #|mxgx135 maxmag  Inf  -Inf   ->  Infinity
  #|
  #|-- 2004.08.02 754r chooses number over NaN in mixed cases
  #|mxgx141 maxmag  NaN -Inf    -> -Infinity
  #|mxgx142 maxmag  NaN -1000   -> -1000
  #|mxgx143 maxmag  NaN -1      -> -1
  #|mxgx144 maxmag  NaN -0      -> -0
  #|mxgx145 maxmag  NaN  0      ->  0
  #|mxgx146 maxmag  NaN  1      ->  1
  #|mxgx147 maxmag  NaN  1000   ->  1000
  #|mxgx148 maxmag  NaN  Inf    ->  Infinity
  #|mxgx149 maxmag  NaN  NaN    ->  NaN
  #|mxgx150 maxmag -Inf  NaN    -> -Infinity
  #|mxgx151 maxmag -1000 NaN    -> -1000
  #|mxgx152 maxmag -1    NaN    -> -1
  #|mxgx153 maxmag -0    NaN    -> -0
  #|mxgx154 maxmag  0    NaN    ->  0
  #|mxgx155 maxmag  1    NaN    ->  1
  #|mxgx156 maxmag  1000 NaN    ->  1000
  #|mxgx157 maxmag  Inf  NaN    ->  Infinity
  #|
  #|mxgx161 maxmag  sNaN -Inf   ->  NaN  Invalid_operation
  #|mxgx162 maxmag  sNaN -1000  ->  NaN  Invalid_operation
  #|mxgx163 maxmag  sNaN -1     ->  NaN  Invalid_operation
  #|mxgx164 maxmag  sNaN -0     ->  NaN  Invalid_operation
  #|mxgx165 maxmag  sNaN  0     ->  NaN  Invalid_operation
  #|mxgx166 maxmag  sNaN  1     ->  NaN  Invalid_operation
  #|mxgx167 maxmag  sNaN  1000  ->  NaN  Invalid_operation
  #|mxgx168 maxmag  sNaN  NaN   ->  NaN  Invalid_operation
  #|mxgx169 maxmag  sNaN sNaN   ->  NaN  Invalid_operation
  #|mxgx170 maxmag  NaN  sNaN   ->  NaN  Invalid_operation
  #|mxgx171 maxmag -Inf  sNaN   ->  NaN  Invalid_operation
  #|mxgx172 maxmag -1000 sNaN   ->  NaN  Invalid_operation
  #|mxgx173 maxmag -1    sNaN   ->  NaN  Invalid_operation
  #|mxgx174 maxmag -0    sNaN   ->  NaN  Invalid_operation
  #|mxgx175 maxmag  0    sNaN   ->  NaN  Invalid_operation
  #|mxgx176 maxmag  1    sNaN   ->  NaN  Invalid_operation
  #|mxgx177 maxmag  1000 sNaN   ->  NaN  Invalid_operation
  #|mxgx178 maxmag  Inf  sNaN   ->  NaN  Invalid_operation
  #|mxgx179 maxmag  NaN  sNaN   ->  NaN  Invalid_operation
  #|
  #|-- propagating NaNs
  #|mxgx181 maxmag  NaN9  -Inf   -> -Infinity
  #|mxgx182 maxmag  NaN8     9   ->  9
  #|mxgx183 maxmag -NaN7   Inf   ->  Infinity
  #|
  #|mxgx184 maxmag -NaN1   NaN11 -> -NaN1
  #|mxgx185 maxmag  NaN2   NaN12 ->  NaN2
  #|mxgx186 maxmag -NaN13 -NaN7  -> -NaN13
  #|mxgx187 maxmag  NaN14 -NaN5  ->  NaN14
  #|
  #|mxgx188 maxmag -Inf    NaN4  -> -Infinity
  #|mxgx189 maxmag -9     -NaN3  -> -9
  #|mxgx190 maxmag  Inf    NaN2  ->  Infinity
  #|
  #|mxgx191 maxmag  sNaN99 -Inf    ->  NaN99 Invalid_operation
  #|mxgx192 maxmag  sNaN98 -1      ->  NaN98 Invalid_operation
  #|mxgx193 maxmag -sNaN97  NaN    -> -NaN97 Invalid_operation
  #|mxgx194 maxmag  sNaN96 sNaN94  ->  NaN96 Invalid_operation
  #|mxgx195 maxmag  NaN95  sNaN93  ->  NaN93 Invalid_operation
  #|mxgx196 maxmag -Inf    sNaN92  ->  NaN92 Invalid_operation
  #|mxgx197 maxmag  0      sNaN91  ->  NaN91 Invalid_operation
  #|mxgx198 maxmag  Inf   -sNaN90  -> -NaN90 Invalid_operation
  #|mxgx199 maxmag  NaN    sNaN89  ->  NaN89 Invalid_operation
  #|
  #|-- rounding checks
  #|maxexponent: 999
  #|minexponent: -999
  #|precision: 9
  #|mxgx201 maxmag 12345678000 1  -> 1.23456780E+10 Rounded
  #|mxgx202 maxmag 1 12345678000  -> 1.23456780E+10 Rounded
  #|mxgx203 maxmag 1234567800  1  -> 1.23456780E+9 Rounded
  #|mxgx204 maxmag 1 1234567800   -> 1.23456780E+9 Rounded
  #|mxgx205 maxmag 1234567890  1  -> 1.23456789E+9 Rounded
  #|mxgx206 maxmag 1 1234567890   -> 1.23456789E+9 Rounded
  #|mxgx207 maxmag 1234567891  1  -> 1.23456789E+9 Inexact Rounded
  #|mxgx208 maxmag 1 1234567891   -> 1.23456789E+9 Inexact Rounded
  #|mxgx209 maxmag 12345678901 1  -> 1.23456789E+10 Inexact Rounded
  #|mxgx210 maxmag 1 12345678901  -> 1.23456789E+10 Inexact Rounded
  #|mxgx211 maxmag 1234567896  1  -> 1.23456790E+9 Inexact Rounded
  #|mxgx212 maxmag 1 1234567896   -> 1.23456790E+9 Inexact Rounded
  #|mxgx213 maxmag -1234567891  1 -> -1.23456789E+9   Inexact Rounded
  #|mxgx214 maxmag 1 -1234567891  -> -1.23456789E+9   Inexact Rounded
  #|mxgx215 maxmag -12345678901 1 -> -1.23456789E+10  Inexact Rounded
  #|mxgx216 maxmag 1 -12345678901 -> -1.23456789E+10  Inexact Rounded
  #|mxgx217 maxmag -1234567896  1 -> -1.23456790E+9   Inexact Rounded
  #|mxgx218 maxmag 1 -1234567896  -> -1.23456790E+9   Inexact Rounded
  #|
  #|precision: 15
  #|mxgx221 maxmag 12345678000 1  -> 12345678000
  #|mxgx222 maxmag 1 12345678000  -> 12345678000
  #|mxgx223 maxmag 1234567800  1  -> 1234567800
  #|mxgx224 maxmag 1 1234567800   -> 1234567800
  #|mxgx225 maxmag 1234567890  1  -> 1234567890
  #|mxgx226 maxmag 1 1234567890   -> 1234567890
  #|mxgx227 maxmag 1234567891  1  -> 1234567891
  #|mxgx228 maxmag 1 1234567891   -> 1234567891
  #|mxgx229 maxmag 12345678901 1  -> 12345678901
  #|mxgx230 maxmag 1 12345678901  -> 12345678901
  #|mxgx231 maxmag 1234567896  1  -> 1234567896
  #|mxgx232 maxmag 1 1234567896   -> 1234567896
  #|mxgx233 maxmag -1234567891  1 -> -1234567891
  #|mxgx234 maxmag 1 -1234567891  -> -1234567891
  #|mxgx235 maxmag -12345678901 1 -> -12345678901
  #|mxgx236 maxmag 1 -12345678901 -> -12345678901
  #|mxgx237 maxmag -1234567896  1 -> -1234567896
  #|mxgx238 maxmag 1 -1234567896  -> -1234567896
  #|
  #|-- from examples
  #|mxgx280 maxmag '3'   '2'  ->  '3'
  #|mxgx281 maxmag '-10' '3'  ->  '-10'
  #|mxgx282 maxmag '1.0' '1'  ->  '1'
  #|mxgx283 maxmag '1' '1.0'  ->  '1'
  #|mxgx284 maxmag '7' 'NaN'  ->  '7'
  #|
  #|-- overflow and underflow tests ...
  #|maxExponent: 999999999
  #|minexponent: -999999999
  #|mxgx330 maxmag +1.23456789012345E-0 9E+999999999 ->  9E+999999999
  #|mxgx331 maxmag 9E+999999999 +1.23456789012345E-0 ->  9E+999999999
  #|mxgx332 maxmag +0.100 9E-999999999               ->  0.100
  #|mxgx333 maxmag 9E-999999999 +0.100               ->  0.100
  #|mxgx335 maxmag -1.23456789012345E-0 9E+999999999 ->  9E+999999999
  #|mxgx336 maxmag 9E+999999999 -1.23456789012345E-0 ->  9E+999999999
  #|mxgx337 maxmag -0.100 9E-999999999               ->  -0.100
  #|mxgx338 maxmag 9E-999999999 -0.100               ->  -0.100
  #|
  #|mxgx339 maxmag 1e-599999999 1e-400000001   ->  1E-400000001
  #|mxgx340 maxmag 1e-599999999 1e-400000000   ->  1E-400000000
  #|mxgx341 maxmag 1e-600000000 1e-400000000   ->  1E-400000000
  #|mxgx342 maxmag 9e-999999998 0.01           ->  0.01
  #|mxgx343 maxmag 9e-999999998 0.1            ->  0.1
  #|mxgx344 maxmag 0.01 9e-999999998           ->  0.01
  #|mxgx345 maxmag 1e599999999 1e400000001     ->  1E+599999999
  #|mxgx346 maxmag 1e599999999 1e400000000     ->  1E+599999999
  #|mxgx347 maxmag 1e600000000 1e400000000     ->  1E+600000000
  #|mxgx348 maxmag 9e999999998 100             ->  9E+999999998
  #|mxgx349 maxmag 9e999999998 10              ->  9E+999999998
  #|mxgx350 maxmag 100  9e999999998            ->  9E+999999998
  #|-- signs
  #|mxgx351 maxmag  1e+777777777  1e+411111111 ->  1E+777777777
  #|mxgx352 maxmag  1e+777777777 -1e+411111111 ->  1E+777777777
  #|mxgx353 maxmag -1e+777777777  1e+411111111 -> -1E+777777777
  #|mxgx354 maxmag -1e+777777777 -1e+411111111 -> -1E+777777777
  #|mxgx355 maxmag  1e-777777777  1e-411111111 ->  1E-411111111
  #|mxgx356 maxmag  1e-777777777 -1e-411111111 -> -1E-411111111
  #|mxgx357 maxmag -1e-777777777  1e-411111111 ->  1E-411111111
  #|mxgx358 maxmag -1e-777777777 -1e-411111111 -> -1E-411111111
  #|
  #|-- expanded list from min/max 754r purple prose
  #|-- [explicit tests for exponent ordering]
  #|mxgx401 maxmag  Inf    1.1     ->  Infinity
  #|mxgx402 maxmag  1.1    1       ->  1.1
  #|mxgx403 maxmag  1      1.0     ->  1
  #|mxgx404 maxmag  1.0    0.1     ->  1.0
  #|mxgx405 maxmag  0.1    0.10    ->  0.1
  #|mxgx406 maxmag  0.10   0.100   ->  0.10
  #|mxgx407 maxmag  0.10   0       ->  0.10
  #|mxgx408 maxmag  0      0.0     ->  0
  #|mxgx409 maxmag  0.0   -0       ->  0.0
  #|mxgx410 maxmag  0.0   -0.0     ->  0.0
  #|mxgx411 maxmag  0.00  -0.0     ->  0.00
  #|mxgx412 maxmag  0.0   -0.00    ->  0.0
  #|mxgx413 maxmag  0     -0.0     ->  0
  #|mxgx414 maxmag  0     -0       ->  0
  #|mxgx415 maxmag -0.0   -0       -> -0.0
  #|mxgx416 maxmag -0     -0.100   -> -0.100
  #|mxgx417 maxmag -0.100 -0.10    -> -0.100
  #|mxgx418 maxmag -0.10  -0.1     -> -0.10
  #|mxgx419 maxmag -0.1   -1.0     -> -1.0
  #|mxgx420 maxmag -1.0   -1       -> -1.0
  #|mxgx421 maxmag -1     -1.1     -> -1.1
  #|mxgx423 maxmag -1.1   -Inf     -> -Infinity
  #|-- same with operands reversed
  #|mxgx431 maxmag  1.1    Inf     ->  Infinity
  #|mxgx432 maxmag  1      1.1     ->  1.1
  #|mxgx433 maxmag  1.0    1       ->  1
  #|mxgx434 maxmag  0.1    1.0     ->  1.0
  #|mxgx435 maxmag  0.10   0.1     ->  0.1
  #|mxgx436 maxmag  0.100  0.10    ->  0.10
  #|mxgx437 maxmag  0      0.10    ->  0.10
  #|mxgx438 maxmag  0.0    0       ->  0
  #|mxgx439 maxmag -0      0.0     ->  0.0
  #|mxgx440 maxmag -0.0    0.0     ->  0.0
  #|mxgx441 maxmag -0.0    0.00    ->  0.00
  #|mxgx442 maxmag -0.00   0.0     ->  0.0
  #|mxgx443 maxmag -0.0    0       ->  0
  #|mxgx444 maxmag -0      0       ->  0
  #|mxgx445 maxmag -0     -0.0     -> -0.0
  #|mxgx446 maxmag -0.100 -0       -> -0.100
  #|mxgx447 maxmag -0.10  -0.100   -> -0.100
  #|mxgx448 maxmag -0.1   -0.10    -> -0.10
  #|mxgx449 maxmag -1.0   -0.1     -> -1.0
  #|mxgx450 maxmag -1     -1.0     -> -1.0
  #|mxgx451 maxmag -1.1   -1       -> -1.1
  #|mxgx453 maxmag -Inf   -1.1     -> -Infinity
  #|-- largies
  #|mxgx460 maxmag  1000   1E+3    ->  1E+3
  #|mxgx461 maxmag  1E+3   1000    ->  1E+3
  #|mxgx462 maxmag  1000  -1E+3    ->  1000
  #|mxgx463 maxmag  1E+3  -1000    ->  1E+3
  #|mxgx464 maxmag -1000   1E+3    ->  1E+3
  #|mxgx465 maxmag -1E+3   1000    ->  1000
  #|mxgx466 maxmag -1000  -1E+3    -> -1000
  #|mxgx467 maxmag -1E+3  -1000    -> -1000
  #|
  #|-- rounding (results treated as though plus)
  #|maxexponent: 999999999
  #|minexponent: -999999999
  #|precision: 3
  #|
  #|mxgx470 maxmag  1      .5     ->  1
  #|mxgx471 maxmag  10     5      ->  10
  #|mxgx472 maxmag  100    50     ->  100
  #|mxgx473 maxmag  1000   500    ->  1.00E+3 Rounded
  #|mxgx474 maxmag  10000  5000   ->  1.00E+4 Rounded
  #|mxgx475 maxmag  6      .5     ->  6
  #|mxgx476 maxmag  66     5      ->  66
  #|mxgx477 maxmag  666    50     ->  666
  #|mxgx478 maxmag  6666   500    ->  6.67E+3 Rounded Inexact
  #|mxgx479 maxmag  66666  5000   ->  6.67E+4 Rounded Inexact
  #|mxgx480 maxmag  33333  5000   ->  3.33E+4 Rounded Inexact
  #|mxgx481 maxmag  .5     1      ->  1
  #|mxgx482 maxmag  .5     10     ->  10
  #|mxgx483 maxmag  .5     100    ->  100
  #|mxgx484 maxmag  .5     1000   ->  1.00E+3 Rounded
  #|mxgx485 maxmag  .5     10000  ->  1.00E+4 Rounded
  #|mxgx486 maxmag  .5     6      ->  6
  #|mxgx487 maxmag  .5     66     ->  66
  #|mxgx488 maxmag  .5     666    ->  666
  #|mxgx489 maxmag  .5     6666   ->  6.67E+3 Rounded Inexact
  #|mxgx490 maxmag  .5     66666  ->  6.67E+4 Rounded Inexact
  #|mxgx491 maxmag  .5     33333  ->  3.33E+4 Rounded Inexact
  #|
  #|-- overflow tests
  #|maxexponent: 999999999
  #|minexponent: -999999999
  #|precision: 3
  #|mxgx500 maxmag 9.999E+999999999  0 ->  Infinity Inexact Overflow Rounded
  #|mxgx501 maxmag -9.999E+999999999 0 -> -Infinity Inexact Overflow Rounded
  #|
  #|-- subnormals and underflow
  #|precision: 3
  #|maxexponent: 999
  #|minexponent: -999
  #|mxgx510 maxmag  1.00E-999       0  ->   1.00E-999
  #|mxgx511 maxmag  0.1E-999        0  ->   1E-1000   Subnormal
  #|mxgx512 maxmag  0.10E-999       0  ->   1.0E-1000 Subnormal
  #|mxgx513 maxmag  0.100E-999      0  ->   1.0E-1000 Subnormal Rounded
  #|mxgx514 maxmag  0.01E-999       0  ->   1E-1001   Subnormal
  #|-- next is rounded to Nmin
  #|mxgx515 maxmag  0.999E-999      0  ->   1.00E-999 Inexact Rounded Subnormal Underflow
  #|mxgx516 maxmag  0.099E-999      0  ->   1.0E-1000 Inexact Rounded Subnormal Underflow
  #|mxgx517 maxmag  0.009E-999      0  ->   1E-1001   Inexact Rounded Subnormal Underflow
  #|mxgx518 maxmag  0.001E-999      0  ->   0E-1001   Inexact Rounded Subnormal Underflow Clamped
  #|mxgx519 maxmag  0.0009E-999     0  ->   0E-1001   Inexact Rounded Subnormal Underflow Clamped
  #|mxgx520 maxmag  0.0001E-999     0  ->   0E-1001   Inexact Rounded Subnormal Underflow Clamped
  #|
  #|mxgx530 maxmag -1.00E-999       0  ->  -1.00E-999
  #|mxgx531 maxmag -0.1E-999        0  ->  -1E-1000   Subnormal
  #|mxgx532 maxmag -0.10E-999       0  ->  -1.0E-1000 Subnormal
  #|mxgx533 maxmag -0.100E-999      0  ->  -1.0E-1000 Subnormal Rounded
  #|mxgx534 maxmag -0.01E-999       0  ->  -1E-1001   Subnormal
  #|-- next is rounded to -Nmin
  #|mxgx535 maxmag -0.999E-999      0  ->  -1.00E-999 Inexact Rounded Subnormal Underflow
  #|mxgx536 maxmag -0.099E-999      0  ->  -1.0E-1000 Inexact Rounded Subnormal Underflow
  #|mxgx537 maxmag -0.009E-999      0  ->  -1E-1001   Inexact Rounded Subnormal Underflow
  #|mxgx538 maxmag -0.001E-999      0  ->  -0E-1001   Inexact Rounded Subnormal Underflow Clamped
  #|mxgx539 maxmag -0.0009E-999     0  ->  -0E-1001   Inexact Rounded Subnormal Underflow Clamped
  #|mxgx540 maxmag -0.0001E-999     0  ->  -0E-1001   Inexact Rounded Subnormal Underflow Clamped
  #|
  #|-- Null tests
  #|mxgx900 maxmag 10  #  -> NaN Invalid_operation
  #|mxgx901 maxmag  # 10  -> NaN Invalid_operation

///|
/// Full `minmag.decTest` corpus (IBM General Decimal
/// Arithmetic testcases), embedded verbatim.
let minmag_subset : String =
  #|------------------------------------------------------------------------
  #|-- minmag.decTest -- decimal minimum by magnitude                     --
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
  #|-- we assume that base comparison is tested in compare.decTest, so
  #|-- these mainly cover special cases and rounding
  #|
  #|extended:    1
  #|precision:   9
  #|rounding:    half_up
  #|maxExponent: 384
  #|minexponent: -383
  #|
  #|-- sanity checks
  #|mngx001 minmag  -2  -2  -> -2
  #|mngx002 minmag  -2  -1  -> -1
  #|mngx003 minmag  -2   0  ->  0
  #|mngx004 minmag  -2   1  ->  1
  #|mngx005 minmag  -2   2  -> -2
  #|mngx006 minmag  -1  -2  -> -1
  #|mngx007 minmag  -1  -1  -> -1
  #|mngx008 minmag  -1   0  ->  0
  #|mngx009 minmag  -1   1  -> -1
  #|mngx010 minmag  -1   2  -> -1
  #|mngx011 minmag   0  -2  ->  0
  #|mngx012 minmag   0  -1  ->  0
  #|mngx013 minmag   0   0  ->  0
  #|mngx014 minmag   0   1  ->  0
  #|mngx015 minmag   0   2  ->  0
  #|mngx016 minmag   1  -2  ->  1
  #|mngx017 minmag   1  -1  -> -1
  #|mngx018 minmag   1   0  ->  0
  #|mngx019 minmag   1   1  ->  1
  #|mngx020 minmag   1   2  ->  1
  #|mngx021 minmag   2  -2  -> -2
  #|mngx022 minmag   2  -1  -> -1
  #|mngx023 minmag   2   0  ->  0
  #|mngx025 minmag   2   1  ->  1
  #|mngx026 minmag   2   2  ->  2
  #|
  #|-- extended zeros
  #|mngx030 minmag   0     0   ->  0
  #|mngx031 minmag   0    -0   -> -0
  #|mngx032 minmag   0    -0.0 -> -0.0
  #|mngx033 minmag   0     0.0 ->  0.0
  #|mngx034 minmag  -0     0   -> -0
  #|mngx035 minmag  -0    -0   -> -0
  #|mngx036 minmag  -0    -0.0 -> -0
  #|mngx037 minmag  -0     0.0 -> -0
  #|mngx038 minmag   0.0   0   ->  0.0
  #|mngx039 minmag   0.0  -0   -> -0
  #|mngx040 minmag   0.0  -0.0 -> -0.0
  #|mngx041 minmag   0.0   0.0 ->  0.0
  #|mngx042 minmag  -0.0   0   -> -0.0
  #|mngx043 minmag  -0.0  -0   -> -0
  #|mngx044 minmag  -0.0  -0.0 -> -0.0
  #|mngx045 minmag  -0.0   0.0 -> -0.0
  #|
  #|mngx046 minmag   0E1  -0E1 -> -0E+1
  #|mngx047 minmag  -0E1   0E2 -> -0E+1
  #|mngx048 minmag   0E2   0E1 ->  0E+1
  #|mngx049 minmag   0E1   0E2 ->  0E+1
  #|mngx050 minmag  -0E3  -0E2 -> -0E+3
  #|mngx051 minmag  -0E2  -0E3 -> -0E+3
  #|
  #|-- Specials
  #|precision: 9
  #|mngx090 minmag  Inf  -Inf   -> -Infinity
  #|mngx091 minmag  Inf  -1000  -> -1000
  #|mngx092 minmag  Inf  -1     -> -1
  #|mngx093 minmag  Inf  -0     -> -0
  #|mngx094 minmag  Inf   0     ->  0
  #|mngx095 minmag  Inf   1     ->  1
  #|mngx096 minmag  Inf   1000  ->  1000
  #|mngx097 minmag  Inf   Inf   ->  Infinity
  #|mngx098 minmag -1000  Inf   -> -1000
  #|mngx099 minmag -Inf   Inf   -> -Infinity
  #|mngx100 minmag -1     Inf   -> -1
  #|mngx101 minmag -0     Inf   -> -0
  #|mngx102 minmag  0     Inf   ->  0
  #|mngx103 minmag  1     Inf   ->  1
  #|mngx104 minmag  1000  Inf   ->  1000
  #|mngx105 minmag  Inf   Inf   ->  Infinity
  #|
  #|mngx120 minmag -Inf  -Inf   -> -Infinity
  #|mngx121 minmag -Inf  -1000  -> -1000
  #|mngx122 minmag -Inf  -1     -> -1
  #|mngx123 minmag -Inf  -0     -> -0
  #|mngx124 minmag -Inf   0     ->  0
  #|mngx125 minmag -Inf   1     ->  1
  #|mngx126 minmag -Inf   1000  ->  1000
  #|mngx127 minmag -Inf   Inf   -> -Infinity
  #|mngx128 minmag -Inf  -Inf   -> -Infinity
  #|mngx129 minmag -1000 -Inf   -> -1000
  #|mngx130 minmag -1    -Inf   -> -1
  #|mngx131 minmag -0    -Inf   -> -0
  #|mngx132 minmag  0    -Inf   ->  0
  #|mngx133 minmag  1    -Inf   ->  1
  #|mngx134 minmag  1000 -Inf   ->  1000
  #|mngx135 minmag  Inf  -Inf   -> -Infinity
  #|
  #|-- 2004.08.02 754r chooses number over NaN in mixed cases
  #|mngx141 minmag  NaN -Inf    ->  -Infinity
  #|mngx142 minmag  NaN -1000   ->  -1000
  #|mngx143 minmag  NaN -1      ->  -1
  #|mngx144 minmag  NaN -0      ->  -0
  #|mngx145 minmag  NaN  0      ->  0
  #|mngx146 minmag  NaN  1      ->  1
  #|mngx147 minmag  NaN  1000   ->  1000
  #|mngx148 minmag  NaN  Inf    ->  Infinity
  #|mngx149 minmag  NaN  NaN    ->  NaN
  #|mngx150 minmag -Inf  NaN    -> -Infinity
  #|mngx151 minmag -1000 NaN    -> -1000
  #|mngx152 minmag -1   -NaN    -> -1
  #|mngx153 minmag -0    NaN    -> -0
  #|mngx154 minmag  0   -NaN    ->  0
  #|mngx155 minmag  1    NaN    ->  1
  #|mngx156 minmag  1000 NaN    ->  1000
  #|mngx157 minmag  Inf  NaN    ->  Infinity
  #|
  #|mngx161 minmag  sNaN -Inf   ->  NaN  Invalid_operation
  #|mngx162 minmag  sNaN -1000  ->  NaN  Invalid_operation
  #|mngx163 minmag  sNaN -1     ->  NaN  Invalid_operation
  #|mngx164 minmag  sNaN -0     ->  NaN  Invalid_operation
  #|mngx165 minmag -sNaN  0     -> -NaN  Invalid_operation
  #|mngx166 minmag -sNaN  1     -> -NaN  Invalid_operation
  #|mngx167 minmag  sNaN  1000  ->  NaN  Invalid_operation
  #|mngx168 minmag  sNaN  NaN   ->  NaN  Invalid_operation
  #|mngx169 minmag  sNaN sNaN   ->  NaN  Invalid_operation
  #|mngx170 minmag  NaN  sNaN   ->  NaN  Invalid_operation
  #|mngx171 minmag -Inf  sNaN   ->  NaN  Invalid_operation
  #|mngx172 minmag -1000 sNaN   ->  NaN  Invalid_operation
  #|mngx173 minmag -1    sNaN   ->  NaN  Invalid_operation
  #|mngx174 minmag -0    sNaN   ->  NaN  Invalid_operation
  #|mngx175 minmag  0    sNaN   ->  NaN  Invalid_operation
  #|mngx176 minmag  1    sNaN   ->  NaN  Invalid_operation
  #|mngx177 minmag  1000 sNaN   ->  NaN  Invalid_operation
  #|mngx178 minmag  Inf  sNaN   ->  NaN  Invalid_operation
  #|mngx179 minmag  NaN  sNaN   ->  NaN  Invalid_operation
  #|
  #|-- propagating NaNs
  #|mngx181 minmag  NaN9   -Inf   -> -Infinity
  #|mngx182 minmag -NaN8    9990  ->  9990
  #|mngx183 minmag  NaN71   Inf   ->  Infinity
  #|
  #|mngx184 minmag  NaN1    NaN54 ->  NaN1
  #|mngx185 minmag  NaN22  -NaN53 ->  NaN22
  #|mngx186 minmag -NaN3    NaN6  -> -NaN3
  #|mngx187 minmag -NaN44   NaN7  -> -NaN44
  #|
  #|mngx188 minmag -Inf     NaN41 -> -Infinity
  #|mngx189 minmag -9999   -NaN33 -> -9999
  #|mngx190 minmag  Inf     NaN2  ->  Infinity
  #|
  #|mngx191 minmag  sNaN99 -Inf    ->  NaN99 Invalid_operation
  #|mngx192 minmag  sNaN98 -11     ->  NaN98 Invalid_operation
  #|mngx193 minmag -sNaN97  NaN8   -> -NaN97 Invalid_operation
  #|mngx194 minmag  sNaN69 sNaN94  ->  NaN69 Invalid_operation
  #|mngx195 minmag  NaN95  sNaN93  ->  NaN93 Invalid_operation
  #|mngx196 minmag -Inf    sNaN92  ->  NaN92 Invalid_operation
  #|mngx197 minmag  088    sNaN91  ->  NaN91 Invalid_operation
  #|mngx198 minmag  Inf   -sNaN90  -> -NaN90 Invalid_operation
  #|mngx199 minmag  NaN    sNaN86  ->  NaN86 Invalid_operation
  #|
  #|-- rounding checks -- chosen is rounded, or not
  #|maxExponent: 999
  #|minexponent: -999
  #|precision: 9
  #|mngx201 minmag -12345678000 1  -> 1
  #|mngx202 minmag 1 -12345678000  -> 1
  #|mngx203 minmag -1234567800  1  -> 1
  #|mngx204 minmag 1 -1234567800   -> 1
  #|mngx205 minmag -1234567890  1  -> 1
  #|mngx206 minmag 1 -1234567890   -> 1
  #|mngx207 minmag -1234567891  1  -> 1
  #|mngx208 minmag 1 -1234567891   -> 1
  #|mngx209 minmag -12345678901 1  -> 1
  #|mngx210 minmag 1 -12345678901  -> 1
  #|mngx211 minmag -1234567896  1  -> 1
  #|mngx212 minmag 1 -1234567896   -> 1
  #|mngx213 minmag 1234567891  1   -> 1
  #|mngx214 minmag 1 1234567891    -> 1
  #|mngx215 minmag 12345678901 1   -> 1
  #|mngx216 minmag 1 12345678901   -> 1
  #|mngx217 minmag 1234567896  1   -> 1
  #|mngx218 minmag 1 1234567896    -> 1
  #|
  #|precision: 15
  #|mngx221 minmag -12345678000 1  -> 1
  #|mngx222 minmag 1 -12345678000  -> 1
  #|mngx223 minmag -1234567800  1  -> 1
  #|mngx224 minmag 1 -1234567800   -> 1
  #|mngx225 minmag -1234567890  1  -> 1
  #|mngx226 minmag 1 -1234567890   -> 1
  #|mngx227 minmag -1234567891  1  -> 1
  #|mngx228 minmag 1 -1234567891   -> 1
  #|mngx229 minmag -12345678901 1  -> 1
  #|mngx230 minmag 1 -12345678901  -> 1
  #|mngx231 minmag -1234567896  1  -> 1
  #|mngx232 minmag 1 -1234567896   -> 1
  #|mngx233 minmag 1234567891  1   -> 1
  #|mngx234 minmag 1 1234567891    -> 1
  #|mngx235 minmag 12345678901 1   -> 1
  #|mngx236 minmag 1 12345678901   -> 1
  #|mngx237 minmag 1234567896  1   -> 1
  #|mngx238 minmag 1 1234567896    -> 1
  #|
  #|-- from examples
  #|mngx280 minmag '3'   '2'  ->  '2'
  #|mngx281 minmag '-10' '3'  ->  '3'
  #|mngx282 minmag '1.0' '1'  ->  '1.0'
  #|mngx283 minmag '1' '1.0'  ->  '1.0'
  #|mngx284 minmag '7' 'NaN'  ->  '7'
  #|
  #|-- overflow and underflow tests .. subnormal results [inputs] now allowed
  #|maxExponent: 999999999
  #|minexponent: -999999999
  #|mngx330 minmag -1.23456789012345E-0 -9E+999999999 -> -1.23456789012345
  #|mngx331 minmag -9E+999999999 -1.23456789012345E-0 -> -1.23456789012345
  #|mngx332 minmag -0.100 -9E-999999999               -> -9E-999999999
  #|mngx333 minmag -9E-999999999 -0.100               -> -9E-999999999
  #|mngx335 minmag +1.23456789012345E-0 -9E+999999999 ->  1.23456789012345
  #|mngx336 minmag -9E+999999999 1.23456789012345E-0  ->  1.23456789012345
  #|mngx337 minmag +0.100 -9E-999999999               -> -9E-999999999
  #|mngx338 minmag -9E-999999999 0.100                -> -9E-999999999
  #|
  #|mngx339 minmag -1e-599999999 -1e-400000001   ->  -1E-599999999
  #|mngx340 minmag -1e-599999999 -1e-400000000   ->  -1E-599999999
  #|mngx341 minmag -1e-600000000 -1e-400000000   ->  -1E-600000000
  #|mngx342 minmag -9e-999999998 -0.01           ->  -9E-999999998
  #|mngx343 minmag -9e-999999998 -0.1            ->  -9E-999999998
  #|mngx344 minmag -0.01         -9e-999999998   ->  -9E-999999998
  #|mngx345 minmag -1e599999999  -1e400000001    ->  -1E+400000001
  #|mngx346 minmag -1e599999999  -1e400000000    ->  -1E+400000000
  #|mngx347 minmag -1e600000000  -1e400000000    ->  -1E+400000000
  #|mngx348 minmag -9e999999998  -100            ->  -100
  #|mngx349 minmag -9e999999998  -10             ->  -10
  #|mngx350 minmag -100          -9e999999998    ->  -100
  #|-- signs
  #|mngx351 minmag -1e+777777777 -1e+411111111 -> -1E+411111111
  #|mngx352 minmag -1e+777777777 +1e+411111111 ->  1E+411111111
  #|mngx353 minmag +1e+777777777 -1e+411111111 -> -1E+411111111
  #|mngx354 minmag +1e+777777777 +1e+411111111 ->  1E+411111111
  #|mngx355 minmag -1e-777777777 -1e-411111111 -> -1E-777777777
  #|mngx356 minmag -1e-777777777 +1e-411111111 -> -1E-777777777
  #|mngx357 minmag +1e-777777777 -1e-411111111 ->  1E-777777777
  #|mngx358 minmag +1e-777777777 +1e-411111111 ->  1E-777777777
  #|
  #|-- expanded list from min/max 754r purple prose
  #|-- [explicit tests for exponent ordering]
  #|mngx401 minmag  Inf    1.1     ->  1.1
  #|mngx402 minmag  1.1    1       ->  1
  #|mngx403 minmag  1      1.0     ->  1.0
  #|mngx404 minmag  1.0    0.1     ->  0.1
  #|mngx405 minmag  0.1    0.10    ->  0.10
  #|mngx406 minmag  0.10   0.100   ->  0.100
  #|mngx407 minmag  0.10   0       ->  0
  #|mngx408 minmag  0      0.0     ->  0.0
  #|mngx409 minmag  0.0   -0       -> -0
  #|mngx410 minmag  0.0   -0.0     -> -0.0
  #|mngx411 minmag  0.00  -0.0     -> -0.0
  #|mngx412 minmag  0.0   -0.00    -> -0.00
  #|mngx413 minmag  0     -0.0     -> -0.0
  #|mngx414 minmag  0     -0       -> -0
  #|mngx415 minmag -0.0   -0       -> -0
  #|mngx416 minmag -0     -0.100   -> -0
  #|mngx417 minmag -0.100 -0.10    -> -0.10
  #|mngx418 minmag -0.10  -0.1     -> -0.1
  #|mngx419 minmag -0.1   -1.0     -> -0.1
  #|mngx420 minmag -1.0   -1       -> -1
  #|mngx421 minmag -1     -1.1     -> -1
  #|mngx423 minmag -1.1   -Inf     -> -1.1
  #|-- same with operands reversed
  #|mngx431 minmag  1.1    Inf     ->  1.1
  #|mngx432 minmag  1      1.1     ->  1
  #|mngx433 minmag  1.0    1       ->  1.0
  #|mngx434 minmag  0.1    1.0     ->  0.1
  #|mngx435 minmag  0.10   0.1     ->  0.10
  #|mngx436 minmag  0.100  0.10    ->  0.100
  #|mngx437 minmag  0      0.10    ->  0
  #|mngx438 minmag  0.0    0       ->  0.0
  #|mngx439 minmag -0      0.0     -> -0
  #|mngx440 minmag -0.0    0.0     -> -0.0
  #|mngx441 minmag -0.0    0.00    -> -0.0
  #|mngx442 minmag -0.00   0.0     -> -0.00
  #|mngx443 minmag -0.0    0       -> -0.0
  #|mngx444 minmag -0      0       -> -0
  #|mngx445 minmag -0     -0.0     -> -0
  #|mngx446 minmag -0.100 -0       -> -0
  #|mngx447 minmag -0.10  -0.100   -> -0.10
  #|mngx448 minmag -0.1   -0.10    -> -0.1
  #|mngx449 minmag -1.0   -0.1     -> -0.1
  #|mngx450 minmag -1     -1.0     -> -1
  #|mngx451 minmag -1.1   -1       -> -1
  #|mngx453 minmag -Inf   -1.1     -> -1.1
  #|-- largies
  #|mngx460 minmag  1000   1E+3    ->  1000
  #|mngx461 minmag  1E+3   1000    ->  1000
  #|mngx462 minmag  1000  -1E+3    -> -1E+3
  #|mngx463 minmag  1E+3  -1000    -> -1000
  #|mngx464 minmag -1000   1E+3    -> -1000
  #|mngx465 minmag -1E+3   1000    -> -1E+3
  #|mngx466 minmag -1000  -1E+3    -> -1E+3
  #|mngx467 minmag -1E+3  -1000    -> -1E+3
  #|
  #|-- rounding (results treated as though plus)
  #|maxexponent: 999999999
  #|minexponent: -999999999
  #|precision: 3
  #|
  #|mngx470 minmag  1      5      ->  1
  #|mngx471 minmag  10     50     ->  10
  #|mngx472 minmag  100    500    ->  100
  #|mngx473 minmag  1000   5000   ->  1.00E+3 Rounded
  #|mngx474 minmag  10000  50000  ->  1.00E+4 Rounded
  #|mngx475 minmag  6      50     ->  6
  #|mngx476 minmag  66     500    ->  66
  #|mngx477 minmag  666    5000   ->  666
  #|mngx478 minmag  6666   50000  ->  6.67E+3 Rounded Inexact
  #|mngx479 minmag  66666  500000 ->  6.67E+4 Rounded Inexact
  #|mngx480 minmag  33333  500000 ->  3.33E+4 Rounded Inexact
  #|mngx481 minmag  75401  1      ->  1
  #|mngx482 minmag  75402  10     ->  10
  #|mngx483 minmag  75403  100    ->  100
  #|mngx484 minmag  75404  1000   ->  1.00E+3 Rounded
  #|mngx485 minmag  75405  10000  ->  1.00E+4 Rounded
  #|mngx486 minmag  75406  6      ->  6
  #|mngx487 minmag  75407  66     ->  66
  #|mngx488 minmag  75408  666    ->  666
  #|mngx489 minmag  75409  6666   ->  6.67E+3 Rounded Inexact
  #|mngx490 minmag  75410  66666  ->  6.67E+4 Rounded Inexact
  #|mngx491 minmag  75411  33333  ->  3.33E+4 Rounded Inexact
  #|
  #|
  #|-- overflow tests
  #|maxexponent: 999999999
  #|minexponent: -999999999
  #|precision: 3
  #|mngx500 minmag 9.999E+999999999  0 ->  0
  #|mngx501 minmag -9.999E+999999999 0 ->  0
  #|
  #|-- subnormals and underflow
  #|precision: 3
  #|maxexponent: 999
  #|minexponent: -999
  #|mngx510 minmag  1.00E-999       0  ->   0
  #|mngx511 minmag  0.1E-999        0  ->   0
  #|mngx512 minmag  0.10E-999       0  ->   0
  #|mngx513 minmag  0.100E-999      0  ->   0
  #|mngx514 minmag  0.01E-999       0  ->   0
  #|mngx515 minmag  0.999E-999      0  ->   0
  #|mngx516 minmag  0.099E-999      0  ->   0
  #|mngx517 minmag  0.009E-999      0  ->   0
  #|mngx518 minmag  0.001E-999      0  ->   0
  #|mngx519 minmag  0.0009E-999     0  ->   0
  #|mngx520 minmag  0.0001E-999     0  ->   0
  #|
  #|mngx530 minmag -1.00E-999       0  ->   0
  #|mngx531 minmag -0.1E-999        0  ->   0
  #|mngx532 minmag -0.10E-999       0  ->   0
  #|mngx533 minmag -0.100E-999      0  ->   0
  #|mngx534 minmag -0.01E-999       0  ->   0
  #|mngx535 minmag -0.999E-999      0  ->   0
  #|mngx536 minmag -0.099E-999      0  ->   0
  #|mngx537 minmag -0.009E-999      0  ->   0
  #|mngx538 minmag -0.001E-999      0  ->   0
  #|mngx539 minmag -0.0009E-999     0  ->   0
  #|mngx540 minmag -0.0001E-999     0  ->   0
  #|
  #|
  #|-- Null tests
  #|mng900 minmag 10  # -> NaN Invalid_operation
  #|mng901 minmag  # 10 -> NaN Invalid_operation

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
test "max.decTest subset" {
  run_subset("max", max_subset)
}

///|
test "min.decTest subset" {
  run_subset("min", min_subset)
}

///|
test "maxmag.decTest subset" {
  run_subset("maxmag", maxmag_subset)
}

///|
test "minmag.decTest subset" {
  run_subset("minmag", minmag_subset)
}
