{
  description = "Arbitrary-precision decimal library for MoonBit";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nur-dzming = {
      url = "github:DzmingLi/nur-packages";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nur-dzming }:
    let
      systems = [ "x86_64-linux" "aarch64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
      pkgsFor = system: import nixpkgs {
        inherit system;
        overlays = [ nur-dzming.overlays.default ];
      };
    in
    {
      devShells = forAllSystems (system:
        let pkgs = pkgsFor system; in
        {
          default = pkgs.mkShell {
            packages = [
              pkgs.moonbit
            ];
            shellHook = ''
              echo "decimal dev shell"
              echo "  moon: $(moon version 2>/dev/null || echo 'not found')"
            '';
          };
        });
    };
}
