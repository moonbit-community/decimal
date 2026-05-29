///|
/// Full `tointegral.decTest` corpus (IBM General Decimal
/// Arithmetic testcases), embedded verbatim.
let tointegral_subset : String =
  #|------------------------------------------------------------------------
  #|-- tointegral.decTest -- round decimal to integral value              --
  #|-- Copyright (c) IBM Corporation, 2001, 2008.  All rights reserved.   --
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
  #|-- This set of tests tests the extended specification 'round-to-integral
  #|-- value' operation (from IEEE 854, later modified in 754r).
  #|-- All non-zero results are defined as being those from either copy or
  #|-- quantize, so those are assumed to have been tested.
  #|-- Note that 754r requires that Inexact not be set, and we similarly
  #|-- assume Rounded is not set.
  #|
  #|extended:    1
  #|precision:   9
  #|rounding:    half_up
  #|maxExponent: 999
  #|minExponent: -999
  #|
  #|intx001 tointegral      0     ->  0
  #|intx002 tointegral      0.0   ->  0
  #|intx003 tointegral      0.1   ->  0
  #|intx004 tointegral      0.2   ->  0
  #|intx005 tointegral      0.3   ->  0
  #|intx006 tointegral      0.4   ->  0
  #|intx007 tointegral      0.5   ->  1
  #|intx008 tointegral      0.6   ->  1
  #|intx009 tointegral      0.7   ->  1
  #|intx010 tointegral      0.8   ->  1
  #|intx011 tointegral      0.9   ->  1
  #|intx012 tointegral      1     ->  1
  #|intx013 tointegral      1.0   ->  1
  #|intx014 tointegral      1.1   ->  1
  #|intx015 tointegral      1.2   ->  1
  #|intx016 tointegral      1.3   ->  1
  #|intx017 tointegral      1.4   ->  1
  #|intx018 tointegral      1.5   ->  2
  #|intx019 tointegral      1.6   ->  2
  #|intx020 tointegral      1.7   ->  2
  #|intx021 tointegral      1.8   ->  2
  #|intx022 tointegral      1.9   ->  2
  #|-- negatives
  #|intx031 tointegral     -0     -> -0
  #|intx032 tointegral     -0.0   -> -0
  #|intx033 tointegral     -0.1   -> -0
  #|intx034 tointegral     -0.2   -> -0
  #|intx035 tointegral     -0.3   -> -0
  #|intx036 tointegral     -0.4   -> -0
  #|intx037 tointegral     -0.5   -> -1
  #|intx038 tointegral     -0.6   -> -1
  #|intx039 tointegral     -0.7   -> -1
  #|intx040 tointegral     -0.8   -> -1
  #|intx041 tointegral     -0.9   -> -1
  #|intx042 tointegral     -1     -> -1
  #|intx043 tointegral     -1.0   -> -1
  #|intx044 tointegral     -1.1   -> -1
  #|intx045 tointegral     -1.2   -> -1
  #|intx046 tointegral     -1.3   -> -1
  #|intx047 tointegral     -1.4   -> -1
  #|intx048 tointegral     -1.5   -> -2
  #|intx049 tointegral     -1.6   -> -2
  #|intx050 tointegral     -1.7   -> -2
  #|intx051 tointegral     -1.8   -> -2
  #|intx052 tointegral     -1.9   -> -2
  #|-- next two would be NaN using quantize(x, 0)
  #|intx053 tointegral    10E+30  -> 1.0E+31
  #|intx054 tointegral   -10E+30  -> -1.0E+31
  #|
  #|-- numbers around precision
  #|precision: 9
  #|intx060 tointegral '56267E-10'   -> '0'
  #|intx061 tointegral '56267E-5'    -> '1'
  #|intx062 tointegral '56267E-2'    -> '563'
  #|intx063 tointegral '56267E-1'    -> '5627'
  #|intx065 tointegral '56267E-0'    -> '56267'
  #|intx066 tointegral '56267E+0'    -> '56267'
  #|intx067 tointegral '56267E+1'    -> '5.6267E+5'
  #|intx068 tointegral '56267E+2'    -> '5.6267E+6'
  #|intx069 tointegral '56267E+3'    -> '5.6267E+7'
  #|intx070 tointegral '56267E+4'    -> '5.6267E+8'
  #|intx071 tointegral '56267E+5'    -> '5.6267E+9'
  #|intx072 tointegral '56267E+6'    -> '5.6267E+10'
  #|intx073 tointegral '1.23E+96'    -> '1.23E+96'
  #|intx074 tointegral '1.23E+384'   -> '1.23E+384'
  #|intx075 tointegral '1.23E+999'   -> '1.23E+999'
  #|
  #|intx080 tointegral '-56267E-10'  -> '-0'
  #|intx081 tointegral '-56267E-5'   -> '-1'
  #|intx082 tointegral '-56267E-2'   -> '-563'
  #|intx083 tointegral '-56267E-1'   -> '-5627'
  #|intx085 tointegral '-56267E-0'   -> '-56267'
  #|intx086 tointegral '-56267E+0'   -> '-56267'
  #|intx087 tointegral '-56267E+1'   -> '-5.6267E+5'
  #|intx088 tointegral '-56267E+2'   -> '-5.6267E+6'
  #|intx089 tointegral '-56267E+3'   -> '-5.6267E+7'
  #|intx090 tointegral '-56267E+4'   -> '-5.6267E+8'
  #|intx091 tointegral '-56267E+5'   -> '-5.6267E+9'
  #|intx092 tointegral '-56267E+6'   -> '-5.6267E+10'
  #|intx093 tointegral '-1.23E+96'   -> '-1.23E+96'
  #|intx094 tointegral '-1.23E+384'  -> '-1.23E+384'
  #|intx095 tointegral '-1.23E+999'  -> '-1.23E+999'
  #|
  #|-- subnormal inputs
  #|intx100 tointegral        1E-999 -> 0
  #|intx101 tointegral      0.1E-999 -> 0
  #|intx102 tointegral     0.01E-999 -> 0
  #|intx103 tointegral        0E-999 -> 0
  #|
  #|-- specials and zeros
  #|intx120 tointegral 'Inf'       ->  Infinity
  #|intx121 tointegral '-Inf'      -> -Infinity
  #|intx122 tointegral   NaN       ->  NaN
  #|intx123 tointegral  sNaN       ->  NaN  Invalid_operation
  #|intx124 tointegral     0       ->  0
  #|intx125 tointegral    -0       -> -0
  #|intx126 tointegral     0.000   ->  0
  #|intx127 tointegral     0.00    ->  0
  #|intx128 tointegral     0.0     ->  0
  #|intx129 tointegral     0       ->  0
  #|intx130 tointegral     0E-3    ->  0
  #|intx131 tointegral     0E-2    ->  0
  #|intx132 tointegral     0E-1    ->  0
  #|intx133 tointegral     0E-0    ->  0
  #|intx134 tointegral     0E+1    ->  0E+1
  #|intx135 tointegral     0E+2    ->  0E+2
  #|intx136 tointegral     0E+3    ->  0E+3
  #|intx137 tointegral     0E+4    ->  0E+4
  #|intx138 tointegral     0E+5    ->  0E+5
  #|intx139 tointegral    -0.000   -> -0
  #|intx140 tointegral    -0.00    -> -0
  #|intx141 tointegral    -0.0     -> -0
  #|intx142 tointegral    -0       -> -0
  #|intx143 tointegral    -0E-3    -> -0
  #|intx144 tointegral    -0E-2    -> -0
  #|intx145 tointegral    -0E-1    -> -0
  #|intx146 tointegral    -0E-0    -> -0
  #|intx147 tointegral    -0E+1    -> -0E+1
  #|intx148 tointegral    -0E+2    -> -0E+2
  #|intx149 tointegral    -0E+3    -> -0E+3
  #|intx150 tointegral    -0E+4    -> -0E+4
  #|intx151 tointegral    -0E+5    -> -0E+5
  #|-- propagating NaNs
  #|intx152 tointegral   NaN808    ->  NaN808
  #|intx153 tointegral  sNaN080    ->  NaN80  Invalid_operation
  #|intx154 tointegral  -NaN808    -> -NaN808
  #|intx155 tointegral -sNaN080    -> -NaN80  Invalid_operation
  #|intx156 tointegral  -NaN       -> -NaN
  #|intx157 tointegral -sNaN       -> -NaN    Invalid_operation
  #|
  #|-- examples
  #|rounding:    half_up
  #|precision:   9
  #|intx200 tointegral     2.1    -> 2
  #|intx201 tointegral   100      -> 100
  #|intx202 tointegral   100.0    -> 100
  #|intx203 tointegral   101.5    -> 102
  #|intx204 tointegral  -101.5    -> -102
  #|intx205 tointegral   10E+5    -> 1.0E+6
  #|intx206 tointegral  7.89E+77  -> 7.89E+77
  #|intx207 tointegral   -Inf     -> -Infinity
  #|
  #|
  #|-- all rounding modes
  #|rounding:    half_even
  #|
  #|intx210 tointegral     55.5   ->  56
  #|intx211 tointegral     56.5   ->  56
  #|intx212 tointegral     57.5   ->  58
  #|intx213 tointegral    -55.5   -> -56
  #|intx214 tointegral    -56.5   -> -56
  #|intx215 tointegral    -57.5   -> -58
  #|
  #|rounding:    half_up
  #|
  #|intx220 tointegral     55.5   ->  56
  #|intx221 tointegral     56.5   ->  57
  #|intx222 tointegral     57.5   ->  58
  #|intx223 tointegral    -55.5   -> -56
  #|intx224 tointegral    -56.5   -> -57
  #|intx225 tointegral    -57.5   -> -58
  #|
  #|rounding:    half_down
  #|
  #|intx230 tointegral     55.5   ->  55
  #|intx231 tointegral     56.5   ->  56
  #|intx232 tointegral     57.5   ->  57
  #|intx233 tointegral    -55.5   -> -55
  #|intx234 tointegral    -56.5   -> -56
  #|intx235 tointegral    -57.5   -> -57
  #|
  #|rounding:    up
  #|
  #|intx240 tointegral     55.3   ->  56
  #|intx241 tointegral     56.3   ->  57
  #|intx242 tointegral     57.3   ->  58
  #|intx243 tointegral    -55.3   -> -56
  #|intx244 tointegral    -56.3   -> -57
  #|intx245 tointegral    -57.3   -> -58
  #|
  #|rounding:    down
  #|
  #|intx250 tointegral     55.7   ->  55
  #|intx251 tointegral     56.7   ->  56
  #|intx252 tointegral     57.7   ->  57
  #|intx253 tointegral    -55.7   -> -55
  #|intx254 tointegral    -56.7   -> -56
  #|intx255 tointegral    -57.7   -> -57
  #|
  #|rounding:    ceiling
  #|
  #|intx260 tointegral     55.3   ->  56
  #|intx261 tointegral     56.3   ->  57
  #|intx262 tointegral     57.3   ->  58
  #|intx263 tointegral    -55.3   -> -55
  #|intx264 tointegral    -56.3   -> -56
  #|intx265 tointegral    -57.3   -> -57
  #|
  #|rounding:    floor
  #|
  #|intx270 tointegral     55.7   ->  55
  #|intx271 tointegral     56.7   ->  56
  #|intx272 tointegral     57.7   ->  57
  #|intx273 tointegral    -55.7   -> -56
  #|intx274 tointegral    -56.7   -> -57
  #|intx275 tointegral    -57.7   -> -58

///|
/// Full `tointegralx.decTest` corpus (IBM General Decimal
/// Arithmetic testcases), embedded verbatim.
let tointegralx_subset : String =
  #|------------------------------------------------------------------------
  #|-- tointegralx.decTest -- round decimal to integral value, exact      --
  #|-- Copyright (c) IBM Corporation, 2001, 2008.  All rights reserved.   --
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
  #|-- This set of tests tests the extended specification 'round-to-integral
  #|-- value' operation (from IEEE 854, later modified in 754r).
  #|-- All non-zero results are defined as being those from either copy or
  #|-- quantize, so those are assumed to have been tested.
  #|
  #|-- This tests toIntegraExact, which may set Inexact
  #|
  #|extended:    1
  #|precision:   9
  #|rounding:    half_up
  #|maxExponent: 999
  #|minExponent: -999
  #|
  #|intxx001 tointegralx      0     ->  0
  #|intxx002 tointegralx      0.0   ->  0
  #|intxx003 tointegralx      0.1   ->  0 Inexact Rounded
  #|intxx004 tointegralx      0.2   ->  0 Inexact Rounded
  #|intxx005 tointegralx      0.3   ->  0 Inexact Rounded
  #|intxx006 tointegralx      0.4   ->  0 Inexact Rounded
  #|intxx007 tointegralx      0.5   ->  1 Inexact Rounded
  #|intxx008 tointegralx      0.6   ->  1 Inexact Rounded
  #|intxx009 tointegralx      0.7   ->  1 Inexact Rounded
  #|intxx010 tointegralx      0.8   ->  1 Inexact Rounded
  #|intxx011 tointegralx      0.9   ->  1 Inexact Rounded
  #|intxx012 tointegralx      1     ->  1
  #|intxx013 tointegralx      1.0   ->  1 Rounded
  #|intxx014 tointegralx      1.1   ->  1 Inexact Rounded
  #|intxx015 tointegralx      1.2   ->  1 Inexact Rounded
  #|intxx016 tointegralx      1.3   ->  1 Inexact Rounded
  #|intxx017 tointegralx      1.4   ->  1 Inexact Rounded
  #|intxx018 tointegralx      1.5   ->  2 Inexact Rounded
  #|intxx019 tointegralx      1.6   ->  2 Inexact Rounded
  #|intxx020 tointegralx      1.7   ->  2 Inexact Rounded
  #|intxx021 tointegralx      1.8   ->  2 Inexact Rounded
  #|intxx022 tointegralx      1.9   ->  2 Inexact Rounded
  #|-- negatives
  #|intxx031 tointegralx     -0     -> -0
  #|intxx032 tointegralx     -0.0   -> -0
  #|intxx033 tointegralx     -0.1   -> -0 Inexact Rounded
  #|intxx034 tointegralx     -0.2   -> -0 Inexact Rounded
  #|intxx035 tointegralx     -0.3   -> -0 Inexact Rounded
  #|intxx036 tointegralx     -0.4   -> -0 Inexact Rounded
  #|intxx037 tointegralx     -0.5   -> -1 Inexact Rounded
  #|intxx038 tointegralx     -0.6   -> -1 Inexact Rounded
  #|intxx039 tointegralx     -0.7   -> -1 Inexact Rounded
  #|intxx040 tointegralx     -0.8   -> -1 Inexact Rounded
  #|intxx041 tointegralx     -0.9   -> -1 Inexact Rounded
  #|intxx042 tointegralx     -1     -> -1
  #|intxx043 tointegralx     -1.0   -> -1 Rounded
  #|intxx044 tointegralx     -1.1   -> -1 Inexact Rounded
  #|intxx045 tointegralx     -1.2   -> -1 Inexact Rounded
  #|intxx046 tointegralx     -1.3   -> -1 Inexact Rounded
  #|intxx047 tointegralx     -1.4   -> -1 Inexact Rounded
  #|intxx048 tointegralx     -1.5   -> -2 Inexact Rounded
  #|intxx049 tointegralx     -1.6   -> -2 Inexact Rounded
  #|intxx050 tointegralx     -1.7   -> -2 Inexact Rounded
  #|intxx051 tointegralx     -1.8   -> -2 Inexact Rounded
  #|intxx052 tointegralx     -1.9   -> -2 Inexact Rounded
  #|-- next two would be NaN using quantize(x, 0)
  #|intxx053 tointegralx    10E+30  -> 1.0E+31
  #|intxx054 tointegralx   -10E+30  -> -1.0E+31
  #|
  #|-- numbers around precision
  #|precision: 9
  #|intxx060 tointegralx '56267E-10'   -> '0'               Inexact Rounded
  #|intxx061 tointegralx '56267E-5'    -> '1'               Inexact Rounded
  #|intxx062 tointegralx '56267E-2'    -> '563'             Inexact Rounded
  #|intxx063 tointegralx '56267E-1'    -> '5627'            Inexact Rounded
  #|intxx065 tointegralx '56267E-0'    -> '56267'
  #|intxx066 tointegralx '56267E+0'    -> '56267'
  #|intxx067 tointegralx '56267E+1'    -> '5.6267E+5'
  #|intxx068 tointegralx '56267E+2'    -> '5.6267E+6'
  #|intxx069 tointegralx '56267E+3'    -> '5.6267E+7'
  #|intxx070 tointegralx '56267E+4'    -> '5.6267E+8'
  #|intxx071 tointegralx '56267E+5'    -> '5.6267E+9'
  #|intxx072 tointegralx '56267E+6'    -> '5.6267E+10'
  #|intxx073 tointegralx '1.23E+96'    -> '1.23E+96'
  #|intxx074 tointegralx '1.23E+384'   -> '1.23E+384'
  #|intxx075 tointegralx '1.23E+999'   -> '1.23E+999'
  #|
  #|intxx080 tointegralx '-56267E-10'  -> '-0'              Inexact Rounded
  #|intxx081 tointegralx '-56267E-5'   -> '-1'              Inexact Rounded
  #|intxx082 tointegralx '-56267E-2'   -> '-563'            Inexact Rounded
  #|intxx083 tointegralx '-56267E-1'   -> '-5627'           Inexact Rounded
  #|intxx085 tointegralx '-56267E-0'   -> '-56267'
  #|intxx086 tointegralx '-56267E+0'   -> '-56267'
  #|intxx087 tointegralx '-56267E+1'   -> '-5.6267E+5'
  #|intxx088 tointegralx '-56267E+2'   -> '-5.6267E+6'
  #|intxx089 tointegralx '-56267E+3'   -> '-5.6267E+7'
  #|intxx090 tointegralx '-56267E+4'   -> '-5.6267E+8'
  #|intxx091 tointegralx '-56267E+5'   -> '-5.6267E+9'
  #|intxx092 tointegralx '-56267E+6'   -> '-5.6267E+10'
  #|intxx093 tointegralx '-1.23E+96'   -> '-1.23E+96'
  #|intxx094 tointegralx '-1.23E+384'  -> '-1.23E+384'
  #|intxx095 tointegralx '-1.23E+999'  -> '-1.23E+999'
  #|
  #|-- subnormal inputs
  #|intxx100 tointegralx        1E-999 -> 0                 Inexact Rounded
  #|intxx101 tointegralx      0.1E-999 -> 0                 Inexact Rounded
  #|intxx102 tointegralx     0.01E-999 -> 0                 Inexact Rounded
  #|intxx103 tointegralx        0E-999 -> 0
  #|
  #|-- specials and zeros
  #|intxx120 tointegralx 'Inf'       ->  Infinity
  #|intxx121 tointegralx '-Inf'      -> -Infinity
  #|intxx122 tointegralx   NaN       ->  NaN
  #|intxx123 tointegralx  sNaN       ->  NaN  Invalid_operation
  #|intxx124 tointegralx     0       ->  0
  #|intxx125 tointegralx    -0       -> -0
  #|intxx126 tointegralx     0.000   ->  0
  #|intxx127 tointegralx     0.00    ->  0
  #|intxx128 tointegralx     0.0     ->  0
  #|intxx129 tointegralx     0       ->  0
  #|intxx130 tointegralx     0E-3    ->  0
  #|intxx131 tointegralx     0E-2    ->  0
  #|intxx132 tointegralx     0E-1    ->  0
  #|intxx133 tointegralx     0E-0    ->  0
  #|intxx134 tointegralx     0E+1    ->  0E+1
  #|intxx135 tointegralx     0E+2    ->  0E+2
  #|intxx136 tointegralx     0E+3    ->  0E+3
  #|intxx137 tointegralx     0E+4    ->  0E+4
  #|intxx138 tointegralx     0E+5    ->  0E+5
  #|intxx139 tointegralx    -0.000   -> -0
  #|intxx140 tointegralx    -0.00    -> -0
  #|intxx141 tointegralx    -0.0     -> -0
  #|intxx142 tointegralx    -0       -> -0
  #|intxx143 tointegralx    -0E-3    -> -0
  #|intxx144 tointegralx    -0E-2    -> -0
  #|intxx145 tointegralx    -0E-1    -> -0
  #|intxx146 tointegralx    -0E-0    -> -0
  #|intxx147 tointegralx    -0E+1    -> -0E+1
  #|intxx148 tointegralx    -0E+2    -> -0E+2
  #|intxx149 tointegralx    -0E+3    -> -0E+3
  #|intxx150 tointegralx    -0E+4    -> -0E+4
  #|intxx151 tointegralx    -0E+5    -> -0E+5
  #|-- propagating NaNs
  #|intxx152 tointegralx   NaN808    ->  NaN808
  #|intxx153 tointegralx  sNaN080    ->  NaN80  Invalid_operation
  #|intxx154 tointegralx  -NaN808    -> -NaN808
  #|intxx155 tointegralx -sNaN080    -> -NaN80  Invalid_operation
  #|intxx156 tointegralx  -NaN       -> -NaN
  #|intxx157 tointegralx -sNaN       -> -NaN    Invalid_operation
  #|
  #|-- examples
  #|rounding:    half_up
  #|precision:   9
  #|intxx200 tointegralx     2.1    -> 2                    Inexact Rounded
  #|intxx201 tointegralx   100      -> 100
  #|intxx202 tointegralx   100.0    -> 100                  Rounded
  #|intxx203 tointegralx   101.5    -> 102                  Inexact Rounded
  #|intxx204 tointegralx  -101.5    -> -102                 Inexact Rounded
  #|intxx205 tointegralx   10E+5    -> 1.0E+6
  #|intxx206 tointegralx  7.89E+77  -> 7.89E+77
  #|intxx207 tointegralx   -Inf     -> -Infinity
  #|
  #|
  #|-- all rounding modes
  #|rounding:    half_even
  #|
  #|intxx210 tointegralx     55.5   ->  56   Inexact Rounded
  #|intxx211 tointegralx     56.5   ->  56   Inexact Rounded
  #|intxx212 tointegralx     57.5   ->  58   Inexact Rounded
  #|intxx213 tointegralx    -55.5   -> -56   Inexact Rounded
  #|intxx214 tointegralx    -56.5   -> -56   Inexact Rounded
  #|intxx215 tointegralx    -57.5   -> -58   Inexact Rounded
  #|
  #|rounding:    half_up
  #|
  #|intxx220 tointegralx     55.5   ->  56   Inexact Rounded
  #|intxx221 tointegralx     56.5   ->  57   Inexact Rounded
  #|intxx222 tointegralx     57.5   ->  58   Inexact Rounded
  #|intxx223 tointegralx    -55.5   -> -56   Inexact Rounded
  #|intxx224 tointegralx    -56.5   -> -57   Inexact Rounded
  #|intxx225 tointegralx    -57.5   -> -58   Inexact Rounded
  #|
  #|rounding:    half_down
  #|
  #|intxx230 tointegralx     55.5   ->  55   Inexact Rounded
  #|intxx231 tointegralx     56.5   ->  56   Inexact Rounded
  #|intxx232 tointegralx     57.5   ->  57   Inexact Rounded
  #|intxx233 tointegralx    -55.5   -> -55   Inexact Rounded
  #|intxx234 tointegralx    -56.5   -> -56   Inexact Rounded
  #|intxx235 tointegralx    -57.5   -> -57   Inexact Rounded
  #|
  #|rounding:    up
  #|
  #|intxx240 tointegralx     55.3   ->  56   Inexact Rounded
  #|intxx241 tointegralx     56.3   ->  57   Inexact Rounded
  #|intxx242 tointegralx     57.3   ->  58   Inexact Rounded
  #|intxx243 tointegralx    -55.3   -> -56   Inexact Rounded
  #|intxx244 tointegralx    -56.3   -> -57   Inexact Rounded
  #|intxx245 tointegralx    -57.3   -> -58   Inexact Rounded
  #|
  #|rounding:    down
  #|
  #|intxx250 tointegralx     55.7   ->  55   Inexact Rounded
  #|intxx251 tointegralx     56.7   ->  56   Inexact Rounded
  #|intxx252 tointegralx     57.7   ->  57   Inexact Rounded
  #|intxx253 tointegralx    -55.7   -> -55   Inexact Rounded
  #|intxx254 tointegralx    -56.7   -> -56   Inexact Rounded
  #|intxx255 tointegralx    -57.7   -> -57   Inexact Rounded
  #|
  #|rounding:    ceiling
  #|
  #|intxx260 tointegralx     55.3   ->  56   Inexact Rounded
  #|intxx261 tointegralx     56.3   ->  57   Inexact Rounded
  #|intxx262 tointegralx     57.3   ->  58   Inexact Rounded
  #|intxx263 tointegralx    -55.3   -> -55   Inexact Rounded
  #|intxx264 tointegralx    -56.3   -> -56   Inexact Rounded
  #|intxx265 tointegralx    -57.3   -> -57   Inexact Rounded
  #|
  #|rounding:    floor
  #|
  #|intxx270 tointegralx     55.7   ->  55   Inexact Rounded
  #|intxx271 tointegralx     56.7   ->  56   Inexact Rounded
  #|intxx272 tointegralx     57.7   ->  57   Inexact Rounded
  #|intxx273 tointegralx    -55.7   -> -56   Inexact Rounded
  #|intxx274 tointegralx    -56.7   -> -57   Inexact Rounded
  #|intxx275 tointegralx    -57.7   -> -58   Inexact Rounded
  #|
  #|-- Int and uInt32 edge values for testing conversions
  #|precision: 16
  #|intxx300 tointegralx -2147483646  -> -2147483646
  #|intxx301 tointegralx -2147483647  -> -2147483647
  #|intxx302 tointegralx -2147483648  -> -2147483648
  #|intxx303 tointegralx -2147483649  -> -2147483649
  #|intxx304 tointegralx  2147483646  ->  2147483646
  #|intxx305 tointegralx  2147483647  ->  2147483647
  #|intxx306 tointegralx  2147483648  ->  2147483648
  #|intxx307 tointegralx  2147483649  ->  2147483649
  #|intxx308 tointegralx  4294967294  ->  4294967294
  #|intxx309 tointegralx  4294967295  ->  4294967295
  #|intxx310 tointegralx  4294967296  ->  4294967296
  #|intxx311 tointegralx  4294967297  ->  4294967297

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
test "tointegral.decTest subset" {
  run_subset("tointegral", tointegral_subset)
}

///|
test "tointegralx.decTest subset" {
  run_subset("tointegralx", tointegralx_subset)
}
