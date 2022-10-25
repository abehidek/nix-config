{ lib, pkgs, config, modulesPath, ... }:

with lib;
let
  nixos-wsl = import ./nixos-wsl;
in
{
  imports = [
    "${modulesPath}/profiles/minimal.nix"

    nixos-wsl.nixosModules.wsl

    ../../modules/shell/zsh
  ];

  wsl = {
    enable = true;
    automountPath = "/mnt";
    defaultUser = "abe";
    startMenuLaunchers = true;

    # Enable integration with Docker Desktop (needs to be installed)
    docker.enable = true;
  };

  # Enable nix flakes
  # nix.package = pkgs.nixFlakes;
  # nix.extraOptions = ''
  #   experimental-features = nix-command flakes
  # '';

  networking.hostName = "wsl";

  environment.systemPackages = with pkgs; [ neofetch pfetch git lazygit ranger htop tree wget nodejs nodePackages.npm ];
}
