{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.system.desktop;
in {
  options.modules.system.desktop = {
    xmonad = {
      enable = mkEnableOption "Enables xmonad for all users";
      rice = mkEnableOption "Rices xmonad using home-manager and other tools";
      users = mkOption { type = types.listOf (types.str); };
    };
  };

  config =
  let
    for = x: genAttrs (x);
    forAllUsers = for (cfg.xmonad.users);
  in (mkMerge [
    (mkIf cfg.xmonad.enable (mkMerge [
      {
        services.xserver = {
          enable = true;
          windowManager.xmonad = {
            enable = true;
            enableContribAndExtras = true;
          };
        };
      }
      (mkIf cfg.xmonad.rice {
        home-manager.users = forAllUsers (user: {
          home.packages = with pkgs; [
            dmenu
          ];
          xsession.windowManager.xmonad = {
            enable = true;
            enableContribAndExtras = true;
            config = ../../../config/xmonad/xmonad.hs;
          };
        });
      })
    ]))
  ]);
}
