
{ lib, config, pkgs, unstable, name, user, ... }:
with lib;
let cfg = config.modules.zsh;
in {
  options.modules.zsh = {
    enable = utils.mkBoolOpt false;
    profileExtra = utils.mkOpt lines "";
  };

  config = mkIf cfg.enable {
    environment = { systemPackages = with pkgs; [ any-nix-shell ]; };
    users.defaultUserShell = pkgs.zsh;
  };
}
