{ config, pkgs, ... }:
let
  ulauncher-theme = pkgs.fetchFromGitHub {
    owner = "vincens2005";
    repo = "dark_trans";
    rev = "dbc72b7cc7aa61c68268c6435b8848b2d411091f";
    sha256 = "0rjcdidarx37j7z0csgbj6y04j5dizkizsapcf6gqssm4rnc5ckv";
    leaveDotGit = true;
  };
  homeDir = "/home/abe";
in {
  imports = [
    (import "${home-manager}/nixos")

    ../modules/wm/sway.nix # Sway Window Manager
    ../modules/development # Dev settings
  ];

  users.users.abe = {
    isNormalUser = true;
    initialPassword = "password";
    shell = pkgs.zsh;
    extraGroups =
      [ "wheel" "doas" "video" "audio" "jackaudio" "networkmanager" "libvirtd" ];
  };

  nixpkgs.config.chromium.commandLineArgs =
    "---enable-features=UseOzonePlatform --ozone-platform=wayland -enable-features=VaapiVideoDecoder";

  home-manager.users.abe = {
    home.stateVersion = "21.11";
    home.username = "abe";
    home.homeDirectory = "${homeDir}";
    programs.home-manager.enable = true;

    nixpkgs.config.allowUnfree = true;
    home.packages = with pkgs; [
      # GUI Applications
      exodus
      signal-desktop
      vlc
      libreoffice
      gnome.nautilus
      ungoogled-chromium
      brave
      # unstable.tetrio-desktop
      shared-mime-info
      obsidian
      ulauncher
    ];
    home.file = {
      # ".config/ulauncher/user-themes/dark_trans".source = ulauncher-theme;
      ".local/share/applications".source = ../modules/applications;
      ".icons".source = ../modules/icons;
    };

    services.dropbox.enable = true;
  };
}
