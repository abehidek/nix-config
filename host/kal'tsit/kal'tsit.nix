{
  # config,
  # lib,
  pkgs,
  # modulesPath,
  # nixpkgs,
  home-manager,
  # nur,
  modules,
  paths,
  all-users,
  nix-homebrew,
  homebrew-core,
  homebrew-cask,
  homebrew-bundle,
  mac-app-util,
  hostName,
  rev,
  ...
}:

{
  imports = [
    home-manager.darwinModules.home-manager
    nix-homebrew.darwinModules.nix-homebrew
    mac-app-util.darwinModules.default
    modules.all.darwin
    modules.develop.lsp.nix
  ];

  # hidekxyz

  hidekxyz.all.mainUser = "gabe";

  # nix opts

  nix = {
    enable = true; # auto upgrade nix pkg and daemon
    settings.extra-platforms = [
      "x86_64-darwin "
      "aarch64-darwin"
    ];
  };

  nixpkgs = {
    hostPlatform = "aarch64-darwin"; # aarch64 because it's Apple M chip which runs ARM
    config.allowUnfree = true;
  };

  # hardware and boot

  security.pam.services.sudo_local.touchIdAuth = true;

  # system

  system = {
    activationScripts."postUserActivation".text = ''
      plutil -insert 'Window Settings' -json '{}' ~/Library/Preferences/com.apple.Terminal.plist > /dev/null 2>&1 || true
      plutil -insert 'Window Settings'.Basic -json '{}' ~/Library/Preferences/com.apple.Terminal.plist > /dev/null 2>&1 || true
      plutil -replace 'Window Settings'.Basic.Font -data YnBsaXN0MDDUAQIDBAUGBwpYJHZlcnNpb25ZJGFyY2hpdmVyVCR0b3BYJG9iamVjdHMSAAGGoF8QD05TS2V5ZWRBcmNoaXZlctEICVRyb290gAGkCwwVFlUkbnVsbNQNDg8QERITFFZOU1NpemVYTlNmRmxhZ3NWTlNOYW1lViRjbGFzcyNAKAAAAAAAABAQgAKAA15GaXJhQ29kZU5GLVJlZ9IXGBkaWiRjbGFzc25hbWVYJGNsYXNzZXNWTlNGb250ohkbWE5TT2JqZWN0CBEaJCkyN0lMUVNYXmdud36FjpCSlKOos7zDxgAAAAAAAAEBAAAAAAAAABwAAAAAAAAAAAAAAAAAAADP ~/Library/Preferences/com.apple.Terminal.plist
    '';

    defaults = {
      dock.autohide = true;
      dock.mru-spaces = false;
      dock.persistent-apps = [
        "${pkgs.alacritty}/Applications/Alacritty.app"
        "${pkgs.zed-editor}/Applications/Zed.app"
        "${pkgs.obsidian}/Applications/Obsidian.app"
        "/Applications/Zen.app"
      ];

      finder.AppleShowAllExtensions = true;
      finder.FXPreferredViewStyle = "clmv";

      loginwindow.GuestEnabled = false;
      loginwindow.LoginwindowText = "hidekxyz";

      screencapture.location = "~/Pictures/screenshots";

      NSGlobalDomain.AppleICUForce24HourTime = true;
      NSGlobalDomain.AppleInterfaceStyle = "Dark";
      NSGlobalDomain.KeyRepeat = 2;

      CustomUserPreferences = {
        "com.apple.Terminal" = {
          SecureKeyboardEntry = 1;
        };
      };
    };
  };

  # services programs

  nix-homebrew = {
    enable = true;
    enableRosetta = true; # Apple Silicon Only
    user = "gabe"; # User owning the Homebrew prefix
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
    ];
    casks = [
      "mos"
      # "iina"
      # "the-unarchiver"
    ];
    masApps = {
      # "Yoink" = 457622435;
    };
  };

  programs.zsh.enableBashCompletion = true;

  fonts.packages = [ pkgs.nerd-fonts.fira-code ];

  # environment and packages

  environment.systemPackages = with pkgs; [
    fastfetch
    lazygit
    helix
    git
    tldr
  ];

  # home-manager
  users.users."gabe".home = "/Users/gabe";
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit paths all-users hostName; };
    sharedModules = [ mac-app-util.homeManagerModules.default ];
    users."gabe" = import (paths.users "gabe/${hostName}.nix");
  };

  system.configurationRevision = rev; # set git commit hash for darwin-version
  system.stateVersion = 6; # used for backwards compat, read the changelog before running: $ darwin-rebuild changelog
}
