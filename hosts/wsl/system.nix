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
      
  modules.hardware = {
    network = {
      hostName = "ssd";
    };
  }; 
  
  environment.systemPackages = with pkgs; [ helix git lazygit ranger ];
  
  services.vscode-server.enable = true;

  system.stateVersion = "22.05";
}
