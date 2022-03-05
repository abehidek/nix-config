{ lib, config, pkgs, ... }:
{
  environment = {
    systemPackages = with pkgs; [];
  };
  home-manager.users.abe = {
    home = {
      packages = with pkgs; [
        pfetch
      ];
      file = {
        ".config/waybar/config".source = ./waybar.sh;
        ".config/waybar/style.css".source = ./style.css;
      };
      # programs.ranger = {

      # };
    };
  };
}