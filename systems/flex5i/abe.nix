{ user }: { inputs, lib, config, pkgs, ... }: 
let
  userName = user;
  homePath = "/home/${userName}";
in {
  home.stateVersion = "21.11";
  home.username = userName;
  home.homeDirectory = homePath;
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

  programs.starship.enable = true;

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  # Services
  programs.git = {
    enable = true;
    userName = "abehidek";
    userEmail = "hidek.abe@outlook.com";
    extraConfig = {
      init.defaultBranch = "main";
    };
  };

  programs.gpg = {
    enable = true;
  };

  # Desktop  
  programs = {
    vscode.enable = true;
    firefox = {
      enable = true;
    };
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
    google-chrome
    insomnia
    discord
    obsidian
  ];
}