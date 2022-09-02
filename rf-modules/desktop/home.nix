{ lib, config, pkgs, unstable, name, user, ... }:
with lib;
let cfg = config.modules.desktop;
in {
  imports = [
    ./hyprland
    ./sway
  ];

  options.modules.desktop = {
  };

  config = (mkMerge [
  ]);
}
