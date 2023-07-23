{ pkgs, inputs, outputs, lib, ... }:

{
  imports = [ 
    ./hardware.nix 
    ../global 
    inputs.home-manager.nixosModules.home-manager 
    inputs.disko.nixosModules.disko ./disko.nix
  ] ++ (builtins.attrValues outputs.nixosModules);

  modules.system = {
    services = {
      docker = {
        enable = true;
        users = [ "abe" ];
      };
    };
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking = {
    hostName = "mail";

    networkmanager.enable = true;

    interfaces.ens18.ipv4.addresses = [{
      address = "192.168.15.23";
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
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      tree
      pfetch
    ];
  };

  environment.systemPackages = with pkgs; [
    vim openssl git helix
  ];

  services.qemuGuest.enable = true;

  system.stateVersion = "23.05"; # Did you read the comment?

}

