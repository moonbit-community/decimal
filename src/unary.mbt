///|
/// A `+0` carrying `d`'s exponent. `plus` / `minus` / `abs` are defined as
/// adding or subtracting this implied zero under the context; giving it the
/// operand's exponent keeps the ideal (unrounded) exponent unchanged, so the
/// operations only differ from the identity when rounding actually fires.
fn zero_like(d : Decimal) -> Decimal {
  { class: Finite, negative: false, coefficient: 0N, exponent: d.exponent }
}

///|
/// GDA `minus`: `subtract('0', N)` applied under the context — negate the
/// operand and round to precision, raising the usual flags (rounding →
/// `Inexact` / `Rounded`, plus overflow / subnormal / clamp via `finalize`).
///
/// NaN handling is explicit so the operand's NaN *sign and payload* propagate
/// unchanged — a NaN is never arithmetically negated — while a signaling NaN
/// raises `Invalid_operation` (and its payload is truncated to precision).
fn Decimal::minus_raw(self : Decimal, ctx : Context) -> Decimal {
  match self.class {
    SNaN => quiet_snan(self, ctx)
    QNaN => truncate_nan_payload(self, ctx)
    _ => Decimal::subtract_raw(zero_like(self), self, ctx)
  }
}

///|
/// GDA `plus`: `add('0', N)` applied under the context — round the operand to
/// precision (value and sign preserved) and raise the usual flags. As with
/// `minus`, a NaN propagates unchanged and a signaling NaN raises
/// `Invalid_operation`.
fn Decimal::plus_raw(self : Decimal, ctx : Context) -> Decimal {
  match self.class {
    SNaN => quiet_snan(self, ctx)
    QNaN => truncate_nan_payload(self, ctx)
    _ => Decimal::add_raw(zero_like(self), self, ctx)
  }
}

///|
/// GDA `abs`: `|N|` under the context — `minus` when the sign bit is set,
/// otherwise `plus`. NaN propagation wins over the absolute value, so a NaN's
/// sign is *not* cleared (e.g. `abs(-NaN22) = -NaN22`); a signaling NaN raises
/// `Invalid_operation`.
fn Decimal::abs_raw(self : Decimal, ctx : Context) -> Decimal {
  match self.class {
    SNaN => quiet_snan(self, ctx)
    QNaN => truncate_nan_payload(self, ctx)
    _ =>
      if self.negative {
        Decimal::minus_raw(self, ctx)
      } else {
        Decimal::plus_raw(self, ctx)
      }
  }
}

///|
pub fn Decimal::minus(self : Decimal, ctx : Context) -> (Decimal, Flags) {
  let ctx = { ..ctx, flags: Flags::new() }
  (self.minus_raw(ctx), ctx.flags)
}

///|
pub fn Decimal::plus(self : Decimal, ctx : Context) -> (Decimal, Flags) {
  let ctx = { ..ctx, flags: Flags::new() }
  (self.plus_raw(ctx), ctx.flags)
}

///|
pub fn Decimal::abs(self : Decimal, ctx : Context) -> (Decimal, Flags) {
  let ctx = { ..ctx, flags: Flags::new() }
  (self.abs_raw(ctx), ctx.flags)
}
