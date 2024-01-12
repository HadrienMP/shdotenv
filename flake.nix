{
  description = "shdotenv";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages."${system}";
      in
      {
        devShells.default = pkgs.mkShell {
          packages = [
            pkgs.gnumake
          ];
        };
        packages.shdotenv =
          pkgs.stdenv.mkDerivation {
            name = "shdotenv";
            src = self;
            buildPhase = "make build";
            installPhase = "mkdir -p $out/bin; mv shdotenv $out/bin";
          };
        defaultPackage = self.packages.${system}.shdotenv;
      });
}
