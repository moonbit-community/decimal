///| `add` cases from `add.decTest`, restricted to the half_up
/// rounding mode and precision >= 9 sections; further filtered to those
/// without conditions we don't yet model (Inexact, Rounded, Overflow,
/// Underflow, Clamped, Conversion_syntax) or a GDA `#` null operand.
let add_subset : String =
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
  #|addx080 add 999999998 1  -> 999999999
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
  #|addx141 add 1E+4    0.0000   ->  '10000.0000'
  #|addx143 add 0.000   1E+5     ->  '100000.000'
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
  #|addx161 add '1E+12' '-1'    -> '999999999999'
  #|addx162 add '1E+12'  '1.11' -> '1000000000001.11'
  #|addx163 add '1.11'  '1E+12' -> '1000000000001.11'
  #|addx164 add '-1'    '1E+12' -> '999999999999'
  #|addx165 add '7E+12' '-1'    -> '6999999999999'
  #|addx166 add '7E+12'  '1.11' -> '7000000000001.11'
  #|addx167 add '1.11'  '7E+12' -> '7000000000001.11'
  #|addx168 add '-1'    '7E+12' -> '6999999999999'
  #|addx178 add '0.444444444444444'  '0.555555555555555' -> '0.999999999999999'
  #|addx179 add '0.444444444444444'  '0.555555555555554' -> '0.999999999999998'
  #|addx180 add '0.444444444444444'  '0.555555555555553' -> '0.999999999999997'
  #|addx181 add '0.444444444444444'  '0.555555555555552' -> '0.999999999999996'
  #|addx182 add '0.444444444444444'  '0.555555555555551' -> '0.999999999999995'
  #|addx183 add '0.444444444444444'  '0.555555555555550' -> '0.999999999999994'
  #|addx200 add '123456789' 0             -> '123456789'
  #|addx216 add '123456789' 1             -> '123456790'
  #|addx340 add 1E+3    0    ->         1000
  #|addx341 add 1E+8    0    ->    100000000
  #|addx344 add 1E+3    1    ->         1001
  #|addx345 add 1E+8    1    ->    100000001
  #|addx348 add 1E+3    7    ->         1007
  #|addx349 add 1E+8    7    ->    100000007
  #|addx372 add 99999999 81512 -> 100081511
  #|addx660 add 98471198160.56524417578665886060 -23994.14313393939743548945165462 -> 98471174166.42211023638922337114834538
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
  #|addx902 add -1E+999999999   +9E+999999999   ->  8E+999999999
  #|addx903 add -9E+999999999   +1E+999999999   -> -8E+999999999
  #|addx571 add       1E-383       0  -> 1E-383
  #|addx573 add       1E-383  1E-384  -> 1.1E-383
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
  #|addx1500 add  0        0E-19  ->  0E-19
  #|addx1501 add -0        0E-19  ->  0E-19
  #|addx1502 add  0       -0E-19  ->  0E-19
  #|addx1503 add -0       -0E-19  -> -0E-19
  #|addx1701  add 130E-2    120E-2    -> 2.50
  #|addx1702  add 130E-2    12E-1     -> 2.50
  #|addx1703  add 130E-2    1E0       -> 2.30
  #|addx1704  add 1E2       1E4       -> 1.01E+4
  #|addx6200 add '6543210123456789' 0             -> '6543210123456789'
  #|addx6216 add '6543210123456789' 1             -> '6543210123456790'
  #|addx61500 add  0        0E-19  ->  0E-19
  #|addx61501 add -0        0E-19  ->  0E-19
  #|addx61502 add  0       -0E-19  ->  0E-19
  #|addx61503 add -0       -0E-19  -> -0E-19

///|
test "add.decTest subset round-trips through parse + add + toSci" {
  let cases = parse_dectest(add_subset)
  assert_eq(cases.length(), 373)
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
