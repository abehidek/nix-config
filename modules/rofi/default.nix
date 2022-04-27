{ lib, config, pkgs, unstable, ... }:
{
  programs.rofi = {
    enable = true;
    package = unstable.rofi-wayland;
    terminal = "${pkgs.kitty}/bin/kitty";
    extraConfig = {
      modi = "drun, run, ssh";
    };
  };
}
