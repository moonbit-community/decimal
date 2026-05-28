///| `subtract` cases from `subtract.decTest`, restricted to the half_up
/// rounding mode and precision >= 9 sections; further filtered to those
/// without conditions we don't yet model (Inexact, Rounded, Overflow,
/// Underflow, Clamped, Conversion_syntax) or a GDA `#` null operand.
let subtract_subset : String =
  #|subx001 subtract  0   0  -> '0'
  #|subx002 subtract  1   1  -> '0'
  #|subx003 subtract  1   2  -> '-1'
  #|subx004 subtract  2   1  -> '1'
  #|subx005 subtract  2   2  -> '0'
  #|subx006 subtract  3   2  -> '1'
  #|subx007 subtract  2   3  -> '-1'
  #|subx011 subtract -0   0  -> '-0'
  #|subx012 subtract -1   1  -> '-2'
  #|subx013 subtract -1   2  -> '-3'
  #|subx014 subtract -2   1  -> '-3'
  #|subx015 subtract -2   2  -> '-4'
  #|subx016 subtract -3   2  -> '-5'
  #|subx017 subtract -2   3  -> '-5'
  #|subx021 subtract  0  -0  -> '0'
  #|subx022 subtract  1  -1  -> '2'
  #|subx023 subtract  1  -2  -> '3'
  #|subx024 subtract  2  -1  -> '3'
  #|subx025 subtract  2  -2  -> '4'
  #|subx026 subtract  3  -2  -> '5'
  #|subx027 subtract  2  -3  -> '5'
  #|subx030 subtract  11  1  -> 10
  #|subx031 subtract  10  1  ->  9
  #|subx032 subtract  9   1  ->  8
  #|subx033 subtract  1   1  ->  0
  #|subx034 subtract  0   1  -> -1
  #|subx035 subtract -1   1  -> -2
  #|subx036 subtract -9   1  -> -10
  #|subx037 subtract -10  1  -> -11
  #|subx038 subtract -11  1  -> -12
  #|subx040 subtract '5.75' '3.3'  -> '2.45'
  #|subx041 subtract '5'    '-3'   -> '8'
  #|subx042 subtract '-5'   '-3'   -> '-2'
  #|subx043 subtract '-7'   '2.5'  -> '-9.5'
  #|subx044 subtract '0.7'  '0.3'  -> '0.4'
  #|subx045 subtract '1.3'  '0.3'  -> '1.0'
  #|subx046 subtract '1.25' '1.25' -> '0.00'
  #|subx050 subtract '1.23456789'    '1.00000000' -> '0.23456789'
  #|subx051 subtract '1.23456789'    '1.00000089' -> '0.23456700'
  #|subx090 subtract '00.0'    '0.0'  -> '0.0'
  #|subx091 subtract '00.0'    '0.00' -> '0.00'
  #|subx092 subtract '0.00'    '00.0' -> '0.00'
  #|subx093 subtract '00.0'    '0.00' -> '0.00'
  #|subx094 subtract '0.00'    '00.0' -> '0.00'
  #|subx095 subtract '3'    '.3'   -> '2.7'
  #|subx096 subtract '3.'   '.3'   -> '2.7'
  #|subx097 subtract '3.0'  '.3'   -> '2.7'
  #|subx098 subtract '3.00' '.3'   -> '2.70'
  #|subx099 subtract '3'    '3'    -> '0'
  #|subx100 subtract '3'    '+3'   -> '0'
  #|subx101 subtract '3'    '-3'   -> '6'
  #|subx102 subtract '3'    '0.3'  -> '2.7'
  #|subx103 subtract '3.'   '0.3'  -> '2.7'
  #|subx104 subtract '3.0'  '0.3'  -> '2.7'
  #|subx105 subtract '3.00' '0.3'  -> '2.70'
  #|subx106 subtract '3'    '3.0'  -> '0.0'
  #|subx107 subtract '3'    '+3.0' -> '0.0'
  #|subx108 subtract '3'    '-3.0' -> '6.0'
  #|subx120 subtract  '10.23456784'    '10.23456789'  -> '-5E-8'
  #|subx121 subtract  '10.23456785'    '10.23456789'  -> '-4E-8'
  #|subx122 subtract  '10.23456786'    '10.23456789'  -> '-3E-8'
  #|subx123 subtract  '10.23456787'    '10.23456789'  -> '-2E-8'
  #|subx124 subtract  '10.23456788'    '10.23456789'  -> '-1E-8'
  #|subx125 subtract  '10.23456789'    '10.23456789'  -> '0E-8'
  #|subx126 subtract  '10.23456790'    '10.23456789'  -> '1E-8'
  #|subx127 subtract  '10.23456791'    '10.23456789'  -> '2E-8'
  #|subx128 subtract  '10.23456792'    '10.23456789'  -> '3E-8'
  #|subx129 subtract  '10.23456793'    '10.23456789'  -> '4E-8'
  #|subx130 subtract  '10.23456794'    '10.23456789'  -> '5E-8'
  #|subx131 subtract  '10.23456781'    '10.23456786'  -> '-5E-8'
  #|subx132 subtract  '10.23456782'    '10.23456786'  -> '-4E-8'
  #|subx133 subtract  '10.23456783'    '10.23456786'  -> '-3E-8'
  #|subx134 subtract  '10.23456784'    '10.23456786'  -> '-2E-8'
  #|subx135 subtract  '10.23456785'    '10.23456786'  -> '-1E-8'
  #|subx136 subtract  '10.23456786'    '10.23456786'  -> '0E-8'
  #|subx137 subtract  '10.23456787'    '10.23456786'  -> '1E-8'
  #|subx138 subtract  '10.23456788'    '10.23456786'  -> '2E-8'
  #|subx139 subtract  '10.23456789'    '10.23456786'  -> '3E-8'
  #|subx140 subtract  '10.23456790'    '10.23456786'  -> '4E-8'
  #|subx141 subtract  '10.23456791'    '10.23456786'  -> '5E-8'
  #|subx142 subtract  '1'              '0.999999999'  -> '1E-9'
  #|subx143 subtract  '0.999999999'    '1'            -> '-1E-9'
  #|subx144 subtract  '-10.23456780'   '-10.23456786' -> '6E-8'
  #|subx145 subtract  '-10.23456790'   '-10.23456786' -> '-4E-8'
  #|subx146 subtract  '-10.23456791'   '-10.23456786' -> '-5E-8'
  #|subx158 subtract '12345678900000' '9999999999999'  -> 2345678900001
  #|subx159 subtract '9999999999999'  '12345678900000' -> -2345678900001
  #|subx160 subtract '0'     '.1'      -> '-0.1'
  #|subx161 subtract '00'    '.97983'  -> '-0.97983'
  #|subx162 subtract '0'     '.9'      -> '-0.9'
  #|subx163 subtract '0'     '0.102'   -> '-0.102'
  #|subx164 subtract '0'     '.4'      -> '-0.4'
  #|subx165 subtract '0'     '.307'    -> '-0.307'
  #|subx166 subtract '0'     '.43822'  -> '-0.43822'
  #|subx167 subtract '0'     '.911'    -> '-0.911'
  #|subx168 subtract '.0'    '.02'     -> '-0.02'
  #|subx169 subtract '00'    '.392'    -> '-0.392'
  #|subx170 subtract '0'     '.26'     -> '-0.26'
  #|subx171 subtract '0'     '0.51'    -> '-0.51'
  #|subx172 subtract '0'     '.2234'   -> '-0.2234'
  #|subx173 subtract '0'     '.2'      -> '-0.2'
  #|subx174 subtract '.0'    '.0008'   -> '-0.0008'
  #|subx180 subtract '0.0'     '-.1'      -> '0.1'
  #|subx181 subtract '0.00'    '-.97983'  -> '0.97983'
  #|subx182 subtract '0.0'     '-.9'      -> '0.9'
  #|subx183 subtract '0.0'     '-0.102'   -> '0.102'
  #|subx184 subtract '0.0'     '-.4'      -> '0.4'
  #|subx185 subtract '0.0'     '-.307'    -> '0.307'
  #|subx186 subtract '0.0'     '-.43822'  -> '0.43822'
  #|subx187 subtract '0.0'     '-.911'    -> '0.911'
  #|subx188 subtract '0.0'     '-.02'     -> '0.02'
  #|subx189 subtract '0.00'    '-.392'    -> '0.392'
  #|subx190 subtract '0.0'     '-.26'     -> '0.26'
  #|subx191 subtract '0.0'     '-0.51'    -> '0.51'
  #|subx192 subtract '0.0'     '-.2234'   -> '0.2234'
  #|subx193 subtract '0.0'     '-.2'      -> '0.2'
  #|subx194 subtract '0.0'     '-.0008'   -> '0.0008'
  #|subx200 subtract '0'     '-.1'      -> '0.1'
  #|subx201 subtract '00'    '-.97983'  -> '0.97983'
  #|subx202 subtract '0'     '-.9'      -> '0.9'
  #|subx203 subtract '0'     '-0.102'   -> '0.102'
  #|subx204 subtract '0'     '-.4'      -> '0.4'
  #|subx205 subtract '0'     '-.307'    -> '0.307'
  #|subx206 subtract '0'     '-.43822'  -> '0.43822'
  #|subx207 subtract '0'     '-.911'    -> '0.911'
  #|subx208 subtract '.0'    '-.02'     -> '0.02'
  #|subx209 subtract '00'    '-.392'    -> '0.392'
  #|subx210 subtract '0'     '-.26'     -> '0.26'
  #|subx211 subtract '0'     '-0.51'    -> '0.51'
  #|subx212 subtract '0'     '-.2234'   -> '0.2234'
  #|subx213 subtract '0'     '-.2'      -> '0.2'
  #|subx214 subtract '.0'    '-.0008'   -> '0.0008'
  #|subx220 subtract '-56267E-12' 0  -> '-5.6267E-8'
  #|subx221 subtract '-56267E-11' 0  -> '-5.6267E-7'
  #|subx222 subtract '-56267E-10' 0  -> '-0.0000056267'
  #|subx223 subtract '-56267E-9'  0  -> '-0.000056267'
  #|subx224 subtract '-56267E-8'  0  -> '-0.00056267'
  #|subx225 subtract '-56267E-7'  0  -> '-0.0056267'
  #|subx226 subtract '-56267E-6'  0  -> '-0.056267'
  #|subx227 subtract '-56267E-5'  0  -> '-0.56267'
  #|subx228 subtract '-56267E-2'  0  -> '-562.67'
  #|subx229 subtract '-56267E-1'  0  -> '-5626.7'
  #|subx230 subtract '-56267E-0'  0  -> '-56267'
  #|subx240 subtract 0 '-56267E-12'  -> '5.6267E-8'
  #|subx241 subtract 0 '-56267E-11'  -> '5.6267E-7'
  #|subx242 subtract 0 '-56267E-10'  -> '0.0000056267'
  #|subx243 subtract 0 '-56267E-9'   -> '0.000056267'
  #|subx244 subtract 0 '-56267E-8'   -> '0.00056267'
  #|subx245 subtract 0 '-56267E-7'   -> '0.0056267'
  #|subx246 subtract 0 '-56267E-6'   -> '0.056267'
  #|subx247 subtract 0 '-56267E-5'   -> '0.56267'
  #|subx248 subtract 0 '-56267E-2'   -> '562.67'
  #|subx249 subtract 0 '-56267E-1'   -> '5626.7'
  #|subx250 subtract 0 '-56267E-0'   -> '56267'
  #|subx301 subtract '1.23456789'  '1.00000000' -> '0.23456789'
  #|subx302 subtract '1.23456789'  '1.00000011' -> '0.23456778'
  #|subx321 subtract '0.9998'  '0.0000' -> '0.9998'
  #|subx322 subtract '0.9998'  '0.0001' -> '0.9997'
  #|subx323 subtract '0.9998'  '0.0002' -> '0.9996'
  #|subx324 subtract '0.9998'  '0.0003' -> '0.9995'
  #|subx325 subtract '0.9998'  '-0.0000' -> '0.9998'
  #|subx326 subtract '0.9998'  '-0.0001' -> '0.9999'
  #|subx327 subtract '0.9998'  '-0.0002' -> '1.0000'
  #|subx328 subtract '0.9998'  '-0.0003' -> '1.0001'
  #|subx346 subtract '10000e+9'  '7'   -> '9999999999993'
  #|subx347 subtract '10000e+9'  '70'   -> '9999999999930'
  #|subx348 subtract '10000e+9'  '700'   -> '9999999999300'
  #|subx349 subtract '10000e+9'  '7000'   -> '9999999993000'
  #|subx350 subtract '10000e+9'  '70000'   -> '9999999930000'
  #|subx351 subtract '10000e+9'  '700000'   -> '9999999300000'
  #|subx352 subtract '7' '10000e+9'   -> '-9999999999993'
  #|subx353 subtract '70' '10000e+9'   -> '-9999999999930'
  #|subx354 subtract '700' '10000e+9'   -> '-9999999999300'
  #|subx355 subtract '7000' '10000e+9'   -> '-9999999993000'
  #|subx356 subtract '70000' '10000e+9'   -> '-9999999930000'
  #|subx357 subtract '700000' '10000e+9'   -> '-9999999300000'
  #|subx910 subtract -103519362 -51897955.3 -> -51621406.7
  #|subx911 subtract 159579.444 89827.5229 -> 69751.9211
  #|subx922 subtract 133.123456 33.1234565 ->  99.9999995
  #|subx923 subtract 133.123456 33.1234564 ->  99.9999996
  #|subx925 subtract 133.123456 43.1234560 ->  90.0000000
  #|subx926 subtract 133.123456 43.1234561 ->  89.9999999
  #|subx927 subtract 133.123456 43.1234566 ->  89.9999994
  #|subx928 subtract 101.123456 91.1234566 ->   9.9999994
  #|subx929 subtract 101.123456 99.1234566 ->   1.9999994
  #|subx951 subtract 101 2.0000001   -> 98.9999999
  #|subx952 subtract 101 92.0000001  ->  8.9999999
  #|subx953 subtract 101 92.00000006 ->  8.99999994
  #|subx390 subtract '-56267E-10'   0 ->  '-0.0000056267'
  #|subx391 subtract '-56267E-6'    0 ->  '-0.056267'
  #|subx392 subtract '-56267E-5'    0 ->  '-0.56267'
  #|subx393 subtract '-56267E-4'    0 ->  '-5.6267'
  #|subx394 subtract '-56267E-3'    0 ->  '-56.267'
  #|subx395 subtract '-56267E-2'    0 ->  '-562.67'
  #|subx396 subtract '-56267E-1'    0 ->  '-5626.7'
  #|subx397 subtract '-56267E-0'    0 ->  '-56267'
  #|subx398 subtract '-5E-10'       0 ->  '-5E-10'
  #|subx399 subtract '-5E-7'        0 ->  '-5E-7'
  #|subx400 subtract '-5E-6'        0 ->  '-0.000005'
  #|subx401 subtract '-5E-5'        0 ->  '-0.00005'
  #|subx402 subtract '-5E-4'        0 ->  '-0.0005'
  #|subx403 subtract '-5E-1'        0 ->  '-0.5'
  #|subx404 subtract '-5E0'         0 ->  '-5'
  #|subx405 subtract '-5E1'         0 ->  '-50'
  #|subx406 subtract '-5E5'         0 ->  '-500000'
  #|subx407 subtract '-5E8'         0 ->  '-500000000'
  #|subx420 subtract 0  '-56267E-10' ->  '0.0000056267'
  #|subx421 subtract 0  '-56267E-6'  ->  '0.056267'
  #|subx422 subtract 0  '-56267E-5'  ->  '0.56267'
  #|subx423 subtract 0  '-56267E-4'  ->  '5.6267'
  #|subx424 subtract 0  '-56267E-3'  ->  '56.267'
  #|subx425 subtract 0  '-56267E-2'  ->  '562.67'
  #|subx426 subtract 0  '-56267E-1'  ->  '5626.7'
  #|subx427 subtract 0  '-56267E-0'  ->  '56267'
  #|subx428 subtract 0  '-5E-10'     ->  '5E-10'
  #|subx429 subtract 0  '-5E-7'      ->  '5E-7'
  #|subx430 subtract 0  '-5E-6'      ->  '0.000005'
  #|subx431 subtract 0  '-5E-5'      ->  '0.00005'
  #|subx432 subtract 0  '-5E-4'      ->  '0.0005'
  #|subx433 subtract 0  '-5E-1'      ->  '0.5'
  #|subx434 subtract 0  '-5E0'       ->  '5'
  #|subx435 subtract 0  '-5E1'       ->  '50'
  #|subx436 subtract 0  '-5E5'       ->  '500000'
  #|subx437 subtract 0  '-5E8'       ->  '500000000'
  #|subx461 subtract '1E+12' '1'       -> '999999999999'
  #|subx462 subtract '1E+12' '-1.11'   -> '1000000000001.11'
  #|subx463 subtract '1.11'  '-1E+12'  -> '1000000000001.11'
  #|subx464 subtract '-1'    '-1E+12'  -> '999999999999'
  #|subx465 subtract '7E+12' '1'       -> '6999999999999'
  #|subx466 subtract '7E+12' '-1.11'   -> '7000000000001.11'
  #|subx467 subtract '1.11'  '-7E+12'  -> '7000000000001.11'
  #|subx468 subtract '-1'    '-7E+12'  -> '6999999999999'
  #|subx478 subtract '0.444444444444444'  '-0.555555555555555' -> '0.999999999999999'
  #|subx479 subtract '0.444444444444444'  '-0.555555555555554' -> '0.999999999999998'
  #|subx480 subtract '0.444444444444444'  '-0.555555555555553' -> '0.999999999999997'
  #|subx481 subtract '0.444444444444444'  '-0.555555555555552' -> '0.999999999999996'
  #|subx482 subtract '0.444444444444444'  '-0.555555555555551' -> '0.999999999999995'
  #|subx483 subtract '0.444444444444444'  '-0.555555555555550' -> '0.999999999999994'
  #|subx500 subtract '123456789' 0             -> '123456789'
  #|subx516 subtract '123456789' 1             -> '123456788'
  #|subx600 subtract 0             '123456789' -> '-123456789'
  #|subx616 subtract 1             '123456789' -> '-123456788'
  #|subx670 subtract '123456789' '123456788.1' -> 0.9
  #|subx671 subtract '123456789' '123456788.9' -> 0.1
  #|subx672 subtract '123456789' '123456789.1' -> -0.1
  #|subx673 subtract '123456789' '123456789.5' -> -0.5
  #|subx674 subtract '123456789' '123456789.9' -> -0.9
  #|subx780 subtract -Inf   Inf   -> -Infinity
  #|subx781 subtract -Inf   1000  -> -Infinity
  #|subx782 subtract -Inf   1     -> -Infinity
  #|subx783 subtract -Inf  -0     -> -Infinity
  #|subx784 subtract -Inf  -1     -> -Infinity
  #|subx785 subtract -Inf  -1000  -> -Infinity
  #|subx787 subtract -1000  Inf   -> -Infinity
  #|subx788 subtract -Inf   Inf   -> -Infinity
  #|subx789 subtract -1     Inf   -> -Infinity
  #|subx790 subtract  0     Inf   -> -Infinity
  #|subx791 subtract  1     Inf   -> -Infinity
  #|subx792 subtract  1000  Inf   -> -Infinity
  #|subx800 subtract  Inf   Inf   ->  NaN  Invalid_operation
  #|subx801 subtract  Inf   1000  ->  Infinity
  #|subx802 subtract  Inf   1     ->  Infinity
  #|subx803 subtract  Inf   0     ->  Infinity
  #|subx804 subtract  Inf  -0     ->  Infinity
  #|subx805 subtract  Inf  -1     ->  Infinity
  #|subx806 subtract  Inf  -1000  ->  Infinity
  #|subx807 subtract  Inf  -Inf   ->  Infinity
  #|subx808 subtract -1000 -Inf   ->  Infinity
  #|subx809 subtract -Inf  -Inf   ->  NaN  Invalid_operation
  #|subx810 subtract -1    -Inf   ->  Infinity
  #|subx811 subtract -0    -Inf   ->  Infinity
  #|subx812 subtract  0    -Inf   ->  Infinity
  #|subx813 subtract  1    -Inf   ->  Infinity
  #|subx814 subtract  1000 -Inf   ->  Infinity
  #|subx815 subtract  Inf  -Inf   ->  Infinity
  #|subx821 subtract  NaN   Inf   ->  NaN
  #|subx822 subtract -NaN   1000  -> -NaN
  #|subx823 subtract  NaN   1     ->  NaN
  #|subx824 subtract  NaN   0     ->  NaN
  #|subx825 subtract  NaN  -0     ->  NaN
  #|subx826 subtract  NaN  -1     ->  NaN
  #|subx827 subtract  NaN  -1000  ->  NaN
  #|subx828 subtract  NaN  -Inf   ->  NaN
  #|subx829 subtract -NaN   NaN   -> -NaN
  #|subx830 subtract -Inf   NaN   ->  NaN
  #|subx831 subtract -1000  NaN   ->  NaN
  #|subx832 subtract -1     NaN   ->  NaN
  #|subx833 subtract -0     NaN   ->  NaN
  #|subx834 subtract  0     NaN   ->  NaN
  #|subx835 subtract  1     NaN   ->  NaN
  #|subx836 subtract  1000 -NaN   -> -NaN
  #|subx837 subtract  Inf   NaN   ->  NaN
  #|subx841 subtract  sNaN  Inf   ->  NaN  Invalid_operation
  #|subx842 subtract -sNaN  1000  -> -NaN  Invalid_operation
  #|subx843 subtract  sNaN  1     ->  NaN  Invalid_operation
  #|subx844 subtract  sNaN  0     ->  NaN  Invalid_operation
  #|subx845 subtract  sNaN -0     ->  NaN  Invalid_operation
  #|subx846 subtract  sNaN -1     ->  NaN  Invalid_operation
  #|subx847 subtract  sNaN -1000  ->  NaN  Invalid_operation
  #|subx848 subtract  sNaN  NaN   ->  NaN  Invalid_operation
  #|subx849 subtract  sNaN sNaN   ->  NaN  Invalid_operation
  #|subx850 subtract  NaN  sNaN   ->  NaN  Invalid_operation
  #|subx851 subtract -Inf -sNaN   -> -NaN  Invalid_operation
  #|subx852 subtract -1000 sNaN   ->  NaN  Invalid_operation
  #|subx853 subtract -1    sNaN   ->  NaN  Invalid_operation
  #|subx854 subtract -0    sNaN   ->  NaN  Invalid_operation
  #|subx855 subtract  0    sNaN   ->  NaN  Invalid_operation
  #|subx856 subtract  1    sNaN   ->  NaN  Invalid_operation
  #|subx857 subtract  1000 sNaN   ->  NaN  Invalid_operation
  #|subx858 subtract  Inf  sNaN   ->  NaN  Invalid_operation
  #|subx859 subtract  NaN  sNaN   ->  NaN  Invalid_operation
  #|subx861 subtract  NaN01   -Inf     ->  NaN1
  #|subx862 subtract -NaN02   -1000    -> -NaN2
  #|subx863 subtract  NaN03    1000    ->  NaN3
  #|subx864 subtract  NaN04    Inf     ->  NaN4
  #|subx865 subtract  NaN05    NaN61   ->  NaN5
  #|subx866 subtract -Inf     -NaN71   -> -NaN71
  #|subx867 subtract -1000     NaN81   ->  NaN81
  #|subx868 subtract  1000     NaN91   ->  NaN91
  #|subx869 subtract  Inf      NaN101  ->  NaN101
  #|subx871 subtract  sNaN011  -Inf    ->  NaN11  Invalid_operation
  #|subx872 subtract  sNaN012  -1000   ->  NaN12  Invalid_operation
  #|subx873 subtract -sNaN013   1000   -> -NaN13  Invalid_operation
  #|subx874 subtract  sNaN014   NaN171 ->  NaN14  Invalid_operation
  #|subx875 subtract  sNaN015  sNaN181 ->  NaN15  Invalid_operation
  #|subx876 subtract  NaN016   sNaN191 ->  NaN191 Invalid_operation
  #|subx877 subtract -Inf      sNaN201 ->  NaN201 Invalid_operation
  #|subx878 subtract -1000     sNaN211 ->  NaN211 Invalid_operation
  #|subx879 subtract  1000    -sNaN221 -> -NaN221 Invalid_operation
  #|subx880 subtract  Inf      sNaN231 ->  NaN231 Invalid_operation
  #|subx881 subtract  NaN025   sNaN241 ->  NaN241 Invalid_operation
  #|subx901 subtract  2.E-3  1.002  -> -1.000
  #|subx902 subtract  2.0E-3  1.002  -> -1.0000
  #|subx903 subtract  2.00E-3  1.0020  -> -1.00000
  #|subx904 subtract  2.000E-3  1.00200  -> -1.000000
  #|subx905 subtract  2.0000E-3  1.002000  -> -1.0000000
  #|subx906 subtract  2.00000E-3  1.0020000  -> -1.00000000
  #|subx907 subtract  2.000000E-3  1.00200000  -> -1.000000000
  #|subx908 subtract  2.0000000E-3  1.002000000  -> -1.0000000000
  #|subx1125  subtract 130E-2  120E-2 -> 0.10
  #|subx1126  subtract 130E-2  12E-1  -> 0.10
  #|subx1127  subtract 130E-2  1E0    -> 0.30
  #|subx1128  subtract 1E2     1E4    -> -9.9E+3

///|
test "subtract.decTest subset round-trips through parse + subtract + toSci" {
  let cases = parse_dectest(subtract_subset)
  assert_eq(cases.length(), 343)
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
    abort("subtract.decTest failures")
  }
}
