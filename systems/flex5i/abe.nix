{ user }: { inputs, outputs, lib, config, pkgs, ... }:
let
  inherit (inputs.nix-colors.lib-contrib { inherit pkgs; }) gtkThemeFromScheme nixWallpaperFromScheme;
  userName = user;
  homePath = "/home/${userName}";
  colorScheme = inputs.nix-colors.colorSchemes.catppuccin-mocha;
in {
  imports = [
    inputs.misterio77.homeManagerModules.fonts
    inputs.nix-colors.homeManagerModule
  ] ++ (builtins.attrValues outputs.userModules);

  modules.user = {
    shell = {
      zsh.rice = true;
    };
    desktop = {
      theme = {
        enable = true;
        gtk = {
          enable = true;
          theme = {
            name = "${colorScheme.slug}";
            package = gtkThemeFromScheme { scheme = colorScheme; };
          };
          icon = {
            name = "Papirus";
            package = pkgs.papirus-icon-theme;
          };
        };
        qt = {
          enable = true;
          useGtkTheme = true;
          dolphinBgColor = "#${colorScheme.palette.base00}";
        };
      };
      hyprland = {
        rice = false;
        waybar = true;
        hyprpicker = true;
        shotman = true;
        swaylock = {
          enable = true;
          lockOnSleep = true;
        };
        wallpaper = {
          enable = true;
          utility = "swww";
          path = lib.mkDefault (nixWallpaperFromScheme {
            scheme = colorScheme;
            width = 1920;
            height = 1080;
            logoScale = 4;
          });
        };
        font = {
          family = "FiraCode Nerd Font";
          package = pkgs.nerdfonts.override { fonts = [ "FiraCode" ]; };
        };
        colorScheme = colorScheme.pallete;
      };
      notifications = {
        mako.enable = false; # Wayland notification daemon
      };
      term = {
        kitty = {
          enable = true;
          font = {
            enable = true;
            family = "FiraCode Nerd Font";
            package = pkgs.nerdfonts.override { fonts = [ "FiraCode" ]; };
          };
          colors = {
            enable = true;
            base16 = colorScheme.palette;
          };
        };
      };
    };
  };

  fontProfiles = {
    enable = true;
    monospace = {
      family = "FiraCode Nerd Font";
      package = pkgs.nerdfonts.override { fonts = [ "FiraCode" ]; };
    };
    regular = {
      family = "Fira Sans";
      package = pkgs.fira;
    };
  };

  fonts.fontconfig.enable = true;
  fonts.fontconfig.defaultFonts = {
    monospace = [
      "FiraCode Nerd Font"
      "IPAGothic"
    ];
    sansSerif = [
      "Fira Sans"
      "IPAPGothic"
    ];
    serif = [
      "DejaVu Serif"
      "IPAPMincho"
    ];
  };

  home = {
    username = userName;
    homeDirectory = homePath;
  };

  xdg = {
    enable = true;
    configHome = "${homePath}/.config";
    dataHome = "${homePath}/.local/share";
    cacheHome = "${homePath}/.cache";
    userDirs = {
      enable = true;
      documents = "${homePath}/doc";
      download = "${homePath}/dwl";
      music = "${homePath}/songs";
      desktop = "${homePath}/ws";
      pictures = "${homePath}/img";
      videos = "${homePath}/vid";
    };
    mimeApps = {
      enable = true;
      defaultApplications = {
        "inode/directory" = [ "nemo.desktop" ];
        "application/x-gnome-saved-search" = [ "nemo.desktop" ];
      };
    };
  };

  home.sessionVariables = {
    VISUAL = "hx";
    EDITOR = "hx";
  };

  dconf.settings = {
    "org/cinnamon/desktop/media-handling" = {
      automount = false;
      automount-open = false;
      autorun-never = true;
    };
  };

  programs = {
    librewolf = {
      enable = true;
      settings = {
        "identity.fxaccounts.enabled" = true;
        "services.sync.prefs.sync.browser.uiCustomization.state" = true;
      };
    };

    alacritty = {
      enable = true;
      settings = {
        font = {
          size = 14;
          normal.family = "Mononoki Nerd Font";
          normal.style = "Regular";
          bold.family = "Mononoki Nerd Font";
          bold.style = "Bold";
          italic.family = "Mononoki Nerd Font";
          italic.style = "Italic";
          bold_italic.family = "Mononoki Nerd Font";
          bold_italic.style = "Bold Italic";
        };
      };
    };

    nushell = {
      enable = true;
      environmentVariables = {
        VISUAL = "hx";
        EDITOR = "hx";
      };
      shellAliases = {
        sysc = "sudo nixos-rebuild switch --flake";
      };
    };
    starship = {
      enable = true;
      settings = {
        character = {
          success_symbol = "[λ](bold green)";
          error_symbol = "[λ](bold red)";
        };
      };
    };

    fzf = {
      enable = true;
      enableZshIntegration = true;
    };

    git = {
      enable = true;
      userName = "abehidek";
      userEmail = "hidek.abe@outlook.com";
      extraConfig = {
        init.defaultBranch = "main";
      };
    };

    gpg.enable = true;

    vscode.enable = true;

    firefox.enable = true;

    helix = {
      enable = true;
      package = pkgs.helix;
      languages = {
        language = [{
          name = "rust";
          auto-format = true;
        }];
      };
      settings = {
        theme = "base16";
        editor.file-picker = {
          hidden = false;
        };
        keys.normal = {
          y = ":clipboard-yank";
        };
      };
    };
  };

  services.nextcloud-client = {
    enable = true;
    startInBackground = true;
  };

  services.flameshot = {
    enable = true;
  };

  # Standalone Packages
  home.packages = with pkgs; [
    # Apps
    chromium
    insomnia
    discord webcord
    obsidian obs-studio
    nextcloud-client
    hardinfo
    mullvad-vpn
    libreoffice-qt
    portfolio
    beekeeper-studio
    # exodus
    bitwarden
    prismlauncher
    spacedrive
    floorp

    # Sys control
    pavucontrol
    libsForQt5.dolphin
    pcmanfm

    # CLI
    xdg-ninja # checks $HOME for unwanted files and dirs
    tldr # simplified man page
    lazygit
    ncdu # disk usage analyzer
    htop
    kickoff # rofi replacement
    bat # cat cmd replacement
    zellij # tmux replacement
    ripgrep # grep replacement
    wiki-tui # wikipedia
    uutils-coreutils

    # Fonts
    (nerdfonts.override { fonts = [ "Mononoki" ]; })
  ];

  home.stateVersion = "21.11";
}
