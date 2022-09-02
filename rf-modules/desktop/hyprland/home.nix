{ lib, config, pkgs, unstable, name, user, ... }:
with lib;
let cfg = config.modules.desktop.hyprland;
in {
  options.modules.desktop.hyprland = {
  };

  config = {
  };
}
