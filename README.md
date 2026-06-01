# decimal

Arbitrary-precision decimal arithmetic for MoonBit.

[![MoonBit library](https://img.shields.io/badge/MoonBit-library-blue.svg)](https://www.moonbitlang.com/)
[![License: Apache-2.0](https://img.shields.io/badge/license-Apache--2.0-green.svg)](LICENSE)

## Overview

`dzmingli/decimal` is an arbitrary-precision decimal arithmetic library for
[MoonBit](https://www.moonbitlang.com/). It implements the **General Decimal
Arithmetic** specification (Mike Cowlishaw / IBM, the decimal arithmetic of
IEEE 754-2008): base-10 arithmetic with exact representation of decimal
fractions, correct rounding, and the full set of status flags and special
values (+0/-0, +/-Infinity, quiet NaN, and signaling NaN).

Unlike binary floating point, `0.1 + 0.2` is exactly `0.3`. Every operation is
parameterized by an explicit `Context` that carries precision, rounding mode,
exponent bounds, and accumulated status flags, so results are deterministic
and the same code can target `decimal32`, `decimal64`, `decimal128`, or an
unbounded exact context.

## Status

Early but well-tested. Every operation is checked against the full IBM
`.decTest` conformance corpora embedded under [`src/tests/`](src/tests/).

## Installation

After the package is published to the MoonBit registry, add the module:

```shell
moon add dzmingli/decimal
```

Then import it from your package manifest:

```moonbit
import {
  "dzmingli/decimal",
}
```

## Examples

```moonbit
let ctx = @decimal.Context::decimal64()

// 0.1 + 0.2 is exactly 0.3
let a = @decimal.Decimal::parse("0.1")
let b = @decimal.Decimal::parse("0.2")
let sum = a.add(b, ctx)
println(sum) // 0.3

// Money: keep two fractional digits
let price = @decimal.Decimal::parse("19.99")
let qty = @decimal.Decimal::of_int(3)
let total = price.multiply(qty, ctx).quantize(@decimal.Decimal::parse("0.01"), ctx)
println(total) // 59.97
```

## Operations

All arithmetic methods take an explicit `Context` as the final argument.

- **Arithmetic**: `add` `subtract` `multiply` `divide` `divide_int`
  `remainder` `fma` `abs` `minus` `plus`
- **Comparison**: `compare` `compare_signal` `compare_total`
  `compare_total_mag` `max` `min` `max_magnitude` `min_magnitude`
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

- **From** (exact, total): `of_int` `of_int64` `of_bigint` `of_double`
- **To integer** (partial — `None` for non-finite, non-integer, or
  out-of-range values, never a silent truncation): `to_int` `to_int64`
  `to_bigint`
- **To `Double`** (total but lossy; saturates to +/-Infinity past range):
  `to_double`
- **To `String`**: `to_sci_string` (GDA to-scientific-string, also the `Show`
  rendering)

`of_double` keeps the double's exact binary value in canonical form, so
`of_double(0.1)` is
`0.1000000000000000055511151231257827021181583404541015625`. For the short,
human-facing form, parse the rendered string instead:
`Decimal::parse(d.to_string())`. To narrow a non-integer to an integer, round
first with `to_integral_value` / `to_integral_exact`.

IEEE 754 decimal interchange (the densely-packed-decimal `decimal32` /
`decimal64` / `decimal128` bit-formats) is out of scope: this library provides
the specification's arithmetic semantics, not its storage encodings.

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

# Run only the index-th test in a single selected file
moon test src/tests/parse/parse_test.mbt --index 0
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
