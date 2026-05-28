// NaN propagation and invalid-operation signalling helpers.

fn quiet_snan(d : Decimal, ctx : Context) -> Decimal {
  ctx.flags.invalid_operation = true
  { ..d, class: QNaN }
}

fn invalid_nan(ctx : Context) -> Decimal {
  ctx.flags.invalid_operation = true
  Decimal::nan()
}

///| Centralised NaN propagation. Returns `Some(d)` when one of the operands
/// is a NaN (with the appropriate quietening / signal); the caller then
/// short-circuits to that value. `None` lets the op continue with the
/// non-NaN code path.
fn propagate_nan(a : Decimal, b : Decimal, ctx : Context) -> Decimal? {
  match (a.class, b.class) {
    (SNaN, _) => Some(quiet_snan(a, ctx))
    (_, SNaN) => Some(quiet_snan(b, ctx))
    (QNaN, _) => Some(a)
    (_, QNaN) => Some(b)
    _ => None
  }
}
