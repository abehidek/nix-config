
{ lib, config, pkgs, unstable, name, user, ... }:
with lib;
let cfg = config.modules.docker;
in {
  options.modules.docker = {
    enable = utils.mkBoolOpt false;
    users = mkOption {
      type = types.listOf (types.str);
    };
  };

  config = let forAllUsers = lib.genAttrs (cfg.users); in mkIf cfg.enable {
    virtualisation.docker.enable = true;
    users.users = forAllUsers (user: let 
      extraGroups = self."${user}".extraGroups;
      in {
        extraGroups = ["docker"];
      }
    );
  };
}
