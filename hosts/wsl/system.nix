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
    # docker-native.addToDockerGroup = true;

    # Enable integration with Docker Desktop (needs to be installed)
    # docker-desktop.enable = true;
  };

  # virtualisation.docker.extraOptions = "--iptables=false";

  virtualisation.docker.package = (pkgs.docker.override { iptables = pkgs.iptables-legacy; });
  virtualisation.docker.enable = true;

  users.groups.docker.members = ["abe"];

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

  
  environment.systemPackages = with pkgs; [ helix git lazygit ranger docker-compose ];
  
  services.vscode-server.enable = true;

  system.stateVersion = "22.05";
}
