
{ lib, config, pkgs, unstable, name, user, ... }:
with lib;
let cfg = config.modules.docker;
in {
  options.modules.docker = {
    enable = utils.mkBoolOpt false;
    user = utils.mkOpt types.str "";
  };

  config = mkIf cfg.enable {
    virtualisation.docker.enable = true;
    users.users.${cfg.user}.extraGroups = ["docker"];
  };
}
