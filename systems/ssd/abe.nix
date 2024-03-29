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
        enable = false;
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
        hyprpicker = true;
        shotman = true;
        swaylock = {
          enable = true;
          lockOnSleep = false;
        };
        wallpaper = {
          enable = true;
          path = lib.mkDefault (nixWallpaperFromScheme {
            scheme = colorScheme;
            width = 1920;
            height = 1080;
            logoScale = 4;
          });
          utility = "swaybg";
        };
        enableAnimations = false;
        font = {
          family = "FiraCode Nerd Font";
          package = pkgs.nerdfonts.override { fonts = [ "FiraCode" ]; };
        };
        colorScheme = colorScheme.colors;
      };
      notifications = {
        mako.enable = true;
      };
      term = {
        alacritty = {
          enable = true;
          font = {
            enable = true;
            family = "Hack Nerd Font";
            package = pkgs.nerdfonts.override { fonts = [ "Hack" ]; };
          };
        };
        kitty = {
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

  # Shell
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
      languages = {
        language = [{
          name = "rust";
          auto-format = false;
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

  # Standalone Packages
  home.packages = with pkgs; [
    # Apps
    chromium
    insomnia
    webcord # discord
    obsidian
    vlc

    # Sys control
    pavucontrol
    pcmanfm

    # CLI
    lazygit lf
    ncdu htop
    zellij
  ];

  home.stateVersion = "21.11";
}
