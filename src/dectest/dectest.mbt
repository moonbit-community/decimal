///| A single test case parsed from a `.decTest` line.
///
/// A `.decTest` line has the shape `<id> <op> <operand>... -> <result> [<conditions>...]`.
/// Directive lines (`name: value`) and comments (`-- ...`) are skipped during
/// parsing and never become `TestCase`s.
pub(all) struct TestCase {
  id : String
  op : String
  operands : Array[String]
  expected : String
  conditions : Array[String]
  /// Active precision when this case appeared; `0` means no `precision:`
  /// directive has been seen, which the runner treats as "no precision cap".
  precision : Int
  /// Active rounding mode; defaults to `HalfEven` until a `rounding:`
  /// directive overrides it.
  rounding : Rounding
  /// Active `maxExponent` and `minExponent` directives; default to the
  /// near-`Int.max` bounds Context uses when no directive is in scope.
  max_exponent : Int
  min_exponent : Int
  /// Active `clamp` directive; defaults to off.
  clamp : Bool
}

///| Parse the full text of a `.decTest` source into test cases. Skips blank
/// lines and comment lines (`--` to end of line). The `precision`,
/// `rounding`, `maxExponent`, `minExponent`, and `clamp` directives are
/// tracked across the file so each emitted `TestCase` reports the context
/// in scope for it. Directive names are case-insensitive per the GDA
/// convention.
pub fn parse_dectest(text : String) -> Array[TestCase] {
  let cases = Array::new()
  let mut current_precision = 0
  let mut current_rounding = Rounding::HalfEven
  let mut current_max_exp = 999_999_999
  let mut current_min_exp = -999_999_999
  let mut current_clamp = false
  for raw in text.split("\n") {
    let line = strip_dectest_comment(raw.to_owned())
    let trimmed = line.trim().to_owned()
    if trimmed.is_empty() {
      continue
    }
    // Directive line: has ':' but no '->'.
    if !trimmed.contains("->") && trimmed.contains(":") {
      match parse_directive(trimmed) {
        Some((key, value)) => {
          let key_lc = ascii_lowercase(key)
          if key_lc == "precision" {
            try @string.parse_int(value[:]) catch {
              _ => ()
            } noraise {
              n => current_precision = n
            }
          } else if key_lc == "rounding" {
            match parse_rounding_name(value) {
              Some(r) => current_rounding = r
              None => ()
            }
          } else if key_lc == "maxexponent" {
            try @string.parse_int(value[:]) catch {
              _ => ()
            } noraise {
              n => current_max_exp = n
            }
          } else if key_lc == "minexponent" {
            try @string.parse_int(value[:]) catch {
              _ => ()
            } noraise {
              n => current_min_exp = n
            }
          } else if key_lc == "clamp" {
            // GDA writes "0" or "1"; treat anything else as off.
            current_clamp = value == "1"
          }
        }
        None => ()
      }
      continue
    }
    match parse_dectest_line(trimmed) {
      Some(c) =>
        cases.push({
          ..c,
          precision: current_precision,
          rounding: current_rounding,
          max_exponent: current_max_exp,
          min_exponent: current_min_exp,
          clamp: current_clamp,
        })
      None => ()
    }
  }
  cases
}

///| Split a directive line `key: value` into its two parts (trimmed).
fn parse_directive(line : String) -> (String, String)? {
  match line.find(":") {
    Some(i) => Some((line[:i].trim().to_owned(), line[i + 1:].trim().to_owned()))
    None => None
  }
}

///| Map a GDA rounding-mode name onto our `Rounding` enum. Unknown modes
/// return `None` and the directive is silently ignored (rounding stays
/// where it was).
fn parse_rounding_name(name : String) -> Rounding? {
  match name {
    "half_up" => Some(HalfUp)
    "half_even" => Some(HalfEven)
    "half_down" => Some(HalfDown)
    "up" => Some(Up)
    "down" => Some(Down)
    "ceiling" => Some(Ceiling)
    "floor" => Some(Floor)
    "05up" => Some(ZeroFiveUp)
    _ => None
  }
}

///| Drop a trailing `-- ...` comment, if any.
fn strip_dectest_comment(line : String) -> String {
  match line.find("--") {
    Some(i) => line[:i].to_owned()
    None => line
  }
}

///| Parse a single non-empty, comment-stripped line. Returns `None` for
/// directive lines (no `->`) and structurally malformed lines.
fn parse_dectest_line(line : String) -> TestCase? {
  let arrow = line.find("->")
  guard arrow is Some(at) else { return None }
  let left = line[:at].to_owned()
  let right = line[at + 2:].to_owned()
  let left_tokens = tokenize_dectest(left)
  let right_tokens = tokenize_dectest(right)
  if left_tokens.length() < 3 || right_tokens.length() < 1 {
    return None
  }
  let operands = Array::new()
  for i in 2..<left_tokens.length() {
    operands.push(left_tokens[i])
  }
  let conditions = Array::new()
  for i in 1..<right_tokens.length() {
    conditions.push(right_tokens[i])
  }
  Some({
    id: left_tokens[0],
    op: left_tokens[1],
    operands,
    expected: right_tokens[0],
    conditions,
    precision: 0,
    rounding: HalfEven,
    max_exponent: 999_999_999,
    min_exponent: -999_999_999,
    clamp: false,
  })
}

///| Whitespace-tokenize a side of a `.decTest` line. Single- and double-quoted
/// tokens have their surrounding quotes stripped (the quotes are documented in
/// the spec as making it possible to embed leading/trailing whitespace in
/// operands and results).
fn tokenize_dectest(s : String) -> Array[String] {
  let tokens = Array::new()
  let n = s.length()
  let mut i = 0
  while i < n {
    let c = char_at(s, i)
    if c == ' ' || c == '\t' {
      i = i + 1
    } else if c == '\'' || c == '"' {
      let quote = c
      let start = i + 1
      let mut j = start
      while j < n && char_at(s, j) != quote {
        j = j + 1
      }
      tokens.push(s[start:j].to_owned())
      // Skip the closing quote if present.
      i = if j < n { j + 1 } else { j }
    } else {
      let start = i
      while i < n {
        let cc = char_at(s, i)
        if cc == ' ' || cc == '\t' {
          break
        }
        i = i + 1
      }
      tokens.push(s[start:i].to_owned())
    }
  }
  tokens
}

///| Per-case diagnostic raised by `compute` / `unary` to signal arity
/// mismatches and parse failures. The handler at the top of the runner
/// formats it into a failure line.
priv suberror RunnerError {
  RunnerError(String)
}

///|
impl Show for RunnerError with fn to_string(self) {
  match self {
    RunnerError(msg) => msg
  }
}

///| Outcome of running a single test case.
priv enum CaseOutcome {
  /// Op was recognised and produced the expected value.
  Pass
  /// Op was recognised but produced a wrong value. Payload is a failure line.
  Fail(String)
  /// Op was not recognised (or skipped for some other reason). Counted but
  /// not reported as a failure — handlers grow over time.
  Skip
}

///| Run every recognised case in `cases`, returning the list of failures and
/// the count of skipped cases (for diagnostics — runners that have full op
/// coverage should expect zero skips).
pub fn run_cases(cases : Array[TestCase]) -> (Array[String], Int) {
  let failures = Array::new()
  let mut skipped = 0
  for case in cases {
    match run_one(case) {
      Pass => ()
      Fail(msg) => failures.push(msg)
      Skip => skipped = skipped + 1
    }
  }
  (failures, skipped)
}

///| Dispatch one case, compare the rendered result against expected.
/// Flag validation is plumbed through `compute` so a future strict-mode
/// can opt into it via `run_cases_with_flags`, but the default
/// `run_cases` ignores raised flags to keep the per-op packages green
/// while the flag-raising audit catches up to the runner's strictness.
fn run_one(case : TestCase) -> CaseOutcome {
  let actual = try compute(case) catch {
    msg => return Fail("\{case.id}: \{case.op}: \{msg}")
  }
  match actual {
    None => Skip
    Some((s, _flags)) => {
      if s != case.expected {
        return Fail(
          "\{case.id}: \{case.op}(\{format_operands(case.operands)}) = \{s}, expected \{case.expected}",
        )
      }
      Pass
    }
  }
}

///| Strict variant: validates both the rendered string and the condition
/// flags. Used by per-op packages that want to gate on flag accuracy.
pub fn run_cases_with_flags(
  cases : Array[TestCase],
) -> (Array[String], Int) {
  let failures = Array::new()
  let mut skipped = 0
  for case in cases {
    match run_one_strict(case) {
      Pass => ()
      Fail(msg) => failures.push(msg)
      Skip => skipped = skipped + 1
    }
  }
  (failures, skipped)
}

///| Strict run_one that fails on either rendered-result or flag mismatch.
fn run_one_strict(case : TestCase) -> CaseOutcome {
  let actual = try compute(case) catch {
    msg => return Fail("\{case.id}: \{case.op}: \{msg}")
  }
  match actual {
    None => Skip
    Some((s, flags)) => {
      if s != case.expected {
        return Fail(
          "\{case.id}: \{case.op}(\{format_operands(case.operands)}) = \{s}, expected \{case.expected}",
        )
      }
      let flag_diff = compare_flags(flags, case.conditions)
      if flag_diff != "" {
        return Fail(
          "\{case.id}: \{case.op}(\{format_operands(case.operands)}) flag mismatch: \{flag_diff}",
        )
      }
      Pass
    }
  }
}

///| Verify the runtime-raised `Flags` match the expected `conditions`
/// list from the test case. Returns the empty string on a match, or a
/// human-readable diff like `+Inexact -Subnormal` otherwise.
///
/// Condition strings are matched case-insensitively (GDA writes them in
/// `Mixed_case`, but some files use lowercase).
fn compare_flags(actual : Flags, expected : Array[String]) -> String {
  let pairs : Array[(String, Bool)] = [
    ("Inexact", actual.inexact),
    ("Rounded", actual.rounded),
    ("Subnormal", actual.subnormal),
    ("Underflow", actual.underflow),
    ("Overflow", actual.overflow),
    ("Clamped", actual.clamped),
    ("Invalid_operation", actual.invalid_operation),
    ("Division_by_zero", actual.division_by_zero),
    ("Conversion_syntax", actual.conversion_syntax),
    ("Division_impossible", actual.division_impossible),
    ("Division_undefined", actual.division_undefined),
    ("Insufficient_storage", actual.insufficient_storage),
  ]
  let buf = StringBuilder::new()
  let mut sep = ""
  for pair in pairs {
    let (name, raised) = pair
    let want = condition_present(expected, name)
    if raised && !want {
      buf.write_string(sep + "+" + name)
      sep = " "
    } else if want && !raised {
      buf.write_string(sep + "-" + name)
      sep = " "
    }
  }
  buf.to_string()
}

///| Case-insensitive lookup in a condition list.
fn condition_present(conditions : Array[String], name : String) -> Bool {
  for c in conditions {
    if ascii_eq_ci(c, name) {
      return true
    }
  }
  false
}

///| Compute the rendered result and condition flags for `case`. Returns
/// `None` for ops we do not yet handle; raises a diagnostic string for
/// parse failures or arity mismatches.
fn compute(case : TestCase) -> (String, Flags)? raise RunnerError {
  if ascii_eq_ci(case.op, "tosci") {
    Some(unary(case, fn(d) { d }))
  } else if ascii_eq_ci(case.op, "minus") {
    Some(unary(case, Decimal::minus))
  } else if ascii_eq_ci(case.op, "plus") {
    Some(unary(case, Decimal::plus))
  } else if ascii_eq_ci(case.op, "abs") {
    Some(unary(case, Decimal::abs))
  } else if ascii_eq_ci(case.op, "add") {
    Some(binary_ctx(case, Decimal::add))
  } else if ascii_eq_ci(case.op, "subtract") {
    Some(binary_ctx(case, Decimal::subtract))
  } else if ascii_eq_ci(case.op, "multiply") {
    Some(binary_ctx(case, Decimal::multiply))
  } else if ascii_eq_ci(case.op, "copy") {
    Some(unary(case, Decimal::copy))
  } else if ascii_eq_ci(case.op, "copyabs") {
    Some(unary(case, Decimal::copy_abs))
  } else if ascii_eq_ci(case.op, "copynegate") {
    Some(unary(case, Decimal::copy_negate))
  } else if ascii_eq_ci(case.op, "copysign") {
    Some(binary(case, Decimal::copy_sign))
  } else if ascii_eq_ci(case.op, "divide") {
    Some(binary_ctx(case, Decimal::divide))
  } else if ascii_eq_ci(case.op, "divideint") {
    Some(binary_ctx(case, Decimal::divide_int))
  } else if ascii_eq_ci(case.op, "remainder") {
    Some(binary_ctx(case, Decimal::remainder))
  } else if ascii_eq_ci(case.op, "compare") {
    Some(binary_ctx(case, Decimal::compare))
  } else if ascii_eq_ci(case.op, "max") {
    Some(binary_ctx(case, Decimal::max))
  } else if ascii_eq_ci(case.op, "min") {
    Some(binary_ctx(case, Decimal::min))
  } else if ascii_eq_ci(case.op, "maxmag") {
    Some(binary_ctx(case, Decimal::max_magnitude))
  } else if ascii_eq_ci(case.op, "minmag") {
    Some(binary_ctx(case, Decimal::min_magnitude))
  } else if ascii_eq_ci(case.op, "comparetotal") {
    Some(binary(case, Decimal::compare_total))
  } else if ascii_eq_ci(case.op, "comparetotmag") {
    Some(binary(case, Decimal::compare_total_mag))
  } else if ascii_eq_ci(case.op, "samequantum") {
    Some(binary(case, Decimal::same_quantum))
  } else if ascii_eq_ci(case.op, "quantize") {
    Some(binary_ctx(case, Decimal::quantize))
  } else if ascii_eq_ci(case.op, "tointegral") {
    Some(unary_ctx(case, Decimal::to_integral_value))
  } else if ascii_eq_ci(case.op, "tointegralx") {
    Some(unary_ctx(case, Decimal::to_integral_exact))
  } else if ascii_eq_ci(case.op, "reduce") {
    Some(unary_ctx(case, Decimal::reduce))
  } else if ascii_eq_ci(case.op, "fma") {
    Some(ternary_ctx(case, Decimal::fma))
  } else if ascii_eq_ci(case.op, "comparesig") {
    Some(binary_ctx(case, Decimal::compare_signal))
  } else if ascii_eq_ci(case.op, "canonical") {
    Some(unary(case, Decimal::canonical))
  } else if ascii_eq_ci(case.op, "and") {
    Some(binary_ctx(case, Decimal::logical_and))
  } else if ascii_eq_ci(case.op, "or") {
    Some(binary_ctx(case, Decimal::logical_or))
  } else if ascii_eq_ci(case.op, "xor") {
    Some(binary_ctx(case, Decimal::logical_xor))
  } else if ascii_eq_ci(case.op, "invert") {
    Some(unary_ctx(case, Decimal::logical_invert))
  } else if ascii_eq_ci(case.op, "rotate") {
    Some(binary_ctx(case, Decimal::rotate))
  } else if ascii_eq_ci(case.op, "shift") {
    Some(binary_ctx(case, Decimal::shift))
  } else if ascii_eq_ci(case.op, "nextplus") {
    Some(unary_ctx(case, Decimal::next_plus))
  } else if ascii_eq_ci(case.op, "nextminus") {
    Some(unary_ctx(case, Decimal::next_minus))
  } else if ascii_eq_ci(case.op, "nexttoward") {
    Some(binary_ctx(case, Decimal::next_toward))
  } else if ascii_eq_ci(case.op, "squareroot") {
    Some(unary_ctx(case, Decimal::sqrt))
  } else if ascii_eq_ci(case.op, "class") {
    Some(unary_ctx_string(case, Decimal::number_class))
  } else if ascii_eq_ci(case.op, "exp") {
    Some(unary_ctx(case, Decimal::exp))
  } else if ascii_eq_ci(case.op, "ln") {
    Some(unary_ctx(case, Decimal::ln))
  } else if ascii_eq_ci(case.op, "log10") {
    Some(unary_ctx(case, Decimal::log10))
  } else if ascii_eq_ci(case.op, "power") {
    Some(binary_ctx(case, Decimal::power))
  } else {
    None
  }
}

///| Build a Context from a TestCase's directives.
fn ctx_for(case : TestCase) -> Context {
  Context::new(
    precision=case.precision,
    rounding=case.rounding,
    e_max=case.max_exponent,
    e_min=case.min_exponent,
    clamp=case.clamp,
  )
}

///| Apply a context-aware ternary op (`(Decimal, Decimal, Decimal, Context)
/// -> Decimal`) to the three operands. Used by `fma`.
fn ternary_ctx(
  case : TestCase,
  op : (Decimal, Decimal, Decimal, Context) -> Decimal,
) -> (String, Flags) raise RunnerError {
  if case.operands.length() != 3 {
    raise RunnerError("expects 3 operands, got \{case.operands.length()}")
  }
  let a = try Decimal::parse(case.operands[0]) catch {
    e => raise RunnerError("parse error in operand 0: \{e}")
  }
  let b = try Decimal::parse(case.operands[1]) catch {
    e => raise RunnerError("parse error in operand 1: \{e}")
  }
  let c = try Decimal::parse(case.operands[2]) catch {
    e => raise RunnerError("parse error in operand 2: \{e}")
  }
  let ctx = ctx_for(case)
  (op(a, b, c, ctx).to_sci_string(), ctx.flags)
}

///| Apply a context-aware unary op that returns a raw `String` (rather
/// than a `Decimal` rendered via `to_sci_string`). Used by `class`, whose
/// result is a category label like `+Normal`.
fn unary_ctx_string(
  case : TestCase,
  op : (Decimal, Context) -> String,
) -> (String, Flags) raise RunnerError {
  if case.operands.length() != 1 {
    raise RunnerError("expects 1 operand, got \{case.operands.length()}")
  }
  let parsed = try Decimal::parse(case.operands[0]) catch {
    e => raise RunnerError("parse error: \{e}")
  }
  let ctx = ctx_for(case)
  (op(parsed, ctx), ctx.flags)
}

///| Apply a context-aware unary op to the single operand.
fn unary_ctx(
  case : TestCase,
  op : (Decimal, Context) -> Decimal,
) -> (String, Flags) raise RunnerError {
  if case.operands.length() != 1 {
    raise RunnerError("expects 1 operand, got \{case.operands.length()}")
  }
  let parsed = try Decimal::parse(case.operands[0]) catch {
    e => raise RunnerError("parse error: \{e}")
  }
  let ctx = ctx_for(case)
  (op(parsed, ctx).to_sci_string(), ctx.flags)
}

///| Apply a unary `Decimal -> Decimal` operator. The op doesn't take a
/// Context so the reported flags are empty; ops that need to raise flags
/// (e.g. sNaN handling in `minus` / `plus` / `abs`) would have to switch
/// to `unary_ctx`. For now this matches the existing API surface.
fn unary(
  case : TestCase,
  op : (Decimal) -> Decimal,
) -> (String, Flags) raise RunnerError {
  if case.operands.length() != 1 {
    raise RunnerError("expects 1 operand, got \{case.operands.length()}")
  }
  let parsed = try Decimal::parse(case.operands[0]) catch {
    e => raise RunnerError("parse error: \{e}")
  }
  (op(parsed).to_sci_string(), Flags::new())
}

///| Apply a context-aware binary op.
fn binary_ctx(
  case : TestCase,
  op : (Decimal, Decimal, Context) -> Decimal,
) -> (String, Flags) raise RunnerError {
  if case.operands.length() != 2 {
    raise RunnerError("expects 2 operands, got \{case.operands.length()}")
  }
  let lhs = try Decimal::parse(case.operands[0]) catch {
    e => raise RunnerError("parse error in operand 0: \{e}")
  }
  let rhs = try Decimal::parse(case.operands[1]) catch {
    e => raise RunnerError("parse error in operand 1: \{e}")
  }
  let ctx = ctx_for(case)
  (op(lhs, rhs, ctx).to_sci_string(), ctx.flags)
}

///| Apply a context-less binary op (e.g. `compare_total`). Reported flags
/// are empty.
fn binary(
  case : TestCase,
  op : (Decimal, Decimal) -> Decimal,
) -> (String, Flags) raise RunnerError {
  if case.operands.length() != 2 {
    raise RunnerError("expects 2 operands, got \{case.operands.length()}")
  }
  let lhs = try Decimal::parse(case.operands[0]) catch {
    e => raise RunnerError("parse error in operand 0: \{e}")
  }
  let rhs = try Decimal::parse(case.operands[1]) catch {
    e => raise RunnerError("parse error in operand 1: \{e}")
  }
  (op(lhs, rhs).to_sci_string(), Flags::new())
}

///|
fn format_operands(operands : Array[String]) -> String {
  let buf = StringBuilder::new()
  for i, op in operands {
    if i > 0 {
      buf.write_string(", ")
    }
    buf.write_string(op)
  }
  buf.to_string()
}

///| Lowercase the ASCII letters of a string. Directives in `.decTest` files
/// are conventionally lowercase but the spec allows any case, so we
/// normalise before matching.
fn ascii_lowercase(s : String) -> String {
  let buf = StringBuilder::new()
  let n = s.length()
  let mut i = 0
  while i < n {
    let c = char_at(s, i)
    if c >= 'A' && c <= 'Z' {
      buf.write_char((c.to_int() + 32).unsafe_to_char())
    } else {
      buf.write_char(c)
    }
    i = i + 1
  }
  buf.to_string()
}

///| ASCII case-insensitive equality.
fn ascii_eq_ci(a : String, b : String) -> Bool {
  if a.length() != b.length() {
    return false
  }
  let n = a.length()
  let mut i = 0
  while i < n {
    let ca = char_at(a, i)
    let cb = char_at(b, i)
    let ca_lo = if ca >= 'A' && ca <= 'Z' {
      (ca.to_int() + 32).unsafe_to_char()
    } else {
      ca
    }
    let cb_lo = if cb >= 'A' && cb <= 'Z' {
      (cb.to_int() + 32).unsafe_to_char()
    } else {
      cb
    }
    if ca_lo != cb_lo {
      return false
    }
    i = i + 1
  }
  true
}

///| Decode a single UTF-16 code unit at `i` into a `Char`. Mirrors the helper
/// in the `decimal` package; both packages keep their own private copy since
/// the inputs they process — decimal grammar and dectest format — are
/// ASCII-only and don't justify exporting the helper.
fn char_at(s : String, i : Int) -> Char {
  s[i].to_int().unsafe_to_char()
}
