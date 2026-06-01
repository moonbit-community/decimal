// ---------------------------------------------------------------------------
// JSON serialization.
//
// A `Decimal` serializes as its GDA scientific string, not as a JSON number:
// JSON numbers are binary64 and cannot carry an arbitrary-precision decimal
// (or its cohort / sign-of-zero / NaN payload) without loss. The string form
// round-trips exactly through `parse` / `to_sci_string`.
// ---------------------------------------------------------------------------

///|
/// Encode as the GDA scientific string (e.g. `"1.50"`, `"-0"`, `"Infinity"`,
/// `"NaN"`).
pub impl ToJson for Decimal with fn to_json(self) {
  self.to_sci_string().to_json()
}

///|
/// Decode from a JSON string via `Decimal::parse`. A non-string value, or a
/// string that isn't a valid GDA numeric literal, is a decode error.
pub impl @json.FromJson for Decimal with fn from_json(json, path) {
  guard json is String(s) else {
    raise @json.JsonDecodeError((path, "Decimal: expected a string"))
  }
  Decimal::parse(s) catch {
    e => raise @json.JsonDecodeError((path, "Decimal: \{e}"))
  }
}
