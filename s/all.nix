{
  # config,
  # lib,
  pkgs,
  nixpkgs,
  ...
}:

{
  nix.nixPath = [ "nixpkgs=${nixpkgs}" ];

  nix.settings = {
    auto-optimise-store = true;
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    trusted-users = [
      "root"
      "abe"
      "@wheel"
    ];
    substituters = [
      "https://cosmic.cachix.org/"
      "https://hyprland.cachix.org"
      "https://devenv.cachix.org"
      "https://nix-gaming.cachix.org"
      "https://playit-nixos-module.cachix.org"
    ];
    trusted-public-keys = [
      "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
      "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
      "playit-nixos-module.cachix.org-1:22hBXWXBbd/7o1cOnh+p0hpFUVk9lPdRLX3p5YSfRz4="
    ];
  };

  nixpkgs.config.allowUnfree = true;

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  users.users."abe".openssh.authorizedKeys.keys = [
    (builtins.readFile ../k/abe/flex5i.pub)
    (builtins.readFile ../k/abe/wsl-t16.pub)
  ];

  programs.mtr.enable = true;

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  environment.shellAliases = {
    sysc = "sudo nixos-rebuild switch --flake .#$(hostname)";
    usrc = "home-manager switch --flake .#$(whoami)@$(hostname)";
  };

  environment.systemPackages = with pkgs; [
    wget
    cachix
  ];
}
