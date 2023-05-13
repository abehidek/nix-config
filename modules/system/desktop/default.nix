{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.system.desktop;
in {
  imports = [
    ./xmonad.nix
    ./hyprland.nix
    ./gnome.nix
    ./plasma.nix
  ];

  options.modules.system.desktop = {
    udiskie = {
      enable = mkEnableOption "Enables udiskie";
      users = mkOption { type = types.listOf (types.str); };
    };
    displayManager = {
      tuigreet = {
        enable = mkEnableOption "Enables tuigreet through greetd for all users";
        defaultSessionCmd = mkOption {
          type = types.str;
          description = "The command to be executed after greetd logs in";
        };
      };
    };
  };

  config = let
    for = x: genAttrs (x);
    forAllUdiskieUsers = for (cfg.udiskie.users);
  in (mkMerge [
    (mkIf cfg.udiskie.enable (mkMerge [
      {
        services.udisks2.enable = true;
        home-manager.users = forAllUdiskieUsers (user: {
          home.packages = [ pkgs.hello pkgs.udiskie ];
          services.udiskie = {
            enable = true;
            automount = true;
            notify = true;
            tray =  "always";
          };
        });
      }
    ]))
    (mkIf cfg.displayManager.tuigreet.enable {
      systemd.services.greetd = {
        serviceConfig.type = "idle";
        unitConfig.After = [ "graphical.target" ];
      };
      services.greetd = {
        enable = true;
        settings = {
          default_session = {
            command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --cmd ${cfg.displayManager.tuigreet.defaultSessionCmd}";
          };
        };
      };
    })
  ]);
}
