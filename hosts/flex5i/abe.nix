# Home-Manager config for flex5i abe user

args@{ inputs, lib, config, pkgs, unstable, ... }: {
  home.stateVersion = "21.11";
  colorScheme = inputs.nix-colors.colorSchemes.solarized-dark;
  imports = [
    # ../../secrets
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
          enable = false;
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
      hyprland.rice = true;
      waybar.enable = true;
      rofi.enable = true;
      swaylock.enable = true;
      wallpaper.path = ../../assets/wallpapers/walking.jpg;
      term = {
        kitty.enable = true;
      };
    };
    editors = {
      vim.enable = false;
      vscodium.enable = false;
      helix.enable = true;
    };
  };
  home.packages = with pkgs; [
    inotify-tools elixir
    rustc cargo rustfmt clippy rust-analyzer gcc
    nodejs-16_x nodePackages.typescript-language-server
    (yarn.override { nodejs = nodejs-16_x;  })
    rnix-lsp
    git-crypt
    beekeeper-studio
    file
    librsvg
    mpv
    feh
    onefetch
    neofetch
    lazygit
    commitizen
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

  qt = {
    enable = true;
    platformTheme = "gtk";
  };

  home.sessionVariables = {
    VISUAL = "hx";
  };
  programs= {
    vscode = { enable = true; };
    starship = { enable = true; };
    firefox = {
      enable = true;
      package = pkgs.wrapFirefox pkgs.firefox-unwrapped {
        # forceWayland = true;
        extraPolicies = {
          ExtensionSettings = {};
        };
      };
    };
  };
  services.dropbox.enable = false;
}
