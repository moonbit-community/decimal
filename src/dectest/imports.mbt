///| Bring the decimal package's types into local scope so references in this
/// package — both the dectest runner and the embedded `_test.mbt` data files —
/// stay unqualified. Enum variant constructors come along with their parent
/// type; values (constructors, methods) are addressed through the type, e.g.
/// `Decimal::parse`, `Class::Finite`, `ParseError::Empty`.
pub using @decimal { type Decimal, type Class, type ParseError }
