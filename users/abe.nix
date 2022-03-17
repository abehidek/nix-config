{ config, pkgs, ... }:
let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-21.11.tar.gz";
  unstable = import (builtins.fetchTarball https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz) { config = config.nixpkgs.config; };
in
{
  imports = [
    #  Home Manager
    (import "${home-manager}/nixos")

    # Modules used by the user
    ../modules/wm/sway.nix # Sway Window Manager
    ../modules/development # Dev settings
  ];

  # System's users
  users.users.abe = {
    isNormalUser = true;
    initialPassword = "password";
    shell = pkgs.zsh;
    extraGroups = [ 
      "wheel" "video" "audio" 
      "jackaudio" 
      "networkmanager"
    ];
  };
  
  nixpkgs.config.chromium.commandLineArgs = "--enable-features=VaapiVideoDecoder";
  
  home-manager.users.abe = {
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    home.stateVersion = "21.11";
    home.username = "abe";
    home.homeDirectory = "/home/abe";
    programs.home-manager.enable = true;

    # User packages
    nixpkgs.config.allowUnfree = true;
    home.packages = with pkgs;  [
      # GUI Applications
      exodus signal-desktop vlc ksnip libreoffice
      ungoogled-chromium brave #firefox
    ];

    # Services
    services.dropbox.enable = true;
  };
}
