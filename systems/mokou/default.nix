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

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";

  networking = {
    hostName = "mokou";
    hostId = "5782e25f";
    networkmanager.enable = true;

    firewall = {
      enable = true;
      allowedTCPPorts = [ 22 ];
    };
  };

  security.sudo.extraConfig = ''
    Defaults  lecture="never"
  '';

  virtualisation.libvirtd.enable = true;

  time.timeZone = "America/Sao_Paulo";

  i18n.defaultLocale = "en_US.UTF-8";

  users = {
    mutableUsers = false;
    users.root.hashedPassword = hashedPwd;
    users.abe = {
      isNormalUser = true;
      hashedPassword = hashedPwd;
      extraGroups = [ "wheel" "networkmanager" "video" "audio" "libvirtd" ];
      packages = with pkgs; [
        tree
        neofetch
      ];
    };
  };

  environment.sessionVariables = {
    NIX_CONFIG = "extra-experimental-features = nix-command flakes repl-flake";
  };

  environment.systemPackages = with pkgs; [
    vim openssl helix git htop psensor
  ];

  system.stateVersion = "23.05"; # Did you read the comment?
}

