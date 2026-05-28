let add_subset : String =
  #|precision: 16
  #|rounding: half_even
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

test "add.decTest chunk 3" {
  let cases = parse_dectest(add_subset)
  assert_eq(cases.length(), 405)
  let (failures, _) = run_cases(cases)
  if failures.length() > 0 {
    println("\{failures.length()} failed:")
    let limit = if failures.length() < 20 { failures.length() } else { 20 }
    for i in 0..<limit { println("  \{failures[i]}") }
    abort("add chunk 3")
  }
}
