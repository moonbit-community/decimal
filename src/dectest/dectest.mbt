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
}

///| Parse the full text of a `.decTest` source into test cases. Skips blank
/// lines and comment lines (`--` to end of line). `precision:` and
/// `rounding:` directives are tracked across the file so each emitted
/// `TestCase` reports the context in scope for it.
pub fn parse_dectest(text : String) -> Array[TestCase] {
  let cases = Array::new()
  let mut current_precision = 0
  let mut current_rounding = Rounding::HalfEven
  for raw in text.split("\n") {
    let line = strip_dectest_comment(raw.to_owned())
    let trimmed = line.trim().to_owned()
    if trimmed.is_empty() {
      continue
    }
    // Directive line: has ':' but no '->'.
    if !trimmed.contains("->") && trimmed.contains(":") {
      match parse_directive(trimmed) {
        Some(("precision", value)) =>
          try @string.parse_int(value[:]) catch {
            _ => ()
          } noraise {
            n => current_precision = n
          }
        Some(("rounding", value)) =>
          match parse_rounding_name(value) {
            Some(r) => current_rounding = r
            None => ()
          }
        _ => ()
      }
      continue
    }
    match parse_dectest_line(trimmed) {
      Some(c) =>
        cases.push({
          ..c,
          precision: current_precision,
          rounding: current_rounding,
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

///| Dispatch one case to its handler based on `op`. Compares the rendered
/// result against `expected`.
fn run_one(case : TestCase) -> CaseOutcome {
  let actual = try compute(case) catch {
    msg => return Fail("\{case.id}: \{case.op}: \{msg}")
  }
  match actual {
    None => Skip
    Some(s) =>
      if s == case.expected {
        Pass
      } else {
        Fail(
          "\{case.id}: \{case.op}(\{format_operands(case.operands)}) = \{s}, expected \{case.expected}",
        )
      }
  }
}

///| Compute the result string for `case`. Returns `None` for ops we do not yet
/// handle. Raises a diagnostic string for parse failures or arity mismatches.
fn compute(case : TestCase) -> String? raise RunnerError {
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
  } else if ascii_eq_ci(case.op, "divideint") {
    Some(binary_ctx(case, Decimal::divide_int))
  } else if ascii_eq_ci(case.op, "remainder") {
    Some(binary_ctx(case, Decimal::remainder))
  } else if ascii_eq_ci(case.op, "comparetotal") {
    Some(binary(case, Decimal::compare_total))
  } else if ascii_eq_ci(case.op, "comparetotmag") {
    Some(binary(case, Decimal::compare_total_mag))
  } else if ascii_eq_ci(case.op, "samequantum") {
    Some(binary(case, Decimal::same_quantum))
  } else {
    None
  }
}

///| Apply a unary `Decimal -> Decimal` operator to the single operand and
/// render the result via `to_sci_string`.
fn unary(case : TestCase, op : (Decimal) -> Decimal) -> String raise RunnerError {
  if case.operands.length() != 1 {
    raise RunnerError("expects 1 operand, got \{case.operands.length()}")
  }
  let parsed = try Decimal::parse(case.operands[0]) catch {
    e => raise RunnerError("parse error: \{e}")
  }
  op(parsed).to_sci_string()
}

///| Apply a context-aware binary op (`(Decimal, Decimal, Context) -> Decimal`)
/// using a Context built from the test case's active precision and rounding
/// directives.
fn binary_ctx(
  case : TestCase,
  op : (Decimal, Decimal, Context) -> Decimal,
) -> String raise RunnerError {
  if case.operands.length() != 2 {
    raise RunnerError("expects 2 operands, got \{case.operands.length()}")
  }
  let lhs = try Decimal::parse(case.operands[0]) catch {
    e => raise RunnerError("parse error in operand 0: \{e}")
  }
  let rhs = try Decimal::parse(case.operands[1]) catch {
    e => raise RunnerError("parse error in operand 1: \{e}")
  }
  let ctx = Context::new(precision=case.precision, rounding=case.rounding)
  op(lhs, rhs, ctx).to_sci_string()
}

///| Apply a binary `Decimal, Decimal -> Decimal` operator to the two operands
/// and render the result via `to_sci_string`.
fn binary(
  case : TestCase,
  op : (Decimal, Decimal) -> Decimal,
) -> String raise RunnerError {
  if case.operands.length() != 2 {
    raise RunnerError("expects 2 operands, got \{case.operands.length()}")
  }
  let lhs = try Decimal::parse(case.operands[0]) catch {
    e => raise RunnerError("parse error in operand 0: \{e}")
  }
  let rhs = try Decimal::parse(case.operands[1]) catch {
    e => raise RunnerError("parse error in operand 1: \{e}")
  }
  op(lhs, rhs).to_sci_string()
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
