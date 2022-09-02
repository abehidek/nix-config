{ lib, config, pkgs, unstable, name, user, ... }:
with lib;
let cfg = config.modules.shell.zsh;
in {
  imports = [];

  options.modules.shell.zsh = {
  };

  config = (mkMerge [
    {
    }
  ]);
}
