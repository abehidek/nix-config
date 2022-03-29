{ config, pkgs, ... }:
let
  colorscheme = import ../theme/colorscheme;
in {
  home.file = {
    ".config/swaylock/config".source = ./config.ini;
  };
}