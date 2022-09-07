{ lib, config, pkgs, unstable, name, user, ... }:
with lib;
let cfg = config.hm-modules.desktop;
in {
  imports = [
    ./hyprland/home.nix
    # ./sway
    ./term/home.nix
  ];

  options.hm-modules.desktop = {
  };

  config = (mkMerge [
  ]);
}
