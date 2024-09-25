{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }: (flake-utils.lib.eachDefaultSystem (
    system: let
      pkgs = import nixpkgs {
        inherit system;
      };
      packages = with pkgs; [
        hugo
        go
      ];
    in {
      packages.default = pkgs.stdenv.mkDerivation {
        name = "weriomat-website";
        src = ./homepage;
        nativeBuildInputs = [pkgs.hugo];
        phases = ["unpackPhase" "buildPhase"];
        buildPhase = ''
          ${pkgs.hugo}/bin/hugo -s . -d "$out"
        '';
      };
      devShells = rec {
        default = dev;
        dev = pkgs.mkShell {
          buildInputs = packages;
        };
      };
    }
  ));
}
