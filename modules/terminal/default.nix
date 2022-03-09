{ lib, config, pkgs, ... }:
{
  environment = {
    variables.EDITOR = "vim";
    variables.TERM = "kitty";
    systemPackages = with pkgs; [
      ranger 
      file 
      librsvg 
      mpv 
      kitty
      xterm
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
        ".config/ranger/commands.py".source = ./commands.py;
        ".config/ranger/scope.sh".source = ./scope.sh;
      };
      # programs.ranger = {

      # };
    };
  };
}