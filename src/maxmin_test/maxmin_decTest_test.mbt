///|
/// First 80 cases each from `max.decTest`, `min.decTest`,
/// `maxmag.decTest`, `minmag.decTest`. Skips cases tagged
/// `Invalid_operation` and sNaN cases pending runner-side flag
/// validation.
let max_subset : String =
  #|precision:   9
  #|rounding:    half_up
  #|maxExponent: 384
  #|minexponent: -383
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
  #|maxx050 max  -0E1   0E1 ->  0E+1
  #|maxx051 max  -0E2   0E2 ->  0E+2
  #|maxx052 max  -0E2   0E1 ->  0E+1
  #|maxx053 max  -0E1   0E2 ->  0E+2
  #|maxx054 max   0E1  -0E1 ->  0E+1
  #|maxx055 max   0E2  -0E2 ->  0E+2
  #|maxx056 max   0E2  -0E1 ->  0E+2
  #|maxx057 max   0E1  -0E2 ->  0E+1
  #|maxx058 max   0E1   0E1 ->  0E+1
  #|maxx059 max   0E2   0E2 ->  0E+2
  #|maxx060 max   0E2   0E1 ->  0E+2
  #|maxx061 max   0E1   0E2 ->  0E+2
  #|maxx062 max  -0E1  -0E1 -> -0E+1
  #|maxx063 max  -0E2  -0E2 -> -0E+2
  #|maxx064 max  -0E2  -0E1 -> -0E+1
  #|maxx065 max  -0E1  -0E2 -> -0E+1
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
  #|maxx120 max -Inf  -Inf   -> -Infinity
  #|maxx121 max -Inf  -1000  -> -1000
  #|maxx122 max -Inf  -1     -> -1
  #|maxx123 max -Inf  -0     -> -0
  #|maxx124 max -Inf   0     ->  0
  #|maxx125 max -Inf   1     ->  1
  #|maxx126 max -Inf   1000  ->  1000

///|
let min_subset : String =
  #|precision:   9
  #|rounding:    half_up
  #|maxExponent: 384
  #|minexponent: -383
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
  #|mnmx046 min   0E1  -0E1 -> -0E+1
  #|mnmx047 min  -0E1   0E2 -> -0E+1
  #|mnmx048 min   0E2   0E1 ->  0E+1
  #|mnmx049 min   0E1   0E2 ->  0E+1
  #|mnmx050 min  -0E3  -0E2 -> -0E+3
  #|mnmx051 min  -0E2  -0E3 -> -0E+3
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
  #|mnmx141 min  NaN -Inf    ->  -Infinity

///|
let maxmag_subset : String =
  #|precision:   9
  #|rounding:    half_up
  #|maxExponent: 384
  #|minexponent: -383
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
  #|mxgx050 maxmag  -0E1   0E1 ->  0E+1
  #|mxgx051 maxmag  -0E2   0E2 ->  0E+2
  #|mxgx052 maxmag  -0E2   0E1 ->  0E+1
  #|mxgx053 maxmag  -0E1   0E2 ->  0E+2
  #|mxgx054 maxmag   0E1  -0E1 ->  0E+1
  #|mxgx055 maxmag   0E2  -0E2 ->  0E+2
  #|mxgx056 maxmag   0E2  -0E1 ->  0E+2
  #|mxgx057 maxmag   0E1  -0E2 ->  0E+1
  #|mxgx058 maxmag   0E1   0E1 ->  0E+1
  #|mxgx059 maxmag   0E2   0E2 ->  0E+2
  #|mxgx060 maxmag   0E2   0E1 ->  0E+2
  #|mxgx061 maxmag   0E1   0E2 ->  0E+2
  #|mxgx062 maxmag  -0E1  -0E1 -> -0E+1
  #|mxgx063 maxmag  -0E2  -0E2 -> -0E+2
  #|mxgx064 maxmag  -0E2  -0E1 -> -0E+1
  #|mxgx065 maxmag  -0E1  -0E2 -> -0E+1
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
  #|mxgx120 maxmag -Inf  -Inf   -> -Infinity
  #|mxgx121 maxmag -Inf  -1000  -> -Infinity
  #|mxgx122 maxmag -Inf  -1     -> -Infinity
  #|mxgx123 maxmag -Inf  -0     -> -Infinity
  #|mxgx124 maxmag -Inf   0     -> -Infinity
  #|mxgx125 maxmag -Inf   1     -> -Infinity
  #|mxgx126 maxmag -Inf   1000  -> -Infinity

///|
let minmag_subset : String =
  #|precision:   9
  #|rounding:    half_up
  #|maxExponent: 384
  #|minexponent: -383
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
  #|mngx046 minmag   0E1  -0E1 -> -0E+1
  #|mngx047 minmag  -0E1   0E2 -> -0E+1
  #|mngx048 minmag   0E2   0E1 ->  0E+1
  #|mngx049 minmag   0E1   0E2 ->  0E+1
  #|mngx050 minmag  -0E3  -0E2 -> -0E+3
  #|mngx051 minmag  -0E2  -0E3 -> -0E+3
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
  #|mngx141 minmag  NaN -Inf    ->  -Infinity

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
test "max.decTest subset" {
  run_subset("max", max_subset, 80)
}

///|
test "min.decTest subset" {
  run_subset("min", min_subset, 80)
}

///|
test "maxmag.decTest subset" {
  run_subset("maxmag", maxmag_subset, 80)
}

///|
test "minmag.decTest subset" {
  run_subset("minmag", minmag_subset, 80)
}
