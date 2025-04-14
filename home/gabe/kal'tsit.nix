{
  # config,
  # lib,
  pkgs,
  modules,
  paths,
  hostName,
  nix-secrets,
  sops-nix,
  ...
}:

let
  user = "gabe";
in
{
  imports = [
    sops-nix.homeManagerModules.sops

    modules.home.all
    modules.home.starship
    modules.home.develop.editor.zed
  ];

  sops = {
    age.keyFile = "/Users/${user}/.config/sops/age/keys.txt";
    defaultSopsFile = "${builtins.toString nix-secrets}/secrets.yaml";
    secrets = {
      "keys/ssh-gabe@kaltsit" = {
        path = "/Users/${user}/.ssh/id_ed25519";
      };
    };
  };

  hidekxyz.home = {
    all = {
      userName = user;
      stateVersion = "25.05";
    };

    develop.editor.zed.shell.program = "${pkgs.nushell}/bin/nu";
  };

  home = {
    file = {
      ".config/zellij/config.kdl".source = paths.dots "zellij/config.kdl";
    };

    packages = with pkgs; [
      obsidian
      telegram-desktop
      code-cursor
      vesktop
      raycast
      github-cli
      zoxide
      keka
      iina
      anki-bin
      arc-browser
    ];

    sessionVariables = {
      GIT_AUTHOR_NAME = "abehidek";
      GIT_AUTHOR_EMAIL = "me@hidek.xyz";
      SOPS_AGE_KEY_FILE = "/Users/${user}/.config/sops/age/keys.txt";
    };
  };

  programs.ssh = {
    enable = true;
    matchBlocks = {
      "git personal" = {
        host = "github.com";
        hostname = "github.com";
        identitiesOnly = true;
        identityFile = [ "~/.ssh/id_ed25519" ];
      };

      "git meli" = {
        host = "github.com-meli";
        hostname = "github.com";
        identitiesOnly = true;
        identityFile = [ "~/.ssh/id_ed25519_meli" ];
      };
    };
  };

  programs.bash = {
    enable = true;
    shellAliases = {
      dwnc = "darwin-rebuild switch --flake .#\"${hostName}\"";
      k = "kubectl";
      l = "ls -lah";
    };
    bashrcExtra = ''
      cursor() {
        open -a "${pkgs.code-cursor}/Applications/Cursor.app/Contents/MacOS/Cursor" "$@"
      }
    '';
  };

  programs.zsh = {
    enable = true;
    shellAliases = {
      dwnc = "darwin-rebuild switch --flake .#\"${hostName}\"";
      k = "kubectl";
      l = "ls -lah";
    };
    initExtra = ''
      eval "$(/opt/homebrew/bin/brew shellenv)"
      export PATH="$HOME/.fury/fury_venv/bin:$PATH"
    '';
  };

  programs.nushell = {
    enable = true;
    configFile.text =
      (builtins.readFile (paths.dots "nushell/config.nu"))
      + ''
        alias nu-open = open
        alias open = ^open
        $env.PATH = ([
          $"($env.HOME)/.fury/fury_venv/bin",
          "/opt/homebrew/bin",

          $"($env.HOME)/.nix-profile/bin",
          "/etc/profiles/per-user/${user}/bin",
          "/run/current-system/sw/bin",
          "/nix/var/nix/profiles/default/bin",
        ] ++ $env.PATH)

        def cursor [...args] {
          open -a "${pkgs.code-cursor}/Applications/Cursor.app/Contents/MacOS/Cursor" ...$args
        }
      '';

    envFile.source = pkgs.substituteAll {
      name = "env.nu";
      src = paths.dots "nushell/env.nu";
      starshipCmd = "${pkgs.starship}/bin/starship";
    };

    shellAliases = {
      dwnc = "darwin-rebuild switch --flake .#\"${hostName}\"";
      l = "ls -al";
      k = "kubectl";
    };

    environmentVariables = {
      VISUAL = "hx";
      EDITOR = "hx";
    };
  };

  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    enableNushellIntegration = true;
  };

  programs.zellij = {
    enable = true;
    enableZshIntegration = false; # not necessarily I want to open zellij when opening zsh
  };

  programs.alacritty = {
    enable = true;
    settings = {
      font = {
        normal.family = "FiraCode Nerd Font";
        size = 14;
      };
      terminal.shell = {
        program = "${pkgs.zsh}/bin/zsh";
        args = [
          "-c"
          "${pkgs.zellij}/bin/zellij"
        ];
      };
    };
  };

  programs.vscode.enable = true;
}
