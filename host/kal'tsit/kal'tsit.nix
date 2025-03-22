{
  # config,
  # lib,
  pkgs,
  # modulesPath,
  nixpkgs,
  home-manager,
  # nur,
  name,
  rev,
  # modules,
  paths,
  all-users,
  nix-homebrew,
  homebrew-core,
  homebrew-cask,
  homebrew-bundle,
  mac-app-util,
  ...
}:

{
  imports = [
    home-manager.darwinModules.home-manager
    nix-homebrew.darwinModules.nix-homebrew
    mac-app-util.darwinModules.default
  ];

  nix.nixPath = [ "nixpkgs=${nixpkgs}" ];

  nix.extraOptions = ''
    extra-platforms = x86_64-darwin aarch64-darwin
  '';

  nix-homebrew = {
    enable = true;
    enableRosetta = true; # Apple Silicon Only
    user = "gabe"; # User owning the Homebrew prefix
    autoMigrate = true;

    taps = {
      "homebrew/homebrew-core" = homebrew-core;
      "homebrew/homebrew-cask" = homebrew-cask;
      "homebrew/homebrew-bundle" = homebrew-bundle;
    };

    # Optional: Enable fully-declarative tap management
    #
    # With mutableTaps disabled, taps can no longer be added imperatively with `brew tap`.
    mutableTaps = false;
  };

  homebrew = {
    enable = true;
    # brews = [ "mas" ];
    casks = [
      "mos"
      # "iina"
      # "the-unarchiver"
    ];
    # masApps."Yoink" = 457622435;
    onActivation.cleanup = "zap";
  };

  security.pam.services.sudo_local.touchIdAuth = true;

  environment.systemPackages = with pkgs; [
    fastfetch
    lazygit
    helix
    git
    tldr
    nixfmt-rfc-style
    nixd
  ];

  environment.variables = {
    EDITOR = "hx";
    VISUAL = "hx";
  };

  environment.shellAliases = {
    dwnc = "darwin-rebuild switch --flake .#\"${name}\"";
    k = "kubectl";
    l = "ls -lah";
  };

  programs.bash.completion.enable = true;

  programs.zsh = {
    enable = true;
    enableBashCompletion = true;
  };

  fonts.packages = [ pkgs.nerd-fonts.fira-code ];

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

  # home-manager
  users.users."gabe".home = "/Users/gabe";
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit paths all-users; };
    sharedModules = [ mac-app-util.homeManagerModules.default ];
    users."gabe" = import (paths.users "gabe/${name}.nix");
  };

  # auto upgrade nix pkg and daemon
  nix.enable = true;
  nix.settings.experimental-features = "nix-command flakes";

  # set git commit hash for darwin-version
  system.configurationRevision = rev;

  # used for backwards compat, read the changelog before running: $ darwin-rebuild changelog
  system.stateVersion = 6;

  # aarch64 because it's Apple M chip which runs ARM
  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config.allowUnfree = true;
}
