{ lib, config, pkgs, ... }:
let
  colorscheme = import ../theme/colorscheme;
in {
  environment = {
    variables.EDITOR = "vim";
    variables.TERM = "kitty";
    systemPackages = with pkgs; [
      ranger 
      file 
      librsvg 
      mpv 
      kitty
      feh
      w3m
    ];
  };
  programs.tmux.terminal = "screen-256color";
  home-manager.users.abe = {
    home = {
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