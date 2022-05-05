{ lib, config, pkgs, unstable, user, ... }: {
  home.username = "${user}";
  home.homeDirectory = "/home/${user}";

  home.packages = with pkgs; [ obs-studio ];
}
