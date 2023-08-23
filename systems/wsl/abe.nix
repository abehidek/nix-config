{ user }: { inputs, outputs, lib, config, pkgs, ... }:
let
  userName = user;
  homePath = "/home/${userName}";
in {
  imports = [] ++ (builtins.attrValues outputs.userModules);

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
    starship.enable = true;

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

    helix = {
      enable = true;
      package = pkgs.helix;
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
    ranger
  ];

  home.stateVersion = "22.05";
}
