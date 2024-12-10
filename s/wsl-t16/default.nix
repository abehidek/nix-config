{
  config,
  lib,
  pkgs,
  # modulesPath,
  nixpkgs,
  # home-manager,
  # nur,
  all,
  nixos-wsl,
  ...
}:

{
  imports = [
    (all { inherit pkgs nixpkgs; })
    nixos-wsl.nixosModules.default
  ];

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
    pfetch
  ];

  system.stateVersion = "24.05";
}
