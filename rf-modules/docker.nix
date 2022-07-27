
{ lib, config, pkgs, unstable, name, user, ... }:
with lib;
let cfg = config.services.docker;
in {
  options.services.docker = {
    enable = mkEnableOption "Docker Virtualisation";
    user = mkOption {
      type = types.str;
      default = "";
    };
  };

  config = mkIf cfg.enable {
    virtualisation.docker.enable = true;
    users.users.${cfg.user}.extraGroups = ["docker"];
  };
}
