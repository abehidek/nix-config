# Home-Manager config for ssd abe user

args@{ inputs, lib, config, pkgs, unstable, ... }: {
  home.stateVersion = "22.05";
  colorScheme = inputs.nix-colors.colorSchemes.solarized-dark;
  imports = [
    ../../modules/editors/neovim/home.nix
  ];

  hm-modules = {
    services = {
      git = {
        enable = true;
        defaultBranch = "main";
      };
      gpg.enable = true;
    };
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
      fzf.enable = true;
      ranger.enable = true;
      direnv.enableForUser = true;
    };
    editors = {
      vim.enable = true;
      vscodium.enable = true;
      helix.enable = true;
    };
  };

  home.packages = with pkgs; [
    # exodus
    obsidian
  ];
  programs = {
    git = {
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
