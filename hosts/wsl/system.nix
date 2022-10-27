{ inputs, lib, pkgs, config, modulesPath, ... }: with lib;
{
  imports = [
    inputs.nixos-wsl.nixosModules.wsl
    inputs.vscode-server.nixosModule
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

  modules = {
    hardware = {
      network = {
        hostName = "ssd";
      };
    };
    shell = {
      zsh = {
        enable = true;
        defaultShellUsers = ["abe"];
      };
      tmux.enable = true;
      direnv.enable = true;
      direnv.preventGC = true;
    };
    services = {
      ssh = { enable = true; };
    };
  };

  
  environment.systemPackages = with pkgs; [ helix git lazygit ranger ];
  
  services.vscode-server.enable = true;

  system.stateVersion = "22.05";
}
