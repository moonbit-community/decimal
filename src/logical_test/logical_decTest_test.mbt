///|
/// Full `and.decTest` corpus (IBM General Decimal
/// Arithmetic testcases), embedded verbatim.
let and_subset : String =
  #|------------------------------------------------------------------------
  #|-- and.decTest -- digitwise logical AND                               --
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
  #|-- Sanity check (truth table)
  #|andx001 and             0    0 ->    0
  #|andx002 and             0    1 ->    0
  #|andx003 and             1    0 ->    0
  #|andx004 and             1    1 ->    1
  #|andx005 and          1100 1010 -> 1000
  #|andx006 and          1111   10 ->   10
  #|andx007 and          1111 1010 -> 1010
  #|
  #|-- and at msd and msd-1
  #|andx010 and 000000000 000000000 ->           0
  #|andx011 and 000000000 100000000 ->           0
  #|andx012 and 100000000 000000000 ->           0
  #|andx013 and 100000000 100000000 ->   100000000
  #|andx014 and 000000000 000000000 ->           0
  #|andx015 and 000000000 010000000 ->           0
  #|andx016 and 010000000 000000000 ->           0
  #|andx017 and 010000000 010000000 ->    10000000
  #|
  #|-- Various lengths
  #|--          123456789     123456789      123456789
  #|andx021 and 111111111     111111111  ->  111111111
  #|andx022 and 111111111111  111111111  ->  111111111
  #|andx023 and 111111111111   11111111  ->   11111111
  #|andx024 and 111111111      11111111  ->   11111111
  #|andx025 and 111111111       1111111  ->    1111111
  #|andx026 and 111111111111     111111  ->     111111
  #|andx027 and 111111111111      11111  ->      11111
  #|andx028 and 111111111111       1111  ->       1111
  #|andx029 and 111111111111        111  ->        111
  #|andx031 and 111111111111         11  ->         11
  #|andx032 and 111111111111          1  ->          1
  #|andx033 and 111111111111 1111111111  ->  111111111
  #|andx034 and 11111111111 11111111111  ->  111111111
  #|andx035 and 1111111111 111111111111  ->  111111111
  #|andx036 and 111111111 1111111111111  ->  111111111
  #|
  #|andx040 and 111111111  111111111111  ->  111111111
  #|andx041 and  11111111  111111111111  ->   11111111
  #|andx042 and  11111111     111111111  ->   11111111
  #|andx043 and   1111111     111111111  ->    1111111
  #|andx044 and    111111     111111111  ->     111111
  #|andx045 and     11111     111111111  ->      11111
  #|andx046 and      1111     111111111  ->       1111
  #|andx047 and       111     111111111  ->        111
  #|andx048 and        11     111111111  ->         11
  #|andx049 and         1     111111111  ->          1
  #|
  #|andx050 and 1111111111  1  ->  1
  #|andx051 and  111111111  1  ->  1
  #|andx052 and   11111111  1  ->  1
  #|andx053 and    1111111  1  ->  1
  #|andx054 and     111111  1  ->  1
  #|andx055 and      11111  1  ->  1
  #|andx056 and       1111  1  ->  1
  #|andx057 and        111  1  ->  1
  #|andx058 and         11  1  ->  1
  #|andx059 and          1  1  ->  1
  #|
  #|andx060 and 1111111111  0  ->  0
  #|andx061 and  111111111  0  ->  0
  #|andx062 and   11111111  0  ->  0
  #|andx063 and    1111111  0  ->  0
  #|andx064 and     111111  0  ->  0
  #|andx065 and      11111  0  ->  0
  #|andx066 and       1111  0  ->  0
  #|andx067 and        111  0  ->  0
  #|andx068 and         11  0  ->  0
  #|andx069 and          1  0  ->  0
  #|
  #|andx070 and 1  1111111111  ->  1
  #|andx071 and 1   111111111  ->  1
  #|andx072 and 1    11111111  ->  1
  #|andx073 and 1     1111111  ->  1
  #|andx074 and 1      111111  ->  1
  #|andx075 and 1       11111  ->  1
  #|andx076 and 1        1111  ->  1
  #|andx077 and 1         111  ->  1
  #|andx078 and 1          11  ->  1
  #|andx079 and 1           1  ->  1
  #|
  #|andx080 and 0  1111111111  ->  0
  #|andx081 and 0   111111111  ->  0
  #|andx082 and 0    11111111  ->  0
  #|andx083 and 0     1111111  ->  0
  #|andx084 and 0      111111  ->  0
  #|andx085 and 0       11111  ->  0
  #|andx086 and 0        1111  ->  0
  #|andx087 and 0         111  ->  0
  #|andx088 and 0          11  ->  0
  #|andx089 and 0           1  ->  0
  #|
  #|andx090 and 011111111  111111111  ->   11111111
  #|andx091 and 101111111  111111111  ->  101111111
  #|andx092 and 110111111  111111111  ->  110111111
  #|andx093 and 111011111  111111111  ->  111011111
  #|andx094 and 111101111  111111111  ->  111101111
  #|andx095 and 111110111  111111111  ->  111110111
  #|andx096 and 111111011  111111111  ->  111111011
  #|andx097 and 111111101  111111111  ->  111111101
  #|andx098 and 111111110  111111111  ->  111111110
  #|
  #|andx100 and 111111111  011111111  ->   11111111
  #|andx101 and 111111111  101111111  ->  101111111
  #|andx102 and 111111111  110111111  ->  110111111
  #|andx103 and 111111111  111011111  ->  111011111
  #|andx104 and 111111111  111101111  ->  111101111
  #|andx105 and 111111111  111110111  ->  111110111
  #|andx106 and 111111111  111111011  ->  111111011
  #|andx107 and 111111111  111111101  ->  111111101
  #|andx108 and 111111111  111111110  ->  111111110
  #|
  #|-- non-0/1 should not be accepted, nor should signs
  #|andx220 and 111111112  111111111  ->  NaN Invalid_operation
  #|andx221 and 333333333  333333333  ->  NaN Invalid_operation
  #|andx222 and 555555555  555555555  ->  NaN Invalid_operation
  #|andx223 and 777777777  777777777  ->  NaN Invalid_operation
  #|andx224 and 999999999  999999999  ->  NaN Invalid_operation
  #|andx225 and 222222222  999999999  ->  NaN Invalid_operation
  #|andx226 and 444444444  999999999  ->  NaN Invalid_operation
  #|andx227 and 666666666  999999999  ->  NaN Invalid_operation
  #|andx228 and 888888888  999999999  ->  NaN Invalid_operation
  #|andx229 and 999999999  222222222  ->  NaN Invalid_operation
  #|andx230 and 999999999  444444444  ->  NaN Invalid_operation
  #|andx231 and 999999999  666666666  ->  NaN Invalid_operation
  #|andx232 and 999999999  888888888  ->  NaN Invalid_operation
  #|-- a few randoms
  #|andx240 and  567468689 -934981942 ->  NaN Invalid_operation
  #|andx241 and  567367689  934981942 ->  NaN Invalid_operation
  #|andx242 and -631917772 -706014634 ->  NaN Invalid_operation
  #|andx243 and -756253257  138579234 ->  NaN Invalid_operation
  #|andx244 and  835590149  567435400 ->  NaN Invalid_operation
  #|-- test MSD
  #|andx250 and  200000000 100000000 ->  NaN Invalid_operation
  #|andx251 and  700000000 100000000 ->  NaN Invalid_operation
  #|andx252 and  800000000 100000000 ->  NaN Invalid_operation
  #|andx253 and  900000000 100000000 ->  NaN Invalid_operation
  #|andx254 and  200000000 000000000 ->  NaN Invalid_operation
  #|andx255 and  700000000 000000000 ->  NaN Invalid_operation
  #|andx256 and  800000000 000000000 ->  NaN Invalid_operation
  #|andx257 and  900000000 000000000 ->  NaN Invalid_operation
  #|andx258 and  100000000 200000000 ->  NaN Invalid_operation
  #|andx259 and  100000000 700000000 ->  NaN Invalid_operation
  #|andx260 and  100000000 800000000 ->  NaN Invalid_operation
  #|andx261 and  100000000 900000000 ->  NaN Invalid_operation
  #|andx262 and  000000000 200000000 ->  NaN Invalid_operation
  #|andx263 and  000000000 700000000 ->  NaN Invalid_operation
  #|andx264 and  000000000 800000000 ->  NaN Invalid_operation
  #|andx265 and  000000000 900000000 ->  NaN Invalid_operation
  #|-- test MSD-1
  #|andx270 and  020000000 100000000 ->  NaN Invalid_operation
  #|andx271 and  070100000 100000000 ->  NaN Invalid_operation
  #|andx272 and  080010000 100000001 ->  NaN Invalid_operation
  #|andx273 and  090001000 100000010 ->  NaN Invalid_operation
  #|andx274 and  100000100 020010100 ->  NaN Invalid_operation
  #|andx275 and  100000000 070001000 ->  NaN Invalid_operation
  #|andx276 and  100000010 080010100 ->  NaN Invalid_operation
  #|andx277 and  100000000 090000010 ->  NaN Invalid_operation
  #|-- test LSD
  #|andx280 and  001000002 100000000 ->  NaN Invalid_operation
  #|andx281 and  000000007 100000000 ->  NaN Invalid_operation
  #|andx282 and  000000008 100000000 ->  NaN Invalid_operation
  #|andx283 and  000000009 100000000 ->  NaN Invalid_operation
  #|andx284 and  100000000 000100002 ->  NaN Invalid_operation
  #|andx285 and  100100000 001000007 ->  NaN Invalid_operation
  #|andx286 and  100010000 010000008 ->  NaN Invalid_operation
  #|andx287 and  100001000 100000009 ->  NaN Invalid_operation
  #|-- test Middie
  #|andx288 and  001020000 100000000 ->  NaN Invalid_operation
  #|andx289 and  000070001 100000000 ->  NaN Invalid_operation
  #|andx290 and  000080000 100010000 ->  NaN Invalid_operation
  #|andx291 and  000090000 100001000 ->  NaN Invalid_operation
  #|andx292 and  100000010 000020100 ->  NaN Invalid_operation
  #|andx293 and  100100000 000070010 ->  NaN Invalid_operation
  #|andx294 and  100010100 000080001 ->  NaN Invalid_operation
  #|andx295 and  100001000 000090000 ->  NaN Invalid_operation
  #|-- signs
  #|andx296 and -100001000 -000000000 ->  NaN Invalid_operation
  #|andx297 and -100001000  000010000 ->  NaN Invalid_operation
  #|andx298 and  100001000 -000000000 ->  NaN Invalid_operation
  #|andx299 and  100001000  000011000 ->  1000
  #|
  #|-- Nmax, Nmin, Ntiny
  #|andx331 and  2   9.99999999E+999     -> NaN Invalid_operation
  #|andx332 and  3   1E-999              -> NaN Invalid_operation
  #|andx333 and  4   1.00000000E-999     -> NaN Invalid_operation
  #|andx334 and  5   1E-1007             -> NaN Invalid_operation
  #|andx335 and  6   -1E-1007            -> NaN Invalid_operation
  #|andx336 and  7   -1.00000000E-999    -> NaN Invalid_operation
  #|andx337 and  8   -1E-999             -> NaN Invalid_operation
  #|andx338 and  9   -9.99999999E+999    -> NaN Invalid_operation
  #|andx341 and  9.99999999E+999     -18 -> NaN Invalid_operation
  #|andx342 and  1E-999               01 -> NaN Invalid_operation
  #|andx343 and  1.00000000E-999     -18 -> NaN Invalid_operation
  #|andx344 and  1E-1007              18 -> NaN Invalid_operation
  #|andx345 and  -1E-1007            -10 -> NaN Invalid_operation
  #|andx346 and  -1.00000000E-999     18 -> NaN Invalid_operation
  #|andx347 and  -1E-999              10 -> NaN Invalid_operation
  #|andx348 and  -9.99999999E+999    -18 -> NaN Invalid_operation
  #|
  #|-- A few other non-integers
  #|andx361 and  1.0                  1  -> NaN Invalid_operation
  #|andx362 and  1E+1                 1  -> NaN Invalid_operation
  #|andx363 and  0.0                  1  -> NaN Invalid_operation
  #|andx364 and  0E+1                 1  -> NaN Invalid_operation
  #|andx365 and  9.9                  1  -> NaN Invalid_operation
  #|andx366 and  9E+1                 1  -> NaN Invalid_operation
  #|andx371 and  0 1.0                   -> NaN Invalid_operation
  #|andx372 and  0 1E+1                  -> NaN Invalid_operation
  #|andx373 and  0 0.0                   -> NaN Invalid_operation
  #|andx374 and  0 0E+1                  -> NaN Invalid_operation
  #|andx375 and  0 9.9                   -> NaN Invalid_operation
  #|andx376 and  0 9E+1                  -> NaN Invalid_operation
  #|
  #|-- All Specials are in error
  #|andx780 and -Inf  -Inf   -> NaN Invalid_operation
  #|andx781 and -Inf  -1000  -> NaN Invalid_operation
  #|andx782 and -Inf  -1     -> NaN Invalid_operation
  #|andx783 and -Inf  -0     -> NaN Invalid_operation
  #|andx784 and -Inf   0     -> NaN Invalid_operation
  #|andx785 and -Inf   1     -> NaN Invalid_operation
  #|andx786 and -Inf   1000  -> NaN Invalid_operation
  #|andx787 and -1000 -Inf   -> NaN Invalid_operation
  #|andx788 and -Inf  -Inf   -> NaN Invalid_operation
  #|andx789 and -1    -Inf   -> NaN Invalid_operation
  #|andx790 and -0    -Inf   -> NaN Invalid_operation
  #|andx791 and  0    -Inf   -> NaN Invalid_operation
  #|andx792 and  1    -Inf   -> NaN Invalid_operation
  #|andx793 and  1000 -Inf   -> NaN Invalid_operation
  #|andx794 and  Inf  -Inf   -> NaN Invalid_operation
  #|
  #|andx800 and  Inf  -Inf   -> NaN Invalid_operation
  #|andx801 and  Inf  -1000  -> NaN Invalid_operation
  #|andx802 and  Inf  -1     -> NaN Invalid_operation
  #|andx803 and  Inf  -0     -> NaN Invalid_operation
  #|andx804 and  Inf   0     -> NaN Invalid_operation
  #|andx805 and  Inf   1     -> NaN Invalid_operation
  #|andx806 and  Inf   1000  -> NaN Invalid_operation
  #|andx807 and  Inf   Inf   -> NaN Invalid_operation
  #|andx808 and -1000  Inf   -> NaN Invalid_operation
  #|andx809 and -Inf   Inf   -> NaN Invalid_operation
  #|andx810 and -1     Inf   -> NaN Invalid_operation
  #|andx811 and -0     Inf   -> NaN Invalid_operation
  #|andx812 and  0     Inf   -> NaN Invalid_operation
  #|andx813 and  1     Inf   -> NaN Invalid_operation
  #|andx814 and  1000  Inf   -> NaN Invalid_operation
  #|andx815 and  Inf   Inf   -> NaN Invalid_operation
  #|
  #|andx821 and  NaN -Inf    -> NaN Invalid_operation
  #|andx822 and  NaN -1000   -> NaN Invalid_operation
  #|andx823 and  NaN -1      -> NaN Invalid_operation
  #|andx824 and  NaN -0      -> NaN Invalid_operation
  #|andx825 and  NaN  0      -> NaN Invalid_operation
  #|andx826 and  NaN  1      -> NaN Invalid_operation
  #|andx827 and  NaN  1000   -> NaN Invalid_operation
  #|andx828 and  NaN  Inf    -> NaN Invalid_operation
  #|andx829 and  NaN  NaN    -> NaN Invalid_operation
  #|andx830 and -Inf  NaN    -> NaN Invalid_operation
  #|andx831 and -1000 NaN    -> NaN Invalid_operation
  #|andx832 and -1    NaN    -> NaN Invalid_operation
  #|andx833 and -0    NaN    -> NaN Invalid_operation
  #|andx834 and  0    NaN    -> NaN Invalid_operation
  #|andx835 and  1    NaN    -> NaN Invalid_operation
  #|andx836 and  1000 NaN    -> NaN Invalid_operation
  #|andx837 and  Inf  NaN    -> NaN Invalid_operation
  #|
  #|andx841 and  sNaN -Inf   ->  NaN  Invalid_operation
  #|andx842 and  sNaN -1000  ->  NaN  Invalid_operation
  #|andx843 and  sNaN -1     ->  NaN  Invalid_operation
  #|andx844 and  sNaN -0     ->  NaN  Invalid_operation
  #|andx845 and  sNaN  0     ->  NaN  Invalid_operation
  #|andx846 and  sNaN  1     ->  NaN  Invalid_operation
  #|andx847 and  sNaN  1000  ->  NaN  Invalid_operation
  #|andx848 and  sNaN  NaN   ->  NaN  Invalid_operation
  #|andx849 and  sNaN sNaN   ->  NaN  Invalid_operation
  #|andx850 and  NaN  sNaN   ->  NaN  Invalid_operation
  #|andx851 and -Inf  sNaN   ->  NaN  Invalid_operation
  #|andx852 and -1000 sNaN   ->  NaN  Invalid_operation
  #|andx853 and -1    sNaN   ->  NaN  Invalid_operation
  #|andx854 and -0    sNaN   ->  NaN  Invalid_operation
  #|andx855 and  0    sNaN   ->  NaN  Invalid_operation
  #|andx856 and  1    sNaN   ->  NaN  Invalid_operation
  #|andx857 and  1000 sNaN   ->  NaN  Invalid_operation
  #|andx858 and  Inf  sNaN   ->  NaN  Invalid_operation
  #|andx859 and  NaN  sNaN   ->  NaN  Invalid_operation
  #|
  #|-- propagating NaNs
  #|andx861 and  NaN1   -Inf    -> NaN Invalid_operation
  #|andx862 and +NaN2   -1000   -> NaN Invalid_operation
  #|andx863 and  NaN3    1000   -> NaN Invalid_operation
  #|andx864 and  NaN4    Inf    -> NaN Invalid_operation
  #|andx865 and  NaN5   +NaN6   -> NaN Invalid_operation
  #|andx866 and -Inf     NaN7   -> NaN Invalid_operation
  #|andx867 and -1000    NaN8   -> NaN Invalid_operation
  #|andx868 and  1000    NaN9   -> NaN Invalid_operation
  #|andx869 and  Inf    +NaN10  -> NaN Invalid_operation
  #|andx871 and  sNaN11  -Inf   -> NaN Invalid_operation
  #|andx872 and  sNaN12  -1000  -> NaN Invalid_operation
  #|andx873 and  sNaN13   1000  -> NaN Invalid_operation
  #|andx874 and  sNaN14   NaN17 -> NaN Invalid_operation
  #|andx875 and  sNaN15  sNaN18 -> NaN Invalid_operation
  #|andx876 and  NaN16   sNaN19 -> NaN Invalid_operation
  #|andx877 and -Inf    +sNaN20 -> NaN Invalid_operation
  #|andx878 and -1000    sNaN21 -> NaN Invalid_operation
  #|andx879 and  1000    sNaN22 -> NaN Invalid_operation
  #|andx880 and  Inf     sNaN23 -> NaN Invalid_operation
  #|andx881 and +NaN25  +sNaN24 -> NaN Invalid_operation
  #|andx882 and -NaN26    NaN28 -> NaN Invalid_operation
  #|andx883 and -sNaN27  sNaN29 -> NaN Invalid_operation
  #|andx884 and  1000    -NaN30 -> NaN Invalid_operation
  #|andx885 and  1000   -sNaN31 -> NaN Invalid_operation

///|
/// Full `or.decTest` corpus (IBM General Decimal
/// Arithmetic testcases), embedded verbatim.
let or_subset : String =
  #|------------------------------------------------------------------------
  #|-- or.decTest -- digitwise logical OR                                 --
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
  #|-- Sanity check (truth table)
  #|orx001 or             0    0 ->    0
  #|orx002 or             0    1 ->    1
  #|orx003 or             1    0 ->    1
  #|orx004 or             1    1 ->    1
  #|orx005 or          1100 1010 -> 1110
  #|-- and at msd and msd-1
  #|orx006 or 000000000 000000000 ->           0
  #|orx007 or 000000000 100000000 ->   100000000
  #|orx008 or 100000000 000000000 ->   100000000
  #|orx009 or 100000000 100000000 ->   100000000
  #|orx010 or 000000000 000000000 ->           0
  #|orx011 or 000000000 010000000 ->    10000000
  #|orx012 or 010000000 000000000 ->    10000000
  #|orx013 or 010000000 010000000 ->    10000000
  #|
  #|-- Various lengths
  #|--        123456789     123456789      123456789
  #|orx021 or 111111111     111111111  ->  111111111
  #|orx022 or 111111111111  111111111  ->  111111111
  #|orx023 or  11111111      11111111  ->   11111111
  #|orx025 or   1111111       1111111  ->    1111111
  #|orx026 or    111111        111111  ->     111111
  #|orx027 or     11111         11111  ->      11111
  #|orx028 or      1111          1111  ->       1111
  #|orx029 or       111           111  ->        111
  #|orx031 or        11            11  ->         11
  #|orx032 or         1             1  ->          1
  #|orx033 or 111111111111 1111111111  ->  111111111
  #|orx034 or 11111111111 11111111111  ->  111111111
  #|orx035 or 1111111111 111111111111  ->  111111111
  #|orx036 or 111111111 1111111111111  ->  111111111
  #|
  #|orx040 or 111111111  111111111111  ->  111111111
  #|orx041 or  11111111  111111111111  ->  111111111
  #|orx042 or  11111111     111111111  ->  111111111
  #|orx043 or   1111111     100000010  ->  101111111
  #|orx044 or    111111     100000100  ->  100111111
  #|orx045 or     11111     100001000  ->  100011111
  #|orx046 or      1111     100010000  ->  100011111
  #|orx047 or       111     100100000  ->  100100111
  #|orx048 or        11     101000000  ->  101000011
  #|orx049 or         1     110000000  ->  110000001
  #|
  #|orx050 or 1111111111  1  ->  111111111
  #|orx051 or  111111111  1  ->  111111111
  #|orx052 or   11111111  1  ->  11111111
  #|orx053 or    1111111  1  ->  1111111
  #|orx054 or     111111  1  ->  111111
  #|orx055 or      11111  1  ->  11111
  #|orx056 or       1111  1  ->  1111
  #|orx057 or        111  1  ->  111
  #|orx058 or         11  1  ->  11
  #|orx059 or          1  1  ->  1
  #|
  #|orx060 or 1111111111  0  ->  111111111
  #|orx061 or  111111111  0  ->  111111111
  #|orx062 or   11111111  0  ->  11111111
  #|orx063 or    1111111  0  ->  1111111
  #|orx064 or     111111  0  ->  111111
  #|orx065 or      11111  0  ->  11111
  #|orx066 or       1111  0  ->  1111
  #|orx067 or        111  0  ->  111
  #|orx068 or         11  0  ->  11
  #|orx069 or          1  0  ->  1
  #|
  #|orx070 or 1  1111111111  ->  111111111
  #|orx071 or 1   111111111  ->  111111111
  #|orx072 or 1    11111111  ->  11111111
  #|orx073 or 1     1111111  ->  1111111
  #|orx074 or 1      111111  ->  111111
  #|orx075 or 1       11111  ->  11111
  #|orx076 or 1        1111  ->  1111
  #|orx077 or 1         111  ->  111
  #|orx078 or 1          11  ->  11
  #|orx079 or 1           1  ->  1
  #|
  #|orx080 or 0  1111111111  ->  111111111
  #|orx081 or 0   111111111  ->  111111111
  #|orx082 or 0    11111111  ->  11111111
  #|orx083 or 0     1111111  ->  1111111
  #|orx084 or 0      111111  ->  111111
  #|orx085 or 0       11111  ->  11111
  #|orx086 or 0        1111  ->  1111
  #|orx087 or 0         111  ->  111
  #|orx088 or 0          11  ->  11
  #|orx089 or 0           1  ->  1
  #|
  #|orx090 or 011111111  111101111  ->  111111111
  #|orx091 or 101111111  111101111  ->  111111111
  #|orx092 or 110111111  111101111  ->  111111111
  #|orx093 or 111011111  111101111  ->  111111111
  #|orx094 or 111101111  111101111  ->  111101111
  #|orx095 or 111110111  111101111  ->  111111111
  #|orx096 or 111111011  111101111  ->  111111111
  #|orx097 or 111111101  111101111  ->  111111111
  #|orx098 or 111111110  111101111  ->  111111111
  #|
  #|orx100 or 111101111  011111111  ->  111111111
  #|orx101 or 111101111  101111111  ->  111111111
  #|orx102 or 111101111  110111111  ->  111111111
  #|orx103 or 111101111  111011111  ->  111111111
  #|orx104 or 111101111  111101111  ->  111101111
  #|orx105 or 111101111  111110111  ->  111111111
  #|orx106 or 111101111  111111011  ->  111111111
  #|orx107 or 111101111  111111101  ->  111111111
  #|orx108 or 111101111  111111110  ->  111111111
  #|
  #|-- non-0/1 should not be accepted, nor should signs
  #|orx220 or 111111112  111111111  ->  NaN Invalid_operation
  #|orx221 or 333333333  333333333  ->  NaN Invalid_operation
  #|orx222 or 555555555  555555555  ->  NaN Invalid_operation
  #|orx223 or 777777777  777777777  ->  NaN Invalid_operation
  #|orx224 or 999999999  999999999  ->  NaN Invalid_operation
  #|orx225 or 222222222  999999999  ->  NaN Invalid_operation
  #|orx226 or 444444444  999999999  ->  NaN Invalid_operation
  #|orx227 or 666666666  999999999  ->  NaN Invalid_operation
  #|orx228 or 888888888  999999999  ->  NaN Invalid_operation
  #|orx229 or 999999999  222222222  ->  NaN Invalid_operation
  #|orx230 or 999999999  444444444  ->  NaN Invalid_operation
  #|orx231 or 999999999  666666666  ->  NaN Invalid_operation
  #|orx232 or 999999999  888888888  ->  NaN Invalid_operation
  #|-- a few randoms
  #|orx240 or  567468689 -934981942 ->  NaN Invalid_operation
  #|orx241 or  567367689  934981942 ->  NaN Invalid_operation
  #|orx242 or -631917772 -706014634 ->  NaN Invalid_operation
  #|orx243 or -756253257  138579234 ->  NaN Invalid_operation
  #|orx244 or  835590149  567435400 ->  NaN Invalid_operation
  #|-- test MSD
  #|orx250 or  200000000 100000000 ->  NaN Invalid_operation
  #|orx251 or  700000000 100000000 ->  NaN Invalid_operation
  #|orx252 or  800000000 100000000 ->  NaN Invalid_operation
  #|orx253 or  900000000 100000000 ->  NaN Invalid_operation
  #|orx254 or  200000000 000000000 ->  NaN Invalid_operation
  #|orx255 or  700000000 000000000 ->  NaN Invalid_operation
  #|orx256 or  800000000 000000000 ->  NaN Invalid_operation
  #|orx257 or  900000000 000000000 ->  NaN Invalid_operation
  #|orx258 or  100000000 200000000 ->  NaN Invalid_operation
  #|orx259 or  100000000 700000000 ->  NaN Invalid_operation
  #|orx260 or  100000000 800000000 ->  NaN Invalid_operation
  #|orx261 or  100000000 900000000 ->  NaN Invalid_operation
  #|orx262 or  000000000 200000000 ->  NaN Invalid_operation
  #|orx263 or  000000000 700000000 ->  NaN Invalid_operation
  #|orx264 or  000000000 800000000 ->  NaN Invalid_operation
  #|orx265 or  000000000 900000000 ->  NaN Invalid_operation
  #|-- test MSD-1
  #|orx270 or  020000000 100000000 ->  NaN Invalid_operation
  #|orx271 or  070100000 100000000 ->  NaN Invalid_operation
  #|orx272 or  080010000 100000001 ->  NaN Invalid_operation
  #|orx273 or  090001000 100000010 ->  NaN Invalid_operation
  #|orx274 or  100000100 020010100 ->  NaN Invalid_operation
  #|orx275 or  100000000 070001000 ->  NaN Invalid_operation
  #|orx276 or  100000010 080010100 ->  NaN Invalid_operation
  #|orx277 or  100000000 090000010 ->  NaN Invalid_operation
  #|-- test LSD
  #|orx280 or  001000002 100000000 ->  NaN Invalid_operation
  #|orx281 or  000000007 100000000 ->  NaN Invalid_operation
  #|orx282 or  000000008 100000000 ->  NaN Invalid_operation
  #|orx283 or  000000009 100000000 ->  NaN Invalid_operation
  #|orx284 or  100000000 000100002 ->  NaN Invalid_operation
  #|orx285 or  100100000 001000007 ->  NaN Invalid_operation
  #|orx286 or  100010000 010000008 ->  NaN Invalid_operation
  #|orx287 or  100001000 100000009 ->  NaN Invalid_operation
  #|-- test Middie
  #|orx288 or  001020000 100000000 ->  NaN Invalid_operation
  #|orx289 or  000070001 100000000 ->  NaN Invalid_operation
  #|orx290 or  000080000 100010000 ->  NaN Invalid_operation
  #|orx291 or  000090000 100001000 ->  NaN Invalid_operation
  #|orx292 or  100000010 000020100 ->  NaN Invalid_operation
  #|orx293 or  100100000 000070010 ->  NaN Invalid_operation
  #|orx294 or  100010100 000080001 ->  NaN Invalid_operation
  #|orx295 or  100001000 000090000 ->  NaN Invalid_operation
  #|-- signs
  #|orx296 or -100001000 -000000000 ->  NaN Invalid_operation
  #|orx297 or -100001000  000010000 ->  NaN Invalid_operation
  #|orx298 or  100001000 -000000000 ->  NaN Invalid_operation
  #|orx299 or  100001000  000011000 ->  100011000
  #|
  #|-- Nmax, Nmin, Ntiny
  #|orx331 or  2   9.99999999E+999     -> NaN Invalid_operation
  #|orx332 or  3   1E-999              -> NaN Invalid_operation
  #|orx333 or  4   1.00000000E-999     -> NaN Invalid_operation
  #|orx334 or  5   1E-1007             -> NaN Invalid_operation
  #|orx335 or  6   -1E-1007            -> NaN Invalid_operation
  #|orx336 or  7   -1.00000000E-999    -> NaN Invalid_operation
  #|orx337 or  8   -1E-999             -> NaN Invalid_operation
  #|orx338 or  9   -9.99999999E+999    -> NaN Invalid_operation
  #|orx341 or  9.99999999E+999     -18 -> NaN Invalid_operation
  #|orx342 or  1E-999               01 -> NaN Invalid_operation
  #|orx343 or  1.00000000E-999     -18 -> NaN Invalid_operation
  #|orx344 or  1E-1007              18 -> NaN Invalid_operation
  #|orx345 or  -1E-1007            -10 -> NaN Invalid_operation
  #|orx346 or  -1.00000000E-999     18 -> NaN Invalid_operation
  #|orx347 or  -1E-999              10 -> NaN Invalid_operation
  #|orx348 or  -9.99999999E+999    -18 -> NaN Invalid_operation
  #|
  #|-- A few other non-integers
  #|orx361 or  1.0                  1  -> NaN Invalid_operation
  #|orx362 or  1E+1                 1  -> NaN Invalid_operation
  #|orx363 or  0.0                  1  -> NaN Invalid_operation
  #|orx364 or  0E+1                 1  -> NaN Invalid_operation
  #|orx365 or  9.9                  1  -> NaN Invalid_operation
  #|orx366 or  9E+1                 1  -> NaN Invalid_operation
  #|orx371 or  0 1.0                   -> NaN Invalid_operation
  #|orx372 or  0 1E+1                  -> NaN Invalid_operation
  #|orx373 or  0 0.0                   -> NaN Invalid_operation
  #|orx374 or  0 0E+1                  -> NaN Invalid_operation
  #|orx375 or  0 9.9                   -> NaN Invalid_operation
  #|orx376 or  0 9E+1                  -> NaN Invalid_operation
  #|
  #|-- All Specials are in error
  #|orx780 or -Inf  -Inf   -> NaN Invalid_operation
  #|orx781 or -Inf  -1000  -> NaN Invalid_operation
  #|orx782 or -Inf  -1     -> NaN Invalid_operation
  #|orx783 or -Inf  -0     -> NaN Invalid_operation
  #|orx784 or -Inf   0     -> NaN Invalid_operation
  #|orx785 or -Inf   1     -> NaN Invalid_operation
  #|orx786 or -Inf   1000  -> NaN Invalid_operation
  #|orx787 or -1000 -Inf   -> NaN Invalid_operation
  #|orx788 or -Inf  -Inf   -> NaN Invalid_operation
  #|orx789 or -1    -Inf   -> NaN Invalid_operation
  #|orx790 or -0    -Inf   -> NaN Invalid_operation
  #|orx791 or  0    -Inf   -> NaN Invalid_operation
  #|orx792 or  1    -Inf   -> NaN Invalid_operation
  #|orx793 or  1000 -Inf   -> NaN Invalid_operation
  #|orx794 or  Inf  -Inf   -> NaN Invalid_operation
  #|
  #|orx800 or  Inf  -Inf   -> NaN Invalid_operation
  #|orx801 or  Inf  -1000  -> NaN Invalid_operation
  #|orx802 or  Inf  -1     -> NaN Invalid_operation
  #|orx803 or  Inf  -0     -> NaN Invalid_operation
  #|orx804 or  Inf   0     -> NaN Invalid_operation
  #|orx805 or  Inf   1     -> NaN Invalid_operation
  #|orx806 or  Inf   1000  -> NaN Invalid_operation
  #|orx807 or  Inf   Inf   -> NaN Invalid_operation
  #|orx808 or -1000  Inf   -> NaN Invalid_operation
  #|orx809 or -Inf   Inf   -> NaN Invalid_operation
  #|orx810 or -1     Inf   -> NaN Invalid_operation
  #|orx811 or -0     Inf   -> NaN Invalid_operation
  #|orx812 or  0     Inf   -> NaN Invalid_operation
  #|orx813 or  1     Inf   -> NaN Invalid_operation
  #|orx814 or  1000  Inf   -> NaN Invalid_operation
  #|orx815 or  Inf   Inf   -> NaN Invalid_operation
  #|
  #|orx821 or  NaN -Inf    -> NaN Invalid_operation
  #|orx822 or  NaN -1000   -> NaN Invalid_operation
  #|orx823 or  NaN -1      -> NaN Invalid_operation
  #|orx824 or  NaN -0      -> NaN Invalid_operation
  #|orx825 or  NaN  0      -> NaN Invalid_operation
  #|orx826 or  NaN  1      -> NaN Invalid_operation
  #|orx827 or  NaN  1000   -> NaN Invalid_operation
  #|orx828 or  NaN  Inf    -> NaN Invalid_operation
  #|orx829 or  NaN  NaN    -> NaN Invalid_operation
  #|orx830 or -Inf  NaN    -> NaN Invalid_operation
  #|orx831 or -1000 NaN    -> NaN Invalid_operation
  #|orx832 or -1    NaN    -> NaN Invalid_operation
  #|orx833 or -0    NaN    -> NaN Invalid_operation
  #|orx834 or  0    NaN    -> NaN Invalid_operation
  #|orx835 or  1    NaN    -> NaN Invalid_operation
  #|orx836 or  1000 NaN    -> NaN Invalid_operation
  #|orx837 or  Inf  NaN    -> NaN Invalid_operation
  #|
  #|orx841 or  sNaN -Inf   ->  NaN  Invalid_operation
  #|orx842 or  sNaN -1000  ->  NaN  Invalid_operation
  #|orx843 or  sNaN -1     ->  NaN  Invalid_operation
  #|orx844 or  sNaN -0     ->  NaN  Invalid_operation
  #|orx845 or  sNaN  0     ->  NaN  Invalid_operation
  #|orx846 or  sNaN  1     ->  NaN  Invalid_operation
  #|orx847 or  sNaN  1000  ->  NaN  Invalid_operation
  #|orx848 or  sNaN  NaN   ->  NaN  Invalid_operation
  #|orx849 or  sNaN sNaN   ->  NaN  Invalid_operation
  #|orx850 or  NaN  sNaN   ->  NaN  Invalid_operation
  #|orx851 or -Inf  sNaN   ->  NaN  Invalid_operation
  #|orx852 or -1000 sNaN   ->  NaN  Invalid_operation
  #|orx853 or -1    sNaN   ->  NaN  Invalid_operation
  #|orx854 or -0    sNaN   ->  NaN  Invalid_operation
  #|orx855 or  0    sNaN   ->  NaN  Invalid_operation
  #|orx856 or  1    sNaN   ->  NaN  Invalid_operation
  #|orx857 or  1000 sNaN   ->  NaN  Invalid_operation
  #|orx858 or  Inf  sNaN   ->  NaN  Invalid_operation
  #|orx859 or  NaN  sNaN   ->  NaN  Invalid_operation
  #|
  #|-- propagating NaNs
  #|orx861 or  NaN1   -Inf    -> NaN Invalid_operation
  #|orx862 or +NaN2   -1000   -> NaN Invalid_operation
  #|orx863 or  NaN3    1000   -> NaN Invalid_operation
  #|orx864 or  NaN4    Inf    -> NaN Invalid_operation
  #|orx865 or  NaN5   +NaN6   -> NaN Invalid_operation
  #|orx866 or -Inf     NaN7   -> NaN Invalid_operation
  #|orx867 or -1000    NaN8   -> NaN Invalid_operation
  #|orx868 or  1000    NaN9   -> NaN Invalid_operation
  #|orx869 or  Inf    +NaN10  -> NaN Invalid_operation
  #|orx871 or  sNaN11  -Inf   -> NaN Invalid_operation
  #|orx872 or  sNaN12  -1000  -> NaN Invalid_operation
  #|orx873 or  sNaN13   1000  -> NaN Invalid_operation
  #|orx874 or  sNaN14   NaN17 -> NaN Invalid_operation
  #|orx875 or  sNaN15  sNaN18 -> NaN Invalid_operation
  #|orx876 or  NaN16   sNaN19 -> NaN Invalid_operation
  #|orx877 or -Inf    +sNaN20 -> NaN Invalid_operation
  #|orx878 or -1000    sNaN21 -> NaN Invalid_operation
  #|orx879 or  1000    sNaN22 -> NaN Invalid_operation
  #|orx880 or  Inf     sNaN23 -> NaN Invalid_operation
  #|orx881 or +NaN25  +sNaN24 -> NaN Invalid_operation
  #|orx882 or -NaN26    NaN28 -> NaN Invalid_operation
  #|orx883 or -sNaN27  sNaN29 -> NaN Invalid_operation
  #|orx884 or  1000    -NaN30 -> NaN Invalid_operation
  #|orx885 or  1000   -sNaN31 -> NaN Invalid_operation

///|
/// Full `xor.decTest` corpus (IBM General Decimal
/// Arithmetic testcases), embedded verbatim.
let xor_subset : String =
  #|------------------------------------------------------------------------
  #|-- xor.decTest -- digitwise logical XOR                               --
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
  #|-- Sanity check (truth table)
  #|xorx001 xor             0    0 ->    0
  #|xorx002 xor             0    1 ->    1
  #|xorx003 xor             1    0 ->    1
  #|xorx004 xor             1    1 ->    0
  #|xorx005 xor          1100 1010 ->  110
  #|xorx006 xor          1111   10 -> 1101
  #|-- and at msd and msd-1
  #|xorx010 xor 000000000 000000000 ->           0
  #|xorx011 xor 000000000 100000000 ->   100000000
  #|xorx012 xor 100000000 000000000 ->   100000000
  #|xorx013 xor 100000000 100000000 ->           0
  #|xorx014 xor 000000000 000000000 ->           0
  #|xorx015 xor 000000000 010000000 ->    10000000
  #|xorx016 xor 010000000 000000000 ->    10000000
  #|xorx017 xor 010000000 010000000 ->           0
  #|
  #|-- Various lengths
  #|--        123456789     123456789      123456789
  #|xorx021 xor 111111111     111111111  ->  0
  #|xorx022 xor 111111111111  111111111  ->  0
  #|xorx023 xor  11111111      11111111  ->  0
  #|xorx025 xor   1111111       1111111  ->  0
  #|xorx026 xor    111111        111111  ->  0
  #|xorx027 xor     11111         11111  ->  0
  #|xorx028 xor      1111          1111  ->  0
  #|xorx029 xor       111           111  ->  0
  #|xorx031 xor        11            11  ->  0
  #|xorx032 xor         1             1  ->  0
  #|xorx033 xor 111111111111 1111111111  ->  0
  #|xorx034 xor 11111111111 11111111111  ->  0
  #|xorx035 xor 1111111111 111111111111  ->  0
  #|xorx036 xor 111111111 1111111111111  ->  0
  #|
  #|xorx040 xor 111111111  111111111111  ->  0
  #|xorx041 xor  11111111  111111111111  ->  100000000
  #|xorx042 xor  11111111     111111111  ->  100000000
  #|xorx043 xor   1111111     100000010  ->  101111101
  #|xorx044 xor    111111     100000100  ->  100111011
  #|xorx045 xor     11111     100001000  ->  100010111
  #|xorx046 xor      1111     100010000  ->  100011111
  #|xorx047 xor       111     100100000  ->  100100111
  #|xorx048 xor        11     101000000  ->  101000011
  #|xorx049 xor         1     110000000  ->  110000001
  #|
  #|xorx050 xor 1111111111  1  ->  111111110
  #|xorx051 xor  111111111  1  ->  111111110
  #|xorx052 xor   11111111  1  ->  11111110
  #|xorx053 xor    1111111  1  ->  1111110
  #|xorx054 xor     111111  1  ->  111110
  #|xorx055 xor      11111  1  ->  11110
  #|xorx056 xor       1111  1  ->  1110
  #|xorx057 xor        111  1  ->  110
  #|xorx058 xor         11  1  ->  10
  #|xorx059 xor          1  1  ->  0
  #|
  #|xorx060 xor 1111111111  0  ->  111111111
  #|xorx061 xor  111111111  0  ->  111111111
  #|xorx062 xor   11111111  0  ->  11111111
  #|xorx063 xor    1111111  0  ->  1111111
  #|xorx064 xor     111111  0  ->  111111
  #|xorx065 xor      11111  0  ->  11111
  #|xorx066 xor       1111  0  ->  1111
  #|xorx067 xor        111  0  ->  111
  #|xorx068 xor         11  0  ->  11
  #|xorx069 xor          1  0  ->  1
  #|
  #|xorx070 xor 1  1111111111  ->  111111110
  #|xorx071 xor 1   111111111  ->  111111110
  #|xorx072 xor 1    11111111  ->  11111110
  #|xorx073 xor 1     1111111  ->  1111110
  #|xorx074 xor 1      111111  ->  111110
  #|xorx075 xor 1       11111  ->  11110
  #|xorx076 xor 1        1111  ->  1110
  #|xorx077 xor 1         111  ->  110
  #|xorx078 xor 1          11  ->  10
  #|xorx079 xor 1           1  ->  0
  #|
  #|xorx080 xor 0  1111111111  ->  111111111
  #|xorx081 xor 0   111111111  ->  111111111
  #|xorx082 xor 0    11111111  ->  11111111
  #|xorx083 xor 0     1111111  ->  1111111
  #|xorx084 xor 0      111111  ->  111111
  #|xorx085 xor 0       11111  ->  11111
  #|xorx086 xor 0        1111  ->  1111
  #|xorx087 xor 0         111  ->  111
  #|xorx088 xor 0          11  ->  11
  #|xorx089 xor 0           1  ->  1
  #|
  #|xorx090 xor 011111111  111101111  ->  100010000
  #|xorx091 xor 101111111  111101111  ->   10010000
  #|xorx092 xor 110111111  111101111  ->    1010000
  #|xorx093 xor 111011111  111101111  ->     110000
  #|xorx094 xor 111101111  111101111  ->          0
  #|xorx095 xor 111110111  111101111  ->      11000
  #|xorx096 xor 111111011  111101111  ->      10100
  #|xorx097 xor 111111101  111101111  ->      10010
  #|xorx098 xor 111111110  111101111  ->      10001
  #|
  #|xorx100 xor 111101111  011111111  ->  100010000
  #|xorx101 xor 111101111  101111111  ->   10010000
  #|xorx102 xor 111101111  110111111  ->    1010000
  #|xorx103 xor 111101111  111011111  ->     110000
  #|xorx104 xor 111101111  111101111  ->          0
  #|xorx105 xor 111101111  111110111  ->      11000
  #|xorx106 xor 111101111  111111011  ->      10100
  #|xorx107 xor 111101111  111111101  ->      10010
  #|xorx108 xor 111101111  111111110  ->      10001
  #|
  #|-- non-0/1 should not be accepted, nor should signs
  #|xorx220 xor 111111112  111111111  ->  NaN Invalid_operation
  #|xorx221 xor 333333333  333333333  ->  NaN Invalid_operation
  #|xorx222 xor 555555555  555555555  ->  NaN Invalid_operation
  #|xorx223 xor 777777777  777777777  ->  NaN Invalid_operation
  #|xorx224 xor 999999999  999999999  ->  NaN Invalid_operation
  #|xorx225 xor 222222222  999999999  ->  NaN Invalid_operation
  #|xorx226 xor 444444444  999999999  ->  NaN Invalid_operation
  #|xorx227 xor 666666666  999999999  ->  NaN Invalid_operation
  #|xorx228 xor 888888888  999999999  ->  NaN Invalid_operation
  #|xorx229 xor 999999999  222222222  ->  NaN Invalid_operation
  #|xorx230 xor 999999999  444444444  ->  NaN Invalid_operation
  #|xorx231 xor 999999999  666666666  ->  NaN Invalid_operation
  #|xorx232 xor 999999999  888888888  ->  NaN Invalid_operation
  #|-- a few randoms
  #|xorx240 xor  567468689 -934981942 ->  NaN Invalid_operation
  #|xorx241 xor  567367689  934981942 ->  NaN Invalid_operation
  #|xorx242 xor -631917772 -706014634 ->  NaN Invalid_operation
  #|xorx243 xor -756253257  138579234 ->  NaN Invalid_operation
  #|xorx244 xor  835590149  567435400 ->  NaN Invalid_operation
  #|-- test MSD
  #|xorx250 xor  200000000 100000000 ->  NaN Invalid_operation
  #|xorx251 xor  700000000 100000000 ->  NaN Invalid_operation
  #|xorx252 xor  800000000 100000000 ->  NaN Invalid_operation
  #|xorx253 xor  900000000 100000000 ->  NaN Invalid_operation
  #|xorx254 xor  200000000 000000000 ->  NaN Invalid_operation
  #|xorx255 xor  700000000 000000000 ->  NaN Invalid_operation
  #|xorx256 xor  800000000 000000000 ->  NaN Invalid_operation
  #|xorx257 xor  900000000 000000000 ->  NaN Invalid_operation
  #|xorx258 xor  100000000 200000000 ->  NaN Invalid_operation
  #|xorx259 xor  100000000 700000000 ->  NaN Invalid_operation
  #|xorx260 xor  100000000 800000000 ->  NaN Invalid_operation
  #|xorx261 xor  100000000 900000000 ->  NaN Invalid_operation
  #|xorx262 xor  000000000 200000000 ->  NaN Invalid_operation
  #|xorx263 xor  000000000 700000000 ->  NaN Invalid_operation
  #|xorx264 xor  000000000 800000000 ->  NaN Invalid_operation
  #|xorx265 xor  000000000 900000000 ->  NaN Invalid_operation
  #|-- test MSD-1
  #|xorx270 xor  020000000 100000000 ->  NaN Invalid_operation
  #|xorx271 xor  070100000 100000000 ->  NaN Invalid_operation
  #|xorx272 xor  080010000 100000001 ->  NaN Invalid_operation
  #|xorx273 xor  090001000 100000010 ->  NaN Invalid_operation
  #|xorx274 xor  100000100 020010100 ->  NaN Invalid_operation
  #|xorx275 xor  100000000 070001000 ->  NaN Invalid_operation
  #|xorx276 xor  100000010 080010100 ->  NaN Invalid_operation
  #|xorx277 xor  100000000 090000010 ->  NaN Invalid_operation
  #|-- test LSD
  #|xorx280 xor  001000002 100000000 ->  NaN Invalid_operation
  #|xorx281 xor  000000007 100000000 ->  NaN Invalid_operation
  #|xorx282 xor  000000008 100000000 ->  NaN Invalid_operation
  #|xorx283 xor  000000009 100000000 ->  NaN Invalid_operation
  #|xorx284 xor  100000000 000100002 ->  NaN Invalid_operation
  #|xorx285 xor  100100000 001000007 ->  NaN Invalid_operation
  #|xorx286 xor  100010000 010000008 ->  NaN Invalid_operation
  #|xorx287 xor  100001000 100000009 ->  NaN Invalid_operation
  #|-- test Middie
  #|xorx288 xor  001020000 100000000 ->  NaN Invalid_operation
  #|xorx289 xor  000070001 100000000 ->  NaN Invalid_operation
  #|xorx290 xor  000080000 100010000 ->  NaN Invalid_operation
  #|xorx291 xor  000090000 100001000 ->  NaN Invalid_operation
  #|xorx292 xor  100000010 000020100 ->  NaN Invalid_operation
  #|xorx293 xor  100100000 000070010 ->  NaN Invalid_operation
  #|xorx294 xor  100010100 000080001 ->  NaN Invalid_operation
  #|xorx295 xor  100001000 000090000 ->  NaN Invalid_operation
  #|-- signs
  #|xorx296 xor -100001000 -000000000 ->  NaN Invalid_operation
  #|xorx297 xor -100001000  000010000 ->  NaN Invalid_operation
  #|xorx298 xor  100001000 -000000000 ->  NaN Invalid_operation
  #|xorx299 xor  100001000  000011000 ->  100010000
  #|
  #|-- Nmax, Nmin, Ntiny
  #|xorx331 xor  2   9.99999999E+999     -> NaN Invalid_operation
  #|xorx332 xor  3   1E-999              -> NaN Invalid_operation
  #|xorx333 xor  4   1.00000000E-999     -> NaN Invalid_operation
  #|xorx334 xor  5   1E-1007             -> NaN Invalid_operation
  #|xorx335 xor  6   -1E-1007            -> NaN Invalid_operation
  #|xorx336 xor  7   -1.00000000E-999    -> NaN Invalid_operation
  #|xorx337 xor  8   -1E-999             -> NaN Invalid_operation
  #|xorx338 xor  9   -9.99999999E+999    -> NaN Invalid_operation
  #|xorx341 xor  9.99999999E+999     -18 -> NaN Invalid_operation
  #|xorx342 xor  1E-999               01 -> NaN Invalid_operation
  #|xorx343 xor  1.00000000E-999     -18 -> NaN Invalid_operation
  #|xorx344 xor  1E-1007              18 -> NaN Invalid_operation
  #|xorx345 xor  -1E-1007            -10 -> NaN Invalid_operation
  #|xorx346 xor  -1.00000000E-999     18 -> NaN Invalid_operation
  #|xorx347 xor  -1E-999              10 -> NaN Invalid_operation
  #|xorx348 xor  -9.99999999E+999    -18 -> NaN Invalid_operation
  #|
  #|-- A few other non-integers
  #|xorx361 xor  1.0                  1  -> NaN Invalid_operation
  #|xorx362 xor  1E+1                 1  -> NaN Invalid_operation
  #|xorx363 xor  0.0                  1  -> NaN Invalid_operation
  #|xorx364 xor  0E+1                 1  -> NaN Invalid_operation
  #|xorx365 xor  9.9                  1  -> NaN Invalid_operation
  #|xorx366 xor  9E+1                 1  -> NaN Invalid_operation
  #|xorx371 xor  0 1.0                   -> NaN Invalid_operation
  #|xorx372 xor  0 1E+1                  -> NaN Invalid_operation
  #|xorx373 xor  0 0.0                   -> NaN Invalid_operation
  #|xorx374 xor  0 0E+1                  -> NaN Invalid_operation
  #|xorx375 xor  0 9.9                   -> NaN Invalid_operation
  #|xorx376 xor  0 9E+1                  -> NaN Invalid_operation
  #|
  #|-- All Specials are in error
  #|xorx780 xor -Inf  -Inf   -> NaN Invalid_operation
  #|xorx781 xor -Inf  -1000  -> NaN Invalid_operation
  #|xorx782 xor -Inf  -1     -> NaN Invalid_operation
  #|xorx783 xor -Inf  -0     -> NaN Invalid_operation
  #|xorx784 xor -Inf   0     -> NaN Invalid_operation
  #|xorx785 xor -Inf   1     -> NaN Invalid_operation
  #|xorx786 xor -Inf   1000  -> NaN Invalid_operation
  #|xorx787 xor -1000 -Inf   -> NaN Invalid_operation
  #|xorx788 xor -Inf  -Inf   -> NaN Invalid_operation
  #|xorx789 xor -1    -Inf   -> NaN Invalid_operation
  #|xorx790 xor -0    -Inf   -> NaN Invalid_operation
  #|xorx791 xor  0    -Inf   -> NaN Invalid_operation
  #|xorx792 xor  1    -Inf   -> NaN Invalid_operation
  #|xorx793 xor  1000 -Inf   -> NaN Invalid_operation
  #|xorx794 xor  Inf  -Inf   -> NaN Invalid_operation
  #|
  #|xorx800 xor  Inf  -Inf   -> NaN Invalid_operation
  #|xorx801 xor  Inf  -1000  -> NaN Invalid_operation
  #|xorx802 xor  Inf  -1     -> NaN Invalid_operation
  #|xorx803 xor  Inf  -0     -> NaN Invalid_operation
  #|xorx804 xor  Inf   0     -> NaN Invalid_operation
  #|xorx805 xor  Inf   1     -> NaN Invalid_operation
  #|xorx806 xor  Inf   1000  -> NaN Invalid_operation
  #|xorx807 xor  Inf   Inf   -> NaN Invalid_operation
  #|xorx808 xor -1000  Inf   -> NaN Invalid_operation
  #|xorx809 xor -Inf   Inf   -> NaN Invalid_operation
  #|xorx810 xor -1     Inf   -> NaN Invalid_operation
  #|xorx811 xor -0     Inf   -> NaN Invalid_operation
  #|xorx812 xor  0     Inf   -> NaN Invalid_operation
  #|xorx813 xor  1     Inf   -> NaN Invalid_operation
  #|xorx814 xor  1000  Inf   -> NaN Invalid_operation
  #|xorx815 xor  Inf   Inf   -> NaN Invalid_operation
  #|
  #|xorx821 xor  NaN -Inf    -> NaN Invalid_operation
  #|xorx822 xor  NaN -1000   -> NaN Invalid_operation
  #|xorx823 xor  NaN -1      -> NaN Invalid_operation
  #|xorx824 xor  NaN -0      -> NaN Invalid_operation
  #|xorx825 xor  NaN  0      -> NaN Invalid_operation
  #|xorx826 xor  NaN  1      -> NaN Invalid_operation
  #|xorx827 xor  NaN  1000   -> NaN Invalid_operation
  #|xorx828 xor  NaN  Inf    -> NaN Invalid_operation
  #|xorx829 xor  NaN  NaN    -> NaN Invalid_operation
  #|xorx830 xor -Inf  NaN    -> NaN Invalid_operation
  #|xorx831 xor -1000 NaN    -> NaN Invalid_operation
  #|xorx832 xor -1    NaN    -> NaN Invalid_operation
  #|xorx833 xor -0    NaN    -> NaN Invalid_operation
  #|xorx834 xor  0    NaN    -> NaN Invalid_operation
  #|xorx835 xor  1    NaN    -> NaN Invalid_operation
  #|xorx836 xor  1000 NaN    -> NaN Invalid_operation
  #|xorx837 xor  Inf  NaN    -> NaN Invalid_operation
  #|
  #|xorx841 xor  sNaN -Inf   ->  NaN  Invalid_operation
  #|xorx842 xor  sNaN -1000  ->  NaN  Invalid_operation
  #|xorx843 xor  sNaN -1     ->  NaN  Invalid_operation
  #|xorx844 xor  sNaN -0     ->  NaN  Invalid_operation
  #|xorx845 xor  sNaN  0     ->  NaN  Invalid_operation
  #|xorx846 xor  sNaN  1     ->  NaN  Invalid_operation
  #|xorx847 xor  sNaN  1000  ->  NaN  Invalid_operation
  #|xorx848 xor  sNaN  NaN   ->  NaN  Invalid_operation
  #|xorx849 xor  sNaN sNaN   ->  NaN  Invalid_operation
  #|xorx850 xor  NaN  sNaN   ->  NaN  Invalid_operation
  #|xorx851 xor -Inf  sNaN   ->  NaN  Invalid_operation
  #|xorx852 xor -1000 sNaN   ->  NaN  Invalid_operation
  #|xorx853 xor -1    sNaN   ->  NaN  Invalid_operation
  #|xorx854 xor -0    sNaN   ->  NaN  Invalid_operation
  #|xorx855 xor  0    sNaN   ->  NaN  Invalid_operation
  #|xorx856 xor  1    sNaN   ->  NaN  Invalid_operation
  #|xorx857 xor  1000 sNaN   ->  NaN  Invalid_operation
  #|xorx858 xor  Inf  sNaN   ->  NaN  Invalid_operation
  #|xorx859 xor  NaN  sNaN   ->  NaN  Invalid_operation
  #|
  #|-- propagating NaNs
  #|xorx861 xor  NaN1   -Inf    -> NaN Invalid_operation
  #|xorx862 xor +NaN2   -1000   -> NaN Invalid_operation
  #|xorx863 xor  NaN3    1000   -> NaN Invalid_operation
  #|xorx864 xor  NaN4    Inf    -> NaN Invalid_operation
  #|xorx865 xor  NaN5   +NaN6   -> NaN Invalid_operation
  #|xorx866 xor -Inf     NaN7   -> NaN Invalid_operation
  #|xorx867 xor -1000    NaN8   -> NaN Invalid_operation
  #|xorx868 xor  1000    NaN9   -> NaN Invalid_operation
  #|xorx869 xor  Inf    +NaN10  -> NaN Invalid_operation
  #|xorx871 xor  sNaN11  -Inf   -> NaN Invalid_operation
  #|xorx872 xor  sNaN12  -1000  -> NaN Invalid_operation
  #|xorx873 xor  sNaN13   1000  -> NaN Invalid_operation
  #|xorx874 xor  sNaN14   NaN17 -> NaN Invalid_operation
  #|xorx875 xor  sNaN15  sNaN18 -> NaN Invalid_operation
  #|xorx876 xor  NaN16   sNaN19 -> NaN Invalid_operation
  #|xorx877 xor -Inf    +sNaN20 -> NaN Invalid_operation
  #|xorx878 xor -1000    sNaN21 -> NaN Invalid_operation
  #|xorx879 xor  1000    sNaN22 -> NaN Invalid_operation
  #|xorx880 xor  Inf     sNaN23 -> NaN Invalid_operation
  #|xorx881 xor +NaN25  +sNaN24 -> NaN Invalid_operation
  #|xorx882 xor -NaN26    NaN28 -> NaN Invalid_operation
  #|xorx883 xor -sNaN27  sNaN29 -> NaN Invalid_operation
  #|xorx884 xor  1000    -NaN30 -> NaN Invalid_operation
  #|xorx885 xor  1000   -sNaN31 -> NaN Invalid_operation

///|
/// Full `invert.decTest` corpus (IBM General Decimal
/// Arithmetic testcases), embedded verbatim.
let invert_subset : String =
  #|------------------------------------------------------------------------
  #|-- invert.decTest -- digitwise logical INVERT                         --
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
  #|-- Sanity check (truth table), and examples from decArith
  #|invx001 invert             0 -> 111111111
  #|invx002 invert             1 -> 111111110
  #|invx003 invert            10 -> 111111101
  #|invx004 invert     111111111 ->         0
  #|invx005 invert     000000000 -> 111111111
  #|invx006 invert     101010101 -> '10101010'
  #|-- and at msd and msd-1
  #|invx007 invert 000000000 ->   111111111
  #|invx009 invert 100000000 ->    11111111
  #|invx011 invert 000000000 ->   111111111
  #|invx013 invert 010000000 ->   101111111
  #|
  #|-- Various lengths
  #|--             123456789         123456789
  #|invx021 invert 111111111     ->  0
  #|invx022 invert 111111111111  ->  0
  #|invx023 invert  11111111     ->  100000000
  #|invx025 invert   1111111     ->  110000000
  #|invx026 invert    111111     ->  111000000
  #|invx027 invert     11111     ->  111100000
  #|invx028 invert      1111     ->  111110000
  #|invx029 invert       111     ->  111111000
  #|invx031 invert        11     ->  111111100
  #|invx032 invert         1     ->  111111110
  #|invx033 invert 111111111111  ->  0
  #|invx034 invert 11111111111   ->  0
  #|invx035 invert 1111111111    ->  0
  #|invx036 invert 111111111     ->  0
  #|
  #|invx080 invert 011111111   ->  100000000
  #|invx081 invert 101111111   ->   10000000
  #|invx082 invert 110111111   ->    1000000
  #|invx083 invert 111011111   ->     100000
  #|invx084 invert 111101111   ->      10000
  #|invx085 invert 111110111   ->       1000
  #|invx086 invert 111111011   ->        100
  #|invx087 invert 111111101   ->         10
  #|invx088 invert 111111110   ->          1
  #|invx089 invert 011111011   ->  100000100
  #|invx090 invert 101111101   ->   10000010
  #|invx091 invert 110111110   ->    1000001
  #|invx092 invert 111011101   ->     100010
  #|invx093 invert 111101011   ->      10100
  #|invx094 invert 111110111   ->       1000
  #|invx095 invert 111101011   ->      10100
  #|invx096 invert 111011101   ->     100010
  #|invx097 invert 110111110   ->    1000001
  #|invx098 invert 101111101   ->   10000010
  #|invx099 invert 011111011   ->  100000100
  #|
  #|-- non-0/1 should not be accepted, nor should signs
  #|invx220 invert 111111112   ->  NaN Invalid_operation
  #|invx221 invert 333333333   ->  NaN Invalid_operation
  #|invx222 invert 555555555   ->  NaN Invalid_operation
  #|invx223 invert 777777777   ->  NaN Invalid_operation
  #|invx224 invert 999999999   ->  NaN Invalid_operation
  #|invx225 invert 222222222   ->  NaN Invalid_operation
  #|invx226 invert 444444444   ->  NaN Invalid_operation
  #|invx227 invert 666666666   ->  NaN Invalid_operation
  #|invx228 invert 888888888   ->  NaN Invalid_operation
  #|invx229 invert 999999999   ->  NaN Invalid_operation
  #|invx230 invert 999999999   ->  NaN Invalid_operation
  #|invx231 invert 999999999   ->  NaN Invalid_operation
  #|invx232 invert 999999999   ->  NaN Invalid_operation
  #|-- a few randoms
  #|invx240 invert  567468689  ->  NaN Invalid_operation
  #|invx241 invert  567367689  ->  NaN Invalid_operation
  #|invx242 invert -631917772  ->  NaN Invalid_operation
  #|invx243 invert -756253257  ->  NaN Invalid_operation
  #|invx244 invert  835590149  ->  NaN Invalid_operation
  #|-- test MSD
  #|invx250 invert  200000000  ->  NaN Invalid_operation
  #|invx251 invert  300000000  ->  NaN Invalid_operation
  #|invx252 invert  400000000  ->  NaN Invalid_operation
  #|invx253 invert  500000000  ->  NaN Invalid_operation
  #|invx254 invert  600000000  ->  NaN Invalid_operation
  #|invx255 invert  700000000  ->  NaN Invalid_operation
  #|invx256 invert  800000000  ->  NaN Invalid_operation
  #|invx257 invert  900000000  ->  NaN Invalid_operation
  #|-- test MSD-1
  #|invx270 invert  021000000  ->  NaN Invalid_operation
  #|invx271 invert  030100000  ->  NaN Invalid_operation
  #|invx272 invert  040010000  ->  NaN Invalid_operation
  #|invx273 invert  050001000  ->  NaN Invalid_operation
  #|invx274 invert  160000100  ->  NaN Invalid_operation
  #|invx275 invert  170000010  ->  NaN Invalid_operation
  #|invx276 invert  180000000  ->  NaN Invalid_operation
  #|invx277 invert  190000000  ->  NaN Invalid_operation
  #|-- test LSD
  #|invx280 invert  000000002  ->  NaN Invalid_operation
  #|invx281 invert  000000003  ->  NaN Invalid_operation
  #|invx282 invert  000000004  ->  NaN Invalid_operation
  #|invx283 invert  000000005  ->  NaN Invalid_operation
  #|invx284 invert  101000006  ->  NaN Invalid_operation
  #|invx285 invert  100100007  ->  NaN Invalid_operation
  #|invx286 invert  100010008  ->  NaN Invalid_operation
  #|invx287 invert  100001009  ->  NaN Invalid_operation
  #|-- test Middie
  #|invx288 invert  000020000  ->  NaN Invalid_operation
  #|invx289 invert  000030001  ->  NaN Invalid_operation
  #|invx290 invert  000040000  ->  NaN Invalid_operation
  #|invx291 invert  000050000  ->  NaN Invalid_operation
  #|invx292 invert  101060000  ->  NaN Invalid_operation
  #|invx293 invert  100170010  ->  NaN Invalid_operation
  #|invx294 invert  100080100  ->  NaN Invalid_operation
  #|invx295 invert  100091000  ->  NaN Invalid_operation
  #|-- signs
  #|invx296 invert -100001000  ->  NaN Invalid_operation
  #|invx299 invert  100001000  ->  11110111
  #|
  #|-- Nmax, Nmin, Ntiny
  #|invx341 invert  9.99999999E+999   -> NaN Invalid_operation
  #|invx342 invert  1E-999            -> NaN Invalid_operation
  #|invx343 invert  1.00000000E-999   -> NaN Invalid_operation
  #|invx344 invert  1E-1007           -> NaN Invalid_operation
  #|invx345 invert  -1E-1007          -> NaN Invalid_operation
  #|invx346 invert  -1.00000000E-999  -> NaN Invalid_operation
  #|invx347 invert  -1E-999           -> NaN Invalid_operation
  #|invx348 invert  -9.99999999E+999  -> NaN Invalid_operation
  #|
  #|-- A few other non-integers
  #|invx361 invert  1.0               -> NaN Invalid_operation
  #|invx362 invert  1E+1              -> NaN Invalid_operation
  #|invx363 invert  0.0               -> NaN Invalid_operation
  #|invx364 invert  0E+1              -> NaN Invalid_operation
  #|invx365 invert  9.9               -> NaN Invalid_operation
  #|invx366 invert  9E+1              -> NaN Invalid_operation
  #|
  #|-- All Specials are in error
  #|invx788 invert -Inf     -> NaN  Invalid_operation
  #|invx794 invert  Inf     -> NaN  Invalid_operation
  #|invx821 invert  NaN     -> NaN  Invalid_operation
  #|invx841 invert  sNaN    -> NaN  Invalid_operation
  #|-- propagating NaNs
  #|invx861 invert  NaN1    -> NaN Invalid_operation
  #|invx862 invert +NaN2    -> NaN Invalid_operation
  #|invx863 invert  NaN3    -> NaN Invalid_operation
  #|invx864 invert  NaN4    -> NaN Invalid_operation
  #|invx865 invert  NaN5    -> NaN Invalid_operation
  #|invx871 invert  sNaN11  -> NaN Invalid_operation
  #|invx872 invert  sNaN12  -> NaN Invalid_operation
  #|invx873 invert  sNaN13  -> NaN Invalid_operation
  #|invx874 invert  sNaN14  -> NaN Invalid_operation
  #|invx875 invert  sNaN15  -> NaN Invalid_operation
  #|invx876 invert  NaN16   -> NaN Invalid_operation
  #|invx881 invert +NaN25   -> NaN Invalid_operation
  #|invx882 invert -NaN26   -> NaN Invalid_operation
  #|invx883 invert -sNaN27  -> NaN Invalid_operation

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
test "and.decTest subset" {
  // 59 cases — the subset includes one `-- and at msd and msd-1` comment
  // line which the runner correctly skips during parse.
  run_subset("and", and_subset)
}

///|
test "or.decTest subset" {
  // 59 cases — same comment-line quirk as and.
  run_subset("or", or_subset)
}

///|
test "xor.decTest subset" {
  run_subset("xor", xor_subset)
}

///|
test "invert.decTest subset" {
  run_subset("invert", invert_subset)
}
