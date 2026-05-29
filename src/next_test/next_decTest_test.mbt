///|
/// First 60 cases each from `nextplus.decTest`, `nextminus.decTest`,
/// `nexttoward.decTest`.
let nextplus_subset : String =
  #|precision:   9
  #|rounding:    half_up
  #|maxExponent: 384
  #|minexponent: -383
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
  #|nextp060 nextplus  1E-99999       ->   1E-391
  #|nextp061 nextplus  1E-999999999   ->   1E-391
  #|nextp062 nextplus  1E-391         ->   2E-391
  #|nextp063 nextplus -1E-99999       ->  -0E-391
  #|nextp064 nextplus -1E-999999999   ->  -0E-391

///|
let nextminus_subset : String =
  #|precision:   9
  #|rounding:    half_up
  #|maxExponent: 384
  #|minexponent: -383
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
  #|nextm060 nextminus  1E-99999       ->   0E-391
  #|nextm061 nextminus  1E-999999999   ->   0E-391
  #|nextm062 nextminus  1E-391         ->   0E-391
  #|nextm063 nextminus -1E-99999       ->  -1E-391
  #|nextm064 nextminus -1E-999999999   ->  -1E-391

///|
let nexttoward_subset : String =
  #|precision:   9
  #|rounding:    half_up
  #|maxExponent: 384
  #|minexponent: -383
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
  #|nextt101 nexttoward          7       7 ->  7
  #|nextt102 nexttoward         -7      -7 -> -7
  #|nextt103 nexttoward         75      75 ->  75
  #|nextt104 nexttoward        -75     -75 -> -75
  #|nextt105 nexttoward       7.50     7.5 ->  7.50
  #|nextt106 nexttoward      -7.50   -7.50 -> -7.50
  #|nextt107 nexttoward       7.500 7.5000 ->  7.500
  #|nextt108 nexttoward      -7.500   -7.5 -> -7.500
  #|nextt111 nexttoward          0       0 ->  0
  #|nextt112 nexttoward         -0      -0 -> -0
  #|nextt113 nexttoward       0E+4       0 ->  0E+4
  #|nextt114 nexttoward      -0E+4      -0 -> -0E+4
  #|nextt115 nexttoward     0.0000 0.00000 ->  0.0000
  #|nextt116 nexttoward    -0.0000   -0.00 -> -0.0000
  #|nextt117 nexttoward      0E-141      0 ->  0E-141
  #|nextt118 nexttoward     -0E-141   -000 -> -0E-141
  #|nextt121 nexttoward   268268268    268268268 ->   268268268
  #|nextt122 nexttoward  -268268268   -268268268 ->  -268268268
  #|nextt123 nexttoward   134134134    134134134 ->   134134134
  #|nextt124 nexttoward  -134134134   -134134134 ->  -134134134
  #|nextt131 nexttoward  9.99999999E+384  9.99999999E+384   ->   9.99999999E+384
  #|nextt132 nexttoward  1E-383           1E-383            ->   1E-383
  #|nextt133 nexttoward  1.00000000E-383  1.00000000E-383   ->   1.00000000E-383
  #|nextt134 nexttoward  1E-391           1E-391            ->   1E-391
  #|nextt135 nexttoward  -1E-391          -1E-391           ->  -1E-391
  #|nextt136 nexttoward  -1.00000000E-383 -1.00000000E-383  ->  -1.00000000E-383
  #|nextt137 nexttoward  -1E-383          -1E-383           ->  -1E-383
  #|nextt138 nexttoward  -9.99999999E+384 -9.99999999E+384  ->  -9.99999999E+384
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
  #|nextt221 nexttoward -0.999999995 Infinity ->  -0.999999994
  #|nextt222 nexttoward -0.999999996 Infinity ->  -0.999999995
  #|nextt223 nexttoward -0.999999997 Infinity ->  -0.999999996
  #|nextt511 nexttoward  0.00   -0.0000 -> -0.00
  #|nextt512 nexttoward -0.00    0.0000 ->  0.00

///|
fn run_subset(label : String, subset : String, expected : Int) -> Unit raise {
  let cases = parse_dectest(subset)
  assert_eq(cases.length(), expected)
  let (failures, _) = run_cases_with_flags(cases)
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
  run_subset("nextplus", nextplus_subset, 60)
}

///|
test "nextminus.decTest subset" {
  run_subset("nextminus", nextminus_subset, 60)
}

///|
test "nexttoward.decTest subset" {
  run_subset("nexttoward", nexttoward_subset, 62)
}
