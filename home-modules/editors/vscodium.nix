{ lib, config, pkgs, unstable, name, user, ... }:
with lib;
let cfg = config.modules.editors.vscodium;
in {
  options.modules.editors.vscodium = {
  };

  config = {
  };
}
