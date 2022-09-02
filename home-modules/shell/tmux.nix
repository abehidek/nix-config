{ lib, config, pkgs, unstable, name, user, ... }:
with lib;
let cfg = config.modules.shell.tmux;
in {
  imports = [];

  options.modules.shell.tmux = {
  };

  config = (mkMerge [
    {
    }
  ]);
}
