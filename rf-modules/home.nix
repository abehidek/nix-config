{ lib, config, pkgs, unstable, ... }: {
  imports = [
    ./shell/home.nix
    ./desktop/home.nix
    ./services/home.nix
    ./editors/home.nix
  ];
}