{
  # config,
  # lib,
  pkgs,
  pkgs-master,
  pkgs-25-11,
  pkgs-24-11,
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
  };

  home = {
    file = {
      ".config/zellij/config.kdl".source = paths.dots "zellij/config.kdl";

      ".config/ghostty/config".source = pkgs.replaceVars (paths.dots "ghostty/config") {
        command = "${pkgs.nushell}/bin/nu";
      };
    };

    packages = with pkgs-25-11; [
      pkgs-master.raycast
      pkgs-24-11.vesktop
      pkgs.vscode

      pkgs.obsidian
      telegram-desktop
      github-cli
      keka
      iina
      anki-bin
      ice-bar
      audacity
      claude-code
    ];

    sessionVariables = {
      GIT_AUTHOR_NAME = "abehidek";
      GIT_AUTHOR_EMAIL = "me@hidek.xyz";
      SOPS_AGE_KEY_FILE = "/Users/${user}/.config/sops/age/keys.txt";
    };
  };

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = {
      "*" = {
        forwardAgent = false;
        addKeysToAgent = "no";
        compression = false;
        serverAliveInterval = 0;
        serverAliveCountMax = 3;
        hashKnownHosts = false;
        userKnownHostsFile = "~/.ssh/known_hosts";
        controlMaster = "no";
        controlPath = "~/.ssh/master-%r@%n:%p";
        controlPersist = "no";
      };
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

      "git emu" = {
        host = "github.com-emu";
        hostname = "github.com";
        identitiesOnly = true;
        identityFile = [ "~/.ssh/id_ed25519_melisource" ];
      };
    };
  };

  programs.bash = {
    enable = true;
    shellAliases = {
      dwnc = "sudo darwin-rebuild switch --flake .#\"${hostName}\"";
      homec = "home-manager switch --flake .#\"${user}@${hostName}\"";
      k = "kubectl";
      l = "ls -lah";
    };
    bashrcExtra = ''
      idea() {
        open -na "IntelliJ IDEA.app" --args "$@"
      }
    '';
  };

  programs.zsh = {
    enable = true;
    shellAliases = {
      dwnc = "sudo darwin-rebuild switch --flake .#\"${hostName}\"";
      homec = "home-manager switch --flake .#\"${user}@${hostName}\"";
      k = "kubectl";
      l = "ls -lah";
    };
    initContent = ''
      eval "$(/opt/homebrew/bin/brew shellenv)"
      export PATH="$HOME/.fury/fury_venv/bin:$PATH"
    '';
  };

  programs.nushell = {
    enable = true;
    configFile.text = (builtins.readFile (paths.dots "nushell/config.nu")) + ''
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

      def idea [...args] {
        open -na "IntelliJ IDEA.app" --args ...$args
      }

      def ze [] {
        let pathHash = $env.pwd | hash md5 |  str substring 0..6
        let folderName = $env.pwd | path basename
        let session = $"($pathHash)-($folderName)"
        zellij attach -c $session
      }
    '';

    envFile.source = pkgs.replaceVars (paths.dots "nushell/env.nu") {
      starshipCmd = "${pkgs.starship}/bin/starship";
    };

    shellAliases = {
      dwnc = "sudo darwin-rebuild switch --flake .#\"${hostName}\"";
      homec = "home-manager switch --flake .#\"${user}@${hostName}\"";
      l = "ls -al";
      k = "kubectl";
    };

    environmentVariables = {
      VISUAL = "hx";
      EDITOR = "hx";
    };
  };

  programs.direnv = {
    enable = true;
    silent = true;
    nix-direnv.enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    enableNushellIntegration = true;
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

  programs.vscode.enable = true;
}
