
{ lib, config, pkgs, unstable, name, user, ... }:
with lib;
let cfg = config.modules.services.docker;
in {
  options.modules.services.docker = {
    enable = utils.mkBoolOpt false;
    users = mkOption {
      type = types.listOf (types.str);
    };
  };

  config = let forAllUsers = lib.genAttrs (cfg.users); in mkIf cfg.enable {
    virtualisation.docker.enable = true;
    environment.systemPackages = with pkgs; [ docker-compose ];
    users.users = forAllUsers (user: let 
      extraGroups = self."${user}".extraGroups;
      in {
        extraGroups = ["docker"];
      }
    );
  };
}
