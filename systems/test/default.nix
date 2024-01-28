{ pkgs, inputs, outputs, lib, ... }:

{
  imports = [
    ./hardware.nix
    ../global 
    inputs.disko.nixosModules.disko
    ./disko.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking = {
    hostName = "test";

    networkmanager.enable = true;

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
      hello
    ];
  };

  environment.systemPackages = with pkgs; [
    vim openssl helix git
  ];

  services.qemuGuest.enable = true;
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = lib.mkForce true;
      PermitRootLogin = lib.mkForce "yes";
    };
  };

  system.stateVersion = "23.05"; # Did you read the comment?
}

