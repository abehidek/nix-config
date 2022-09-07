# Home-Manager config for flex5i abe user

args@{ lib, config, pkgs, unstable, ... }: {
  home.stateVersion = "21.11";
  imports = [
    (import ../home.nix { inherit args; user = "abe"; })
    # ../../secrets

    ../../modules/editors/neovim/home.nix
    ../../modules/editors/vim/home.nix

    ../../modules/dev/home.nix

    # ../../modules/shell/home.nix
    # ../../modules/shell/zsh/home.nix
    # ../../modules/shell/kitty/home.nix

    # ../../modules/desktop/sway/home.nix
    # ../../modules/desktop/services/waybar/home.nix
    # ../../modules/desktop/services/rofi/home.nix
    # ../../modules/desktop/utils/swaylock/home.nix

    ../../modules/themes/gtk/home.nix
  ];
  hm-modules = {
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
  };
  # nixpkgs.config.allowUnfree = true;
  home.packages = with pkgs; [
    # CLI
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
    # GUI Applications
    # exodus
    signal-desktop
    vlc
    helix
    wofi
    dolphin
    libreoffice
    # brave
    # unstable.tetrio-desktop
    google-chrome
    obsidian
    # unstable.spacevim
    # unstable.neovim
  ];
  home.sessionVariables = {
    VISUAL = "nvim";
  };
  programs.firefox = { enable = true; };
  home.file = {
    # ".config/ulauncher/user-themes/dark_trans".source = ulauncher-theme;
    # ".local/share/applications".source = ../modules/applications;
    # ".icons".source = ../../modules/icons;
  };

  services.dropbox.enable = true;
}
