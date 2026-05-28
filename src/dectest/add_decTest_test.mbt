///| `add` cases from `add.decTest`, restricted to precision >= 9
/// sections. `precision:` and `rounding:` directive lines are kept
/// alongside the test lines so the runner can build the matching
/// Context for each test. Skipped: Subnormal / Underflow / Overflow /
/// Clamped (need e_min/e_max enforcement), Conversion_syntax (parse
/// errors surface as ParseError), Division_impossible (precision-
/// bounded quotient check not yet implemented).
let add_subset : String =
  #|precision:   9
  #|rounding:    half_up
  #|addx001 add 1       1       ->  2
  #|addx002 add 2       3       ->  5
  #|addx003 add '5.75'  '3.3'   ->  9.05
  #|addx004 add '5'     '-3'    ->  2
  #|addx005 add '-5'    '-3'    ->  -8
  #|addx006 add '-7'    '2.5'   ->  -4.5
  #|addx007 add '0.7'   '0.3'   ->  1.0
  #|addx008 add '1.25'  '1.25'  ->  2.50
  #|addx009 add '1.23456789'  '1.00000000' -> '2.23456789'
  #|addx010 add '1.23456789'  '1.00000011' -> '2.23456800'
  #|addx011 add '0.4444444444'  '0.5555555555' -> '1.00000000' Inexact Rounded
  #|addx012 add '0.4444444440'  '0.5555555555' -> '1.00000000' Inexact Rounded
  #|addx013 add '0.4444444444'  '0.5555555550' -> '0.999999999' Inexact Rounded
  #|addx014 add '0.44444444449'    '0' -> '0.444444444' Inexact Rounded
  #|addx015 add '0.444444444499'   '0' -> '0.444444444' Inexact Rounded
  #|addx016 add '0.4444444444999'  '0' -> '0.444444444' Inexact Rounded
  #|addx017 add '0.4444444445000'  '0' -> '0.444444445' Inexact Rounded
  #|addx018 add '0.4444444445001'  '0' -> '0.444444445' Inexact Rounded
  #|addx019 add '0.444444444501'   '0' -> '0.444444445' Inexact Rounded
  #|addx020 add '0.44444444451'    '0' -> '0.444444445' Inexact Rounded
  #|addx021 add 0 1 -> 1
  #|addx022 add 1 1 -> 2
  #|addx023 add 2 1 -> 3
  #|addx024 add 3 1 -> 4
  #|addx025 add 4 1 -> 5
  #|addx026 add 5 1 -> 6
  #|addx027 add 6 1 -> 7
  #|addx028 add 7 1 -> 8
  #|addx029 add 8 1 -> 9
  #|addx030 add 9 1 -> 10
  #|addx031 add '0.9998'  '0.0000' -> '0.9998'
  #|addx032 add '0.9998'  '0.0001' -> '0.9999'
  #|addx033 add '0.9998'  '0.0002' -> '1.0000'
  #|addx034 add '0.9998'  '0.0003' -> '1.0001'
  #|addx035 add '70'  '10000e+9' -> '1.00000000E+13' Inexact Rounded
  #|addx036 add '700'  '10000e+9' -> '1.00000000E+13' Inexact Rounded
  #|addx037 add '7000'  '10000e+9' -> '1.00000000E+13' Inexact Rounded
  #|addx038 add '70000'  '10000e+9' -> '1.00000001E+13' Inexact Rounded
  #|addx039 add '700000'  '10000e+9' -> '1.00000007E+13' Rounded
  #|addx040 add '10000e+9'  '70' -> '1.00000000E+13' Inexact Rounded
  #|addx041 add '10000e+9'  '700' -> '1.00000000E+13' Inexact Rounded
  #|addx042 add '10000e+9'  '7000' -> '1.00000000E+13' Inexact Rounded
  #|addx044 add '10000e+9'  '70000' -> '1.00000001E+13' Inexact Rounded
  #|addx045 add '10000e+9'  '700000' -> '1.00000007E+13' Rounded
  #|precision: 15
  #|addx046 add '10000e+9'  '7' -> '10000000000007'
  #|addx047 add '10000e+9'  '70' -> '10000000000070'
  #|addx048 add '10000e+9'  '700' -> '10000000000700'
  #|addx049 add '10000e+9'  '7000' -> '10000000007000'
  #|addx050 add '10000e+9'  '70000' -> '10000000070000'
  #|addx051 add '10000e+9'  '700000' -> '10000000700000'
  #|addx052 add '10000e+9'  '7000000' -> '10000007000000'
  #|addx053 add '12' '7.00' -> '19.00'
  #|addx054 add '1.3' '-1.07' -> '0.23'
  #|addx055 add '1.3' '-1.30' -> '0.00'
  #|addx056 add '1.3' '-2.07' -> '-0.77'
  #|addx057 add '1E+2' '1E+4' -> '1.01E+4'
  #|precision: 6
  #|precision: 9
  #|addx080 add 999999998 1  -> 999999999
  #|addx081 add 999999999 1  -> 1.00000000E+9 Rounded
  #|addx082 add  99999999 1  -> 100000000
  #|addx083 add   9999999 1  -> 10000000
  #|addx084 add    999999 1  -> 1000000
  #|addx085 add     99999 1  -> 100000
  #|addx086 add      9999 1  -> 10000
  #|addx087 add       999 1  -> 1000
  #|addx088 add        99 1  -> 100
  #|addx089 add         9 1  -> 10
  #|addx090 add '-56267E-10'   0 ->  '-0.0000056267'
  #|addx091 add '-56267E-6'    0 ->  '-0.056267'
  #|addx092 add '-56267E-5'    0 ->  '-0.56267'
  #|addx093 add '-56267E-4'    0 ->  '-5.6267'
  #|addx094 add '-56267E-3'    0 ->  '-56.267'
  #|addx095 add '-56267E-2'    0 ->  '-562.67'
  #|addx096 add '-56267E-1'    0 ->  '-5626.7'
  #|addx097 add '-56267E-0'    0 ->  '-56267'
  #|addx098 add '-5E-10'       0 ->  '-5E-10'
  #|addx099 add '-5E-7'        0 ->  '-5E-7'
  #|addx100 add '-5E-6'        0 ->  '-0.000005'
  #|addx101 add '-5E-5'        0 ->  '-0.00005'
  #|addx102 add '-5E-4'        0 ->  '-0.0005'
  #|addx103 add '-5E-1'        0 ->  '-0.5'
  #|addx104 add '-5E0'         0 ->  '-5'
  #|addx105 add '-5E1'         0 ->  '-50'
  #|addx106 add '-5E5'         0 ->  '-500000'
  #|addx107 add '-5E8'         0 ->  '-500000000'
  #|addx108 add '-5E9'         0 ->  '-5.00000000E+9'   Rounded
  #|addx109 add '-5E10'        0 ->  '-5.00000000E+10'  Rounded
  #|addx110 add '-5E11'        0 ->  '-5.00000000E+11'  Rounded
  #|addx111 add '-5E100'       0 ->  '-5.00000000E+100' Rounded
  #|addx113 add 0  '-56267E-10' ->  '-0.0000056267'
  #|addx114 add 0  '-56267E-6'  ->  '-0.056267'
  #|addx116 add 0  '-56267E-5'  ->  '-0.56267'
  #|addx117 add 0  '-56267E-4'  ->  '-5.6267'
  #|addx119 add 0  '-56267E-3'  ->  '-56.267'
  #|addx120 add 0  '-56267E-2'  ->  '-562.67'
  #|addx121 add 0  '-56267E-1'  ->  '-5626.7'
  #|addx122 add 0  '-56267E-0'  ->  '-56267'
  #|addx123 add 0  '-5E-10'     ->  '-5E-10'
  #|addx124 add 0  '-5E-7'      ->  '-5E-7'
  #|addx125 add 0  '-5E-6'      ->  '-0.000005'
  #|addx126 add 0  '-5E-5'      ->  '-0.00005'
  #|addx127 add 0  '-5E-4'      ->  '-0.0005'
  #|addx128 add 0  '-5E-1'      ->  '-0.5'
  #|addx129 add 0  '-5E0'       ->  '-5'
  #|addx130 add 0  '-5E1'       ->  '-50'
  #|addx131 add 0  '-5E5'       ->  '-500000'
  #|addx132 add 0  '-5E8'       ->  '-500000000'
  #|addx133 add 0  '-5E9'       ->  '-5.00000000E+9'    Rounded
  #|addx134 add 0  '-5E10'      ->  '-5.00000000E+10'   Rounded
  #|addx135 add 0  '-5E11'      ->  '-5.00000000E+11'   Rounded
  #|addx136 add 0  '-5E100'     ->  '-5.00000000E+100'  Rounded
  #|addx137 add  1  '0E-12'      ->  '1.00000000'  Rounded
  #|addx138 add -1  '0E-12'      ->  '-1.00000000' Rounded
  #|addx139 add '0E-12' 1        ->  '1.00000000'  Rounded
  #|addx140 add '0E-12' -1       ->  '-1.00000000' Rounded
  #|addx141 add 1E+4    0.0000   ->  '10000.0000'
  #|addx142 add 1E+4    0.00000  ->  '10000.0000'  Rounded
  #|addx143 add 0.000   1E+5     ->  '100000.000'
  #|addx144 add 0.0000  1E+5     ->  '100000.000'  Rounded
  #|addx146 add '00.0'  0       ->  '0.0'
  #|addx147 add '0.00'  0       ->  '0.00'
  #|addx148 add  0      '0.00'  ->  '0.00'
  #|addx149 add  0      '00.0'  ->  '0.0'
  #|addx150 add '00.0'  '0.00'  ->  '0.00'
  #|addx151 add '0.00'  '00.0'  ->  '0.00'
  #|addx152 add '3'     '.3'    ->  '3.3'
  #|addx153 add '3.'    '.3'    ->  '3.3'
  #|addx154 add '3.0'   '.3'    ->  '3.3'
  #|addx155 add '3.00'  '.3'    ->  '3.30'
  #|addx156 add '3'     '3'     ->  '6'
  #|addx157 add '3'     '+3'    ->  '6'
  #|addx158 add '3'     '-3'    ->  '0'
  #|addx159 add '0.3'   '-0.3'  ->  '0.0'
  #|addx160 add '0.03'  '-0.03' ->  '0.00'
  #|precision: 15
  #|addx161 add '1E+12' '-1'    -> '999999999999'
  #|addx162 add '1E+12'  '1.11' -> '1000000000001.11'
  #|addx163 add '1.11'  '1E+12' -> '1000000000001.11'
  #|addx164 add '-1'    '1E+12' -> '999999999999'
  #|addx165 add '7E+12' '-1'    -> '6999999999999'
  #|addx166 add '7E+12'  '1.11' -> '7000000000001.11'
  #|addx167 add '1.11'  '7E+12' -> '7000000000001.11'
  #|addx168 add '-1'    '7E+12' -> '6999999999999'
  #|addx170 add '0.444444444444444'  '0.555555555555563' -> '1.00000000000001' Inexact Rounded
  #|addx171 add '0.444444444444444'  '0.555555555555562' -> '1.00000000000001' Inexact Rounded
  #|addx172 add '0.444444444444444'  '0.555555555555561' -> '1.00000000000001' Inexact Rounded
  #|addx173 add '0.444444444444444'  '0.555555555555560' -> '1.00000000000000' Inexact Rounded
  #|addx174 add '0.444444444444444'  '0.555555555555559' -> '1.00000000000000' Inexact Rounded
  #|addx175 add '0.444444444444444'  '0.555555555555558' -> '1.00000000000000' Inexact Rounded
  #|addx176 add '0.444444444444444'  '0.555555555555557' -> '1.00000000000000' Inexact Rounded
  #|addx177 add '0.444444444444444'  '0.555555555555556' -> '1.00000000000000' Rounded
  #|addx178 add '0.444444444444444'  '0.555555555555555' -> '0.999999999999999'
  #|addx179 add '0.444444444444444'  '0.555555555555554' -> '0.999999999999998'
  #|addx180 add '0.444444444444444'  '0.555555555555553' -> '0.999999999999997'
  #|addx181 add '0.444444444444444'  '0.555555555555552' -> '0.999999999999996'
  #|addx182 add '0.444444444444444'  '0.555555555555551' -> '0.999999999999995'
  #|addx183 add '0.444444444444444'  '0.555555555555550' -> '0.999999999999994'
  #|precision: 9
  #|rounding: half_up
  #|addx200 add '123456789' 0             -> '123456789'
  #|addx201 add '123456789' 0.000000001   -> '123456789' Inexact Rounded
  #|addx202 add '123456789' 0.000001      -> '123456789' Inexact Rounded
  #|addx203 add '123456789' 0.1           -> '123456789' Inexact Rounded
  #|addx204 add '123456789' 0.4           -> '123456789' Inexact Rounded
  #|addx205 add '123456789' 0.49          -> '123456789' Inexact Rounded
  #|addx206 add '123456789' 0.499999      -> '123456789' Inexact Rounded
  #|addx207 add '123456789' 0.499999999   -> '123456789' Inexact Rounded
  #|addx208 add '123456789' 0.5           -> '123456790' Inexact Rounded
  #|addx209 add '123456789' 0.500000001   -> '123456790' Inexact Rounded
  #|addx210 add '123456789' 0.500001      -> '123456790' Inexact Rounded
  #|addx211 add '123456789' 0.51          -> '123456790' Inexact Rounded
  #|addx212 add '123456789' 0.6           -> '123456790' Inexact Rounded
  #|addx213 add '123456789' 0.9           -> '123456790' Inexact Rounded
  #|addx214 add '123456789' 0.99999       -> '123456790' Inexact Rounded
  #|addx215 add '123456789' 0.999999999   -> '123456790' Inexact Rounded
  #|addx216 add '123456789' 1             -> '123456790'
  #|addx217 add '123456789' 1.000000001   -> '123456790' Inexact Rounded
  #|addx218 add '123456789' 1.00001       -> '123456790' Inexact Rounded
  #|addx219 add '123456789' 1.1           -> '123456790' Inexact Rounded
  #|rounding: half_even
  #|addx220 add '123456789' 0             -> '123456789'
  #|addx221 add '123456789' 0.000000001   -> '123456789' Inexact Rounded
  #|addx222 add '123456789' 0.000001      -> '123456789' Inexact Rounded
  #|addx223 add '123456789' 0.1           -> '123456789' Inexact Rounded
  #|addx224 add '123456789' 0.4           -> '123456789' Inexact Rounded
  #|addx225 add '123456789' 0.49          -> '123456789' Inexact Rounded
  #|addx226 add '123456789' 0.499999      -> '123456789' Inexact Rounded
  #|addx227 add '123456789' 0.499999999   -> '123456789' Inexact Rounded
  #|addx228 add '123456789' 0.5           -> '123456790' Inexact Rounded
  #|addx229 add '123456789' 0.500000001   -> '123456790' Inexact Rounded
  #|addx230 add '123456789' 0.500001      -> '123456790' Inexact Rounded
  #|addx231 add '123456789' 0.51          -> '123456790' Inexact Rounded
  #|addx232 add '123456789' 0.6           -> '123456790' Inexact Rounded
  #|addx233 add '123456789' 0.9           -> '123456790' Inexact Rounded
  #|addx234 add '123456789' 0.99999       -> '123456790' Inexact Rounded
  #|addx235 add '123456789' 0.999999999   -> '123456790' Inexact Rounded
  #|addx236 add '123456789' 1             -> '123456790'
  #|addx237 add '123456789' 1.00000001    -> '123456790' Inexact Rounded
  #|addx238 add '123456789' 1.00001       -> '123456790' Inexact Rounded
  #|addx239 add '123456789' 1.1           -> '123456790' Inexact Rounded
  #|addx240 add '123456788' 0.499999999   -> '123456788' Inexact Rounded
  #|addx241 add '123456788' 0.5           -> '123456788' Inexact Rounded
  #|addx242 add '123456788' 0.500000001   -> '123456789' Inexact Rounded
  #|rounding: down
  #|addx250 add '123456789' 0             -> '123456789'
  #|addx251 add '123456789' 0.000000001   -> '123456789' Inexact Rounded
  #|addx252 add '123456789' 0.000001      -> '123456789' Inexact Rounded
  #|addx253 add '123456789' 0.1           -> '123456789' Inexact Rounded
  #|addx254 add '123456789' 0.4           -> '123456789' Inexact Rounded
  #|addx255 add '123456789' 0.49          -> '123456789' Inexact Rounded
  #|addx256 add '123456789' 0.499999      -> '123456789' Inexact Rounded
  #|addx257 add '123456789' 0.499999999   -> '123456789' Inexact Rounded
  #|addx258 add '123456789' 0.5           -> '123456789' Inexact Rounded
  #|addx259 add '123456789' 0.500000001   -> '123456789' Inexact Rounded
  #|addx260 add '123456789' 0.500001      -> '123456789' Inexact Rounded
  #|addx261 add '123456789' 0.51          -> '123456789' Inexact Rounded
  #|addx262 add '123456789' 0.6           -> '123456789' Inexact Rounded
  #|addx263 add '123456789' 0.9           -> '123456789' Inexact Rounded
  #|addx264 add '123456789' 0.99999       -> '123456789' Inexact Rounded
  #|addx265 add '123456789' 0.999999999   -> '123456789' Inexact Rounded
  #|addx266 add '123456789' 1             -> '123456790'
  #|addx267 add '123456789' 1.00000001    -> '123456790' Inexact Rounded
  #|addx268 add '123456789' 1.00001       -> '123456790' Inexact Rounded
  #|addx269 add '123456789' 1.1           -> '123456790' Inexact Rounded
  #|precision: 3
  #|rounding: half_up
  #|rounding: half_down
  #|rounding: half_up
  #|precision: 9
  #|addx340 add 1E+3    0    ->         1000
  #|addx341 add 1E+8    0    ->    100000000
  #|addx342 add 1E+9    0    ->   1.00000000E+9   Rounded
  #|addx343 add 1E+10   0    ->   1.00000000E+10  Rounded
  #|addx344 add 1E+3    1    ->         1001
  #|addx345 add 1E+8    1    ->    100000001
  #|addx346 add 1E+9    1    ->   1.00000000E+9   Inexact Rounded
  #|addx347 add 1E+10   1    ->   1.00000000E+10  Inexact Rounded
  #|addx348 add 1E+3    7    ->         1007
  #|addx349 add 1E+8    7    ->    100000007
  #|addx350 add 1E+9    7    ->   1.00000001E+9   Inexact Rounded
  #|addx351 add 1E+10   7    ->   1.00000000E+10  Inexact Rounded
  #|precision:   7
  #|rounding:    half_up
  #|rounding:    half_down
  #|precision:   10
  #|addx370 add 99999999 81512 -> 100081511
  #|precision:      6
  #|rounding:    half_up
  #|precision:   10
  #|addx372 add 99999999 81512 -> 100081511
  #|precision:      6
  #|rounding:    half_even
  #|precision:   10
  #|addx374 add 99999999 81512 -> 100081511
  #|precision:      6
  #|precision: 9
  #|addx400 add   1   77e-7       ->  1.0000077
  #|addx401 add   1   77e-8       ->  1.00000077
  #|addx402 add   1   77e-9       ->  1.00000008 Inexact Rounded
  #|addx403 add   1   77e-10      ->  1.00000001 Inexact Rounded
  #|addx404 add   1   77e-11      ->  1.00000000 Inexact Rounded
  #|addx405 add   1   77e-12      ->  1.00000000 Inexact Rounded
  #|addx406 add   1   77e-999     ->  1.00000000 Inexact Rounded
  #|addx407 add   1   77e-9999999 ->  1.00000000 Inexact Rounded
  #|addx410 add  10   77e-7       ->  10.0000077
  #|addx411 add  10   77e-8       ->  10.0000008 Inexact Rounded
  #|addx412 add  10   77e-9       ->  10.0000001 Inexact Rounded
  #|addx413 add  10   77e-10      ->  10.0000000 Inexact Rounded
  #|addx414 add  10   77e-11      ->  10.0000000 Inexact Rounded
  #|addx415 add  10   77e-12      ->  10.0000000 Inexact Rounded
  #|addx416 add  10   77e-999     ->  10.0000000 Inexact Rounded
  #|addx417 add  10   77e-9999999 ->  10.0000000 Inexact Rounded
  #|addx420 add  77e-7        1   ->  1.0000077
  #|addx421 add  77e-8        1   ->  1.00000077
  #|addx422 add  77e-9        1   ->  1.00000008 Inexact Rounded
  #|addx423 add  77e-10       1   ->  1.00000001 Inexact Rounded
  #|addx424 add  77e-11       1   ->  1.00000000 Inexact Rounded
  #|addx425 add  77e-12       1   ->  1.00000000 Inexact Rounded
  #|addx426 add  77e-999      1   ->  1.00000000 Inexact Rounded
  #|addx427 add  77e-9999999  1   ->  1.00000000 Inexact Rounded
  #|addx430 add  77e-7       10   ->  10.0000077
  #|addx431 add  77e-8       10   ->  10.0000008 Inexact Rounded
  #|addx432 add  77e-9       10   ->  10.0000001 Inexact Rounded
  #|addx433 add  77e-10      10   ->  10.0000000 Inexact Rounded
  #|addx434 add  77e-11      10   ->  10.0000000 Inexact Rounded
  #|addx435 add  77e-12      10   ->  10.0000000 Inexact Rounded
  #|addx436 add  77e-999     10   ->  10.0000000 Inexact Rounded
  #|addx437 add  77e-9999999 10   ->  10.0000000 Inexact Rounded
  #|addx440 add   1   -77e-7       ->  0.9999923
  #|addx441 add   1   -77e-8       ->  0.99999923
  #|addx442 add   1   -77e-9       ->  0.999999923
  #|addx443 add   1   -77e-10      ->  0.999999992 Inexact Rounded
  #|addx444 add   1   -77e-11      ->  0.999999999 Inexact Rounded
  #|addx445 add   1   -77e-12      ->  1.00000000 Inexact Rounded
  #|addx446 add   1   -77e-999     ->  1.00000000 Inexact Rounded
  #|addx447 add   1   -77e-9999999 ->  1.00000000 Inexact Rounded
  #|addx450 add  10   -77e-7       ->   9.9999923
  #|addx451 add  10   -77e-8       ->   9.99999923
  #|addx452 add  10   -77e-9       ->   9.99999992 Inexact Rounded
  #|addx453 add  10   -77e-10      ->   9.99999999 Inexact Rounded
  #|addx454 add  10   -77e-11      ->  10.0000000 Inexact Rounded
  #|addx455 add  10   -77e-12      ->  10.0000000 Inexact Rounded
  #|addx456 add  10   -77e-999     ->  10.0000000 Inexact Rounded
  #|addx457 add  10   -77e-9999999 ->  10.0000000 Inexact Rounded
  #|addx460 add  -77e-7        1   ->  0.9999923
  #|addx461 add  -77e-8        1   ->  0.99999923
  #|addx462 add  -77e-9        1   ->  0.999999923
  #|addx463 add  -77e-10       1   ->  0.999999992 Inexact Rounded
  #|addx464 add  -77e-11       1   ->  0.999999999 Inexact Rounded
  #|addx465 add  -77e-12       1   ->  1.00000000 Inexact Rounded
  #|addx466 add  -77e-999      1   ->  1.00000000 Inexact Rounded
  #|addx467 add  -77e-9999999  1   ->  1.00000000 Inexact Rounded
  #|addx470 add  -77e-7       10   ->   9.9999923
  #|addx471 add  -77e-8       10   ->   9.99999923
  #|addx472 add  -77e-9       10   ->   9.99999992 Inexact Rounded
  #|addx473 add  -77e-10      10   ->   9.99999999 Inexact Rounded
  #|addx474 add  -77e-11      10   ->  10.0000000 Inexact Rounded
  #|addx475 add  -77e-12      10   ->  10.0000000 Inexact Rounded
  #|addx476 add  -77e-999     10   ->  10.0000000 Inexact Rounded
  #|addx477 add  -77e-9999999 10   ->  10.0000000 Inexact Rounded
  #|addx480 add  -1    77e-7       ->  -0.9999923
  #|addx481 add  -1    77e-8       ->  -0.99999923
  #|addx482 add  -1    77e-9       ->  -0.999999923
  #|addx483 add  -1    77e-10      ->  -0.999999992 Inexact Rounded
  #|addx484 add  -1    77e-11      ->  -0.999999999 Inexact Rounded
  #|addx485 add  -1    77e-12      ->  -1.00000000 Inexact Rounded
  #|addx486 add  -1    77e-999     ->  -1.00000000 Inexact Rounded
  #|addx487 add  -1    77e-9999999 ->  -1.00000000 Inexact Rounded
  #|addx490 add -10    77e-7       ->   -9.9999923
  #|addx491 add -10    77e-8       ->   -9.99999923
  #|addx492 add -10    77e-9       ->   -9.99999992 Inexact Rounded
  #|addx493 add -10    77e-10      ->   -9.99999999 Inexact Rounded
  #|addx494 add -10    77e-11      ->  -10.0000000 Inexact Rounded
  #|addx495 add -10    77e-12      ->  -10.0000000 Inexact Rounded
  #|addx496 add -10    77e-999     ->  -10.0000000 Inexact Rounded
  #|addx497 add -10    77e-9999999 ->  -10.0000000 Inexact Rounded
  #|addx500 add   77e-7       -1   ->  -0.9999923
  #|addx501 add   77e-8       -1   ->  -0.99999923
  #|addx502 add   77e-9       -1   ->  -0.999999923
  #|addx503 add   77e-10      -1   ->  -0.999999992 Inexact Rounded
  #|addx504 add   77e-11      -1   ->  -0.999999999 Inexact Rounded
  #|addx505 add   77e-12      -1   ->  -1.00000000 Inexact Rounded
  #|addx506 add   77e-999     -1   ->  -1.00000000 Inexact Rounded
  #|addx507 add   77e-9999999 -1   ->  -1.00000000 Inexact Rounded
  #|addx510 add   77e-7       -10  ->   -9.9999923
  #|addx511 add   77e-8       -10  ->   -9.99999923
  #|addx512 add   77e-9       -10  ->   -9.99999992 Inexact Rounded
  #|addx513 add   77e-10      -10  ->   -9.99999999 Inexact Rounded
  #|addx514 add   77e-11      -10  ->  -10.0000000 Inexact Rounded
  #|addx515 add   77e-12      -10  ->  -10.0000000 Inexact Rounded
  #|addx516 add   77e-999     -10  ->  -10.0000000 Inexact Rounded
  #|addx517 add   77e-9999999 -10  ->  -10.0000000 Inexact Rounded
  #|precision: 9
  #|addx521 add 12345678000 0 -> 1.23456780E+10 Rounded
  #|addx522 add 0 12345678000 -> 1.23456780E+10 Rounded
  #|addx523 add 1234567800  0 -> 1.23456780E+9 Rounded
  #|addx524 add 0 1234567800  -> 1.23456780E+9 Rounded
  #|addx525 add 1234567890  0 -> 1.23456789E+9 Rounded
  #|addx526 add 0 1234567890  -> 1.23456789E+9 Rounded
  #|addx527 add 1234567891  0 -> 1.23456789E+9 Inexact Rounded
  #|addx528 add 0 1234567891  -> 1.23456789E+9 Inexact Rounded
  #|addx529 add 12345678901 0 -> 1.23456789E+10 Inexact Rounded
  #|addx530 add 0 12345678901 -> 1.23456789E+10 Inexact Rounded
  #|addx531 add 1234567896  0 -> 1.23456790E+9 Inexact Rounded
  #|addx532 add 0 1234567896  -> 1.23456790E+9 Inexact Rounded
  #|precision: 15
  #|addx541 add 12345678000 0 -> 12345678000
  #|addx542 add 0 12345678000 -> 12345678000
  #|addx543 add 1234567800  0 -> 1234567800
  #|addx544 add 0 1234567800  -> 1234567800
  #|addx545 add 1234567890  0 -> 1234567890
  #|addx546 add 0 1234567890  -> 1234567890
  #|addx547 add 1234567891  0 -> 1234567891
  #|addx548 add 0 1234567891  -> 1234567891
  #|addx549 add 12345678901 0 -> 12345678901
  #|addx550 add 0 12345678901 -> 12345678901
  #|addx551 add 1234567896  0 -> 1234567896
  #|addx552 add 0 1234567896  -> 1234567896
  #|precision:    16
  #|rounding:     down
  #|addx561 add 1e-398 9.000000000000000E+384 -> 9.000000000000000E+384 Inexact Rounded
  #|addx562 add      0 9.000000000000000E+384 -> 9.000000000000000E+384 Rounded
  #|precision:    16
  #|rounding:     down
  #|addx563 add 1e-388 9.000000000000000E+374 -> 9.000000000000000E+374 Inexact Rounded
  #|addx564 add      0 9.000000000000000E+374 -> 9.000000000000000E+374 Rounded
  #|precision:   9
  #|rounding: half_up
  #|addx601 add 123456789  0.000001 -> 123456789 Inexact Rounded
  #|rounding: half_even
  #|addx602 add 123456789  0.000001 -> 123456789 Inexact Rounded
  #|rounding: half_down
  #|addx603 add 123456789  0.000001 -> 123456789 Inexact Rounded
  #|rounding: floor
  #|addx604 add 123456789  0.000001 -> 123456789 Inexact Rounded
  #|rounding: ceiling
  #|addx605 add 123456789  0.000001 -> 123456790 Inexact Rounded
  #|rounding: up
  #|addx606 add 123456789  0.000001 -> 123456790 Inexact Rounded
  #|rounding: down
  #|addx607 add 123456789  0.000001 -> 123456789 Inexact Rounded
  #|rounding: half_up
  #|addx611 add 123456789 -0.000001 -> 123456789 Inexact Rounded
  #|rounding: half_even
  #|addx612 add 123456789 -0.000001 -> 123456789 Inexact Rounded
  #|rounding: half_down
  #|addx613 add 123456789 -0.000001 -> 123456789 Inexact Rounded
  #|rounding: floor
  #|addx614 add 123456789 -0.000001 -> 123456788 Inexact Rounded
  #|rounding: ceiling
  #|addx615 add 123456789 -0.000001 -> 123456789 Inexact Rounded
  #|rounding: up
  #|addx616 add 123456789 -0.000001 -> 123456789 Inexact Rounded
  #|rounding: down
  #|addx617 add 123456789 -0.000001 -> 123456788 Inexact Rounded
  #|rounding: half_up
  #|addx621 add 123456789  0.499999 -> 123456789 Inexact Rounded
  #|rounding: half_even
  #|addx622 add 123456789  0.499999 -> 123456789 Inexact Rounded
  #|rounding: half_down
  #|addx623 add 123456789  0.499999 -> 123456789 Inexact Rounded
  #|rounding: floor
  #|addx624 add 123456789  0.499999 -> 123456789 Inexact Rounded
  #|rounding: ceiling
  #|addx625 add 123456789  0.499999 -> 123456790 Inexact Rounded
  #|rounding: up
  #|addx626 add 123456789  0.499999 -> 123456790 Inexact Rounded
  #|rounding: down
  #|addx627 add 123456789  0.499999 -> 123456789 Inexact Rounded
  #|rounding: half_up
  #|addx631 add 123456789 -0.499999 -> 123456789 Inexact Rounded
  #|rounding: half_even
  #|addx632 add 123456789 -0.499999 -> 123456789 Inexact Rounded
  #|rounding: half_down
  #|addx633 add 123456789 -0.499999 -> 123456789 Inexact Rounded
  #|rounding: floor
  #|addx634 add 123456789 -0.499999 -> 123456788 Inexact Rounded
  #|rounding: ceiling
  #|addx635 add 123456789 -0.499999 -> 123456789 Inexact Rounded
  #|rounding: up
  #|addx636 add 123456789 -0.499999 -> 123456789 Inexact Rounded
  #|rounding: down
  #|addx637 add 123456789 -0.499999 -> 123456788 Inexact Rounded
  #|rounding: half_up
  #|addx641 add 123456789  0.500001 -> 123456790 Inexact Rounded
  #|rounding: half_even
  #|addx642 add 123456789  0.500001 -> 123456790 Inexact Rounded
  #|rounding: half_down
  #|addx643 add 123456789  0.500001 -> 123456790 Inexact Rounded
  #|rounding: floor
  #|addx644 add 123456789  0.500001 -> 123456789 Inexact Rounded
  #|rounding: ceiling
  #|addx645 add 123456789  0.500001 -> 123456790 Inexact Rounded
  #|rounding: up
  #|addx646 add 123456789  0.500001 -> 123456790 Inexact Rounded
  #|rounding: down
  #|addx647 add 123456789  0.500001 -> 123456789 Inexact Rounded
  #|rounding: half_up
  #|addx651 add 123456789 -0.500001 -> 123456788 Inexact Rounded
  #|rounding: half_even
  #|addx652 add 123456789 -0.500001 -> 123456788 Inexact Rounded
  #|rounding: half_down
  #|addx653 add 123456789 -0.500001 -> 123456788 Inexact Rounded
  #|rounding: floor
  #|addx654 add 123456789 -0.500001 -> 123456788 Inexact Rounded
  #|rounding: ceiling
  #|addx655 add 123456789 -0.500001 -> 123456789 Inexact Rounded
  #|rounding: up
  #|addx656 add 123456789 -0.500001 -> 123456789 Inexact Rounded
  #|rounding: down
  #|addx657 add 123456789 -0.500001 -> 123456788 Inexact Rounded
  #|rounding: half_up
  #|precision:  37
  #|addx660 add 98471198160.56524417578665886060 -23994.14313393939743548945165462 -> 98471174166.42211023638922337114834538
  #|precision:  36
  #|addx661 add 98471198160.56524417578665886060 -23994.14313393939743548945165462 -> 98471174166.4221102363892233711483454  Inexact Rounded
  #|precision:  35
  #|addx662 add 98471198160.56524417578665886060 -23994.14313393939743548945165462 -> 98471174166.422110236389223371148345   Inexact Rounded
  #|precision:  34
  #|addx663 add 98471198160.56524417578665886060 -23994.14313393939743548945165462 -> 98471174166.42211023638922337114835    Inexact Rounded
  #|precision:  33
  #|addx664 add 98471198160.56524417578665886060 -23994.14313393939743548945165462 -> 98471174166.4221102363892233711483     Inexact Rounded
  #|precision:  32
  #|addx665 add 98471198160.56524417578665886060 -23994.14313393939743548945165462 -> 98471174166.422110236389223371148      Inexact Rounded
  #|precision:  31
  #|addx666 add 98471198160.56524417578665886060 -23994.14313393939743548945165462 -> 98471174166.42211023638922337115       Inexact Rounded
  #|precision:  30
  #|addx667 add 98471198160.56524417578665886060 -23994.14313393939743548945165462 -> 98471174166.4221102363892233711        Inexact Rounded
  #|precision:  29
  #|addx668 add 98471198160.56524417578665886060 -23994.14313393939743548945165462 -> 98471174166.422110236389223371         Inexact Rounded
  #|precision:  28
  #|addx669 add 98471198160.56524417578665886060 -23994.14313393939743548945165462 -> 98471174166.42211023638922337          Inexact Rounded
  #|precision:  27
  #|addx670 add 98471198160.56524417578665886060 -23994.14313393939743548945165462 -> 98471174166.4221102363892234           Inexact Rounded
  #|precision:  26
  #|addx671 add 98471198160.56524417578665886060 -23994.14313393939743548945165462 -> 98471174166.422110236389223            Inexact Rounded
  #|precision:  25
  #|addx672 add 98471198160.56524417578665886060 -23994.14313393939743548945165462 -> 98471174166.42211023638922             Inexact Rounded
  #|precision:  24
  #|addx673 add 98471198160.56524417578665886060 -23994.14313393939743548945165462 -> 98471174166.4221102363892              Inexact Rounded
  #|precision:  23
  #|addx674 add 98471198160.56524417578665886060 -23994.14313393939743548945165462 -> 98471174166.422110236389               Inexact Rounded
  #|precision:  22
  #|addx675 add 98471198160.56524417578665886060 -23994.14313393939743548945165462 -> 98471174166.42211023639                Inexact Rounded
  #|precision:  21
  #|addx676 add 98471198160.56524417578665886060 -23994.14313393939743548945165462 -> 98471174166.4221102364                 Inexact Rounded
  #|precision:  20
  #|addx677 add 98471198160.56524417578665886060 -23994.14313393939743548945165462 -> 98471174166.422110236                  Inexact Rounded
  #|precision:  19
  #|addx678 add 98471198160.56524417578665886060 -23994.14313393939743548945165462 -> 98471174166.42211024                   Inexact Rounded
  #|precision:  18
  #|addx679 add 98471198160.56524417578665886060 -23994.14313393939743548945165462 -> 98471174166.4221102                    Inexact Rounded
  #|precision:  17
  #|addx680 add 98471198160.56524417578665886060 -23994.14313393939743548945165462 -> 98471174166.422110                     Inexact Rounded
  #|precision:  16
  #|addx681 add 98471198160.56524417578665886060 -23994.14313393939743548945165462 -> 98471174166.42211                      Inexact Rounded
  #|precision:  15
  #|addx682 add 98471198160.56524417578665886060 -23994.14313393939743548945165462 -> 98471174166.4221                       Inexact Rounded
  #|precision:  14
  #|addx683 add 98471198160.56524417578665886060 -23994.14313393939743548945165462 -> 98471174166.422                        Inexact Rounded
  #|precision:  13
  #|addx684 add 98471198160.56524417578665886060 -23994.14313393939743548945165462 -> 98471174166.42                         Inexact Rounded
  #|precision:  12
  #|addx685 add 98471198160.56524417578665886060 -23994.14313393939743548945165462 -> 98471174166.4                          Inexact Rounded
  #|precision:  11
  #|addx686 add 98471198160.56524417578665886060 -23994.14313393939743548945165462 -> 98471174166                            Inexact Rounded
  #|precision:  10
  #|addx687 add 98471198160.56524417578665886060 -23994.14313393939743548945165462 -> 9.847117417E+10                        Inexact Rounded
  #|precision:   9
  #|addx688 add 98471198160.56524417578665886060 -23994.14313393939743548945165462 -> 9.84711742E+10                         Inexact Rounded
  #|precision:   8
  #|precision:   7
  #|precision:   6
  #|precision:   5
  #|precision:   4
  #|precision:   3
  #|precision:   2
  #|precision:   1
  #|rounding: half_up
  #|precision:   9
  #|addx701 add 5.00 1.00E-3 -> 5.00100
  #|addx702 add 00.00 0.000  -> 0.000
  #|addx703 add 00.00 0E-3   -> 0.000
  #|addx704 add 0E-3  00.00  -> 0.000
  #|addx710 add 0E+3  00.00  -> 0.00
  #|addx711 add 0E+3  00.0   -> 0.0
  #|addx712 add 0E+3  00.    -> 0
  #|addx713 add 0E+3  00.E+1 -> 0E+1
  #|addx714 add 0E+3  00.E+2 -> 0E+2
  #|addx715 add 0E+3  00.E+3 -> 0E+3
  #|addx716 add 0E+3  00.E+4 -> 0E+3
  #|addx717 add 0E+3  00.E+5 -> 0E+3
  #|addx718 add 0E+3  -00.0   -> 0.0
  #|addx719 add 0E+3  -00.    -> 0
  #|addx731 add 0E+3  -00.E+1 -> 0E+1
  #|addx720 add 00.00  0E+3  -> 0.00
  #|addx721 add 00.0   0E+3  -> 0.0
  #|addx722 add 00.    0E+3  -> 0
  #|addx723 add 00.E+1 0E+3  -> 0E+1
  #|addx724 add 00.E+2 0E+3  -> 0E+2
  #|addx725 add 00.E+3 0E+3  -> 0E+3
  #|addx726 add 00.E+4 0E+3  -> 0E+3
  #|addx727 add 00.E+5 0E+3  -> 0E+3
  #|addx728 add -00.00 0E+3  -> 0.00
  #|addx729 add -00.0  0E+3  -> 0.0
  #|addx730 add -00.   0E+3  -> 0
  #|addx732 add  0     0     ->  0
  #|addx733 add  0    -0     ->  0
  #|addx734 add -0     0     ->  0
  #|addx735 add -0    -0     -> -0     -- IEEE 854 special case
  #|addx736 add  1    -1     ->  0
  #|addx737 add -1    -1     -> -2
  #|addx738 add  1     1     ->  2
  #|addx739 add -1     1     ->  0
  #|addx741 add  0    -1     -> -1
  #|addx742 add -0    -1     -> -1
  #|addx743 add  0     1     ->  1
  #|addx744 add -0     1     ->  1
  #|addx745 add -1     0     -> -1
  #|addx746 add -1    -0     -> -1
  #|addx747 add  1     0     ->  1
  #|addx748 add  1    -0     ->  1
  #|addx751 add  0.0  -1     -> -1.0
  #|addx752 add -0.0  -1     -> -1.0
  #|addx753 add  0.0   1     ->  1.0
  #|addx754 add -0.0   1     ->  1.0
  #|addx755 add -1.0   0     -> -1.0
  #|addx756 add -1.0  -0     -> -1.0
  #|addx757 add  1.0   0     ->  1.0
  #|addx758 add  1.0  -0     ->  1.0
  #|addx761 add  0    -1.0   -> -1.0
  #|addx762 add -0    -1.0   -> -1.0
  #|addx763 add  0     1.0   ->  1.0
  #|addx764 add -0     1.0   ->  1.0
  #|addx765 add -1     0.0   -> -1.0
  #|addx766 add -1    -0.0   -> -1.0
  #|addx767 add  1     0.0   ->  1.0
  #|addx768 add  1    -0.0   ->  1.0
  #|addx771 add  0.0  -1.0   -> -1.0
  #|addx772 add -0.0  -1.0   -> -1.0
  #|addx773 add  0.0   1.0   ->  1.0
  #|addx774 add -0.0   1.0   ->  1.0
  #|addx775 add -1.0   0.0   -> -1.0
  #|addx776 add -1.0  -0.0   -> -1.0
  #|addx777 add  1.0   0.0   ->  1.0
  #|addx778 add  1.0  -0.0   ->  1.0
  #|addx780 add -Inf  -Inf   -> -Infinity
  #|addx781 add -Inf  -1000  -> -Infinity
  #|addx782 add -Inf  -1     -> -Infinity
  #|addx783 add -Inf  -0     -> -Infinity
  #|addx784 add -Inf   0     -> -Infinity
  #|addx785 add -Inf   1     -> -Infinity
  #|addx786 add -Inf   1000  -> -Infinity
  #|addx787 add -1000 -Inf   -> -Infinity
  #|addx788 add -Inf  -Inf   -> -Infinity
  #|addx789 add -1    -Inf   -> -Infinity
  #|addx790 add -0    -Inf   -> -Infinity
  #|addx791 add  0    -Inf   -> -Infinity
  #|addx792 add  1    -Inf   -> -Infinity
  #|addx793 add  1000 -Inf   -> -Infinity
  #|addx794 add  Inf  -Inf   ->  NaN  Invalid_operation
  #|addx800 add  Inf  -Inf   ->  NaN  Invalid_operation
  #|addx801 add  Inf  -1000  ->  Infinity
  #|addx802 add  Inf  -1     ->  Infinity
  #|addx803 add  Inf  -0     ->  Infinity
  #|addx804 add  Inf   0     ->  Infinity
  #|addx805 add  Inf   1     ->  Infinity
  #|addx806 add  Inf   1000  ->  Infinity
  #|addx807 add  Inf   Inf   ->  Infinity
  #|addx808 add -1000  Inf   ->  Infinity
  #|addx809 add -Inf   Inf   ->  NaN  Invalid_operation
  #|addx810 add -1     Inf   ->  Infinity
  #|addx811 add -0     Inf   ->  Infinity
  #|addx812 add  0     Inf   ->  Infinity
  #|addx813 add  1     Inf   ->  Infinity
  #|addx814 add  1000  Inf   ->  Infinity
  #|addx815 add  Inf   Inf   ->  Infinity
  #|addx821 add  NaN -Inf    ->  NaN
  #|addx822 add  NaN -1000   ->  NaN
  #|addx823 add  NaN -1      ->  NaN
  #|addx824 add  NaN -0      ->  NaN
  #|addx825 add  NaN  0      ->  NaN
  #|addx826 add  NaN  1      ->  NaN
  #|addx827 add  NaN  1000   ->  NaN
  #|addx828 add  NaN  Inf    ->  NaN
  #|addx829 add  NaN  NaN    ->  NaN
  #|addx830 add -Inf  NaN    ->  NaN
  #|addx831 add -1000 NaN    ->  NaN
  #|addx832 add -1    NaN    ->  NaN
  #|addx833 add -0    NaN    ->  NaN
  #|addx834 add  0    NaN    ->  NaN
  #|addx835 add  1    NaN    ->  NaN
  #|addx836 add  1000 NaN    ->  NaN
  #|addx837 add  Inf  NaN    ->  NaN
  #|addx841 add  sNaN -Inf   ->  NaN  Invalid_operation
  #|addx842 add  sNaN -1000  ->  NaN  Invalid_operation
  #|addx843 add  sNaN -1     ->  NaN  Invalid_operation
  #|addx844 add  sNaN -0     ->  NaN  Invalid_operation
  #|addx845 add  sNaN  0     ->  NaN  Invalid_operation
  #|addx846 add  sNaN  1     ->  NaN  Invalid_operation
  #|addx847 add  sNaN  1000  ->  NaN  Invalid_operation
  #|addx848 add  sNaN  NaN   ->  NaN  Invalid_operation
  #|addx849 add  sNaN sNaN   ->  NaN  Invalid_operation
  #|addx850 add  NaN  sNaN   ->  NaN  Invalid_operation
  #|addx851 add -Inf  sNaN   ->  NaN  Invalid_operation
  #|addx852 add -1000 sNaN   ->  NaN  Invalid_operation
  #|addx853 add -1    sNaN   ->  NaN  Invalid_operation
  #|addx854 add -0    sNaN   ->  NaN  Invalid_operation
  #|addx855 add  0    sNaN   ->  NaN  Invalid_operation
  #|addx856 add  1    sNaN   ->  NaN  Invalid_operation
  #|addx857 add  1000 sNaN   ->  NaN  Invalid_operation
  #|addx858 add  Inf  sNaN   ->  NaN  Invalid_operation
  #|addx859 add  NaN  sNaN   ->  NaN  Invalid_operation
  #|addx861 add  NaN1   -Inf    ->  NaN1
  #|addx862 add +NaN2   -1000   ->  NaN2
  #|addx863 add  NaN3    1000   ->  NaN3
  #|addx864 add  NaN4    Inf    ->  NaN4
  #|addx865 add  NaN5   +NaN6   ->  NaN5
  #|addx866 add -Inf     NaN7   ->  NaN7
  #|addx867 add -1000    NaN8   ->  NaN8
  #|addx868 add  1000    NaN9   ->  NaN9
  #|addx869 add  Inf    +NaN10  ->  NaN10
  #|addx871 add  sNaN11  -Inf   ->  NaN11  Invalid_operation
  #|addx872 add  sNaN12  -1000  ->  NaN12  Invalid_operation
  #|addx873 add  sNaN13   1000  ->  NaN13  Invalid_operation
  #|addx874 add  sNaN14   NaN17 ->  NaN14  Invalid_operation
  #|addx875 add  sNaN15  sNaN18 ->  NaN15  Invalid_operation
  #|addx876 add  NaN16   sNaN19 ->  NaN19  Invalid_operation
  #|addx877 add -Inf    +sNaN20 ->  NaN20  Invalid_operation
  #|addx878 add -1000    sNaN21 ->  NaN21  Invalid_operation
  #|addx879 add  1000    sNaN22 ->  NaN22  Invalid_operation
  #|addx880 add  Inf     sNaN23 ->  NaN23  Invalid_operation
  #|addx881 add +NaN25  +sNaN24 ->  NaN24  Invalid_operation
  #|addx882 add -NaN26    NaN28 -> -NaN26
  #|addx883 add -sNaN27  sNaN29 -> -NaN27  Invalid_operation
  #|addx884 add  1000    -NaN30 -> -NaN30
  #|addx885 add  1000   -sNaN31 -> -NaN31  Invalid_operation
  #|precision: 9
  #|addx902 add -1E+999999999   +9E+999999999   ->  8E+999999999
  #|addx903 add -9E+999999999   +1E+999999999   -> -8E+999999999
  #|precision: 3
  #|precision: 3
  #|precision: 8
  #|precision: 7
  #|precision: 6
  #|precision:   16
  #|rounding:    half_up
  #|addx571 add       1E-383       0  -> 1E-383
  #|addx573 add       1E-383  1E-384  -> 1.1E-383
  #|precision:   7
  #|rounding:    half_up
  #|precision:   5
  #|precision:    16
  #|rounding:     down
  #|addx1100 add 1e+2 -1e-383    -> 99.99999999999999 Rounded Inexact
  #|addx1101 add 1e+1 -1e-383    -> 9.999999999999999  Rounded Inexact
  #|addx1103 add   +1 -1e-383    -> 0.9999999999999999  Rounded Inexact
  #|addx1104 add 1e-1 -1e-383    -> 0.09999999999999999  Rounded Inexact
  #|addx1105 add 1e-2 -1e-383    -> 0.009999999999999999  Rounded Inexact
  #|addx1106 add 1e-3 -1e-383    -> 0.0009999999999999999  Rounded Inexact
  #|addx1107 add 1e-4 -1e-383    -> 0.00009999999999999999  Rounded Inexact
  #|addx1108 add 1e-5 -1e-383    -> 0.000009999999999999999  Rounded Inexact
  #|addx1109 add 1e-6 -1e-383    -> 9.999999999999999E-7  Rounded Inexact
  #|rounding:     ceiling
  #|addx1110 add -1e+2 +1e-383   -> -99.99999999999999 Rounded Inexact
  #|addx1111 add -1e+1 +1e-383   -> -9.999999999999999  Rounded Inexact
  #|addx1113 add    -1 +1e-383   -> -0.9999999999999999  Rounded Inexact
  #|addx1114 add -1e-1 +1e-383   -> -0.09999999999999999  Rounded Inexact
  #|addx1115 add -1e-2 +1e-383   -> -0.009999999999999999  Rounded Inexact
  #|addx1116 add -1e-3 +1e-383   -> -0.0009999999999999999  Rounded Inexact
  #|addx1117 add -1e-4 +1e-383   -> -0.00009999999999999999  Rounded Inexact
  #|addx1118 add -1e-5 +1e-383   -> -0.000009999999999999999  Rounded Inexact
  #|addx1119 add -1e-6 +1e-383   -> -9.999999999999999E-7  Rounded Inexact
  #|addx1120 add +1e-383 -1e+2   -> -99.99999999999999 Rounded Inexact
  #|addx1121 add +1e-383 -1e+1   -> -9.999999999999999  Rounded Inexact
  #|addx1123 add +1e-383    -1   -> -0.9999999999999999  Rounded Inexact
  #|addx1124 add +1e-383 -1e-1   -> -0.09999999999999999  Rounded Inexact
  #|addx1125 add +1e-383 -1e-2   -> -0.009999999999999999  Rounded Inexact
  #|addx1126 add +1e-383 -1e-3   -> -0.0009999999999999999  Rounded Inexact
  #|addx1127 add +1e-383 -1e-4   -> -0.00009999999999999999  Rounded Inexact
  #|addx1128 add +1e-383 -1e-5   -> -0.000009999999999999999  Rounded Inexact
  #|addx1129 add +1e-383 -1e-6   -> -9.999999999999999E-7  Rounded Inexact
  #|rounding:     down
  #|precision:    7
  #|precision:   15
  #|rounding:    half_up
  #|addx1200 add 1E15  -0.5                 ->  1.00000000000000E+15 Inexact Rounded
  #|addx1201 add 1E15  -0.50                ->  1.00000000000000E+15 Inexact Rounded
  #|addx1210 add 1E15  -0.51                ->  999999999999999      Inexact Rounded
  #|addx1211 add 1E15  -0.501               ->  999999999999999      Inexact Rounded
  #|addx1212 add 1E15  -0.5001              ->  999999999999999      Inexact Rounded
  #|addx1213 add 1E15  -0.50001             ->  999999999999999      Inexact Rounded
  #|addx1214 add 1E15  -0.500001            ->  999999999999999      Inexact Rounded
  #|addx1215 add 1E15  -0.5000001           ->  999999999999999      Inexact Rounded
  #|addx1216 add 1E15  -0.50000001          ->  999999999999999      Inexact Rounded
  #|addx1217 add 1E15  -0.500000001         ->  999999999999999      Inexact Rounded
  #|addx1218 add 1E15  -0.5000000001        ->  999999999999999      Inexact Rounded
  #|addx1219 add 1E15  -0.50000000001       ->  999999999999999      Inexact Rounded
  #|addx1220 add 1E15  -0.500000000001      ->  999999999999999      Inexact Rounded
  #|addx1221 add 1E15  -0.5000000000001     ->  999999999999999      Inexact Rounded
  #|addx1222 add 1E15  -0.50000000000001    ->  999999999999999      Inexact Rounded
  #|addx1223 add 1E15  -0.500000000000001   ->  999999999999999      Inexact Rounded
  #|addx1224 add 1E15  -0.5000000000000001  ->  999999999999999      Inexact Rounded
  #|addx1225 add 1E15  -0.5000000000000000  ->  1.00000000000000E+15 Inexact Rounded
  #|addx1230 add 1E15  -5000000.000000001   ->  999999995000000      Inexact Rounded
  #|precision:   16
  #|addx1300 add 1E16  -0.5                 ->  1.000000000000000E+16 Inexact Rounded
  #|addx1310 add 1E16  -0.51                ->  9999999999999999      Inexact Rounded
  #|addx1311 add 1E16  -0.501               ->  9999999999999999      Inexact Rounded
  #|addx1312 add 1E16  -0.5001              ->  9999999999999999      Inexact Rounded
  #|addx1313 add 1E16  -0.50001             ->  9999999999999999      Inexact Rounded
  #|addx1314 add 1E16  -0.500001            ->  9999999999999999      Inexact Rounded
  #|addx1315 add 1E16  -0.5000001           ->  9999999999999999      Inexact Rounded
  #|addx1316 add 1E16  -0.50000001          ->  9999999999999999      Inexact Rounded
  #|addx1317 add 1E16  -0.500000001         ->  9999999999999999      Inexact Rounded
  #|addx1318 add 1E16  -0.5000000001        ->  9999999999999999      Inexact Rounded
  #|addx1319 add 1E16  -0.50000000001       ->  9999999999999999      Inexact Rounded
  #|addx1320 add 1E16  -0.500000000001      ->  9999999999999999      Inexact Rounded
  #|addx1321 add 1E16  -0.5000000000001     ->  9999999999999999      Inexact Rounded
  #|addx1322 add 1E16  -0.50000000000001    ->  9999999999999999      Inexact Rounded
  #|addx1323 add 1E16  -0.500000000000001   ->  9999999999999999      Inexact Rounded
  #|addx1324 add 1E16  -0.5000000000000001  ->  9999999999999999      Inexact Rounded
  #|addx1325 add 1E16  -0.5000000000000000  ->  1.000000000000000E+16 Inexact Rounded
  #|addx1326 add 1E16  -0.500000000000000   ->  1.000000000000000E+16 Inexact Rounded
  #|addx1327 add 1E16  -0.50000000000000    ->  1.000000000000000E+16 Inexact Rounded
  #|addx1328 add 1E16  -0.5000000000000     ->  1.000000000000000E+16 Inexact Rounded
  #|addx1329 add 1E16  -0.500000000000      ->  1.000000000000000E+16 Inexact Rounded
  #|addx1330 add 1E16  -0.50000000000       ->  1.000000000000000E+16 Inexact Rounded
  #|addx1331 add 1E16  -0.5000000000        ->  1.000000000000000E+16 Inexact Rounded
  #|addx1332 add 1E16  -0.500000000         ->  1.000000000000000E+16 Inexact Rounded
  #|addx1333 add 1E16  -0.50000000          ->  1.000000000000000E+16 Inexact Rounded
  #|addx1334 add 1E16  -0.5000000           ->  1.000000000000000E+16 Inexact Rounded
  #|addx1335 add 1E16  -0.500000            ->  1.000000000000000E+16 Inexact Rounded
  #|addx1336 add 1E16  -0.50000             ->  1.000000000000000E+16 Inexact Rounded
  #|addx1337 add 1E16  -0.5000              ->  1.000000000000000E+16 Inexact Rounded
  #|addx1338 add 1E16  -0.500               ->  1.000000000000000E+16 Inexact Rounded
  #|addx1339 add 1E16  -0.50                ->  1.000000000000000E+16 Inexact Rounded
  #|addx1340 add 1E16  -5000000.000010001   ->  9999999995000000      Inexact Rounded
  #|addx1341 add 1E16  -5000000.000000001   ->  9999999995000000      Inexact Rounded
  #|addx1349 add 9999999999999999 0.4                 ->  9999999999999999      Inexact Rounded
  #|addx1350 add 9999999999999999 0.49                ->  9999999999999999      Inexact Rounded
  #|addx1351 add 9999999999999999 0.499               ->  9999999999999999      Inexact Rounded
  #|addx1352 add 9999999999999999 0.4999              ->  9999999999999999      Inexact Rounded
  #|addx1353 add 9999999999999999 0.49999             ->  9999999999999999      Inexact Rounded
  #|addx1354 add 9999999999999999 0.499999            ->  9999999999999999      Inexact Rounded
  #|addx1355 add 9999999999999999 0.4999999           ->  9999999999999999      Inexact Rounded
  #|addx1356 add 9999999999999999 0.49999999          ->  9999999999999999      Inexact Rounded
  #|addx1357 add 9999999999999999 0.499999999         ->  9999999999999999      Inexact Rounded
  #|addx1358 add 9999999999999999 0.4999999999        ->  9999999999999999      Inexact Rounded
  #|addx1359 add 9999999999999999 0.49999999999       ->  9999999999999999      Inexact Rounded
  #|addx1360 add 9999999999999999 0.499999999999      ->  9999999999999999      Inexact Rounded
  #|addx1361 add 9999999999999999 0.4999999999999     ->  9999999999999999      Inexact Rounded
  #|addx1362 add 9999999999999999 0.49999999999999    ->  9999999999999999      Inexact Rounded
  #|addx1363 add 9999999999999999 0.499999999999999   ->  9999999999999999      Inexact Rounded
  #|addx1364 add 9999999999999999 0.4999999999999999  ->  9999999999999999      Inexact Rounded
  #|addx1365 add 9999999999999999 0.5000000000000000  ->  1.000000000000000E+16 Inexact Rounded
  #|addx1367 add 9999999999999999 0.500000000000000   ->  1.000000000000000E+16 Inexact Rounded
  #|addx1368 add 9999999999999999 0.50000000000000    ->  1.000000000000000E+16 Inexact Rounded
  #|addx1369 add 9999999999999999 0.5000000000000     ->  1.000000000000000E+16 Inexact Rounded
  #|addx1370 add 9999999999999999 0.500000000000      ->  1.000000000000000E+16 Inexact Rounded
  #|addx1371 add 9999999999999999 0.50000000000       ->  1.000000000000000E+16 Inexact Rounded
  #|addx1372 add 9999999999999999 0.5000000000        ->  1.000000000000000E+16 Inexact Rounded
  #|addx1373 add 9999999999999999 0.500000000         ->  1.000000000000000E+16 Inexact Rounded
  #|addx1374 add 9999999999999999 0.50000000          ->  1.000000000000000E+16 Inexact Rounded
  #|addx1375 add 9999999999999999 0.5000000           ->  1.000000000000000E+16 Inexact Rounded
  #|addx1376 add 9999999999999999 0.500000            ->  1.000000000000000E+16 Inexact Rounded
  #|addx1377 add 9999999999999999 0.50000             ->  1.000000000000000E+16 Inexact Rounded
  #|addx1378 add 9999999999999999 0.5000              ->  1.000000000000000E+16 Inexact Rounded
  #|addx1379 add 9999999999999999 0.500               ->  1.000000000000000E+16 Inexact Rounded
  #|addx1380 add 9999999999999999 0.50                ->  1.000000000000000E+16 Inexact Rounded
  #|addx1381 add 9999999999999999 0.5                 ->  1.000000000000000E+16 Inexact Rounded
  #|addx1382 add 9999999999999999 0.5000000000000001  ->  1.000000000000000E+16 Inexact Rounded
  #|addx1383 add 9999999999999999 0.500000000000001   ->  1.000000000000000E+16 Inexact Rounded
  #|addx1384 add 9999999999999999 0.50000000000001    ->  1.000000000000000E+16 Inexact Rounded
  #|addx1385 add 9999999999999999 0.5000000000001     ->  1.000000000000000E+16 Inexact Rounded
  #|addx1386 add 9999999999999999 0.500000000001      ->  1.000000000000000E+16 Inexact Rounded
  #|addx1387 add 9999999999999999 0.50000000001       ->  1.000000000000000E+16 Inexact Rounded
  #|addx1388 add 9999999999999999 0.5000000001        ->  1.000000000000000E+16 Inexact Rounded
  #|addx1389 add 9999999999999999 0.500000001         ->  1.000000000000000E+16 Inexact Rounded
  #|addx1390 add 9999999999999999 0.50000001          ->  1.000000000000000E+16 Inexact Rounded
  #|addx1391 add 9999999999999999 0.5000001           ->  1.000000000000000E+16 Inexact Rounded
  #|addx1392 add 9999999999999999 0.500001            ->  1.000000000000000E+16 Inexact Rounded
  #|addx1393 add 9999999999999999 0.50001             ->  1.000000000000000E+16 Inexact Rounded
  #|addx1394 add 9999999999999999 0.5001              ->  1.000000000000000E+16 Inexact Rounded
  #|addx1395 add 9999999999999999 0.501               ->  1.000000000000000E+16 Inexact Rounded
  #|addx1396 add 9999999999999999 0.51                ->  1.000000000000000E+16 Inexact Rounded
  #|precision:   15
  #|rounding:    half_up
  #|addx1400 add  0 1.23456789012345     -> 1.23456789012345
  #|addx1401 add  0 1.23456789012345E-1  -> 0.123456789012345
  #|addx1402 add  0 1.23456789012345E-2  -> 0.0123456789012345
  #|addx1403 add  0 1.23456789012345E-3  -> 0.00123456789012345
  #|addx1404 add  0 1.23456789012345E-4  -> 0.000123456789012345
  #|addx1405 add  0 1.23456789012345E-5  -> 0.0000123456789012345
  #|addx1406 add  0 1.23456789012345E-6  -> 0.00000123456789012345
  #|addx1407 add  0 1.23456789012345E-7  -> 1.23456789012345E-7
  #|addx1408 add  0 1.23456789012345E-8  -> 1.23456789012345E-8
  #|addx1409 add  0 1.23456789012345E-9  -> 1.23456789012345E-9
  #|addx1410 add  0 1.23456789012345E-10 -> 1.23456789012345E-10
  #|addx1411 add  0 1.23456789012345E-11 -> 1.23456789012345E-11
  #|addx1412 add  0 1.23456789012345E-12 -> 1.23456789012345E-12
  #|addx1413 add  0 1.23456789012345E-13 -> 1.23456789012345E-13
  #|addx1414 add  0 1.23456789012345E-14 -> 1.23456789012345E-14
  #|addx1415 add  0 1.23456789012345E-15 -> 1.23456789012345E-15
  #|addx1416 add  0 1.23456789012345E-16 -> 1.23456789012345E-16
  #|addx1417 add  0 1.23456789012345E-17 -> 1.23456789012345E-17
  #|addx1418 add  0 1.23456789012345E-18 -> 1.23456789012345E-18
  #|addx1419 add  0 1.23456789012345E-19 -> 1.23456789012345E-19
  #|precision:   16
  #|addx1420 add  0 1.123456789012345     -> 1.123456789012345
  #|addx1421 add  0 1.123456789012345E-1  -> 0.1123456789012345
  #|addx1422 add  0 1.123456789012345E-2  -> 0.01123456789012345
  #|addx1423 add  0 1.123456789012345E-3  -> 0.001123456789012345
  #|addx1424 add  0 1.123456789012345E-4  -> 0.0001123456789012345
  #|addx1425 add  0 1.123456789012345E-5  -> 0.00001123456789012345
  #|addx1426 add  0 1.123456789012345E-6  -> 0.000001123456789012345
  #|addx1427 add  0 1.123456789012345E-7  -> 1.123456789012345E-7
  #|addx1428 add  0 1.123456789012345E-8  -> 1.123456789012345E-8
  #|addx1429 add  0 1.123456789012345E-9  -> 1.123456789012345E-9
  #|addx1430 add  0 1.123456789012345E-10 -> 1.123456789012345E-10
  #|addx1431 add  0 1.123456789012345E-11 -> 1.123456789012345E-11
  #|addx1432 add  0 1.123456789012345E-12 -> 1.123456789012345E-12
  #|addx1433 add  0 1.123456789012345E-13 -> 1.123456789012345E-13
  #|addx1434 add  0 1.123456789012345E-14 -> 1.123456789012345E-14
  #|addx1435 add  0 1.123456789012345E-15 -> 1.123456789012345E-15
  #|addx1436 add  0 1.123456789012345E-16 -> 1.123456789012345E-16
  #|addx1437 add  0 1.123456789012345E-17 -> 1.123456789012345E-17
  #|addx1438 add  0 1.123456789012345E-18 -> 1.123456789012345E-18
  #|addx1439 add  0 1.123456789012345E-19 -> 1.123456789012345E-19
  #|addx1440 add 1.123456789012345     0 -> 1.123456789012345
  #|addx1441 add 1.123456789012345E-1  0 -> 0.1123456789012345
  #|addx1442 add 1.123456789012345E-2  0 -> 0.01123456789012345
  #|addx1443 add 1.123456789012345E-3  0 -> 0.001123456789012345
  #|addx1444 add 1.123456789012345E-4  0 -> 0.0001123456789012345
  #|addx1445 add 1.123456789012345E-5  0 -> 0.00001123456789012345
  #|addx1446 add 1.123456789012345E-6  0 -> 0.000001123456789012345
  #|addx1447 add 1.123456789012345E-7  0 -> 1.123456789012345E-7
  #|addx1448 add 1.123456789012345E-8  0 -> 1.123456789012345E-8
  #|addx1449 add 1.123456789012345E-9  0 -> 1.123456789012345E-9
  #|addx1450 add 1.123456789012345E-10 0 -> 1.123456789012345E-10
  #|addx1451 add 1.123456789012345E-11 0 -> 1.123456789012345E-11
  #|addx1452 add 1.123456789012345E-12 0 -> 1.123456789012345E-12
  #|addx1453 add 1.123456789012345E-13 0 -> 1.123456789012345E-13
  #|addx1454 add 1.123456789012345E-14 0 -> 1.123456789012345E-14
  #|addx1455 add 1.123456789012345E-15 0 -> 1.123456789012345E-15
  #|addx1456 add 1.123456789012345E-16 0 -> 1.123456789012345E-16
  #|addx1457 add 1.123456789012345E-17 0 -> 1.123456789012345E-17
  #|addx1458 add 1.123456789012345E-18 0 -> 1.123456789012345E-18
  #|addx1459 add 1.123456789012345E-19 0 -> 1.123456789012345E-19
  #|addx1460 add 1.123456789012345  0E-0   -> 1.123456789012345
  #|addx1461 add 1.123456789012345  0E-1   -> 1.123456789012345
  #|addx1462 add 1.123456789012345  0E-2   -> 1.123456789012345
  #|addx1463 add 1.123456789012345  0E-3   -> 1.123456789012345
  #|addx1464 add 1.123456789012345  0E-4   -> 1.123456789012345
  #|addx1465 add 1.123456789012345  0E-5   -> 1.123456789012345
  #|addx1466 add 1.123456789012345  0E-6   -> 1.123456789012345
  #|addx1467 add 1.123456789012345  0E-7   -> 1.123456789012345
  #|addx1468 add 1.123456789012345  0E-8   -> 1.123456789012345
  #|addx1469 add 1.123456789012345  0E-9   -> 1.123456789012345
  #|addx1470 add 1.123456789012345  0E-10  -> 1.123456789012345
  #|addx1471 add 1.123456789012345  0E-11  -> 1.123456789012345
  #|addx1472 add 1.123456789012345  0E-12  -> 1.123456789012345
  #|addx1473 add 1.123456789012345  0E-13  -> 1.123456789012345
  #|addx1474 add 1.123456789012345  0E-14  -> 1.123456789012345
  #|addx1475 add 1.123456789012345  0E-15  -> 1.123456789012345
  #|addx1476 add 1.123456789012345  0E-16  -> 1.123456789012345 Rounded
  #|addx1477 add 1.123456789012345  0E-17  -> 1.123456789012345 Rounded
  #|addx1478 add 1.123456789012345  0E-18  -> 1.123456789012345 Rounded
  #|addx1479 add 1.123456789012345  0E-19  -> 1.123456789012345 Rounded
  #|precision:   16
  #|rounding:    half_up
  #|addx1500 add  0        0E-19  ->  0E-19
  #|addx1501 add -0        0E-19  ->  0E-19
  #|addx1502 add  0       -0E-19  ->  0E-19
  #|addx1503 add -0       -0E-19  -> -0E-19
  #|rounding:    half_down
  #|addx1520 add  0        0E-19  ->  0E-19
  #|addx1521 add -0        0E-19  ->  0E-19
  #|addx1522 add  0       -0E-19  ->  0E-19
  #|addx1523 add -0       -0E-19  -> -0E-19
  #|rounding:    half_even
  #|addx1540 add  0        0E-19  ->  0E-19
  #|addx1541 add -0        0E-19  ->  0E-19
  #|addx1542 add  0       -0E-19  ->  0E-19
  #|addx1543 add -0       -0E-19  -> -0E-19
  #|rounding:    up
  #|addx1560 add  0        0E-19  ->  0E-19
  #|addx1561 add -0        0E-19  ->  0E-19
  #|addx1562 add  0       -0E-19  ->  0E-19
  #|addx1563 add -0       -0E-19  -> -0E-19
  #|rounding:    down
  #|addx1580 add  0        0E-19  ->  0E-19
  #|addx1581 add -0        0E-19  ->  0E-19
  #|addx1582 add  0       -0E-19  ->  0E-19
  #|addx1583 add -0       -0E-19  -> -0E-19
  #|rounding:    ceiling
  #|addx1600 add  0        0E-19  ->  0E-19
  #|addx1601 add -0        0E-19  ->  0E-19
  #|addx1602 add  0       -0E-19  ->  0E-19
  #|addx1603 add -0       -0E-19  -> -0E-19
  #|rounding:    floor
  #|addx1620 add  0        0E-19  ->  0E-19
  #|addx1621 add -0        0E-19  -> -0E-19           -- *
  #|addx1622 add  0       -0E-19  -> -0E-19           -- *
  #|addx1623 add -0       -0E-19  -> -0E-19
  #|precision:   16
  #|rounding:  down
  #|precision: 7
  #|precision: 6
  #|precision: 5
  #|precision: 4
  #|precision: 3
  #|precision: 2
  #|precision: 1
  #|rounding:  half_even
  #|precision: 7
  #|precision: 6
  #|precision: 5
  #|precision: 4
  #|precision: 3
  #|precision: 2
  #|precision: 1
  #|rounding:  up
  #|precision: 7
  #|precision: 6
  #|precision: 5
  #|precision: 4
  #|precision: 3
  #|precision: 2
  #|precision: 1
  #|precision:   34
  #|rounding:    half_up
  #|addx1701  add 130E-2    120E-2    -> 2.50
  #|addx1702  add 130E-2    12E-1     -> 2.50
  #|addx1703  add 130E-2    1E0       -> 2.30
  #|addx1704  add 1E2       1E4       -> 1.01E+4
  #|precision:   16
  #|rounding:    half_even
  #|addx6001 add 1       1       ->  2
  #|addx6002 add 2       3       ->  5
  #|addx6003 add '5.75'  '3.3'   ->  9.05
  #|addx6004 add '5'     '-3'    ->  2
  #|addx6005 add '-5'    '-3'    ->  -8
  #|addx6006 add '-7'    '2.5'   ->  -4.5
  #|addx6007 add '0.7'   '0.3'   ->  1.0
  #|addx6008 add '1.25'  '1.25'  ->  2.50
  #|addx6009 add '1.23456789'  '1.00000000' -> '2.23456789'
  #|addx6010 add '1.23456789'  '1.00000011' -> '2.23456800'
  #|addx6011 add '0.44444444444444444'  '0.55555555555555555' -> '1.000000000000000' Inexact Rounded
  #|addx6012 add '0.44444444444444440'  '0.55555555555555555' -> '1.000000000000000' Inexact Rounded
  #|addx6013 add '0.44444444444444444'  '0.55555555555555550' -> '0.9999999999999999' Inexact Rounded
  #|addx6014 add '0.444444444444444449'    '0' -> '0.4444444444444444' Inexact Rounded
  #|addx6015 add '0.4444444444444444499'   '0' -> '0.4444444444444444' Inexact Rounded
  #|addx6016 add '0.44444444444444444999'  '0' -> '0.4444444444444444' Inexact Rounded
  #|addx6017 add '0.44444444444444445000'  '0' -> '0.4444444444444444' Inexact Rounded
  #|addx6018 add '0.44444444444444445001'  '0' -> '0.4444444444444445' Inexact Rounded
  #|addx6019 add '0.4444444444444444501'   '0' -> '0.4444444444444445' Inexact Rounded
  #|addx6020 add '0.444444444444444451'    '0' -> '0.4444444444444445' Inexact Rounded
  #|addx6021 add 0 1 -> 1
  #|addx6022 add 1 1 -> 2
  #|addx6023 add 2 1 -> 3
  #|addx6024 add 3 1 -> 4
  #|addx6025 add 4 1 -> 5
  #|addx6026 add 5 1 -> 6
  #|addx6027 add 6 1 -> 7
  #|addx6028 add 7 1 -> 8
  #|addx6029 add 8 1 -> 9
  #|addx6030 add 9 1 -> 10
  #|addx6031 add '0.9998'  '0.0000' -> '0.9998'
  #|addx6032 add '0.9998'  '0.0001' -> '0.9999'
  #|addx6033 add '0.9998'  '0.0002' -> '1.0000'
  #|addx6034 add '0.9998'  '0.0003' -> '1.0001'
  #|addx6035 add '70'      '10000e+16' -> '1.000000000000000E+20' Inexact Rounded
  #|addx6036 add '700'     '10000e+16' -> '1.000000000000000E+20' Inexact Rounded
  #|addx6037 add '7000'    '10000e+16' -> '1.000000000000000E+20' Inexact Rounded
  #|addx6038 add '70000'   '10000e+16' -> '1.000000000000001E+20' Inexact Rounded
  #|addx6039 add '700000'  '10000e+16' -> '1.000000000000007E+20' Rounded
  #|addx6040 add '10000e+16'  '70' -> '1.000000000000000E+20' Inexact Rounded
  #|addx6041 add '10000e+16'  '700' -> '1.000000000000000E+20' Inexact Rounded
  #|addx6042 add '10000e+16'  '7000' -> '1.000000000000000E+20' Inexact Rounded
  #|addx6044 add '10000e+16'  '70000' -> '1.000000000000001E+20' Inexact Rounded
  #|addx6045 add '10000e+16'  '700000' -> '1.000000000000007E+20' Rounded
  #|addx6046 add '10000e+9'  '7' -> '10000000000007'
  #|addx6047 add '10000e+9'  '70' -> '10000000000070'
  #|addx6048 add '10000e+9'  '700' -> '10000000000700'
  #|addx6049 add '10000e+9'  '7000' -> '10000000007000'
  #|addx6050 add '10000e+9'  '70000' -> '10000000070000'
  #|addx6051 add '10000e+9'  '700000' -> '10000000700000'
  #|addx6053 add '12' '7.00' -> '19.00'
  #|addx6054 add '1.3' '-1.07' -> '0.23'
  #|addx6055 add '1.3' '-1.30' -> '0.00'
  #|addx6056 add '1.3' '-2.07' -> '-0.77'
  #|addx6057 add '1E+2' '1E+4' -> '1.01E+4'
  #|addx6060 add 1 '0.1' -> '1.1'
  #|addx6061 add 1 '0.01' -> '1.01'
  #|addx6062 add 1 '0.001' -> '1.001'
  #|addx6063 add 1 '0.0001' -> '1.0001'
  #|addx6064 add 1 '0.00001' -> '1.00001'
  #|addx6065 add 1 '0.000001' -> '1.000001'
  #|addx6066 add 1 '0.0000001' -> '1.0000001'
  #|addx6067 add 1 '0.00000001' -> '1.00000001'
  #|addx6068 add 99999999999999123456789 -99999999999999E+9 -> 123456789
  #|addx6069 add "-1234567890123455.234567890123454" "1234567890123456" -> 0.765432109876546
  #|addx6070 add 1  0    -> 1
  #|addx6071 add 1 0.    -> 1
  #|addx6072 add 1  .0   -> 1.0
  #|addx6073 add 1 0.0   -> 1.0
  #|addx6074 add 1 0.00  -> 1.00
  #|addx6075 add  0  1   -> 1
  #|addx6076 add 0.  1   -> 1
  #|addx6077 add  .0 1   -> 1.0
  #|addx6078 add 0.0 1   -> 1.0
  #|addx6079 add 0.00 1  -> 1.00
  #|addx6080 add 9999999999999998 1  -> 9999999999999999
  #|addx6081 add 9999999999999999 1  -> 1.000000000000000E+16 Rounded
  #|addx6082 add  999999999999999 1  -> 1000000000000000
  #|addx6083 add    9999999999999 1  -> 10000000000000
  #|addx6084 add      99999999999 1  -> 100000000000
  #|addx6085 add        999999999 1  -> 1000000000
  #|addx6086 add          9999999 1  -> 10000000
  #|addx6087 add            99999 1  -> 100000
  #|addx6088 add              999 1  -> 1000
  #|addx6089 add                9 1  -> 10
  #|addx6090 add '-56267E-10'   0 ->  '-0.0000056267'
  #|addx6091 add '-56267E-6'    0 ->  '-0.056267'
  #|addx6092 add '-56267E-5'    0 ->  '-0.56267'
  #|addx6093 add '-56267E-4'    0 ->  '-5.6267'
  #|addx6094 add '-56267E-3'    0 ->  '-56.267'
  #|addx6095 add '-56267E-2'    0 ->  '-562.67'
  #|addx6096 add '-56267E-1'    0 ->  '-5626.7'
  #|addx6097 add '-56267E-0'    0 ->  '-56267'
  #|addx6098 add '-5E-10'       0 ->  '-5E-10'
  #|addx6099 add '-5E-7'        0 ->  '-5E-7'
  #|addx6100 add '-5E-6'        0 ->  '-0.000005'
  #|addx6101 add '-5E-5'        0 ->  '-0.00005'
  #|addx6102 add '-5E-4'        0 ->  '-0.0005'
  #|addx6103 add '-5E-1'        0 ->  '-0.5'
  #|addx6104 add '-5E0'         0 ->  '-5'
  #|addx6105 add '-5E1'         0 ->  '-50'
  #|addx6106 add '-5E5'         0 ->  '-500000'
  #|addx6107 add '-5E15'        0 ->  '-5000000000000000'
  #|addx6108 add '-5E16'        0 ->  '-5.000000000000000E+16'   Rounded
  #|addx6109 add '-5E17'        0 ->  '-5.000000000000000E+17'  Rounded
  #|addx6110 add '-5E18'        0 ->  '-5.000000000000000E+18'  Rounded
  #|addx6111 add '-5E100'       0 ->  '-5.000000000000000E+100' Rounded
  #|addx6113 add 0  '-56267E-10' ->  '-0.0000056267'
  #|addx6114 add 0  '-56267E-6'  ->  '-0.056267'
  #|addx6116 add 0  '-56267E-5'  ->  '-0.56267'
  #|addx6117 add 0  '-56267E-4'  ->  '-5.6267'
  #|addx6119 add 0  '-56267E-3'  ->  '-56.267'
  #|addx6120 add 0  '-56267E-2'  ->  '-562.67'
  #|addx6121 add 0  '-56267E-1'  ->  '-5626.7'
  #|addx6122 add 0  '-56267E-0'  ->  '-56267'
  #|addx6123 add 0  '-5E-10'     ->  '-5E-10'
  #|addx6124 add 0  '-5E-7'      ->  '-5E-7'
  #|addx6125 add 0  '-5E-6'      ->  '-0.000005'
  #|addx6126 add 0  '-5E-5'      ->  '-0.00005'
  #|addx6127 add 0  '-5E-4'      ->  '-0.0005'
  #|addx6128 add 0  '-5E-1'      ->  '-0.5'
  #|addx6129 add 0  '-5E0'       ->  '-5'
  #|addx6130 add 0  '-5E1'       ->  '-50'
  #|addx6131 add 0  '-5E5'       ->  '-500000'
  #|addx6132 add 0  '-5E15'      ->  '-5000000000000000'
  #|addx6133 add 0  '-5E16'      ->  '-5.000000000000000E+16'   Rounded
  #|addx6134 add 0  '-5E17'      ->  '-5.000000000000000E+17'   Rounded
  #|addx6135 add 0  '-5E18'      ->  '-5.000000000000000E+18'   Rounded
  #|addx6136 add 0  '-5E100'     ->  '-5.000000000000000E+100'  Rounded
  #|addx6137 add  1  '0E-19'      ->  '1.000000000000000'  Rounded
  #|addx6138 add -1  '0E-19'      ->  '-1.000000000000000' Rounded
  #|addx6139 add '0E-19' 1        ->  '1.000000000000000'  Rounded
  #|addx6140 add '0E-19' -1       ->  '-1.000000000000000' Rounded
  #|addx6141 add 1E+11   0.0000   ->  '100000000000.0000'
  #|addx6142 add 1E+11   0.00000  ->  '100000000000.0000'  Rounded
  #|addx6143 add 0.000   1E+12    ->  '1000000000000.000'
  #|addx6144 add 0.0000  1E+12    ->  '1000000000000.000'  Rounded
  #|addx6146 add '00.0'  0       ->  '0.0'
  #|addx6147 add '0.00'  0       ->  '0.00'
  #|addx6148 add  0      '0.00'  ->  '0.00'
  #|addx6149 add  0      '00.0'  ->  '0.0'
  #|addx6150 add '00.0'  '0.00'  ->  '0.00'
  #|addx6151 add '0.00'  '00.0'  ->  '0.00'
  #|addx6152 add '3'     '.3'    ->  '3.3'
  #|addx6153 add '3.'    '.3'    ->  '3.3'
  #|addx6154 add '3.0'   '.3'    ->  '3.3'
  #|addx6155 add '3.00'  '.3'    ->  '3.30'
  #|addx6156 add '3'     '3'     ->  '6'
  #|addx6157 add '3'     '+3'    ->  '6'
  #|addx6158 add '3'     '-3'    ->  '0'
  #|addx6159 add '0.3'   '-0.3'  ->  '0.0'
  #|addx6160 add '0.03'  '-0.03' ->  '0.00'
  #|addx6161 add '1E+13' '-1'    -> '9999999999999'
  #|addx6162 add '1E+13'  '1.11' -> '10000000000001.11'
  #|addx6163 add '1.11'  '1E+13' -> '10000000000001.11'
  #|addx6164 add '-1'    '1E+13' -> '9999999999999'
  #|addx6165 add '7E+13' '-1'    -> '69999999999999'
  #|addx6166 add '7E+13'  '1.11' -> '70000000000001.11'
  #|addx6167 add '1.11'  '7E+13' -> '70000000000001.11'
  #|addx6168 add '-1'    '7E+13' -> '69999999999999'
  #|addx6170 add '0.4444444444444444'  '0.5555555555555563' -> '1.000000000000001' Inexact Rounded
  #|addx6171 add '0.4444444444444444'  '0.5555555555555562' -> '1.000000000000001' Inexact Rounded
  #|addx6172 add '0.4444444444444444'  '0.5555555555555561' -> '1.000000000000000' Inexact Rounded
  #|addx6173 add '0.4444444444444444'  '0.5555555555555560' -> '1.000000000000000' Inexact Rounded
  #|addx6174 add '0.4444444444444444'  '0.5555555555555559' -> '1.000000000000000' Inexact Rounded
  #|addx6175 add '0.4444444444444444'  '0.5555555555555558' -> '1.000000000000000' Inexact Rounded
  #|addx6176 add '0.4444444444444444'  '0.5555555555555557' -> '1.000000000000000' Inexact Rounded
  #|addx6177 add '0.4444444444444444'  '0.5555555555555556' -> '1.000000000000000' Rounded
  #|addx6178 add '0.4444444444444444'  '0.5555555555555555' -> '0.9999999999999999'
  #|addx6179 add '0.4444444444444444'  '0.5555555555555554' -> '0.9999999999999998'
  #|addx6180 add '0.4444444444444444'  '0.5555555555555553' -> '0.9999999999999997'
  #|addx6181 add '0.4444444444444444'  '0.5555555555555552' -> '0.9999999999999996'
  #|addx6182 add '0.4444444444444444'  '0.5555555555555551' -> '0.9999999999999995'
  #|addx6183 add '0.4444444444444444'  '0.5555555555555550' -> '0.9999999999999994'
  #|rounding: half_up
  #|addx6200 add '6543210123456789' 0             -> '6543210123456789'
  #|addx6201 add '6543210123456789' 0.000000001   -> '6543210123456789' Inexact Rounded
  #|addx6202 add '6543210123456789' 0.000001      -> '6543210123456789' Inexact Rounded
  #|addx6203 add '6543210123456789' 0.1           -> '6543210123456789' Inexact Rounded
  #|addx6204 add '6543210123456789' 0.4           -> '6543210123456789' Inexact Rounded
  #|addx6205 add '6543210123456789' 0.49          -> '6543210123456789' Inexact Rounded
  #|addx6206 add '6543210123456789' 0.499999      -> '6543210123456789' Inexact Rounded
  #|addx6207 add '6543210123456789' 0.499999999   -> '6543210123456789' Inexact Rounded
  #|addx6208 add '6543210123456789' 0.5           -> '6543210123456790' Inexact Rounded
  #|addx6209 add '6543210123456789' 0.500000001   -> '6543210123456790' Inexact Rounded
  #|addx6210 add '6543210123456789' 0.500001      -> '6543210123456790' Inexact Rounded
  #|addx6211 add '6543210123456789' 0.51          -> '6543210123456790' Inexact Rounded
  #|addx6212 add '6543210123456789' 0.6           -> '6543210123456790' Inexact Rounded
  #|addx6213 add '6543210123456789' 0.9           -> '6543210123456790' Inexact Rounded
  #|addx6214 add '6543210123456789' 0.99999       -> '6543210123456790' Inexact Rounded
  #|addx6215 add '6543210123456789' 0.999999999   -> '6543210123456790' Inexact Rounded
  #|addx6216 add '6543210123456789' 1             -> '6543210123456790'
  #|addx6217 add '6543210123456789' 1.000000001   -> '6543210123456790' Inexact Rounded
  #|addx6218 add '6543210123456789' 1.00001       -> '6543210123456790' Inexact Rounded
  #|addx6219 add '6543210123456789' 1.1           -> '6543210123456790' Inexact Rounded
  #|rounding: half_even
  #|addx6220 add '6543210123456789' 0             -> '6543210123456789'
  #|addx6221 add '6543210123456789' 0.000000001   -> '6543210123456789' Inexact Rounded
  #|addx6222 add '6543210123456789' 0.000001      -> '6543210123456789' Inexact Rounded
  #|addx6223 add '6543210123456789' 0.1           -> '6543210123456789' Inexact Rounded
  #|addx6224 add '6543210123456789' 0.4           -> '6543210123456789' Inexact Rounded
  #|addx6225 add '6543210123456789' 0.49          -> '6543210123456789' Inexact Rounded
  #|addx6226 add '6543210123456789' 0.499999      -> '6543210123456789' Inexact Rounded
  #|addx6227 add '6543210123456789' 0.499999999   -> '6543210123456789' Inexact Rounded
  #|addx6228 add '6543210123456789' 0.5           -> '6543210123456790' Inexact Rounded
  #|addx6229 add '6543210123456789' 0.500000001   -> '6543210123456790' Inexact Rounded
  #|addx6230 add '6543210123456789' 0.500001      -> '6543210123456790' Inexact Rounded
  #|addx6231 add '6543210123456789' 0.51          -> '6543210123456790' Inexact Rounded
  #|addx6232 add '6543210123456789' 0.6           -> '6543210123456790' Inexact Rounded
  #|addx6233 add '6543210123456789' 0.9           -> '6543210123456790' Inexact Rounded
  #|addx6234 add '6543210123456789' 0.99999       -> '6543210123456790' Inexact Rounded
  #|addx6235 add '6543210123456789' 0.999999999   -> '6543210123456790' Inexact Rounded
  #|addx6236 add '6543210123456789' 1             -> '6543210123456790'
  #|addx6237 add '6543210123456789' 1.00000001    -> '6543210123456790' Inexact Rounded
  #|addx6238 add '6543210123456789' 1.00001       -> '6543210123456790' Inexact Rounded
  #|addx6239 add '6543210123456789' 1.1           -> '6543210123456790' Inexact Rounded
  #|addx6240 add '6543210123456788' 0.499999999   -> '6543210123456788' Inexact Rounded
  #|addx6241 add '6543210123456788' 0.5           -> '6543210123456788' Inexact Rounded
  #|addx6242 add '6543210123456788' 0.500000001   -> '6543210123456789' Inexact Rounded
  #|rounding: down
  #|addx6250 add '6543210123456789' 0             -> '6543210123456789'
  #|addx6251 add '6543210123456789' 0.000000001   -> '6543210123456789' Inexact Rounded
  #|addx6252 add '6543210123456789' 0.000001      -> '6543210123456789' Inexact Rounded
  #|addx6253 add '6543210123456789' 0.1           -> '6543210123456789' Inexact Rounded
  #|addx6254 add '6543210123456789' 0.4           -> '6543210123456789' Inexact Rounded
  #|addx6255 add '6543210123456789' 0.49          -> '6543210123456789' Inexact Rounded
  #|addx6256 add '6543210123456789' 0.499999      -> '6543210123456789' Inexact Rounded
  #|addx6257 add '6543210123456789' 0.499999999   -> '6543210123456789' Inexact Rounded
  #|addx6258 add '6543210123456789' 0.5           -> '6543210123456789' Inexact Rounded
  #|addx6259 add '6543210123456789' 0.500000001   -> '6543210123456789' Inexact Rounded
  #|addx6260 add '6543210123456789' 0.500001      -> '6543210123456789' Inexact Rounded
  #|addx6261 add '6543210123456789' 0.51          -> '6543210123456789' Inexact Rounded
  #|addx6262 add '6543210123456789' 0.6           -> '6543210123456789' Inexact Rounded
  #|addx6263 add '6543210123456789' 0.9           -> '6543210123456789' Inexact Rounded
  #|addx6264 add '6543210123456789' 0.99999       -> '6543210123456789' Inexact Rounded
  #|addx6265 add '6543210123456789' 0.999999999   -> '6543210123456789' Inexact Rounded
  #|addx6266 add '6543210123456789' 1             -> '6543210123456790'
  #|addx6267 add '6543210123456789' 1.00000001    -> '6543210123456790' Inexact Rounded
  #|addx6268 add '6543210123456789' 1.00001       -> '6543210123456790' Inexact Rounded
  #|addx6269 add '6543210123456789' 1.1           -> '6543210123456790' Inexact Rounded
  #|rounding: half_even
  #|addx6301 add  -1   1      ->   0
  #|addx6302 add   0   1      ->   1
  #|addx6303 add   1   1      ->   2
  #|addx6304 add  12   1      ->  13
  #|addx6305 add  98   1      ->  99
  #|addx6306 add  99   1      -> 100
  #|addx6307 add 100   1      -> 101
  #|addx6308 add 101   1      -> 102
  #|addx6309 add  -1  -1      ->  -2
  #|addx6310 add   0  -1      ->  -1
  #|addx6311 add   1  -1      ->   0
  #|addx6312 add  12  -1      ->  11
  #|addx6313 add  98  -1      ->  97
  #|addx6314 add  99  -1      ->  98
  #|addx6315 add 100  -1      ->  99
  #|addx6316 add 101  -1      -> 100
  #|addx6321 add -0.01  0.01    ->  0.00
  #|addx6322 add  0.00  0.01    ->  0.01
  #|addx6323 add  0.01  0.01    ->  0.02
  #|addx6324 add  0.12  0.01    ->  0.13
  #|addx6325 add  0.98  0.01    ->  0.99
  #|addx6326 add  0.99  0.01    ->  1.00
  #|addx6327 add  1.00  0.01    ->  1.01
  #|addx6328 add  1.01  0.01    ->  1.02
  #|addx6329 add -0.01 -0.01    -> -0.02
  #|addx6330 add  0.00 -0.01    -> -0.01
  #|addx6331 add  0.01 -0.01    ->  0.00
  #|addx6332 add  0.12 -0.01    ->  0.11
  #|addx6333 add  0.98 -0.01    ->  0.97
  #|addx6334 add  0.99 -0.01    ->  0.98
  #|addx6335 add  1.00 -0.01    ->  0.99
  #|addx6336 add  1.01 -0.01    ->  1.00
  #|addx6340 add 1E+3    0    ->         1000
  #|addx6341 add 1E+15   0    ->    1000000000000000
  #|addx6342 add 1E+16   0    ->   1.000000000000000E+16  Rounded
  #|addx6343 add 1E+17   0    ->   1.000000000000000E+17  Rounded
  #|addx6344 add 1E+3    1    ->         1001
  #|addx6345 add 1E+15   1    ->    1000000000000001
  #|addx6346 add 1E+16   1    ->   1.000000000000000E+16  Inexact Rounded
  #|addx6347 add 1E+17   1    ->   1.000000000000000E+17  Inexact Rounded
  #|addx6348 add 1E+3    7    ->         1007
  #|addx6349 add 1E+15   7    ->    1000000000000007
  #|addx6350 add 1E+16   7    ->   1.000000000000001E+16  Inexact Rounded
  #|addx6351 add 1E+17   7    ->   1.000000000000000E+17  Inexact Rounded
  #|addx6361  add 0E+50 10000E+1  -> 1.0000E+5
  #|addx6362  add 10000E+1 0E-50  -> 100000.0000000000  Rounded
  #|addx6363  add 10000E+1 10000E-50  -> 100000.0000000000  Rounded Inexact
  #|addx6364  add 12.34    0e-398  -> 12.34000000000000  Rounded
  #|addx6400 add   1   77e-14      ->  1.00000000000077
  #|addx6401 add   1   77e-15      ->  1.000000000000077
  #|addx6402 add   1   77e-16      ->  1.000000000000008 Inexact Rounded
  #|addx6403 add   1   77e-17      ->  1.000000000000001 Inexact Rounded
  #|addx6404 add   1   77e-18      ->  1.000000000000000 Inexact Rounded
  #|addx6405 add   1   77e-19      ->  1.000000000000000 Inexact Rounded
  #|addx6406 add   1   77e-99      ->  1.000000000000000 Inexact Rounded
  #|addx6410 add  10   77e-14      ->  10.00000000000077
  #|addx6411 add  10   77e-15      ->  10.00000000000008 Inexact Rounded
  #|addx6412 add  10   77e-16      ->  10.00000000000001 Inexact Rounded
  #|addx6413 add  10   77e-17      ->  10.00000000000000 Inexact Rounded
  #|addx6414 add  10   77e-18      ->  10.00000000000000 Inexact Rounded
  #|addx6415 add  10   77e-19      ->  10.00000000000000 Inexact Rounded
  #|addx6416 add  10   77e-99      ->  10.00000000000000 Inexact Rounded
  #|addx6420 add  77e-14       1   ->  1.00000000000077
  #|addx6421 add  77e-15       1   ->  1.000000000000077
  #|addx6422 add  77e-16       1   ->  1.000000000000008 Inexact Rounded
  #|addx6423 add  77e-17       1   ->  1.000000000000001 Inexact Rounded
  #|addx6424 add  77e-18       1   ->  1.000000000000000 Inexact Rounded
  #|addx6425 add  77e-19       1   ->  1.000000000000000 Inexact Rounded
  #|addx6426 add  77e-99       1   ->  1.000000000000000 Inexact Rounded
  #|addx6430 add  77e-14      10   ->  10.00000000000077
  #|addx6431 add  77e-15      10   ->  10.00000000000008 Inexact Rounded
  #|addx6432 add  77e-16      10   ->  10.00000000000001 Inexact Rounded
  #|addx6433 add  77e-17      10   ->  10.00000000000000 Inexact Rounded
  #|addx6434 add  77e-18      10   ->  10.00000000000000 Inexact Rounded
  #|addx6435 add  77e-19      10   ->  10.00000000000000 Inexact Rounded
  #|addx6436 add  77e-99      10   ->  10.00000000000000 Inexact Rounded
  #|addx6440 add   1   -77e-14      ->  0.99999999999923
  #|addx6441 add   1   -77e-15      ->  0.999999999999923
  #|addx6442 add   1   -77e-16      ->  0.9999999999999923
  #|addx6443 add   1   -77e-17      ->  0.9999999999999992 Inexact Rounded
  #|addx6444 add   1   -77e-18      ->  0.9999999999999999 Inexact Rounded
  #|addx6445 add   1   -77e-19      ->  1.000000000000000 Inexact Rounded
  #|addx6446 add   1   -77e-99      ->  1.000000000000000 Inexact Rounded
  #|addx6450 add  10   -77e-14      ->   9.99999999999923
  #|addx6451 add  10   -77e-15      ->   9.999999999999923
  #|addx6452 add  10   -77e-16      ->   9.999999999999992 Inexact Rounded
  #|addx6453 add  10   -77e-17      ->   9.999999999999999 Inexact Rounded
  #|addx6454 add  10   -77e-18      ->  10.00000000000000 Inexact Rounded
  #|addx6455 add  10   -77e-19      ->  10.00000000000000 Inexact Rounded
  #|addx6456 add  10   -77e-99      ->  10.00000000000000 Inexact Rounded
  #|addx6460 add  -77e-14       1   ->  0.99999999999923
  #|addx6461 add  -77e-15       1   ->  0.999999999999923
  #|addx6462 add  -77e-16       1   ->  0.9999999999999923
  #|addx6463 add  -77e-17       1   ->  0.9999999999999992 Inexact Rounded
  #|addx6464 add  -77e-18       1   ->  0.9999999999999999 Inexact Rounded
  #|addx6465 add  -77e-19       1   ->  1.000000000000000 Inexact Rounded
  #|addx6466 add  -77e-99       1   ->  1.000000000000000 Inexact Rounded
  #|addx6470 add  -77e-14      10   ->   9.99999999999923
  #|addx6471 add  -77e-15      10   ->   9.999999999999923
  #|addx6472 add  -77e-16      10   ->   9.999999999999992 Inexact Rounded
  #|addx6473 add  -77e-17      10   ->   9.999999999999999 Inexact Rounded
  #|addx6474 add  -77e-18      10   ->  10.00000000000000 Inexact Rounded
  #|addx6475 add  -77e-19      10   ->  10.00000000000000 Inexact Rounded
  #|addx6476 add  -77e-99      10   ->  10.00000000000000 Inexact Rounded
  #|addx6480 add  -1    77e-14      ->  -0.99999999999923
  #|addx6481 add  -1    77e-15      ->  -0.999999999999923
  #|addx6482 add  -1    77e-16      ->  -0.9999999999999923
  #|addx6483 add  -1    77e-17      ->  -0.9999999999999992 Inexact Rounded
  #|addx6484 add  -1    77e-18      ->  -0.9999999999999999 Inexact Rounded
  #|addx6485 add  -1    77e-19      ->  -1.000000000000000 Inexact Rounded
  #|addx6486 add  -1    77e-99      ->  -1.000000000000000 Inexact Rounded
  #|addx6490 add -10    77e-14      ->   -9.99999999999923
  #|addx6491 add -10    77e-15      ->   -9.999999999999923
  #|addx6492 add -10    77e-16      ->   -9.999999999999992 Inexact Rounded
  #|addx6493 add -10    77e-17      ->   -9.999999999999999 Inexact Rounded
  #|addx6494 add -10    77e-18      ->  -10.00000000000000 Inexact Rounded
  #|addx6495 add -10    77e-19      ->  -10.00000000000000 Inexact Rounded
  #|addx6496 add -10    77e-99      ->  -10.00000000000000 Inexact Rounded
  #|addx6500 add   77e-14      -1   ->  -0.99999999999923
  #|addx6501 add   77e-15      -1   ->  -0.999999999999923
  #|addx6502 add   77e-16      -1   ->  -0.9999999999999923
  #|addx6503 add   77e-17      -1   ->  -0.9999999999999992 Inexact Rounded
  #|addx6504 add   77e-18      -1   ->  -0.9999999999999999 Inexact Rounded
  #|addx6505 add   77e-19      -1   ->  -1.000000000000000 Inexact Rounded
  #|addx6506 add   77e-99      -1   ->  -1.000000000000000 Inexact Rounded
  #|addx6510 add   77e-14      -10  ->   -9.99999999999923
  #|addx6511 add   77e-15      -10  ->   -9.999999999999923
  #|addx6512 add   77e-16      -10  ->   -9.999999999999992 Inexact Rounded
  #|addx6513 add   77e-17      -10  ->   -9.999999999999999 Inexact Rounded
  #|addx6514 add   77e-18      -10  ->  -10.00000000000000 Inexact Rounded
  #|addx6515 add   77e-19      -10  ->  -10.00000000000000 Inexact Rounded
  #|addx6516 add   77e-99      -10  ->  -10.00000000000000 Inexact Rounded
  #|addx6521 add 101234562345678000 0 -> 1.012345623456780E+17 Rounded
  #|addx6522 add 0 101234562345678000 -> 1.012345623456780E+17 Rounded
  #|addx6523 add 10123456234567800  0 -> 1.012345623456780E+16 Rounded
  #|addx6524 add 0 10123456234567800  -> 1.012345623456780E+16 Rounded
  #|addx6525 add 10123456234567890  0 -> 1.012345623456789E+16 Rounded
  #|addx6526 add 0 10123456234567890  -> 1.012345623456789E+16 Rounded
  #|addx6527 add 10123456234567891  0 -> 1.012345623456789E+16 Inexact Rounded
  #|addx6528 add 0 10123456234567891  -> 1.012345623456789E+16 Inexact Rounded
  #|addx6529 add 101234562345678901 0 -> 1.012345623456789E+17 Inexact Rounded
  #|addx6530 add 0 101234562345678901 -> 1.012345623456789E+17 Inexact Rounded
  #|addx6531 add 10123456234567896  0 -> 1.012345623456790E+16 Inexact Rounded
  #|addx6532 add 0 10123456234567896  -> 1.012345623456790E+16 Inexact Rounded
  #|rounding:     down
  #|addx6561 add 1e-398 9.000000000000000E+384 -> 9.000000000000000E+384 Inexact Rounded
  #|addx6562 add      0 9.000000000000000E+384 -> 9.000000000000000E+384 Rounded
  #|rounding:     down
  #|addx6563 add 1e-388 9.000000000000000E+374 -> 9.000000000000000E+374 Inexact Rounded
  #|addx6564 add      0 9.000000000000000E+374 -> 9.000000000000000E+374 Rounded
  #|rounding: half_even
  #|addx6701 add 5.00 1.00E-3 -> 5.00100
  #|addx6702 add 00.00 0.000  -> 0.000
  #|addx6703 add 00.00 0E-3   -> 0.000
  #|addx6704 add 0E-3  00.00  -> 0.000
  #|addx6710 add 0E+3  00.00  -> 0.00
  #|addx6711 add 0E+3  00.0   -> 0.0
  #|addx6712 add 0E+3  00.    -> 0
  #|addx6713 add 0E+3  00.E+1 -> 0E+1
  #|addx6714 add 0E+3  00.E+2 -> 0E+2
  #|addx6715 add 0E+3  00.E+3 -> 0E+3
  #|addx6716 add 0E+3  00.E+4 -> 0E+3
  #|addx6717 add 0E+3  00.E+5 -> 0E+3
  #|addx6718 add 0E+3  -00.0   -> 0.0
  #|addx6719 add 0E+3  -00.    -> 0
  #|addx6731 add 0E+3  -00.E+1 -> 0E+1
  #|addx6720 add 00.00  0E+3  -> 0.00
  #|addx6721 add 00.0   0E+3  -> 0.0
  #|addx6722 add 00.    0E+3  -> 0
  #|addx6723 add 00.E+1 0E+3  -> 0E+1
  #|addx6724 add 00.E+2 0E+3  -> 0E+2
  #|addx6725 add 00.E+3 0E+3  -> 0E+3
  #|addx6726 add 00.E+4 0E+3  -> 0E+3
  #|addx6727 add 00.E+5 0E+3  -> 0E+3
  #|addx6728 add -00.00 0E+3  -> 0.00
  #|addx6729 add -00.0  0E+3  -> 0.0
  #|addx6730 add -00.   0E+3  -> 0
  #|addx6732 add  0     0     ->  0
  #|addx6733 add  0    -0     ->  0
  #|addx6734 add -0     0     ->  0
  #|addx6735 add -0    -0     -> -0     -- IEEE 854 special case
  #|addx6736 add  1    -1     ->  0
  #|addx6737 add -1    -1     -> -2
  #|addx6738 add  1     1     ->  2
  #|addx6739 add -1     1     ->  0
  #|addx6741 add  0    -1     -> -1
  #|addx6742 add -0    -1     -> -1
  #|addx6743 add  0     1     ->  1
  #|addx6744 add -0     1     ->  1
  #|addx6745 add -1     0     -> -1
  #|addx6746 add -1    -0     -> -1
  #|addx6747 add  1     0     ->  1
  #|addx6748 add  1    -0     ->  1
  #|addx6751 add  0.0  -1     -> -1.0
  #|addx6752 add -0.0  -1     -> -1.0
  #|addx6753 add  0.0   1     ->  1.0
  #|addx6754 add -0.0   1     ->  1.0
  #|addx6755 add -1.0   0     -> -1.0
  #|addx6756 add -1.0  -0     -> -1.0
  #|addx6757 add  1.0   0     ->  1.0
  #|addx6758 add  1.0  -0     ->  1.0
  #|addx6761 add  0    -1.0   -> -1.0
  #|addx6762 add -0    -1.0   -> -1.0
  #|addx6763 add  0     1.0   ->  1.0
  #|addx6764 add -0     1.0   ->  1.0
  #|addx6765 add -1     0.0   -> -1.0
  #|addx6766 add -1    -0.0   -> -1.0
  #|addx6767 add  1     0.0   ->  1.0
  #|addx6768 add  1    -0.0   ->  1.0
  #|addx6771 add  0.0  -1.0   -> -1.0
  #|addx6772 add -0.0  -1.0   -> -1.0
  #|addx6773 add  0.0   1.0   ->  1.0
  #|addx6774 add -0.0   1.0   ->  1.0
  #|addx6775 add -1.0   0.0   -> -1.0
  #|addx6776 add -1.0  -0.0   -> -1.0
  #|addx6777 add  1.0   0.0   ->  1.0
  #|addx6778 add  1.0  -0.0   ->  1.0
  #|addx6780 add -Inf  -Inf   -> -Infinity
  #|addx6781 add -Inf  -1000  -> -Infinity
  #|addx6782 add -Inf  -1     -> -Infinity
  #|addx6783 add -Inf  -0     -> -Infinity
  #|addx6784 add -Inf   0     -> -Infinity
  #|addx6785 add -Inf   1     -> -Infinity
  #|addx6786 add -Inf   1000  -> -Infinity
  #|addx6787 add -1000 -Inf   -> -Infinity
  #|addx6788 add -Inf  -Inf   -> -Infinity
  #|addx6789 add -1    -Inf   -> -Infinity
  #|addx6790 add -0    -Inf   -> -Infinity
  #|addx6791 add  0    -Inf   -> -Infinity
  #|addx6792 add  1    -Inf   -> -Infinity
  #|addx6793 add  1000 -Inf   -> -Infinity
  #|addx6794 add  Inf  -Inf   ->  NaN  Invalid_operation
  #|addx6800 add  Inf  -Inf   ->  NaN  Invalid_operation
  #|addx6801 add  Inf  -1000  ->  Infinity
  #|addx6802 add  Inf  -1     ->  Infinity
  #|addx6803 add  Inf  -0     ->  Infinity
  #|addx6804 add  Inf   0     ->  Infinity
  #|addx6805 add  Inf   1     ->  Infinity
  #|addx6806 add  Inf   1000  ->  Infinity
  #|addx6807 add  Inf   Inf   ->  Infinity
  #|addx6808 add -1000  Inf   ->  Infinity
  #|addx6809 add -Inf   Inf   ->  NaN  Invalid_operation
  #|addx6810 add -1     Inf   ->  Infinity
  #|addx6811 add -0     Inf   ->  Infinity
  #|addx6812 add  0     Inf   ->  Infinity
  #|addx6813 add  1     Inf   ->  Infinity
  #|addx6814 add  1000  Inf   ->  Infinity
  #|addx6815 add  Inf   Inf   ->  Infinity
  #|addx6821 add  NaN -Inf    ->  NaN
  #|addx6822 add  NaN -1000   ->  NaN
  #|addx6823 add  NaN -1      ->  NaN
  #|addx6824 add  NaN -0      ->  NaN
  #|addx6825 add  NaN  0      ->  NaN
  #|addx6826 add  NaN  1      ->  NaN
  #|addx6827 add  NaN  1000   ->  NaN
  #|addx6828 add  NaN  Inf    ->  NaN
  #|addx6829 add  NaN  NaN    ->  NaN
  #|addx6830 add -Inf  NaN    ->  NaN
  #|addx6831 add -1000 NaN    ->  NaN
  #|addx6832 add -1    NaN    ->  NaN
  #|addx6833 add -0    NaN    ->  NaN
  #|addx6834 add  0    NaN    ->  NaN
  #|addx6835 add  1    NaN    ->  NaN
  #|addx6836 add  1000 NaN    ->  NaN
  #|addx6837 add  Inf  NaN    ->  NaN
  #|addx6841 add  sNaN -Inf   ->  NaN  Invalid_operation
  #|addx6842 add  sNaN -1000  ->  NaN  Invalid_operation
  #|addx6843 add  sNaN -1     ->  NaN  Invalid_operation
  #|addx6844 add  sNaN -0     ->  NaN  Invalid_operation
  #|addx6845 add  sNaN  0     ->  NaN  Invalid_operation
  #|addx6846 add  sNaN  1     ->  NaN  Invalid_operation
  #|addx6847 add  sNaN  1000  ->  NaN  Invalid_operation
  #|addx6848 add  sNaN  NaN   ->  NaN  Invalid_operation
  #|addx6849 add  sNaN sNaN   ->  NaN  Invalid_operation
  #|addx6850 add  NaN  sNaN   ->  NaN  Invalid_operation
  #|addx6851 add -Inf  sNaN   ->  NaN  Invalid_operation
  #|addx6852 add -1000 sNaN   ->  NaN  Invalid_operation
  #|addx6853 add -1    sNaN   ->  NaN  Invalid_operation
  #|addx6854 add -0    sNaN   ->  NaN  Invalid_operation
  #|addx6855 add  0    sNaN   ->  NaN  Invalid_operation
  #|addx6856 add  1    sNaN   ->  NaN  Invalid_operation
  #|addx6857 add  1000 sNaN   ->  NaN  Invalid_operation
  #|addx6858 add  Inf  sNaN   ->  NaN  Invalid_operation
  #|addx6859 add  NaN  sNaN   ->  NaN  Invalid_operation
  #|addx6861 add  NaN1   -Inf    ->  NaN1
  #|addx6862 add +NaN2   -1000   ->  NaN2
  #|addx6863 add  NaN3    1000   ->  NaN3
  #|addx6864 add  NaN4    Inf    ->  NaN4
  #|addx6865 add  NaN5   +NaN6   ->  NaN5
  #|addx6866 add -Inf     NaN7   ->  NaN7
  #|addx6867 add -1000    NaN8   ->  NaN8
  #|addx6868 add  1000    NaN9   ->  NaN9
  #|addx6869 add  Inf    +NaN10  ->  NaN10
  #|addx6871 add  sNaN11  -Inf   ->  NaN11  Invalid_operation
  #|addx6872 add  sNaN12  -1000  ->  NaN12  Invalid_operation
  #|addx6873 add  sNaN13   1000  ->  NaN13  Invalid_operation
  #|addx6874 add  sNaN14   NaN17 ->  NaN14  Invalid_operation
  #|addx6875 add  sNaN15  sNaN18 ->  NaN15  Invalid_operation
  #|addx6876 add  NaN16   sNaN19 ->  NaN19  Invalid_operation
  #|addx6877 add -Inf    +sNaN20 ->  NaN20  Invalid_operation
  #|addx6878 add -1000    sNaN21 ->  NaN21  Invalid_operation
  #|addx6879 add  1000    sNaN22 ->  NaN22  Invalid_operation
  #|addx6880 add  Inf     sNaN23 ->  NaN23  Invalid_operation
  #|addx6881 add +NaN25  +sNaN24 ->  NaN24  Invalid_operation
  #|addx6882 add -NaN26    NaN28 -> -NaN26
  #|addx6883 add -sNaN27  sNaN29 -> -NaN27  Invalid_operation
  #|addx6884 add  1000    -NaN30 -> -NaN30
  #|addx6885 add  1000   -sNaN31 -> -NaN31  Invalid_operation
  #|addx6571 add       1E-383       0  -> 1E-383
  #|addx6573 add       1E-383  1E-384  -> 1.1E-383
  #|addx6973 add     9.999999999999999E+384  1      -> 9.999999999999999E+384 Inexact Rounded
  #|addx6974 add      9999999999999999E+369  1      -> 9.999999999999999E+384 Inexact Rounded
  #|addx6981 add      9999999999999999E+369  4E+368  -> 9.999999999999999E+384 Inexact Rounded
  #|addx6982 add      9999999999999999E+369  3E+368  -> 9.999999999999999E+384 Inexact Rounded
  #|addx6983 add      9999999999999999E+369  2E+368  -> 9.999999999999999E+384 Inexact Rounded
  #|addx6984 add      9999999999999999E+369  1E+368  -> 9.999999999999999E+384 Inexact Rounded
  #|addx6986 add    -9.999999999999999E+384 -1      -> -9.999999999999999E+384 Inexact Rounded
  #|addx6987 add     -9999999999999999E+369 -1      -> -9.999999999999999E+384 Inexact Rounded
  #|addx6994 add     -9999999999999999E+369 -4E+368  -> -9.999999999999999E+384 Inexact Rounded
  #|addx6995 add     -9999999999999999E+369 -3E+368  -> -9.999999999999999E+384 Inexact Rounded
  #|addx6996 add     -9999999999999999E+369 -2E+368  -> -9.999999999999999E+384 Inexact Rounded
  #|addx6997 add     -9999999999999999E+369 -1E+368  -> -9.999999999999999E+384 Inexact Rounded
  #|rounding:     down
  #|addx61100 add 1e+2 -1e-383    -> 99.99999999999999 Rounded Inexact
  #|addx61101 add 1e+1 -1e-383    -> 9.999999999999999  Rounded Inexact
  #|addx61103 add   +1 -1e-383    -> 0.9999999999999999  Rounded Inexact
  #|addx61104 add 1e-1 -1e-383    -> 0.09999999999999999  Rounded Inexact
  #|addx61105 add 1e-2 -1e-383    -> 0.009999999999999999  Rounded Inexact
  #|addx61106 add 1e-3 -1e-383    -> 0.0009999999999999999  Rounded Inexact
  #|addx61107 add 1e-4 -1e-383    -> 0.00009999999999999999  Rounded Inexact
  #|addx61108 add 1e-5 -1e-383    -> 0.000009999999999999999  Rounded Inexact
  #|addx61109 add 1e-6 -1e-383    -> 9.999999999999999E-7  Rounded Inexact
  #|rounding:     ceiling
  #|addx61110 add -1e+2 +1e-383   -> -99.99999999999999 Rounded Inexact
  #|addx61111 add -1e+1 +1e-383   -> -9.999999999999999  Rounded Inexact
  #|addx61113 add    -1 +1e-383   -> -0.9999999999999999  Rounded Inexact
  #|addx61114 add -1e-1 +1e-383   -> -0.09999999999999999  Rounded Inexact
  #|addx61115 add -1e-2 +1e-383   -> -0.009999999999999999  Rounded Inexact
  #|addx61116 add -1e-3 +1e-383   -> -0.0009999999999999999  Rounded Inexact
  #|addx61117 add -1e-4 +1e-383   -> -0.00009999999999999999  Rounded Inexact
  #|addx61118 add -1e-5 +1e-383   -> -0.000009999999999999999  Rounded Inexact
  #|addx61119 add -1e-6 +1e-383   -> -9.999999999999999E-7  Rounded Inexact
  #|rounding:     half_even
  #|addx61300 add 1E16  -0.5                 ->  1.000000000000000E+16 Inexact Rounded
  #|addx61310 add 1E16  -0.51                ->  9999999999999999      Inexact Rounded
  #|addx61311 add 1E16  -0.501               ->  9999999999999999      Inexact Rounded
  #|addx61312 add 1E16  -0.5001              ->  9999999999999999      Inexact Rounded
  #|addx61313 add 1E16  -0.50001             ->  9999999999999999      Inexact Rounded
  #|addx61314 add 1E16  -0.500001            ->  9999999999999999      Inexact Rounded
  #|addx61315 add 1E16  -0.5000001           ->  9999999999999999      Inexact Rounded
  #|addx61316 add 1E16  -0.50000001          ->  9999999999999999      Inexact Rounded
  #|addx61317 add 1E16  -0.500000001         ->  9999999999999999      Inexact Rounded
  #|addx61318 add 1E16  -0.5000000001        ->  9999999999999999      Inexact Rounded
  #|addx61319 add 1E16  -0.50000000001       ->  9999999999999999      Inexact Rounded
  #|addx61320 add 1E16  -0.500000000001      ->  9999999999999999      Inexact Rounded
  #|addx61321 add 1E16  -0.5000000000001     ->  9999999999999999      Inexact Rounded
  #|addx61322 add 1E16  -0.50000000000001    ->  9999999999999999      Inexact Rounded
  #|addx61323 add 1E16  -0.500000000000001   ->  9999999999999999      Inexact Rounded
  #|addx61324 add 1E16  -0.5000000000000001  ->  9999999999999999      Inexact Rounded
  #|addx61325 add 1E16  -0.5000000000000000  ->  1.000000000000000E+16 Inexact Rounded
  #|addx61326 add 1E16  -0.500000000000000   ->  1.000000000000000E+16 Inexact Rounded
  #|addx61327 add 1E16  -0.50000000000000    ->  1.000000000000000E+16 Inexact Rounded
  #|addx61328 add 1E16  -0.5000000000000     ->  1.000000000000000E+16 Inexact Rounded
  #|addx61329 add 1E16  -0.500000000000      ->  1.000000000000000E+16 Inexact Rounded
  #|addx61330 add 1E16  -0.50000000000       ->  1.000000000000000E+16 Inexact Rounded
  #|addx61331 add 1E16  -0.5000000000        ->  1.000000000000000E+16 Inexact Rounded
  #|addx61332 add 1E16  -0.500000000         ->  1.000000000000000E+16 Inexact Rounded
  #|addx61333 add 1E16  -0.50000000          ->  1.000000000000000E+16 Inexact Rounded
  #|addx61334 add 1E16  -0.5000000           ->  1.000000000000000E+16 Inexact Rounded
  #|addx61335 add 1E16  -0.500000            ->  1.000000000000000E+16 Inexact Rounded
  #|addx61336 add 1E16  -0.50000             ->  1.000000000000000E+16 Inexact Rounded
  #|addx61337 add 1E16  -0.5000              ->  1.000000000000000E+16 Inexact Rounded
  #|addx61338 add 1E16  -0.500               ->  1.000000000000000E+16 Inexact Rounded
  #|addx61339 add 1E16  -0.50                ->  1.000000000000000E+16 Inexact Rounded
  #|addx61340 add 1E16  -5000000.000010001   ->  9999999995000000      Inexact Rounded
  #|addx61341 add 1E16  -5000000.000000001   ->  9999999995000000      Inexact Rounded
  #|addx61349 add 9999999999999999 0.4                 ->  9999999999999999      Inexact Rounded
  #|addx61350 add 9999999999999999 0.49                ->  9999999999999999      Inexact Rounded
  #|addx61351 add 9999999999999999 0.499               ->  9999999999999999      Inexact Rounded
  #|addx61352 add 9999999999999999 0.4999              ->  9999999999999999      Inexact Rounded
  #|addx61353 add 9999999999999999 0.49999             ->  9999999999999999      Inexact Rounded
  #|addx61354 add 9999999999999999 0.499999            ->  9999999999999999      Inexact Rounded
  #|addx61355 add 9999999999999999 0.4999999           ->  9999999999999999      Inexact Rounded
  #|addx61356 add 9999999999999999 0.49999999          ->  9999999999999999      Inexact Rounded
  #|addx61357 add 9999999999999999 0.499999999         ->  9999999999999999      Inexact Rounded
  #|addx61358 add 9999999999999999 0.4999999999        ->  9999999999999999      Inexact Rounded
  #|addx61359 add 9999999999999999 0.49999999999       ->  9999999999999999      Inexact Rounded
  #|addx61360 add 9999999999999999 0.499999999999      ->  9999999999999999      Inexact Rounded
  #|addx61361 add 9999999999999999 0.4999999999999     ->  9999999999999999      Inexact Rounded
  #|addx61362 add 9999999999999999 0.49999999999999    ->  9999999999999999      Inexact Rounded
  #|addx61363 add 9999999999999999 0.499999999999999   ->  9999999999999999      Inexact Rounded
  #|addx61364 add 9999999999999999 0.4999999999999999  ->  9999999999999999      Inexact Rounded
  #|addx61365 add 9999999999999999 0.5000000000000000  ->  1.000000000000000E+16 Inexact Rounded
  #|addx61367 add 9999999999999999 0.500000000000000   ->  1.000000000000000E+16 Inexact Rounded
  #|addx61368 add 9999999999999999 0.50000000000000    ->  1.000000000000000E+16 Inexact Rounded
  #|addx61369 add 9999999999999999 0.5000000000000     ->  1.000000000000000E+16 Inexact Rounded
  #|addx61370 add 9999999999999999 0.500000000000      ->  1.000000000000000E+16 Inexact Rounded
  #|addx61371 add 9999999999999999 0.50000000000       ->  1.000000000000000E+16 Inexact Rounded
  #|addx61372 add 9999999999999999 0.5000000000        ->  1.000000000000000E+16 Inexact Rounded
  #|addx61373 add 9999999999999999 0.500000000         ->  1.000000000000000E+16 Inexact Rounded
  #|addx61374 add 9999999999999999 0.50000000          ->  1.000000000000000E+16 Inexact Rounded
  #|addx61375 add 9999999999999999 0.5000000           ->  1.000000000000000E+16 Inexact Rounded
  #|addx61376 add 9999999999999999 0.500000            ->  1.000000000000000E+16 Inexact Rounded
  #|addx61377 add 9999999999999999 0.50000             ->  1.000000000000000E+16 Inexact Rounded
  #|addx61378 add 9999999999999999 0.5000              ->  1.000000000000000E+16 Inexact Rounded
  #|addx61379 add 9999999999999999 0.500               ->  1.000000000000000E+16 Inexact Rounded
  #|addx61380 add 9999999999999999 0.50                ->  1.000000000000000E+16 Inexact Rounded
  #|addx61381 add 9999999999999999 0.5                 ->  1.000000000000000E+16 Inexact Rounded
  #|addx61382 add 9999999999999999 0.5000000000000001  ->  1.000000000000000E+16 Inexact Rounded
  #|addx61383 add 9999999999999999 0.500000000000001   ->  1.000000000000000E+16 Inexact Rounded
  #|addx61384 add 9999999999999999 0.50000000000001    ->  1.000000000000000E+16 Inexact Rounded
  #|addx61385 add 9999999999999999 0.5000000000001     ->  1.000000000000000E+16 Inexact Rounded
  #|addx61386 add 9999999999999999 0.500000000001      ->  1.000000000000000E+16 Inexact Rounded
  #|addx61387 add 9999999999999999 0.50000000001       ->  1.000000000000000E+16 Inexact Rounded
  #|addx61388 add 9999999999999999 0.5000000001        ->  1.000000000000000E+16 Inexact Rounded
  #|addx61389 add 9999999999999999 0.500000001         ->  1.000000000000000E+16 Inexact Rounded
  #|addx61390 add 9999999999999999 0.50000001          ->  1.000000000000000E+16 Inexact Rounded
  #|addx61391 add 9999999999999999 0.5000001           ->  1.000000000000000E+16 Inexact Rounded
  #|addx61392 add 9999999999999999 0.500001            ->  1.000000000000000E+16 Inexact Rounded
  #|addx61393 add 9999999999999999 0.50001             ->  1.000000000000000E+16 Inexact Rounded
  #|addx61394 add 9999999999999999 0.5001              ->  1.000000000000000E+16 Inexact Rounded
  #|addx61395 add 9999999999999999 0.501               ->  1.000000000000000E+16 Inexact Rounded
  #|addx61396 add 9999999999999999 0.51                ->  1.000000000000000E+16 Inexact Rounded
  #|addx61420 add  0 1.123456789012345     -> 1.123456789012345
  #|addx61421 add  0 1.123456789012345E-1  -> 0.1123456789012345
  #|addx61422 add  0 1.123456789012345E-2  -> 0.01123456789012345
  #|addx61423 add  0 1.123456789012345E-3  -> 0.001123456789012345
  #|addx61424 add  0 1.123456789012345E-4  -> 0.0001123456789012345
  #|addx61425 add  0 1.123456789012345E-5  -> 0.00001123456789012345
  #|addx61426 add  0 1.123456789012345E-6  -> 0.000001123456789012345
  #|addx61427 add  0 1.123456789012345E-7  -> 1.123456789012345E-7
  #|addx61428 add  0 1.123456789012345E-8  -> 1.123456789012345E-8
  #|addx61429 add  0 1.123456789012345E-9  -> 1.123456789012345E-9
  #|addx61430 add  0 1.123456789012345E-10 -> 1.123456789012345E-10
  #|addx61431 add  0 1.123456789012345E-11 -> 1.123456789012345E-11
  #|addx61432 add  0 1.123456789012345E-12 -> 1.123456789012345E-12
  #|addx61433 add  0 1.123456789012345E-13 -> 1.123456789012345E-13
  #|addx61434 add  0 1.123456789012345E-14 -> 1.123456789012345E-14
  #|addx61435 add  0 1.123456789012345E-15 -> 1.123456789012345E-15
  #|addx61436 add  0 1.123456789012345E-16 -> 1.123456789012345E-16
  #|addx61437 add  0 1.123456789012345E-17 -> 1.123456789012345E-17
  #|addx61438 add  0 1.123456789012345E-18 -> 1.123456789012345E-18
  #|addx61439 add  0 1.123456789012345E-19 -> 1.123456789012345E-19
  #|addx61440 add 1.123456789012345     0 -> 1.123456789012345
  #|addx61441 add 1.123456789012345E-1  0 -> 0.1123456789012345
  #|addx61442 add 1.123456789012345E-2  0 -> 0.01123456789012345
  #|addx61443 add 1.123456789012345E-3  0 -> 0.001123456789012345
  #|addx61444 add 1.123456789012345E-4  0 -> 0.0001123456789012345
  #|addx61445 add 1.123456789012345E-5  0 -> 0.00001123456789012345
  #|addx61446 add 1.123456789012345E-6  0 -> 0.000001123456789012345
  #|addx61447 add 1.123456789012345E-7  0 -> 1.123456789012345E-7
  #|addx61448 add 1.123456789012345E-8  0 -> 1.123456789012345E-8
  #|addx61449 add 1.123456789012345E-9  0 -> 1.123456789012345E-9
  #|addx61450 add 1.123456789012345E-10 0 -> 1.123456789012345E-10
  #|addx61451 add 1.123456789012345E-11 0 -> 1.123456789012345E-11
  #|addx61452 add 1.123456789012345E-12 0 -> 1.123456789012345E-12
  #|addx61453 add 1.123456789012345E-13 0 -> 1.123456789012345E-13
  #|addx61454 add 1.123456789012345E-14 0 -> 1.123456789012345E-14
  #|addx61455 add 1.123456789012345E-15 0 -> 1.123456789012345E-15
  #|addx61456 add 1.123456789012345E-16 0 -> 1.123456789012345E-16
  #|addx61457 add 1.123456789012345E-17 0 -> 1.123456789012345E-17
  #|addx61458 add 1.123456789012345E-18 0 -> 1.123456789012345E-18
  #|addx61459 add 1.123456789012345E-19 0 -> 1.123456789012345E-19
  #|addx61460 add 1.123456789012345  0E-0   -> 1.123456789012345
  #|addx61461 add 1.123456789012345  0E-1   -> 1.123456789012345
  #|addx61462 add 1.123456789012345  0E-2   -> 1.123456789012345
  #|addx61463 add 1.123456789012345  0E-3   -> 1.123456789012345
  #|addx61464 add 1.123456789012345  0E-4   -> 1.123456789012345
  #|addx61465 add 1.123456789012345  0E-5   -> 1.123456789012345
  #|addx61466 add 1.123456789012345  0E-6   -> 1.123456789012345
  #|addx61467 add 1.123456789012345  0E-7   -> 1.123456789012345
  #|addx61468 add 1.123456789012345  0E-8   -> 1.123456789012345
  #|addx61469 add 1.123456789012345  0E-9   -> 1.123456789012345
  #|addx61470 add 1.123456789012345  0E-10  -> 1.123456789012345
  #|addx61471 add 1.123456789012345  0E-11  -> 1.123456789012345
  #|addx61472 add 1.123456789012345  0E-12  -> 1.123456789012345
  #|addx61473 add 1.123456789012345  0E-13  -> 1.123456789012345
  #|addx61474 add 1.123456789012345  0E-14  -> 1.123456789012345
  #|addx61475 add 1.123456789012345  0E-15  -> 1.123456789012345
  #|addx61476 add 1.123456789012345  0E-16  -> 1.123456789012345 Rounded
  #|addx61477 add 1.123456789012345  0E-17  -> 1.123456789012345 Rounded
  #|addx61478 add 1.123456789012345  0E-18  -> 1.123456789012345 Rounded
  #|addx61479 add 1.123456789012345  0E-19  -> 1.123456789012345 Rounded
  #|rounding:    half_up
  #|addx61500 add  0        0E-19  ->  0E-19
  #|addx61501 add -0        0E-19  ->  0E-19
  #|addx61502 add  0       -0E-19  ->  0E-19
  #|addx61503 add -0       -0E-19  -> -0E-19
  #|rounding:    half_down
  #|addx61520 add  0        0E-19  ->  0E-19
  #|addx61521 add -0        0E-19  ->  0E-19
  #|addx61522 add  0       -0E-19  ->  0E-19
  #|addx61523 add -0       -0E-19  -> -0E-19
  #|rounding:    half_even
  #|addx61540 add  0        0E-19  ->  0E-19
  #|addx61541 add -0        0E-19  ->  0E-19
  #|addx61542 add  0       -0E-19  ->  0E-19
  #|addx61543 add -0       -0E-19  -> -0E-19
  #|rounding:    up
  #|addx61560 add  0        0E-19  ->  0E-19
  #|addx61561 add -0        0E-19  ->  0E-19
  #|addx61562 add  0       -0E-19  ->  0E-19
  #|addx61563 add -0       -0E-19  -> -0E-19
  #|rounding:    down
  #|addx61580 add  0        0E-19  ->  0E-19
  #|addx61581 add -0        0E-19  ->  0E-19
  #|addx61582 add  0       -0E-19  ->  0E-19
  #|addx61583 add -0       -0E-19  -> -0E-19
  #|rounding:    ceiling
  #|addx61600 add  0        0E-19  ->  0E-19
  #|addx61601 add -0        0E-19  ->  0E-19
  #|addx61602 add  0       -0E-19  ->  0E-19
  #|addx61603 add -0       -0E-19  -> -0E-19
  #|rounding:    floor
  #|addx61620 add  0        0E-19  ->  0E-19
  #|addx61621 add -0        0E-19  -> -0E-19           -- *
  #|addx61622 add  0       -0E-19  -> -0E-19           -- *
  #|addx61623 add -0       -0E-19  -> -0E-19
  #|addx61701 add 130E-2    120E-2    -> 2.50
  #|addx61702 add 130E-2    12E-1     -> 2.50
  #|addx61703 add 130E-2    1E0       -> 2.30
  #|addx61704 add 1E2       1E4       -> 1.01E+4
  #|rounding: half_even
  #|addx62001 add 1234567890123456 1      -> 1234567890123457
  #|addx62002 add 1234567890123456 0.6    -> 1234567890123457  Inexact Rounded
  #|addx62003 add 1234567890123456 0.06   -> 1234567890123456  Inexact Rounded
  #|addx62004 add 1234567890123456 6E-3   -> 1234567890123456  Inexact Rounded
  #|addx62005 add 1234567890123456 6E-4   -> 1234567890123456  Inexact Rounded
  #|addx62006 add 1234567890123456 6E-5   -> 1234567890123456  Inexact Rounded
  #|addx62007 add 1234567890123456 6E-6   -> 1234567890123456  Inexact Rounded
  #|addx62008 add 1234567890123456 6E-7   -> 1234567890123456  Inexact Rounded
  #|addx62009 add 1234567890123456 6E-8   -> 1234567890123456  Inexact Rounded
  #|addx62010 add 1234567890123456 6E-9   -> 1234567890123456  Inexact Rounded
  #|addx62011 add 1234567890123456 6E-10  -> 1234567890123456  Inexact Rounded
  #|addx62012 add 1234567890123456 6E-11  -> 1234567890123456  Inexact Rounded
  #|addx62013 add 1234567890123456 6E-12  -> 1234567890123456  Inexact Rounded
  #|addx62014 add 1234567890123456 6E-13  -> 1234567890123456  Inexact Rounded
  #|addx62015 add 1234567890123456 6E-14  -> 1234567890123456  Inexact Rounded
  #|addx62016 add 1234567890123456 6E-15  -> 1234567890123456  Inexact Rounded
  #|addx62017 add 1234567890123456 6E-16  -> 1234567890123456  Inexact Rounded
  #|addx62018 add 1234567890123456 6E-17  -> 1234567890123456  Inexact Rounded
  #|addx62019 add 1234567890123456 6E-18  -> 1234567890123456  Inexact Rounded
  #|addx62020 add 1234567890123456 6E-19  -> 1234567890123456  Inexact Rounded
  #|addx62021 add 1234567890123456 6E-20  -> 1234567890123456  Inexact Rounded
  #|addx62030 add 12345678 1                       -> 12345679
  #|addx62031 add 12345678 0.1                     -> 12345678.1
  #|addx62032 add 12345678 0.12                    -> 12345678.12
  #|addx62033 add 12345678 0.123                   -> 12345678.123
  #|addx62034 add 12345678 0.1234                  -> 12345678.1234
  #|addx62035 add 12345678 0.12345                 -> 12345678.12345
  #|addx62036 add 12345678 0.123456                -> 12345678.123456
  #|addx62037 add 12345678 0.1234567               -> 12345678.1234567
  #|addx62038 add 12345678 0.12345678              -> 12345678.12345678
  #|addx62039 add 12345678 0.123456789             -> 12345678.12345679 Inexact Rounded
  #|addx62040 add 12345678 0.123456785             -> 12345678.12345678 Inexact Rounded
  #|addx62041 add 12345678 0.1234567850            -> 12345678.12345678 Inexact Rounded
  #|addx62042 add 12345678 0.1234567851            -> 12345678.12345679 Inexact Rounded
  #|addx62043 add 12345678 0.12345678501           -> 12345678.12345679 Inexact Rounded
  #|addx62044 add 12345678 0.123456785001          -> 12345678.12345679 Inexact Rounded
  #|addx62045 add 12345678 0.1234567850001         -> 12345678.12345679 Inexact Rounded
  #|addx62046 add 12345678 0.12345678500001        -> 12345678.12345679 Inexact Rounded
  #|addx62047 add 12345678 0.123456785000001       -> 12345678.12345679 Inexact Rounded
  #|addx62048 add 12345678 0.1234567850000001      -> 12345678.12345679 Inexact Rounded
  #|addx62049 add 12345678 0.1234567850000000      -> 12345678.12345678 Inexact Rounded
  #|rounding: half_even
  #|addx62050 add 12345678 0.0234567750000000      -> 12345678.02345678 Inexact Rounded
  #|addx62051 add 12345678 0.0034567750000000      -> 12345678.00345678 Inexact Rounded
  #|addx62052 add 12345678 0.0004567750000000      -> 12345678.00045678 Inexact Rounded
  #|addx62053 add 12345678 0.0000567750000000      -> 12345678.00005678 Inexact Rounded
  #|addx62054 add 12345678 0.0000067750000000      -> 12345678.00000678 Inexact Rounded
  #|addx62055 add 12345678 0.0000007750000000      -> 12345678.00000078 Inexact Rounded
  #|addx62056 add 12345678 0.0000000750000000      -> 12345678.00000008 Inexact Rounded
  #|addx62057 add 12345678 0.0000000050000000      -> 12345678.00000000 Inexact Rounded
  #|addx62060 add 12345678 0.0234567750000001      -> 12345678.02345678 Inexact Rounded
  #|addx62061 add 12345678 0.0034567750000001      -> 12345678.00345678 Inexact Rounded
  #|addx62062 add 12345678 0.0004567750000001      -> 12345678.00045678 Inexact Rounded
  #|addx62063 add 12345678 0.0000567750000001      -> 12345678.00005678 Inexact Rounded
  #|addx62064 add 12345678 0.0000067750000001      -> 12345678.00000678 Inexact Rounded
  #|addx62065 add 12345678 0.0000007750000001      -> 12345678.00000078 Inexact Rounded
  #|addx62066 add 12345678 0.0000000750000001      -> 12345678.00000008 Inexact Rounded
  #|addx62067 add 12345678 0.0000000050000001      -> 12345678.00000001 Inexact Rounded
  #|rounding: up
  #|addx62070 add 12345678 1E-8                    -> 12345678.00000001
  #|addx62071 add 12345678 1E-9                    -> 12345678.00000001 Inexact Rounded
  #|addx62072 add 12345678 1E-10                   -> 12345678.00000001 Inexact Rounded
  #|addx62073 add 12345678 1E-11                   -> 12345678.00000001 Inexact Rounded
  #|addx62074 add 12345678 1E-12                   -> 12345678.00000001 Inexact Rounded
  #|addx62075 add 12345678 1E-13                   -> 12345678.00000001 Inexact Rounded
  #|addx62076 add 12345678 1E-14                   -> 12345678.00000001 Inexact Rounded
  #|addx62077 add 12345678 1E-15                   -> 12345678.00000001 Inexact Rounded
  #|addx62078 add 12345678 1E-16                   -> 12345678.00000001 Inexact Rounded
  #|addx62079 add 12345678 1E-17                   -> 12345678.00000001 Inexact Rounded
  #|addx62080 add 12345678 1E-18                   -> 12345678.00000001 Inexact Rounded
  #|addx62081 add 12345678 1E-19                   -> 12345678.00000001 Inexact Rounded
  #|addx62082 add 12345678 1E-20                   -> 12345678.00000001 Inexact Rounded
  #|addx62083 add 12345678 1E-25                   -> 12345678.00000001 Inexact Rounded
  #|addx62084 add 12345678 1E-30                   -> 12345678.00000001 Inexact Rounded
  #|addx62085 add 12345678 1E-31                   -> 12345678.00000001 Inexact Rounded
  #|addx62086 add 12345678 1E-32                   -> 12345678.00000001 Inexact Rounded
  #|addx62087 add 12345678 1E-33                   -> 12345678.00000001 Inexact Rounded
  #|addx62088 add 12345678 1E-34                   -> 12345678.00000001 Inexact Rounded
  #|addx62089 add 12345678 1E-35                   -> 12345678.00000001 Inexact Rounded
  #|precision: 5

///|
test "add.decTest subset round-trips through parse + add + toSci" {
  let cases = parse_dectest(add_subset)
  assert_eq(cases.length(), 1650)
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
    abort("add.decTest failures")
  }
}
