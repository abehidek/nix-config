{ user }: { inputs, outputs, lib, config, pkgs, ... }:
let
  inherit (inputs.nix-colors.lib-contrib { inherit pkgs; }) gtkThemeFromScheme nixWallpaperFromScheme;
  userName = user;
  homePath = "/home/${userName}";
  colorScheme = inputs.nix-colors.colorSchemes.classic-dark;
in {
  imports = [
    inputs.misterio77.homeManagerModules.fonts
    inputs.nix-colors.homeManagerModule
  ] ++ (builtins.attrValues outputs.userModules);

  modules.user = {
    desktop = {
      hyprland = {
        rice = true;
        # wallpaper = ../../rsc/kyoushitsu.jpg;
        wallpaper = lib.mkDefault (nixWallpaperFromScheme {
          scheme = colorScheme;
          width = 1920;
          height = 1080;
          logoScale = 4;
        });
        waybar = true;
        colors = {
          enable = true;
          base16 = colorScheme.colors;
        };
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
      documents = "$HOME/doc";
      download = "$HOME/dwl";
      music = "$HOME/songs";
      desktop = "$HOME/ws";
      pictures = "$HOME/img";
      videos = "$HOME/vid";
    };
  };

  # Shell and Theme
  systemd.user.sessionVariables = {
    QT_QPA_PLATFORM = "wayland";
    QT_QPA_PLATFORMTHEME = "gtk2";
  };

  home.sessionVariables = {
    VISUAL = "hx";
    EDITOR = "hx";
  };

  home.file.".config/kdeglobals".text = ''
    [Colors:View]
    BackgroundNormal=#${colorScheme.colors.base00}
  '';

  programs = {
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

  gtk = {
    enable = true;
    theme = {
      name = "${colorScheme.slug}";
      package = gtkThemeFromScheme { scheme = colorScheme; };
    };
    iconTheme = {
      name = "Papirus";
      package = pkgs.papirus-icon-theme;
    };
  };

  qt = {
    enable = true;
    platformTheme = "gtk";
  };

  # Standalone Packages
  home.packages = with pkgs; [
    lazygit
    ncdu htop
    chromium
    insomnia
    discord webcord
    pcmanfm
    libsForQt5.dolphin
    libsForQt5.qt5.qtwayland
    qt6.qtwayland
    obsidian
  ];

  home.stateVersion = "21.11";
}
