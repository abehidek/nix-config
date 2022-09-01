{ lib, config, pkgs, unstable, name, user, ... }:
with lib;
let cfg = config.modules.desktop;
in {
  options.modules.desktop = {
    enable = mkEnableOption "Install a Graphic Interface";
    environment = mkOption {
      type = types.enum ["sway" "xmonad" "hyprland" "kde" "hyprland"];
      default = "sway";
      description = ''
        Define the type of the graphic interface protocol, it may be x11 or wayland
      '';
    };
  };

  config = mkIf cfg.enable {
    # programs.qt5ct.enable = true;
    services.xserver = mkIf (cfg.environment == "kde") {
      enable = true;
      displayManager.sddm.enable = true;
      desktopManager.plasma5.enable = true;
    };
    environment.loginShellInit = mkIf (cfg.environment == "hyprland") ''
      if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
        exec Hyprland
      fi
    '';
    programs = {
      hyprland = mkIf (cfg.environment == "hyprland") {
        enable= true;
      };
      sway = mkIf (cfg.environment == "sway")  {
        enable = true;
        wrapperFeatures.gtk = true;
        extraPackages = with pkgs; [
          xwayland
          wl-clipboard
          swayidle
          waybar
          wlr-randr
          wdisplays
          mako
          autotiling
          waypipe
          drm_info
          grim
          slurp
          jq
          libnotify
          sway-contrib.grimshot
        ];
      };
    };
  };
}
