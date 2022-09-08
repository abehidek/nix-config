{ lib, config, pkgs, unstable, name, user, ... }:
with lib;
let
  cfg = config.hm-modules.desktop.wallpaper;
  inherit (config.colorscheme) colors;
in {
  options.hm-modules.desktop.wallpaper = {
    path = mkOption { type = types.path; };
  };

  config = {
  };
}
