{ pkgs, inputs, outputs, lib, ... }:

{
  imports = [ ./hardware.nix ../global ]; # ++ (builtins.attrValues outputs.nixosModules);

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking = {
    hostName = "mail";

    networkmanager.enable = true;

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
        privateKeyFile = "/etc/wireguard/private.key";

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
    vim docker-compose openssl
  ];

  services.qemuGuest.enable = true;

  virtualisation.docker.enable = true;

  system.stateVersion = "23.05"; # Did you read the comment?

}

