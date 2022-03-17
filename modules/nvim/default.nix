{ config, pkgs, ... }:
let
  colorscheme = import ../theme/colorscheme;
  unstable = import (builtins.fetchTarball https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz) { config = config.nixpkgs.config; };
in
{
  # programs = {
  # };
  environment = {
        systemPackages = with pkgs; [];
  };
  home-manager.users.abe = {
    home.packages = [
      unstable.neovim
    ];
  };
}