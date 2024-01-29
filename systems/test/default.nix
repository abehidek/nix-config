{ pkgs, inputs, outputs, lib, ... }:
let
  hashedPwd = "$y$j9T$ywA6mEeY3SU.Xcgc2aKQ7.$FFp4Q3.uYg1gt391HqayFiZXI4rsWVdwv0rYaZnue5C";
in {
  imports = [
    ./hardware.nix
    ../global 
    inputs.disko.nixosModules.disko
    inputs.impermanence.nixosModules.impermanence
    ./disko.nix
    ./impermanence.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";

  networking = {
    hostName = "test";
    hostId = "6782e25f";

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

  users = {
    mutableUsers = false;
    users.root.hashedPassword = hashedPwd;
    users.abe = {
      isNormalUser = true;
      hashedPassword = hashedPwd;
      extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
      packages = with pkgs; [
        tree
        pfetch
        hello
      ];
    };
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

