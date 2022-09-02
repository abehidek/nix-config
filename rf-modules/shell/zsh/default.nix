{ lib, config, pkgs, unstable, name, user, ... }:
with lib;
let cfg = config.modules.shell.zsh;
in {
  imports = [];

  options.modules.shell.zsh = {
    enable = utils.mkBoolOpt false;
  };

  config = mkIf cfg.enable (mkMerge [
    {
      users.defaultUserShell = pkgs.zsh;
    }
  ]);
}
