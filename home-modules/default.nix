{ lib, config, pkgs, unstable, ... }: {
  imports = [
    ./desktop
    ./shell
    ./services
    ./editors
  ];
}