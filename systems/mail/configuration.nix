# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ config, pkgs, ... }:

{
  imports = [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
  ];

  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ];
    };
  };


  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking = {
    hostName = "mail"; # Define your hostname.

    networkmanager.enable = true;  # Easiest to use and most distros use this by default.

    interfaces.ens18.ipv4.addresses = [{
      address = "192.168.15.13";
      prefixLength = 24;
    }];

    firewall = {
      enable = true;
      allowedTCPPorts = [
        22
        8080
      ];
    };

    wireguard = {
      interfaces.wg1 = {
        ips = [ "10.0.1.3/32" ];
        privateKeyFile = "/etc/nixos/private.key";

        peers = [
          {
            publicKey = "XmTBhv7gckx1e2lUfVIGpW7LWDsBw2x/INGoftDQp2k=";
            allowedIPs = [ "10.0.1.1/32" ];
            endpoint = "216.238.108.97:443";
            persistentKeepalive = 25;
          }
        ];
      };
    };
  };

  time.timeZone = "America/Sao_Paulo";
  
  i18n.defaultLocale = "en_US.UTF-8";
  
  users.users.abe = {
    isNormalUser = true;
    initialPassword = "password";
    extraGroups = [ "wheel" "docker" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      helix
      tree
      git
    ];
  };

  environment.systemPackages = with pkgs; [
    wget vim docker-compose
    openssl
  ];

  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };


  services.openssh.enable = true;
  services.qemuGuest.enable = true;

  virtualisation.docker.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}

