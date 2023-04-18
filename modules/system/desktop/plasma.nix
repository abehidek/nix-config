{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.system.desktop;
in {
  imports = [];

  options.modules.system.desktop = {
    plasma = {
      enable = mkEnableOption "Enables gnome for all users";
    };
  };

  config = (mkMerge [
    (mkIf cfg.plasma.enable (mkMerge [
      {
        environment = {
          systemPackages = with pkgs; [
            xclip
            xorg.xrandr
            pfetch
          ];
        };
        services.xserver = {
          enable = true;
          desktopManager.plasma5.enable = true;
        };
      }
    ]))
  ]);
}
