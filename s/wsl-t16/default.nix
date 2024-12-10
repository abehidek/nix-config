{
  config,
  lib,
  pkgs,
  # modulesPath,
  nixpkgs,
  # home-manager,
  # nur,
  all,
  nix-secrets,
  sops-nix,
  nixos-wsl,
  ...
}:

{
  imports = [
    (all { inherit pkgs nixpkgs; })
    sops-nix.nixosModules.sops
    nixos-wsl.nixosModules.default
  ];

  sops = {
    defaultSopsFile = "${builtins.toString nix-secrets}/secrets.yaml";
    validateSopsFiles = false;
    age = {
      # sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
      generateKey = false;
      keyFile = "/home/abe/.config/sops/age/keys.txt";
    };

    secrets = {
      "keys/ssh-abe@flex5i" = {
        path = "/root/.ssh/id_ed25519"; # private repo access on "sudo nixos-rebuild switch" bc sudo runs w/ sudo user
      };
    };
  };

  wsl = {
    enable = true;
    defaultUser = "abe";
  };

  networking.hostName = "wsl-t16";

  services.openssh.ports = [ 2022 ];

  programs.nix-ld = {
    enable = true;
    package = pkgs.nix-ld-rs; # only for NixOS 24.05
  };

  environment.systemPackages = with pkgs; [
    wget
    git
    helix
    lazygit
    age
    sops

    pfetch
    neofetch
  ];

  system.stateVersion = "24.05";
}
