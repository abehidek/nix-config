{ config, pkgs, ... }:
let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-21.11.tar.gz";
  unstable = import (builtins.fetchTarball https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz) { config = config.nixpkgs.config; };
in
{
  imports = [
    (import "${home-manager}/nixos")
  ];
  nixpkgs.config.chromium.commandLineArgs = "--enable-features=VaapiVideoDecoder";
  
  home-manager.users.abe = {
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    home.stateVersion = "21.11";
    home.username = "abe";
    home.homeDirectory = "/home/abe";

    programs.home-manager.enable = true;
    nixpkgs.config.allowUnfree = true;
    home.packages = with pkgs;  [
      # GUI Applications
      exodus signal-desktop vlc ksnip libreoffice
      ungoogled-chromium brave #firefox
    ];
    services.dropbox.enable = true;
  };
}