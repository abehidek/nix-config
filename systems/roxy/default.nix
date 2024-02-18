{ pkgs, inputs, outputs, lib, config, modulesPath, ... }: {
  imports = [
    ./hardware.nix
    ../global
  ];

  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = true;

  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = "1";
  };

  networking = {
    hostName = "roxy";
    firewall = {
      allowedTCPPorts = [ 8080 ];
      allowedUDPPorts = [ 51820 ];
    };

    wireguard.enable = true;
    wireguard.interfaces.wg0 = {
      ips = [ "10.100.0.1/24" ];
      listenPort = 51820;

      privateKeyFile = "/home/abe/wireguard/private";

      peers = [
        # Meeru
        {
          publicKey = "aIpyJbTs5COlGCpYhZhwf5FibTVyxUXluafF02LMBg0=";
          allowedIPs = [ "10.100.0.10/32" ];
        }
      ];

      postSetup = ''
        ${pkgs.iptables}/bin/iptables -A FORWARD -i enp1s0 -o wg0 -p tcp --syn --dport 8080 -m conntrack --ctstate NEW -j ACCEPT
        ${pkgs.iptables}/bin/iptables -A FORWARD -i wg0 -o enp1s0 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
        ${pkgs.iptables}/bin/iptables -t nat -A PREROUTING -i enp1s0 -p tcp --dport 8080 -j DNAT --to-destination 10.100.0.10
        ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -o wg0 -p tcp --dport 8080 -d 10.100.0.10 -j SNAT --to-source 10.100.0.1
      '';

      postShutdown = ''
        ${pkgs.iptables}/bin/iptables -D FORWARD -i enp1s0 -o wg0 -p tcp --syn --dport 8080 -m conntrack --ctstate NEW -j ACCEPT
        ${pkgs.iptables}/bin/iptables -D FORWARD -i wg0 -o enp1s0 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
        ${pkgs.iptables}/bin/iptables -t nat -D PREROUTING -i enp1s0 -p tcp --dport 8080 -j DNAT --to-destination 10.100.0.10
        ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -o wg0 -p tcp --dport 8080 -d 10.100.0.10 -j SNAT --to-source 10.100.0.1
      '';
    };
  };

  time.timeZone = "America/Sao_Paulo";
  i18n.defaultLocale = "en_US.UTF-8";

  services.openssh.enable = true;

  environment.systemPackages = with pkgs; [
    vim openssl helix git lazygit hello lsof
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
