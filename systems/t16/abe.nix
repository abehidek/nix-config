{ config, pkgs, ... }:

{
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  home = {
    username = "abe";
    homeDirectory = "/home/abe";

    packages = with pkgs; [
      pfetch
      lazygit
      zellij
      tldr
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
