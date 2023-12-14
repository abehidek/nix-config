{ inputs, outputs, lib, config, pkgs, ... }:

{
  home = {
    username = "abe";
    homeDirectory = "/home/abe";
    stateVersion = "22.05";
  };

  home.packages = with pkgs; [
    pfetch
    lazygit
    zellij
    tldr
    inputs.devenv.packages.${pkgs.system}.default
  ];

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
        editor.true-color = true;
        editor.file-picker = {
          hidden = false;
        };
        keys.normal = {
          y = ":clipboard-yank";
        };
      };
    };

    bash.enable = true;

    direnv = {
      enable = true;
      enableBashIntegration = true;
      nix-direnv.enable = true;
    };

    home-manager.enable = true;
  };
}
