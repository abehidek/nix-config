{ config, pkgs, ... }:
let
  colorscheme = import ../theme/colorscheme;
in {
  # imports = [
  #   ../../xdg
  # ];
  environment = {
    systemPackages = with pkgs; [];
  };
  users.users.abe.shell = pkgs.zsh;
  home-manager.users.abe = {
    programs.zsh = {
      enable = true;
      history = {
        size = 5000;
        path = "$HOME/.local/share/zsh/history";
      };
      oh-my-zsh = {
        enable = true;
        theme = "robbyrussell";
      };
    };
  };
}