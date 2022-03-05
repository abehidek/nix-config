{ config, pkgs, ... }:
let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-21.11.tar.gz";
  unstable = import
    (builtins.fetchTarball https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz)
    { config = config.nixpkgs.config; };
in
{
  imports = [
    (import "${home-manager}/nixos")
  ];
  nixpkgs.config.chromium.commandLineArgs = "--enable-features=VaapiVideoDecoder";
  
  home-manager.users.abe = {
    # Home Manager needs a bit of information about you and the
    # paths it should manage.
    home.username = "abe";
    home.homeDirectory = "/home/abe";

    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    home.stateVersion = "21.11";

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;
    nixpkgs.config.allowUnfree = true;
    home.packages = with pkgs;  [
      neofetch
      github-desktop vscode
      exodus signal-desktop vlc ksnip
      ungoogled-chromium brave libreoffice #firefox
    ];
    services.dropbox.enable = true;
    home.file = {
      ".config/waybar/config".text = import ../../modules/waybar/waybar.sh;
      ".config/waybar/style.css".text = import ../../modules/waybar/style.css;
    };
  };
}