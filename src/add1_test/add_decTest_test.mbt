let add_subset : String =
  #|precision: 21
  #|rounding: half_up
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

test "add.decTest chunk 1" {
  let cases = parse_dectest(add_subset)
  assert_eq(cases.length(), 415)
  let (failures, _) = run_cases_with_flags(cases)
  if failures.length() > 0 {
    println("\{failures.length()} failed:")
    let limit = if failures.length() < 20 { failures.length() } else { 20 }
    for i in 0..<limit { println("  \{failures[i]}") }
    abort("add chunk 1")
  }
}
