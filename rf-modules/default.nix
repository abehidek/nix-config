{ lib, config, pkgs, unstable, ... }: {
  imports = [
    ./desktop
    ./shell
    ./hardware
    ./services
  ];
}