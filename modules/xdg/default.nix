{ pkgs, ... }:
{
home-manager.users.abe.xdg = 
let
  homeDirectory = "/home/abe";
in
{
  enable = true;
  configHome = "${homeDirectory}/.config";
  dataHome = "${homeDirectory}/.local/share";
  cacheHome = "${homeDirectory}/.cache";
  
  mimeApps.defaultApplications = {
    "inode/directory" = "org.gnome.Nautilus.desktop";
    # "" = "nautilus.desktop"
    # env XDG_UTILS_DEBUG_LEVEL=10  xdg-mime query default inode/directory
  };
  mimeApps.associations.removed = { 
    "inode/directory" = "code.desktop"; 
  };
};
}