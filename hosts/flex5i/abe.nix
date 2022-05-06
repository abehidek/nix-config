# Home-Manager config for flex5i abe user

{ lib, config, pkgs, unstable, user, ... }: {
  # home.stateVersion = "21.11";
  home.username = user;
  home.homeDirectory = "/home/${user}";
  imports = [
    ../../secrets
    # ../../modules/waybar
    # ../../modules/waybar/wlogout
    # ../../modules/swaylock-effects
    # ../../modules/theme
    # ../../modules/theme/gtk
    ../../modules/rofi

    # rf-modules
    ../../rf-modules/desktop/sway/home.nix
    ../../rf-modules/editors/neovim/home.nix
    ../../rf-modules/dev/home.nix
    ../../rf-modules/shell/home.nix
    ../../rf-modules/shell/zsh/home.nix
    ../../rf-modules/shell/kitty/home.nix
    ../../rf-modules/desktop/services/waybar/home.nix
    ../../rf-modules/desktop/utils/swaylock/home.nix
    ../../rf-modules/themes/gtk/home.nix
  ];
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
    google-chrome
    shared-mime-info
    obsidian
  ];
  programs.firefox = { enable = true; };
  home.file = {
    # ".config/ulauncher/user-themes/dark_trans".source = ulauncher-theme;
    # ".local/share/applications".source = ../modules/applications;
    ".icons".source = ../../modules/icons;
  };

  services.dropbox.enable = true;
}
