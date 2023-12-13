{ config, pkgs, inputs, ... }:

{
  nix = {
    package = pkgs.nixFlakes;

    extraOptions = ''
      experimental-features = nix-command flakes
    '';

    settings = {
      substituters = [
        "https://devenv.cachix.org"
      ];
      trusted-public-keys = [
        "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
      ];  
    };
  };

  home = {
    username = "abe";
    homeDirectory = "/home/abe";

    packages = with pkgs; [
      pfetch
      lazygit
      zellij
      tldr
      inputs.devenv.packages.${pkgs.system}.default
    ];

    stateVersion = "22.05";
  };

  programs = {
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
