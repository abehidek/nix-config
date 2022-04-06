{ config, pkgs, ... }: {
  environment.systemPackages = [ pkgs.xdg-utils ];
  xdg = {
    portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-wlr
        xdg-desktop-portal-gtk
      ];
      gtkUsePortal = true;
    };
    mime.defaultApplications = {
      "image/jpeg" = "feh.desktop";
      "image/png" = "feh.desktop";
      "inode/directory" = "nautilus.desktop";
      "application/x-directory" = "nautilus.desktop";
    };
  };

  home-manager.users.abe.xdg = let homeDirectory = "/home/abe";
  in {
    enable = true;
    userDirs = {
      enable = true;
      documents = "$HOME/doc";
      download = "$HOME/dl";
      music = "$HOME/songs";
      desktop = "$HOME/ws";
      pictures = "$HOME/img";
      videos = "$HOME/vid";
    };
    configHome = "${homeDirectory}/.config";
    dataHome = "${homeDirectory}/.local/share";
    cacheHome = "${homeDirectory}/.cache";
  };
}
