{ lib, config, pkgs, unstable, ... }: {
  imports = [
    ./shell/home.nix
    ./desktop/home.nix
  ];
}