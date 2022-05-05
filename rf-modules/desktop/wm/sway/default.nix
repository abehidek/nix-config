{ config, lib, pkgs, ... }: {
  programs.qt5ct.enable = true;
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
      phwmon
      grim
      slurp
      jq
      libnotify
      sway-contrib.grimshot
    ];
  };
}
