{ lib, config, pkgs, unstable, name, user, ... }:
with lib;
let cfg = config.modules.desktop.sway;
in {
  options.modules.desktop.sway = {
    enable = mkEnableOption "Install and Enable Sway";
  };

  config = mkIf cfg.enable {
    programs.sway = {
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
}
