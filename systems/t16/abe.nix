{ inputs, outputs, lib, config, pkgs, ... }:

{
  imports = [] ++ (builtins.attrValues outputs.userModules);

  # modules.user.shell.zsh.rice = true;

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

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting = {
      enable = true;
    };
    history = {
      size = 5000;
      path = "$HOME/.local/share/zsh/history";
    };
    initExtraFirst = ''
      ${pkgs.any-nix-shell}/bin/any-nix-shell zsh --info-right | source /dev/stdin
    '';
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "web-search" "copypath" "dirhistory" ];
    };
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

    starship = {
      enable = true;
      settings = {
        character = {
          success_symbol = "[λ](bold green)";
          error_symbol = "[λ](bold red)";
        };
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
      enableFishIntegration = false;
      nix-direnv.enable = true;
    };

    home-manager.enable = true;
  };
}
