# Home-Manager config for ssd abe user

args@{ inputs, lib, config, pkgs, unstable, ... }: {
  home.stateVersion = "22.05";
  # colorScheme = inputs.nix-colors.colorSchemes.solarized-dark;
  # imports = [ ../../modules/editors/neovim/home.nix ];

  hm-modules = {
    desktop = {
      term.kitty.enable = false;
      rofi.enable = false;
    };
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
          enable = false;
          riceFolder = ../../config/p10k;
          instantPrompt = false;
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
      vscodium.enable = false;
      helix.enable = true;
    };
  };

  home.packages = with pkgs; [
    # exodus
    lazygit
    inotify-tools
    elixir nodejs yarn python310
    neofetch sl
  ];
  services.dropbox.enable = false;

  programs = {
    starship = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
