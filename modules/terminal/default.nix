{ config, pkgs, ... }:
let
  colorscheme = import ../theme/colorscheme;
in {
  imports = [
    ./zsh
    ./kitty
  ];
  environment = {
    variables.EDITOR = "nvim";
    variables.TERM = "kitty";
    systemPackages = with pkgs; [
      ranger nnn vifm # File Managers
      file 
      librsvg 
      mpv 
      kitty
      feh w3m
      neofetch
    ];
  };
  programs.tmux.terminal = "screen-256color";
  home-manager.users.abe = {
    home = {
      file = {
        ".config/ranger/rc.conf".source = ./ranger/rc.conf;
        ".config/ranger/rifle.conf".source = ./ranger/rifle.conf;
        ".config/ranger/commands.py".source = ./ranger/commands.py;
        ".config/ranger/scope.sh".source = ./ranger/scope.sh;
      };
    };
    # programs.ncmpcpp.enable = true;
  };
}