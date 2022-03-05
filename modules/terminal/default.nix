{ lib, config, pkgs, ... }:
{
  environment = {
    variables.EDITOR = "vim";
    systemPackages = with pkgs; [
      ranger 
      file 
      librsvg 
      mpv 
      kitty
      feh
    ];
  };
  home-manager.users.abe = {
    home = {
      packages = with pkgs; [
        pfetch
      ];
      file = {
        ".config/ranger/rc.conf".source = ./rc.conf;
        ".config/ranger/rifle.conf".source = ./rifle.conf;
        ".config/ranger/commands_full.py".source = ./commands_full.py;
        ".config/ranger/commands.py".source = ./commands.py;
        ".config/ranger/scope.sh".source = ./scope.sh;
      };
      # programs.ranger = {

      # };
    };
  };
}