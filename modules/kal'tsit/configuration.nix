{ inputs, self, ... }:

{
  flake.darwinConfigurations."kal'tsit" = inputs.nix-darwin.lib.darwinSystem {
    modules = [ self.darwinModules."hostKaltsit" ];
  };

  flake.homeConfigurations."abe@kal'tsit" = inputs.home-manager.lib.homeManagerConfiguration {
    modules = [ self.homeManagerModules."homeKaltsit" ];
    pkgs = import inputs.nixpkgs-24-11 {
      system = "x86_64-linux";
      config.allowUnfree = true;
    };
  };

  flake.homeManagerModules."homeKaltsit" =
    { pkgs, ... }:
    let
      user = "gabe";
      hostName = "kal'tsit";
      importRepoAllowUnfree =
        input:
        import input {
          system = "aarch64-darwin";
          config.allowUnfree = true;
        };
      pkgs-master = importRepoAllowUnfree inputs.nixpkgs-master;
      pkgs-25-11 = importRepoAllowUnfree inputs.nixpkgs;
      pkgs-24-11 = importRepoAllowUnfree inputs.nixpkgs-24-11;
    in
    {
      imports = [
        inputs.sops-nix.homeManagerModules.sops
      ];

      sops = {
        age.keyFile = "/Users/${user}/.config/sops/age/keys.txt";
        defaultSopsFile = "${builtins.toString inputs.nix-secrets}/secrets.yaml";
        secrets = {
          "keys/ssh-gabe@kaltsit" = {
            path = "/Users/${user}/.ssh/id_ed25519";
          };
        };
      };

      home = {
        username = user;
        stateVersion = "25.05";
        homeDirectory = "/Users/${user}";

        file = {
          ".config/zellij/config.kdl".source = ./zellij/config.kdl;

          ".config/ghostty/config".source = pkgs.replaceVars ./ghostty/config {
            command = "${pkgs.nushell}/bin/nu";
          };
        };

        packages = with pkgs-25-11; [
          pkgs.home-manager
          pkgs-master.raycast
          pkgs-24-11.vesktop
          pkgs.vscode
          pkgs.bruno

          cbonsai

          pkgs.obsidian
          pkgs.telegram-desktop
          github-cli
          keka
          iina
          anki-bin
          audacity
          pkgs.claude-code
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
        configFile.text = (builtins.readFile (./nushell/config.nu)) + ''
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
            let folderName = $env.pwd | path basename | str substring 0..9
            let session = $"($pathHash)-($folderName)"
            zellij attach -c $session
          }
        '';

        envFile.source = pkgs.replaceVars (./nushell/env.nu) {
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

      programs.starship = {
        enable = true;
        enableZshIntegration = true;
        enableNushellIntegration = true;
        settings = {
          character = {
            success_symbol = "[λ](bold green)";
            error_symbol = "[λ](bold red)";
          };
          shell = {
            disabled = false;
            bash_indicator = "bash";
            zsh_indicator = "zsh";
            nu_indicator = "nu";
            fish_indicator = "󰈺 ";
            powershell_indicator = "_";
            unknown_indicator = "?";
            style = "cyan bold";
          };
        };
      };

      programs.lazygit = {
        enable = true;
        enableBashIntegration = true;
        enableZshIntegration = true;
        enableNushellIntegration = true;
        settings."git"."overrideGpg" = true;
      };
    };

  flake.darwinModules."hostKaltsit" =
    { pkgs, ... }:
    {
      imports = [
        inputs.home-manager.darwinModules.home-manager
        inputs.nix-homebrew.darwinModules.nix-homebrew
        inputs.sops-nix.darwinModules.sops
      ];

      # home-manager
      users.users."gabe".home = "/Users/gabe";
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        users."gabe" = self.homeManagerModules."homeKaltsit";
      };

      nix.optimise.automatic = true;

      nix.nixPath = [ "nixpkgs=${pkgs.path}" ];

      sops = {
        defaultSopsFile = "${builtins.toString inputs.nix-secrets}/secrets.yaml";
        validateSopsFiles = false;
        age = {
          sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
          generateKey = true;
          keyFile = "/var/lib/sops-nix/key.txt";
        };

        secrets = {
          "files/cred-hidek@hako" = { };
        };
      };

      # nix opts

      nix.enable = true; # auto upgrade nix pkg and daemon
      nix.settings.experimental-features = [
        "nix-command"
        "flakes"
      ];
      nix.settings.extra-platforms = [
        "aarch64-linux"
        "x86_64-linux"
      ];

      nixpkgs = {
        hostPlatform = "aarch64-darwin"; # aarch64 because it's Apple M chip which runs ARM
        config.allowUnfree = true;
      };

      # hardware and boot

      security.pam.services.sudo_local.touchIdAuth = true;

      # system

      # https://macos-defaults.com/
      # The trick to get those configuration keys:
      # defaults read > before
      # defaults read > after
      # diff before after
      system = {
        primaryUser = "gabe";

        activationScripts."AssignFontToAppleTerminal".text = ''
          plutil -insert 'Window Settings' -json '{}' ~/Library/Preferences/com.apple.Terminal.plist > /dev/null 2>&1 || true
          plutil -insert 'Window Settings'.Basic -json '{}' ~/Library/Preferences/com.apple.Terminal.plist > /dev/null 2>&1 || true
          plutil -replace 'Window Settings'.Basic.Font -data YnBsaXN0MDDUAQIDBAUGBwpYJHZlcnNpb25ZJGFyY2hpdmVyVCR0b3BYJG9iamVjdHMSAAGGoF8QD05TS2V5ZWRBcmNoaXZlctEICVRyb290gAGkCwwVFlUkbnVsbNQNDg8QERITFFZOU1NpemVYTlNmRmxhZ3NWTlNOYW1lViRjbGFzcyNAKAAAAAAAABAQgAKAA15GaXJhQ29kZU5GLVJlZ9IXGBkaWiRjbGFzc25hbWVYJGNsYXNzZXNWTlNGb250ohkbWE5TT2JqZWN0CBEaJCkyN0lMUVNYXmdud36FjpCSlKOos7zDxgAAAAAAAAEBAAAAAAAAABwAAAAAAAAAAAAAAAAAAADP ~/Library/Preferences/com.apple.Terminal.plist
        '';

        defaults = {
          universalaccess.reduceMotion = false;

          trackpad = {
            Clicking = true;
            TrackpadThreeFingerDrag = false;
          };

          dock = {
            autohide = true;
            autohide-delay = 0.0;
            magnification = false;
            show-recents = false;
            mru-spaces = false;
            persistent-apps = [
              "/Applications/Legcord.app"
              "/Applications/Slack.app"
              "/Applications/Spotify.app"
              { spacer.small = true; }
              "/Applications/Ghostty.app"
              "${pkgs.vscode}/Applications/Visual Studio Code.app"
              "${pkgs.obsidian}/Applications/Obsidian.app"
              "${pkgs.anki-bin}/Applications/Anki.app"
              "/System/Applications/Calendar.app"
              "/System/Applications/Reminders.app"
              "/Applications/Zen.app"
            ];
          };

          finder = {
            AppleShowAllExtensions = true;
            AppleShowAllFiles = true;
            _FXShowPosixPathInTitle = true;
            FXPreferredViewStyle = "clmv"; # Column as default view style
            FXDefaultSearchScope = "SCcf"; # Define only current folder as search scope
            FXEnableExtensionChangeWarning = false;
            ShowStatusBar = true;
            ShowPathbar = true;
            QuitMenuItem = false;
          };

          loginwindow = {
            GuestEnabled = false;
            LoginwindowText = "hidekxyz";
          };

          screencapture.location = "~/Pictures/screenshots";

          NSGlobalDomain = {
            AppleICUForce24HourTime = true;
            AppleInterfaceStyle = "Dark";
            ApplePressAndHoldEnabled = true;
            AppleShowAllExtensions = true;
            NSAutomaticWindowAnimationsEnabled = false;
            NSWindowShouldDragOnGesture = true;
            NSDocumentSaveNewDocumentsToCloud = false;
            InitialKeyRepeat = 25;
            KeyRepeat = 2;

            "com.apple.mouse.tapBehavior" = 1;
          };

          CustomUserPreferences = {
            "com.apple.Terminal".SecureKeyboardEntry = 1;

            "com.apple.desktopservices" = {
              DSDontWriteNetworkStores = true;
              DSDontWriteUSBStores = true;
            };
          };
        };
      };

      # services programs

      nix-homebrew = {
        enable = true;
        user = "gabe"; # User owning the Homebrew prefix
        enableRosetta = true; # Apple Silicon Only
        autoMigrate = true;
        mutableTaps = false; # With mutableTaps disabled, taps can no longer be added imperatively with `brew tap`.
        taps = {
          "homebrew/homebrew-core" = inputs.homebrew-core;
          "homebrew/homebrew-cask" = inputs.homebrew-cask;
          "homebrew/homebrew-bundle" = inputs.homebrew-bundle;
        };
      };

      homebrew = {
        enable = true;
        onActivation.cleanup = "zap";
        brews = [
          # "mas"
          "colima"
        ];
        casks = [
          "sanesidebuttons"
          "betterdisplay"
          "meetingbar"
          "linearmouse"
          "legcord"
          "spotify"
          "ghostty"
          "keyboardcleantool"
          "mullvad-vpn"
          "thaw"
          # "PlayCover/playcover/playcover-community"
        ];
        masApps = {
          # "Yoink" = 457622435;
          # "Balance Lock" = 1019371109;
        };
      };

      services.tailscale.enable = true;

      services.openssh.enable = false;

      programs.bash = {
        enable = true;
        completion.enable = true;
      };

      programs.zsh.enableBashCompletion = true;

      fonts.packages = with pkgs.nerd-fonts; [
        fira-code
        zed-mono
      ];

      # environment and packages

      environment.systemPackages = with pkgs; [
        nixd
        nixfmt

        pre-commit

        fastfetch
        helix
        git
        tldr
        nixos-rebuild
        sops
        tailscale
        docker
        docker-compose
        docker-credential-helpers
        gnupg

        (python312.withPackages (ps: with ps; [ pip ]))
      ];

      system.configurationRevision = self.rev or self.dirtyRev or null; # set git commit hash for darwin-version
      system.stateVersion = 6; # used for backwards compat, read the changelog before running: $ darwin-rebuild changelog
    };
}
