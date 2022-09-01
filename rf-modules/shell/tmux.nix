{ lib, config, pkgs, unstable, name, user, ... }:
with lib;
let cfg = config.modules.shell.tmux;
in {
  imports = [];

  options.modules.shell.tmux = {
    enable = utils.mkBoolOpt false;
  };

  config = mkIf cfg.enable (mkMerge [
    {
      environment.systemPackages = with pkgs; [ tmux ];
    }
  ]);
}
