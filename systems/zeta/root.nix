{ config, pkgs, ... }:

{
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  home = {
    username = "root";
    homeDirectory = "/root";

    sessionVariables = {
      EDITOR = "hx";
      VISUAL = "hx";
    };

    packages = with pkgs; [
      # cli
      pfetch neofetch
      tldr
      intel-gpu-tools
      # tui
      lazygit htop
    ];

    stateVersion = "24.05";
  };

  programs = {
    bash.enable = true;

    git = {
      enable = true;
      userName = "abehidek";
      userEmail = "hidek.abe@outlook.com";
      extraConfig = {
        init.defaultBranch = "main";
      };
    };

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

    home-manager.enable = true;
  };
}
