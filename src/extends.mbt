///|
pub extend Class with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend Class with Eq::{not_equal, equal}

///|
pub extend Class with Show::{to_string, output}

///|
pub extend Decimal with @moonbitlang/core/json.FromJson::{from_json}

///|
pub extend Decimal with Compare::{op_lt, op_le, op_ge, op_gt}

///|
pub extend Decimal with Div::{div}

///|
pub extend Decimal with Eq::{not_equal, equal}

///|
pub extend Decimal with Hash::{hash, hash_combine}

///|
pub extend Decimal with Mul::{mul}

///|
pub extend Decimal with Neg::{neg}

///|
pub extend Decimal with Show::{to_string, output}

///|
pub extend Decimal with Sub::{sub}

///|
pub extend Decimal with ToJson::{to_json}

///|
pub extend Flags with Eq::{not_equal, equal}

///|
pub extend ParseError with Eq::{not_equal, equal}

///|
pub extend ParseError with Show::{to_string, output}

///|
pub extend Rounding with Eq::{not_equal, equal}

///|
pub extend Rounding with Show::{to_string, output}
