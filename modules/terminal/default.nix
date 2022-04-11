{ config, pkgs, ... }:
let colorscheme = import ../theme/colorscheme;
in {
  imports = [ ./zsh ./kitty ];
  environment = {
    variables.EDITOR = "nvim";
    variables.VISUAL = "nvim";
    variables.TERM = "kitty";
  };
  home-manager.users.abe = {
    home = {
      file = {
        ".config/ranger/rc.conf".source = ./ranger/rc.conf;
        ".config/ranger/rifle.conf".source = ./ranger/rifle.conf;
        ".config/ranger/commands.py".source = ./ranger/commands.py;
        ".config/ranger/scope.sh".source = ./ranger/scope.sh;
      };
      packages = with pkgs; [
        ranger # lf# File Manager
        file
        librsvg
        mpv
        kitty
        feh
        onefetch
        neofetch
        lazygit
        tree
        ncdu
      ];
    };
    programs.fzf = {
      enable = true;
      enableZshIntegration = true;
    };

    # programs.ncmpcpp.enable = true;
  };
}
