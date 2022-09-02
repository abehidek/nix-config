{ lib, config, pkgs, unstable, name, user, ... }:
with lib;
let cfg = config.modules.desktop.sway;
in {
  options.modules.desktop.sway = {
  };

  config = {
  };
}
