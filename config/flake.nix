{
  description = "Shell environments for development";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    stable.url = "github:nixos/nixpkgs/nixos-22.11";
    abehidek.url = "github:abehidek/env.nix";
  };
  outputs = {
    self,
    nixpkgs,
    stable,
    abehidek,
    ...
  } @ inputs: let
    inherit (self) outputs;
    supportedSystems = [ "x86_64-linux" ];
    forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
  in rec {
    devShells = forAllSystems (system: {
      default = let
        pkgs = nixpkgs.legacyPackages.${system};
      in pkgs.mkShell {
        nativeBuildInputs = [ pkgs.bashInteractive ];
        inputsFrom = [ abehidek.devShells.${system}.haskell ];
        buildInputs = with pkgs; [
          xorg.libX11
          xorg.libXrandr
          xorg.libXinerama
          xorg.libXScrnSaver
          xorg.libXext
          xorg.libXft
          pkg-config
        ];
      };
    });
  };
}