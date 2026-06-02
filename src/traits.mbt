// ---------------------------------------------------------------------------
// Numeric Eq / Compare / Hash: a Decimal is a first-class comparable,
// sortable, hashable value.
//
// Equality, ordering, and hashing compare by numeric value: `1.0` and `1.00`
// are equal, `-0` and `+0` are equal, and every cohort of a value hashes
// alike. NaN is reflexive (`NaN == NaN`) and ordered below every other value,
// which makes `Compare` a genuine total order — safe for sorting and for use
// as a map key. The signalling, value-only comparison defined by the
// arithmetic specification stays available as the explicit `compare` /
// `compare_signal` methods.
// ---------------------------------------------------------------------------

///|
/// Total numeric order with NaN ordered below everything (and equal to
/// itself). `-0`/`+0` and differing cohorts of one value compare equal,
/// matching the numeric `Eq`/`Hash` below.
fn numeric_total_cmp(a : Decimal, b : Decimal) -> Int {
  let a_nan = a.class is (QNaN | SNaN)
  let b_nan = b.class is (QNaN | SNaN)
  if a_nan && b_nan {
    0
  } else if a_nan {
    -1
  } else if b_nan {
    1
  } else {
    compare_numeric_int(a, b)
  }
}

///|
/// Numeric equality: `1.0 == 1.00`, `-0 == +0`, and `NaN == NaN` (reflexive,
/// so the impl is lawful with `Hash`). Use `compare_signal` for the
/// signalling, non-reflexive NaN semantics.
pub impl Eq for Decimal with fn equal(self, other) {
  numeric_total_cmp(self, other) == 0
}

///|
/// Total numeric order (NaN lowest). Consistent with `Eq`: `compare == 0`
/// exactly when `==`.
pub impl Compare for Decimal with fn compare(self, other) {
  numeric_total_cmp(self, other)
}

///|
/// Hash consistent with the numeric `Eq`: every cohort of a value hashes the
/// same (trailing zeros stripped), all zeros hash alike regardless of sign,
/// and all NaNs hash alike.
pub impl Hash for Decimal with fn hash_combine(self, hasher) {
  match self.class {
    QNaN | SNaN => hasher.combine_int(0)
    Infinity => {
      hasher.combine_int(1)
      hasher.combine_int(if self.negative { 1 } else { 0 })
    }
    Finite =>
      if self.coefficient.is_zero() {
        hasher.combine_int(2)
      } else {
        let (coef, exp) = strip_trailing_zeros(
          self.coefficient,
          self.exponent,
          _ => true,
        )
        hasher.combine_int(3)
        hasher.combine_int(if self.negative { 1 } else { 0 })
        hasher.combine(coef)
        hasher.combine_int(exp)
      }
  }
}

// ---------------------------------------------------------------------------
// Arithmetic operators.
//
// `+ - * /` and unary `-` are a convenience over the explicit-context methods.
// Each evaluates under the *active* context: the `decimal128` baseline by
// default, or whatever context the enclosing `with_context` block installed.
// Outside a block every operator gets a fresh flag set and touches no shared
// state; inside a block, operators accumulate their flags into the block's
// context so `with_context` can hand them back. Reach for `add(_, ctx)` etc.
// when you want a one-off precision or to observe flags without a block.
// ---------------------------------------------------------------------------

///|
/// The baseline context for the arithmetic operators when no `with_context`
/// block is active: a fresh `decimal128` (precision 34, half-even). Override it
/// for a dynamic extent with `with_context`.
pub fn default_context() -> Context {
  Context::decimal128()
}

///|
/// Context installed by the innermost active `with_context` block. `None` means
/// no block is active and the operators fall back to `default_context()`.
let active_ctx_slot : Ref[Context?] = { val: None }

///|
/// The context the arithmetic operators currently evaluate under: the active
/// `with_context` context if a block is running, else a fresh `default_context`.
fn active_context() -> Context {
  match active_ctx_slot.val {
    Some(ctx) => ctx
    None => default_context()
  }
}

///|
/// Run `f` with the arithmetic operators (`+ - * /`, unary `-`) evaluating
/// under `ctx` for the dynamic extent of the call, then restore the previously
/// active context. Returns `f`'s result together with the status flags every
/// operator inside the block accumulated.
///
/// The caller's own `ctx` value is never mutated: the block runs on a fresh
/// copy with cleared flags. Blocks nest — an inner `with_context` restores the
/// outer context on exit, not the global default.
///
/// ```
/// let (sum, _flags) = with_context(Context::decimal64(), fn() {
///   Decimal::from_int(1) + Decimal::from_int(2) // evaluated at 16-digit decimal64
/// })
/// ```
pub fn[T] with_context(ctx : Context, f : () -> T) -> (T, Flags) {
  let installed = { ..ctx, flags: Flags::new() }
  let saved = active_ctx_slot.val
  active_ctx_slot.val = Some(installed)
  let result = f()
  active_ctx_slot.val = saved
  (result, installed.flags)
}

///|
pub impl Add for Decimal with fn add(self, other) {
  Decimal::add_raw(self, other, active_context())
}

///|
pub impl Sub for Decimal with fn sub(self, other) {
  self.subtract_raw(other, active_context())
}

///|
pub impl Mul for Decimal with fn mul(self, other) {
  self.multiply_raw(other, active_context())
}

///|
pub impl Div for Decimal with fn div(self, other) {
  self.divide_raw(other, active_context())
}

///|
pub impl Neg for Decimal with fn neg(self) {
  self.minus_raw(active_context())
}
