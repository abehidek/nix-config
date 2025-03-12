{ nixpkgs, system, ... }:
let
  pkgs = import nixpkgs { inherit system; };
  my-helm = pkgs.wrapHelm pkgs.kubernetes-helm {
    plugins = with pkgs.kubernetes-helmPlugins; [
      helm-secrets
      helm-diff
      helm-s3
      helm-git
    ];
  };

  my-helmfile = pkgs.helmfile-wrapped.override { inherit (my-helm) pluginsDir; };
in
pkgs.mkShell {
  name = "helmfile devShell";

  nativeBuildInputs = with pkgs; [
    bashInteractive
  ];

  buildInputs = [
    my-helm
    my-helmfile
  ];

  shellHook = ''
    cd ./k3s
  '';
}
