// ---------------------------------------------------------------------------
// JSON serialization.
//
// A `Decimal` serializes as its GDA scientific string, not as a JSON number:
// JSON numbers are binary64 and cannot carry an arbitrary-precision decimal without loss.
// ---------------------------------------------------------------------------

///|
/// Encode as the GDA scientific string (e.g. `"1.50"`, `"-0"`, `"Infinity"`.)
pub impl ToJson for Decimal with fn to_json(self) {
  self.to_sci_string().to_json()
}

///|
/// Decode from a JSON string via `Decimal::parse`.
pub impl @json.FromJson for Decimal with fn from_json(json, path) {
  guard json is String(s) else {
    raise JsonDecodeError((path, "Decimal: expected a string"))
  }
  Decimal::parse(s) catch {
    e => raise JsonDecodeError((path, "Decimal: \{e}"))
  }
}
