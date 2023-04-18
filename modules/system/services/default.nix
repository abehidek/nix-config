{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.system.services;
in {
  imports = [
    ./virt-manager.nix
  ];

  options.modules.system.services = {
    keyring = {
      enable = mkEnableOption "Enables gnome-keyring for all users";
    };
    docker = {
      enable = mkEnableOption "Enables docker for all users";
      users = mkOption { type = types.listOf (types.str); };
      package = mkOption {
        type = types.package;
        default = pkgs.docker;
        description = "Docker package";
        example = "pkgs.docker";
      };
    };
  };

  config =
  let
    forAllUsers = genAttrs (cfg.docker.users);
  in (mkMerge [
    (mkIf cfg.keyring.enable {
      services.gnome.gnome-keyring.enable = true;
      environment.systemPackages = with pkgs; [ 
        gnome.seahorse
        gnome.gnome-keyring
        libsecret
      ];
    })
    (mkIf cfg.docker.enable {
      virtualisation.docker.enable = true;
      virtualisation.docker.package = cfg.docker.package;
      environment.systemPackages = with pkgs; [ docker-compose ];
      users.users = forAllUsers (user: {
        extraGroups = [ "docker" ];
      });
    })
  ]);
}