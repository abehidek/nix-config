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
          dolphinBgColor = "#${colorScheme.colors.base00}";
        };
      };
      hyprland = {
        rice = true;
        waybar = true;
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
        colorScheme = colorScheme.colors;
      };
      term.kitty = {
        enable = true;
        font = {
          enable = true;
          family = "FiraCode Nerd Font";
          package = pkgs.nerdfonts.override { fonts = [ "FiraCode" ]; };
        };
        colors = {
          enable = true;
          base16 = colorScheme.colors;
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
  };

  home.sessionVariables = {
    VISUAL = "hx";
    EDITOR = "hx";
  };

  programs = {
    nushell = {
      enable = true;
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
      languages = [
        { name = "rust"; auto-format = true; }
      ];
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

  # Standalone Packages
  home.packages = with pkgs; [
    # Apps
    chromium
    insomnia
    discord webcord
    obsidian

    # Sys control
    pavucontrol
    libsForQt5.dolphin
    pcmanfm

    # CLI
    lazygit
    ncdu htop
    bat # cat cmd replacement
    zellij # tmux replacement
    ripgrep # grep replacement
    wiki-tui # wikipedia
    uutils-coreutils
  ];

  home.stateVersion = "21.11";
}
