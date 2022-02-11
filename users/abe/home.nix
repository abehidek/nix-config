{ config, pkgs, ... }:

{
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
    github-desktop
    vscode
    #vscodium
    discord
    exodus
  ];
  home.file = {
    ".config/sway/config".text = import ./sway/sway.sh;
    ".config/waybar/config".text = import ./waybar/waybar.sh;
    ".config/waybar/style.css".text = import ./waybar/style.css;
  };
}
