{ lib, config, pkgs, ... }:
with lib;
let cfg = config.hm-modules.shell.direnv;
in {
  imports = [];

  options.hm-modules.shell.direnv = {
    enableForUser = mkEnableOption "Enable direnv for user";
  };

  config = mkIf cfg.enableForUser (mkMerge [
    {
      programs.direnv.enable = true;
      programs.direnv.nix-direnv.enable = true;
    }
  ]);
}
