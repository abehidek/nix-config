{ lib, config, pkgs, unstable, ... }: {
  imports = [
    ./vscodium.nix
    ./desktop
    ./shell
    ./hardware
    ./services
  ];
}