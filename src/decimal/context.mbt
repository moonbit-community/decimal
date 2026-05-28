// ---------------------------------------------------------------------------
// Arithmetic context: precision, rounding mode, accumulated status flags.
//
// This file introduces the arithmetic context shared by arithmetic operations.
// ---------------------------------------------------------------------------

///| GDA rounding modes for finite-result finalisation.
pub(all) enum Rounding {
  /// Round to nearest; on tie, round away from zero.
  HalfUp
  /// Round to nearest; on tie, round to the even kept-coefficient digit.
  /// IEEE 754 default; minimises bias across many round operations.
  HalfEven
  /// Round to nearest; on tie, round toward zero.
  HalfDown
  /// Always round away from zero.
  Up
  /// Always round toward zero (truncation).
  Down
  /// Round toward `+Infinity`.
  Ceiling
  /// Round toward `-Infinity`.
  Floor
  /// Round-half-to-even — but only kick in when the kept coefficient's last
  /// digit is `0` or `5`. Used in legal/financial contexts.
  ZeroFiveUp
} derive(Eq)

///|
pub impl Show for Rounding with fn to_string(self) {
  match self {
    HalfUp => "half_up"
    HalfEven => "half_even"
    HalfDown => "half_down"
    Up => "up"
    Down => "down"
    Ceiling => "ceiling"
    Floor => "floor"
    ZeroFiveUp => "05up"
  }
}

///| GDA status flags accumulated by Context-aware ops. All flags are set
/// additively (never cleared by an op); a sequence of ops reports whether
/// any of them triggered the signal.
pub(all) struct Flags {
  mut inexact : Bool
  mut rounded : Bool
  mut invalid_operation : Bool
  mut division_by_zero : Bool
  mut overflow : Bool
  mut underflow : Bool
  mut subnormal : Bool
  mut clamped : Bool
}

///| A fresh `Flags` with every signal cleared.
pub fn Flags::new() -> Flags {
  {
    inexact: false,
    rounded: false,
    invalid_operation: false,
    division_by_zero: false,
    overflow: false,
    underflow: false,
    subnormal: false,
    clamped: false,
  }
}

///| Arithmetic context — precision, rounding mode, exponent range, and
/// accumulated flags. Ops take a `Context` (with a no-precision default),
/// produce a result that has been rounded / clamped to fit, and side-channel
/// signals into the context's flags.
///
/// `precision == 0` means "no precision limit": the op produces an exact
/// result with as many digits as needed. This is the default so the existing
/// "exact" arithmetic surface keeps its current behaviour.
pub(all) struct Context {
  precision : Int
  rounding : Rounding
  e_min : Int
  e_max : Int
  /// When set, finite results with `exponent > etop = e_max - precision + 1`
  /// get their exponent folded down to `etop` by padding the coefficient
  /// with trailing zeros, and `clamped` is raised. Required for IEEE-754
  /// decimal{32,64,128} conformance; off by default so the bare GDA
  /// arithmetic surface preserves trailing-zero scale.
  clamp : Bool
  flags : Flags
}

///| Build a Context. Defaults: no precision cap, half-to-even rounding,
/// near-`Int.max` exponent range (effectively unbounded for dectest's range),
/// no clamp.
pub fn Context::new(
  precision~ : Int = 0,
  rounding~ : Rounding = HalfEven,
  e_min~ : Int = -999_999_999,
  e_max~ : Int = 999_999_999,
  clamp~ : Bool = false,
) -> Context {
  { precision, rounding, e_min, e_max, clamp, flags: Flags::new() }
}

///| Convenience: a context that performs no rounding and lets every result
/// pass through exactly. Mostly useful as a sentinel for "give me exact
/// arithmetic" callers.
pub fn Context::exact() -> Context {
  Context::new()
}

///| Raise status flags on the context. Flags are additive and never clear an
/// existing signal; these helpers make the side-channel explicit at call sites.
fn Context::raise_inexact(self : Context) -> Unit {
  self.flags.inexact = true
}

fn Context::raise_rounded(self : Context) -> Unit {
  self.flags.rounded = true
}

fn Context::raise_invalid_operation(self : Context) -> Unit {
  self.flags.invalid_operation = true
}

fn Context::raise_division_by_zero(self : Context) -> Unit {
  self.flags.division_by_zero = true
}

fn Context::raise_overflow(self : Context) -> Unit {
  self.flags.overflow = true
}

fn Context::raise_clamped(self : Context) -> Unit {
  self.flags.clamped = true
}
