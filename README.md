# decimal

Arbitrary-precision decimal arithmetic for MoonBit.

[![mooncakes.io](https://img.shields.io/badge/mooncakes.io-moonbit-community%2Fdecimal-blue)](https://mooncakes.io/docs/moonbit-community/decimal)
[![MoonBit library](https://img.shields.io/badge/MoonBit-library-blue.svg)](https://www.moonbitlang.com/)
[![License: Apache-2.0](https://img.shields.io/badge/license-Apache--2.0-green.svg)](LICENSE)

## Overview

`moonbit-community/decimal` is an arbitrary-precision decimal arithmetic library for
[MoonBit](https://www.moonbitlang.com/). It implements the
[General Decimal Arithmetic specification](https://speleotrove.com/decimal/decarith.html)
(v1.70, Mike Cowlishaw / IBM — the decimal arithmetic of IEEE 754-2008):
base-10 arithmetic with exact representation of decimal
fractions, correct rounding, and the full set of status flags and special
values (+0/-0, +/-Infinity, quiet NaN, and signaling NaN).

Unlike binary floating point, `0.1 + 0.2` is exactly `0.3`. Each context-aware
operation takes an explicit `Context` (precision, rounding mode, exponent
bounds) and returns its result paired with the status `Flags` it raised — no
hidden mutable state — so arithmetic is deterministic and the same code can
target `decimal32`, `decimal64`, `decimal128`, or an unbounded exact context.
For quick math, the `+` `-` `*` `/` operators work directly under a fixed
default context.

## Installation

Add the module from the [MoonBit registry](https://mooncakes.io/docs/moonbit-community/decimal):

```shell
moon add moonbit-community/decimal
```

Then import it from your package manifest:

```moonbit
import {
  "moonbit-community/decimal",
}
```

## Examples

```moonbit
let a = @decimal.Decimal::parse("0.1")
let b = @decimal.Decimal::parse("0.2")

// Operators evaluate under a fixed default context — handy for quick math.
println(a + b) // 0.3   (exact, not 0.30000000000000004)

// The explicit-context methods return the result *and* the flags they raised.
let ctx = @decimal.Context::decimal64()
let (sum, flags) = a.add(b, ctx)
println(sum) // 0.3
println(flags.inexact) // false

// Money: round a product to two fractional digits.
let price = @decimal.Decimal::parse("19.99")
let qty = @decimal.Decimal::from_int(3)
let (subtotal, _) = price.multiply(qty, ctx)
let (total, _) = subtotal.quantize(@decimal.Decimal::parse("0.01"), ctx)
println(total) // 59.97
```

## Operations

Each context-aware method takes a `Context` as the final argument and returns
`(Decimal, Flags)` — the result paired with the status flags that computation
raised (`Flags::combine` folds them across a sequence). The `+` `-` `*` `/` and
unary `-` operators are conveniences over these, evaluated under a fixed
`decimal128` context with a fresh flag set per call.

- **Arithmetic**: `add` `subtract` `multiply` `divide` `divide_int`
  `remainder` `fma` `abs` `minus` `plus`
- **Comparison**: `compare` `compare_signal` `compare_total`
  `compare_total_magnitude` `max` `min` `max_magnitude` `min_magnitude`
  `same_quantum`
- **Rounding / scaling**: `quantize` `rescale` `reduce` `scaleb`
  `to_integral_value` `to_integral_exact` `finalize`
- **Exponent / digits**: `shift` `rotate` `next_plus` `next_minus`
  `next_toward`
- **Logical** (digit-wise on `0`/`1` strings): `logical_and` `logical_or`
  `logical_xor` `logical_invert`
- **Mathematical** (correctly rounded): `sqrt` `exp` `ln` `log10` `power`
- **Copy / sign** (no rounding): `copy` `copy_abs` `copy_negate`
  `copy_sign` `canonical`
- **Classification**: `is_finite` `is_infinite` `is_nan` `is_signaling`
  `is_zero` `is_normal` `is_subnormal` `is_canonical` `number_class`

See [`src/pkg.generated.mbti`](src/pkg.generated.mbti) for the full
signatures.

## Conversions

Convert between `Decimal` and the machine numeric types:

- **From strings**: `parse(s)` (exact; raises `ParseError` on bad input) and
  `from_string(s, ctx)` (GDA *to-number*: rounds to the context and returns
  `(Decimal, Flags)`, yielding `NaN` with `conversion_syntax` set on bad input)
- **From** (exact, total): `from_int` `from_int64` `from_bigint` `from_double`
- **To integer** (partial — `None` for non-finite, non-integer, or
  out-of-range values, never a silent truncation): `to_int` `to_int64`
  `to_bigint`
- **To `Double`** (total but lossy; saturates to +/-Infinity past range):
  `to_double`
- **To `String`**: `to_sci_string` (GDA to-scientific-string, also the `Show`
  rendering) and `to_eng_string` (engineering notation, exponent a multiple of
  three)

`Decimal` implements `Eq`, `Compare`, and `Hash` by **numeric value**, so values
sort, dedupe, and serve as map keys directly: `1.0` and `1.00` compare and hash
equal, `-0` equals `+0`, and `NaN` sorts below everything. For the
specification's signalling, cohort-distinguishing comparisons use the explicit
`compare` / `compare_signal` / `compare_total` methods.

`from_double` keeps the double's exact binary value in canonical form, so
`from_double(0.1)` is
`0.1000000000000000055511151231257827021181583404541015625`. For the short,
human-facing form, parse the rendered string instead:
`Decimal::parse(d.to_string())`. To narrow a non-integer to an integer, round
first with `to_integral_value` / `to_integral_exact`.

To build a value with an explicit exponent (a coefficient × 10ᵉ), use
`try_finite(coef, exp, negative?) -> Decimal?` (e.g. `try_finite(150N, -2)` is
`1.50`; `None` if the coefficient is negative — the sign lives in `negative`),
or `unsafe_finite` when you already uphold that invariant.

`Decimal` also implements `ToJson` / `@json.FromJson`, serializing as the GDA
string so values round-trip exactly (JSON numbers are binary64 and would lose
precision).

### Interchange Encoding

IEEE 754 / GDA decimal interchange encodings are available as uppercase
network-byte-order hexadecimal strings:

- Decode: `from_decimal32_hex` `from_decimal64_hex` `from_decimal128_hex`
- Encode: `to_decimal32_hex` `to_decimal64_hex` `to_decimal128_hex`

Encoding returns `(hex, Flags)` after rounding/clamping into the selected
format. Decoding is exact and returns `None` for malformed hex strings.

## Tests

The operation tests under [`src/tests/`](src/tests/) embed the IBM `.decTest`
conformance corpora.

```shell
# Run the full test suite
moon test

# Control parallelism
moon test -j 8

# Run tests for one operation package
moon test src/tests/divide

# Run tests from one file
moon test src/tests/parse/parse_test.mbt

```

Microbenchmarks (small/large arithmetic, conversion, format, math functions)
live in [`src/tests/benchmarks/`](src/tests/benchmarks/):

```shell
moon bench -p moonbit-community/decimal/tests/benchmarks
```

## Development

A Nix flake provides a dev shell with the MoonBit toolchain and a C compiler:

```shell
nix develop      # or: direnv allow
moon check
```

Without Nix, install the [MoonBit toolchain](https://www.moonbitlang.com/download)
directly and run the same `moon` commands.

### Layout

| Path | Contents |
| --- | --- |
| [`src/`](src/) | the library (one file per operation family) |
| [`src/dectest/`](src/dectest/) | the `.decTest` parser/runner harness (no test data) |
| [`src/tests/`](src/tests/) | per-operation packages embedding the IBM corpora |

## License

Apache-2.0. See [`LICENSE`](LICENSE).
