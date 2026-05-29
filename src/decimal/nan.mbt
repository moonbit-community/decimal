// NaN propagation and invalid-operation signalling helpers.

fn quiet_snan(d : Decimal, ctx : Context) -> Decimal {
  ctx.raise_invalid_operation()
  truncate_nan_payload({ ..d, class: QNaN }, ctx)
}

fn invalid_nan(ctx : Context) -> Decimal {
  ctx.raise_invalid_operation()
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
    (QNaN, _) => Some(truncate_nan_payload(a, ctx))
    (_, QNaN) => Some(truncate_nan_payload(b, ctx))
    _ => None
  }
}

///| Drop NaN-payload digits that won't fit in `precision`. GDA's rule:
/// the payload is treated like a coefficient, so when it has more than
/// `precision` digits the *leftmost* (most significant) ones are
/// discarded — e.g. precision 5 turns NaN123456789 into NaN56789.
fn truncate_nan_payload(d : Decimal, ctx : Context) -> Decimal {
  if ctx.precision <= 0 {
    return d
  }
  if digit_count(d.coefficient) <= ctx.precision {
    return d
  }
  let divisor = pow10(ctx.precision)
  { ..d, coefficient: d.coefficient % divisor }
}
