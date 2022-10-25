{ lib, pkgs, config, modulesPath, ... }:

with lib;
let
  nixos-wsl = import ./nixos-wsl;
in
{
  imports = [
    nixos-wsl.nixosModules.wsl
  ];

  wsl = {
    enable = true;
    automountPath = "/mnt";
    defaultUser = "abe";
    startMenuLaunchers = true;

    # Enable native Docker support
    # docker-native.enable = true;

    # Enable integration with Docker Desktop (needs to be installed)
    # docker-desktop.enable = true;

  };
      
  modules.desktop = {              
    auto-startup.enable = false;
  };
      
  modules.hardware = {
    network = {
      hostName = "ssd";
      useNetworkManager = false;
    };
  }; 

  # Enable nix flakes
  # nix.package = pkgs.nixFlakes;
  # nix.extraOptions = ''
  #   experimental-features = nix-command flakes
  # '';
  
  nix = {
    settings.auto-optimise-store = true;
    settings.experimental-features = ["nix-command" "flakes"];  
  };
  
  environment.systemPackages = with pkgs; [ helix git lazygit ranger ];

  system.stateVersion = "22.05";
}
