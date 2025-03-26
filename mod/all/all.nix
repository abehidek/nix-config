{
  config,
  lib,
  pkgs,
  # modulesPath,
  paths,
  ...
}:
let
  cfg = config."hidekxyz"."all";
in
{
  options."hidekxyz"."all" = {
    mainUser = lib.mkOption { type = lib.types.str; };
  };

  config = {
    nix.settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      trusted-users = [
        "root"
        "abe"
        "gabe"
        "@wheel"
        "@admin"
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

    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    environment.systemPackages = with pkgs; [
      wget
      cachix
      deploy-rs
    ];

    users.users.${cfg.mainUser}.openssh.authorizedKeys.keys = [
      (builtins.readFile (paths.keys "abe/flex5i.pub"))
      (builtins.readFile (paths.keys "abe/wsl-t16.pub"))
      (builtins.readFile (paths.keys "gabe/kal'tsit.pub"))
    ];
  };
}
