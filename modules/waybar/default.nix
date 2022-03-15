{ lib, config, pkgs, ... }:
let 
  theme = import ../theme;
in 
{
  environment = {
    systemPackages = with pkgs; [];
  };
  home-manager.users.abe = {
    home = {
      file = {
        ".config/waybar/config".source = ./waybar.sh;
        ".config/waybar/style.css".source = ./style.css;
      };
      # programs.ranger = {

      # };
    };
  };
}