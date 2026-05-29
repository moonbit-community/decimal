let add_subset : String =
  #|precision: 9
  #|rounding: half_up
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

test "add.decTest chunk 0" {
  let cases = parse_dectest(add_subset)
  assert_eq(cases.length(), 415)
  let (failures, _) = run_cases_with_flags(cases)
  if failures.length() > 0 {
    println("\{failures.length()} failed:")
    let limit = if failures.length() < 20 { failures.length() } else { 20 }
    for i in 0..<limit { println("  \{failures[i]}") }
    abort("add chunk 0")
  }
}
