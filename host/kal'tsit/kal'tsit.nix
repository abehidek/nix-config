{
  # config,
  # lib,
  pkgs,
  # modulesPath,
  home-manager,
  # nur,
  # nixpkgs,
  nixpkgs-master,
  nixpkgs-24-11,
  nixpkgs-25-11,
  modules,
  paths,
  nix-secrets,
  sops-nix,
  nix-homebrew,
  homebrew-core,
  homebrew-cask,
  homebrew-bundle,
  # nix-rosetta-builder,
  hostName,
  rev,
  ...
}:
let
  importRepoAllowUnfree =
    input:
    import input {
      system = "aarch64-darwin";
      config.allowUnfree = true;
    };

  pkgs-master = importRepoAllowUnfree nixpkgs-master;
  pkgs-25-11 = importRepoAllowUnfree nixpkgs-25-11;
  pkgs-24-11 = importRepoAllowUnfree nixpkgs-24-11;
in
{
  imports = [
    home-manager.darwinModules.home-manager
    nix-homebrew.darwinModules.nix-homebrew
    sops-nix.darwinModules.sops
    # nix-rosetta-builder.darwinModules.default

    modules.all.darwin
    modules.develop.lsp.nix
  ];

  # hidekxyz

  hidekxyz.all.mainUser = "gabe";

  # sops

  sops = {
    defaultSopsFile = "${builtins.toString nix-secrets}/secrets.yaml";
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

  # nix-rosetta

  # nix-rosetta-builder.onDemand = true;

  # nix opts

  nix.enable = true; # auto upgrade nix pkg and daemon
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
          "${pkgs.alacritty}/Applications/Alacritty.app"
          "${pkgs.code-cursor}/Applications/Cursor.app"
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
      "homebrew/homebrew-core" = homebrew-core;
      "homebrew/homebrew-cask" = homebrew-cask;
      "homebrew/homebrew-bundle" = homebrew-bundle;
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
    fastfetch
    lazygit
    helix
    git
    tldr
    nixos-rebuild
    sops
    tailscale
    docker
    docker-compose
    docker-credential-helpers

    (python312.withPackages (ps: with ps; [ pip ]))
  ];

  # home-manager
  users.users."gabe".home = "/Users/gabe";
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit pkgs-master pkgs-24-11 pkgs-25-11;
      inherit modules paths hostName;
      inherit nix-secrets sops-nix;
    };
    users."gabe" = import (paths.users "gabe/${hostName}.nix");
  };

  system.configurationRevision = rev; # set git commit hash for darwin-version
  system.stateVersion = 6; # used for backwards compat, read the changelog before running: $ darwin-rebuild changelog
}
