name = "moonbit-community/decimal"

version = "0.1.0"

license = "Apache-2.0"

description = "Arbitrary-precision decimal arithmetic for MoonBit"

readme = "README.md"

repository = "https://github.com/moonbit-community/decimal"

options(
  source: "src",
  exclude: [ "src/tests", "src/dectest", "flake.nix", "flake.lock" ],
)
