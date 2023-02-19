{ user }: { inputs, outputs, lib, config, pkgs, ... }:
let
  userName = user;
  homePath = "/home/${userName}";
  colorScheme = inputs.nix-colors.colorSchemes.solarized-dark;
in {
  imports = [
    inputs.misterio77.homeManagerModules.fonts
    inputs.nix-colors.homeManagerModule
  ] ++ (builtins.attrValues outputs.userModules);

  modules.user = {
    desktop = {
      hyprland = {
        rice = true;
        wallpaper = ../../rsc/kyoushitsu.jpg;
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

  # Shell
  home.sessionVariables = {
    VISUAL = "hx";
  };

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

  # Standalone Packages
  home.packages = with pkgs; [
    lazygit
    ncdu htop
    chromium
    insomnia
    discord
    obsidian
  ];

  home.stateVersion = "21.11";
}
