# Home-Manager config for ssd abe user

args@{ lib, config, pkgs, unstable, ... }: {
  home.stateVersion = "22.05";
  imports = [
    ../../modules/editors/neovim/home.nix
  ];

  hm-modules = {
    shell = {
      zsh = {
        historySize = 5000;
        nixShellCompat = true;
        powerlevel10k = {
          enable = true;
          riceFolder = ../../config/p10k;
          instantPrompt = true;
        };
        oh-my-zsh = {
          enable = true;
          plugins = [ "git" "web-search" "copypath" "dirhistory" ];
        };
      };
      direnv.enableForUser = true;
    };
  };

  home.packages = with pkgs; [
    # exodus
    obsidian
  ];
  programs = {
    git = {
      enable = true;
      userEmail = "hidek.abe@outlook.com";
      userName = "abehidek";
      extraConfig = {
        core = {
          filemode = false;
        };
        safe = {
          directory = "/shared/ws/zettelkasten";
        };
      };
    };
  };
}
