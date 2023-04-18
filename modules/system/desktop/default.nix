{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.system.desktop;
in {
  imports = [
    ./xmonad.nix
    ./hyprland.nix
    ./gnome.nix
    ./plasma.nix
  ];
}
