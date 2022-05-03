{ lib, config, pkgs, unstable, home-manager, ...}:
{
  # home.stateVersion = "21.11";
  home.username = "abe";
  home.homeDirectory = "/home/abe";
  # programs.home-manager.enable = true;
  imports = [ ../modules/nvim ];
  # nixpkgs.config.allowUnfree = true;
  home.packages = with pkgs; [
    # GUI Applications
    exodus
    signal-desktop
    vlc
    libreoffice
    # gnome.nautilus
    pcmanfm
    # brave
    # unstable.tetrio-desktop
    # google-chrome
    shared-mime-info
    obsidian
  ];
  programs.firefox = {
    enable = true;
  };
  home.file = {
    # ".config/ulauncher/user-themes/dark_trans".source = ulauncher-theme;
    # ".local/share/applications".source = ../modules/applications;
    ".icons".source = ../modules/icons;
  };

  services.dropbox.enable = true;
}
