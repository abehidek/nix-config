{ lib, config, pkgs, unstable, ... }: {
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
      htop
    ];
    sessionVariables = {
      TEST = "123";
    };
  };
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };
  # programs.ncmpcpp.enable = true;
}
