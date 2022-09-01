{ args, user, ... }:
let
  inherit (args) lib config pkgs unstable;
  homeDir = "/home/${user}";
in {
  home.username = "${user}";
  home.homeDirectory = "${homeDir}";
  home.packages = with pkgs; [ obs-studio ];
  xdg = {
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
    configHome = "${homeDir}/.config";
    dataHome = "${homeDir}/.local/share";
    cacheHome = "${homeDir}/.cache";
  };
}
