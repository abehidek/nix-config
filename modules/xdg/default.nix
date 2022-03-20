{ config, pkgs, ... }:
{
environment.systemPackages = [ pkgs.xdg-utils ];
xdg = {
  portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-wlr xdg-desktop-portal-gtk ];
    gtkUsePortal = true;
  };
  mime.defaultApplications = {
    #"image/jpeg" = "chromium-browser.desktop";
    "inode/directory" = "ranger.desktop";
    "application/x-directory" = "ranger.desktop";
  };
};

home-manager.users.abe.xdg = 
let
  homeDirectory = "/home/abe";
in
{
  enable = true;
  userDirs = {
    documents = "$HOME/doc";
    download = "$HOME/dl";
    music = "$HOME/songs";
    desktop = "$HOME/ws";
  };
  configHome = "${homeDirectory}/.config";
  dataHome = "${homeDirectory}/.local/share";
  cacheHome = "${homeDirectory}/.cache";
};
}