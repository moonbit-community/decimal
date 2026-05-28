///| Decode a single UTF-16 code unit at `i` into a `Char`. Only correct for
/// the ASCII subset of any input; non-BMP / surrogate inputs are out of scope
/// for the call sites that use this helper (decimal grammar + dectest format
/// are ASCII-only).
fn char_at(s : String, i : Int) -> Char {
  s[i].to_int().unsafe_to_char()
}
