# Home-Manager config for flex5i abe user

args@{ lib, config, pkgs, unstable, ... }: {
  home.stateVersion = "21.11";
  imports = [
    # ../../secrets
    # ../../modules/desktop/sway/home.nix
    # ../../modules/desktop/services/waybar/home.nix
    # ../../modules/desktop/services/rofi/home.nix
    # ../../modules/desktop/utils/swaylock/home.nix
    # ../../modules/themes/gtk/home.nix
  ];
  hm-modules = {
    services = {
      git = {
        enable = true;
        defaultBranch = "main";
      };
      gpg.enable = true;
    };
    shell = {
      zsh = {
        historySize = 5000;
        nixShellCompat = true;
        powerlevel10k = {
          enable = true;
          riceFolder = ../../config/p10k;
          instantPrompt = true;
        };
        oh-my-zsh = {
          enable = true;
          plugins = [ "git" "web-search" "copypath" "dirhistory" ];
        };
      };
      fzf.enable = true;
      ranger.enable = true;
      direnv.enableForUser = true;
    };
    desktop = {
      term = {
        kitty.enable = true;
      };
    };
    editors = {
      vim.enable = true;
      vscodium.enable = true;
      helix.enable = true;
    };
  };
  home.packages = with pkgs; [
    rustc cargo rustfmt clippy rust-analyzer gcc
    git-crypt
    beekeeper-studio
    file
    librsvg
    mpv
    feh
    onefetch
    neofetch
    lazygit
    tree
    ncdu
    htop
    # gnome.nautilus
    # exodus
    signal-desktop
    vlc
    wofi
    dolphin
    # libreoffice
    google-chrome
    obsidian
  ];
  home.sessionVariables = {
    VISUAL = "hx";
  };
  programs.firefox = { enable = true; };
  services.dropbox.enable = true;
}
