{ lib, config, pkgs, unstable, name, user, ... }:
with lib;
let cfg = config.modules.shell.direnv;
in {
  imports = [];

  options.modules.shell.direnv = {
  };

  config = (mkMerge [
    { 
    }
  ]);
}
