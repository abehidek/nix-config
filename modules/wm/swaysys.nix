{ pkgs, ... }:

{
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraPackages = with pkgs; [ wofi xwayland alacritty wl-clipboard swayidle waybar wlr-randr wdisplays mako autotiling waypipe swaylock-effects swaylock-fancy drm_info ];
  };
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-wlr xdg-desktop-portal-gtk ];
    gtkUsePortal = true;
  };
}