{ nixpkgs, system, inputs, ... }:
let
  pkgs = nixpkgs.legacyPackages.${system};
in pkgs.mkShell {
  nativeBuildInputs = [ pkgs.bashInteractive ];
  inputsFrom = [ inputs.env.devShells.${system}.haskell ];
  buildInputs = with pkgs; [
    xorg.libX11
    xorg.libXrandr
    xorg.libXinerama
    xorg.libXScrnSaver
    xorg.libXext
    xorg.libXft
    pkg-config
  ];
}
