{ nixpkgs, system, ... }:
let
  pkgs = import nixpkgs { inherit system; };
in
pkgs.mkShell {
  name = "meli devShell";

  nativeBuildInputs = with pkgs; [
    bashInteractive
  ];

  buildInputs = with pkgs; [
    git
    vitetris
  ];

  GIT_AUTHOR_NAME = "gabe_meli";
  GIT_AUTHOR_EMAIL = "guilherme.abe@mercadolivre.com";

  shellHook = ''

  '';
}
