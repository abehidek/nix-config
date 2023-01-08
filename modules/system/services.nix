{ config, lib, pkgs, ... }:

with lib;
let 
  cfg = config.modules.system.services;
in {
  options.modules.system.services = {
    docker = {
      enable = mkEnableOption "Enables docker for all users";
      users = mkOption { type = types.listOf (types.str); };
    };
  };

  config = 
  let 
    forAllUsers = genAttrs (cfg.docker.users);
  in (mkMerge [
    (mkIf cfg.docker.enable {
      virtualisation.docker.enable = true;
      environment.systemPackages = with pkgs; [ docker-compose ];
      users.users = forAllUsers (user: {
        extraGroups = [ "docker" ];
      });
    })
  ]);
}