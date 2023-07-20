{ user }: { inputs, outputs, lib, config, pkgs, ... }:
let
  inherit (inputs.nix-colors.lib-contrib { inherit pkgs; }) gtkThemeFromScheme nixWallpaperFromScheme;
  userName = user;
  homePath = "/home/${userName}";
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
      term = {
        alacritty = {
          enable = true;
          font = {
            enable = true;
            family = "Mononoki Nerd Font";
            package = pkgs.nerdfonts.override { fonts = [ "Mononoki" ]; };
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
    irpf

    # Sys control
    pavucontrol
    libsForQt5.dolphin
    pcmanfm

    # CLI
    tldr # simplified man page
    lazygit
    ncdu # disk usage analyzer
  ];

  home.stateVersion = "21.11";
}
