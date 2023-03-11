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
        programs.dconf.enable = true;
        systemd.services.upower.enable = true; # start upower service
        services = {
          gnome.gnome-keyring.enable = true;
          upower.enable = true; # install upower
          xserver = {
            enable = true;
            windowManager.xmonad = {
              enable = true;
              enableContribAndExtras = true;
            };
          };
        };
        environment.systemPackages = with pkgs; [
          xclip
          xorg.xrandr
        ];
      }
      (mkIf cfg.xmonad.rice {
        home-manager.users = forAllUsers (user: {
          home.packages = with pkgs; [
            dmenu
          ];
          xsession.windowManager.xmonad = {
            enable = true;
            enableContribAndExtras = true;
            config = ../../../config/xmonad-wm/app/Main.hs;
          };
        });
      })
    ]))
  ]);
}
