{ pkgs, inputs, outputs, lib, config, modulesPath, ... }: {
  imports = [
    ./hardware.nix
    ../global
  ];

  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = true;

  boot.extraModulePackages = [ config.boot.kernelPackages.wireguard ];
  boot.kernel.sysctl = {
    "net.ipv4.ping_group_range" = "0 1000";
    "net.ipv4.ip_forward" = "1";
  };

  networking = {
    hostName = "roxy";
    domain = "";

    wireguard.enable = true;
    wg-quick.interfaces = {
      wg0 = {
        privateKeyFile = "/home/abe/wireguard/privatekey";
        listenPort = 55107;
        address = [ "10.100.0.1/24" ];
        peers = [
          # Portainer
          {
            publicKey = "ADp4rHQORLcQJd+kgSgcbVttRJ/0vcjPM9NX0NCTPUQ=";
            allowedIPs = [ "10.100.0.2/24" ];
          }
        ];
      };
    };
  };

  time.timeZone = "America/Sao_Paulo";
  i18n.defaultLocale = "en_US.UTF-8";

  services.openssh.enable = true;

  environment.systemPackages = with pkgs; [
    vim openssl helix git lazygit
  ];

  environment.variables = {
    EDITOR = "hx";
    VISUAL = "hx";
  };

  users = {
    users.abe = {
      isNormalUser = true;
      initialPassword = "password";
      extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    };
  };

  system.stateVersion = "23.11";
}
