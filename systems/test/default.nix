{ pkgs, inputs, outputs, lib, ... }:

{
  imports = [ ./hardware.nix ../global inputs.disko.nixosModules.disko ./disko.nix ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking = {
    hostName = "test";

    networkmanager.enable = true;

    interfaces.ens18.ipv4.addresses = [{
      address = "192.168.15.142";
      prefixLength = 24;
    }];

    firewall = {
      enable = true;
      allowedTCPPorts = [
        22
      ];
    };

    wireguard = {
      enable = false;
    };
  };

  time.timeZone = "America/Sao_Paulo";
  
  i18n.defaultLocale = "en_US.UTF-8";
  
  users.users.abe = {
    isNormalUser = true;
    initialPassword = "password";
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      tree
      pfetch
    ];
  };

  environment.systemPackages = with pkgs; [
    vim openssl helix git
  ];

  services.qemuGuest.enable = true;

  system.stateVersion = "23.05"; # Did you read the comment?
}

