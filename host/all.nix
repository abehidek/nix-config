{
  # config,
  # lib,
  pkgs,
  nixpkgs,
  paths,
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
      "https://microvm.cachix.org"
    ];
    trusted-public-keys = [
      "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE="
      "microvm.cachix.org-1:oXnBc6hRE3eX5rSYdRyMYXnfzcCxC7yKPTbZXALsqys="
    ];
  };

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  users.users."abe".openssh.authorizedKeys.keys = [
    (builtins.readFile (paths.keys "abe/flex5i.pub"))
    (builtins.readFile (paths.keys "abe/wsl-t16.pub"))
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
