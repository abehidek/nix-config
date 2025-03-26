{
  # config,
  # lib,
  pkgs,
  # modulesPath,
  # nixpkgs,
  modules,
  ...
}:
{
  imports = [
    modules.all.linux
    modules.system
    ./hardware.nix
  ];

  # hidekxyz

  hidekxyz = {
    all.mainUser = "abe";
    system.hostname = "roxy";
  };

  # hardware and boot

  boot = {
    tmp.cleanOnBoot = true;
    kernel.sysctl."net.ipv4.ip_forward" = "1";
  };

  zramSwap.enable = true;

  # network

  networking = {
    nameservers = [
      "1.1.1.1"
      "1.0.0.1"
    ];
    firewall = {
      enable = true;
      allowedTCPPorts = [
        # 80 443 # http/https for mailcow/sogo webmin
        25
        110
        143
        465
        587
        993
        995
        4190
      ];
      allowedUDPPorts = [ 51820 ]; # for Wireguard
    };

    wireguard = {
      enable = true;
      interfaces.wg0 = {
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
          # Port 25
          ${pkgs.iptables}/bin/iptables -A FORWARD -i enp1s0 -o wg0 -p tcp --syn --dport 25 -m conntrack --ctstate NEW -j ACCEPT
          ${pkgs.iptables}/bin/iptables -A FORWARD -i wg0 -o enp1s0 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
          ${pkgs.iptables}/bin/iptables -t nat -A PREROUTING -i enp1s0 -p tcp --dport 25 -j DNAT --to-destination 10.100.0.10
          ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -o wg0 -p tcp --dport 25 -d 10.100.0.10 -j SNAT --to-source 10.100.0.1
          # Port 80
          ${pkgs.iptables}/bin/iptables -A FORWARD -i enp1s0 -o wg0 -p tcp --syn --dport 80 -m conntrack --ctstate NEW -j ACCEPT
          ${pkgs.iptables}/bin/iptables -A FORWARD -i wg0 -o enp1s0 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
          ${pkgs.iptables}/bin/iptables -t nat -A PREROUTING -i enp1s0 -p tcp --dport 80 -j DNAT --to-destination 10.100.0.10
          ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -o wg0 -p tcp --dport 80 -d 10.100.0.10 -j SNAT --to-source 10.100.0.1
          # Port 110
          ${pkgs.iptables}/bin/iptables -A FORWARD -i enp1s0 -o wg0 -p tcp --syn --dport 110 -m conntrack --ctstate NEW -j ACCEPT
          ${pkgs.iptables}/bin/iptables -A FORWARD -i wg0 -o enp1s0 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
          ${pkgs.iptables}/bin/iptables -t nat -A PREROUTING -i enp1s0 -p tcp --dport 110 -j DNAT --to-destination 10.100.0.10
          ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -o wg0 -p tcp --dport 110 -d 10.100.0.10 -j SNAT --to-source 10.100.0.1
          # Port 143
          ${pkgs.iptables}/bin/iptables -A FORWARD -i enp1s0 -o wg0 -p tcp --syn --dport 143 -m conntrack --ctstate NEW -j ACCEPT
          ${pkgs.iptables}/bin/iptables -A FORWARD -i wg0 -o enp1s0 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
          ${pkgs.iptables}/bin/iptables -t nat -A PREROUTING -i enp1s0 -p tcp --dport 143 -j DNAT --to-destination 10.100.0.10
          ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -o wg0 -p tcp --dport 143 -d 10.100.0.10 -j SNAT --to-source 10.100.0.1
          # Port 443
          # ${pkgs.iptables}/bin/iptables -A FORWARD -i enp1s0 -o wg0 -p tcp --syn --dport 443 -m conntrack --ctstate NEW -j ACCEPT
          # ${pkgs.iptables}/bin/iptables -A FORWARD -i wg0 -o enp1s0 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
          # ${pkgs.iptables}/bin/iptables -t nat -A PREROUTING -i enp1s0 -p tcp --dport 443 -j DNAT --to-destination 10.100.0.10
          # ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -o wg0 -p tcp --dport 443 -d 10.100.0.10 -j SNAT --to-source 10.100.0.1
          # Port 465
          ${pkgs.iptables}/bin/iptables -A FORWARD -i enp1s0 -o wg0 -p tcp --syn --dport 465 -m conntrack --ctstate NEW -j ACCEPT
          ${pkgs.iptables}/bin/iptables -A FORWARD -i wg0 -o enp1s0 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
          ${pkgs.iptables}/bin/iptables -t nat -A PREROUTING -i enp1s0 -p tcp --dport 465 -j DNAT --to-destination 10.100.0.10
          ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -o wg0 -p tcp --dport 465 -d 10.100.0.10 -j SNAT --to-source 10.100.0.1
          # Port 587
          ${pkgs.iptables}/bin/iptables -A FORWARD -i enp1s0 -o wg0 -p tcp --syn --dport 587 -m conntrack --ctstate NEW -j ACCEPT
          ${pkgs.iptables}/bin/iptables -A FORWARD -i wg0 -o enp1s0 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
          ${pkgs.iptables}/bin/iptables -t nat -A PREROUTING -i enp1s0 -p tcp --dport 587 -j DNAT --to-destination 10.100.0.10
          ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -o wg0 -p tcp --dport 587 -d 10.100.0.10 -j SNAT --to-source 10.100.0.1
          # Port 993
          ${pkgs.iptables}/bin/iptables -A FORWARD -i enp1s0 -o wg0 -p tcp --syn --dport 993 -m conntrack --ctstate NEW -j ACCEPT
          ${pkgs.iptables}/bin/iptables -A FORWARD -i wg0 -o enp1s0 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
          ${pkgs.iptables}/bin/iptables -t nat -A PREROUTING -i enp1s0 -p tcp --dport 993 -j DNAT --to-destination 10.100.0.10
          ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -o wg0 -p tcp --dport 993 -d 10.100.0.10 -j SNAT --to-source 10.100.0.1
          # Port 995
          ${pkgs.iptables}/bin/iptables -A FORWARD -i enp1s0 -o wg0 -p tcp --syn --dport 995 -m conntrack --ctstate NEW -j ACCEPT
          ${pkgs.iptables}/bin/iptables -A FORWARD -i wg0 -o enp1s0 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
          ${pkgs.iptables}/bin/iptables -t nat -A PREROUTING -i enp1s0 -p tcp --dport 995 -j DNAT --to-destination 10.100.0.10
          ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -o wg0 -p tcp --dport 995 -d 10.100.0.10 -j SNAT --to-source 10.100.0.1
          # Port 4190
          ${pkgs.iptables}/bin/iptables -A FORWARD -i enp1s0 -o wg0 -p tcp --syn --dport 4190 -m conntrack --ctstate NEW -j ACCEPT
          ${pkgs.iptables}/bin/iptables -A FORWARD -i wg0 -o enp1s0 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
          ${pkgs.iptables}/bin/iptables -t nat -A PREROUTING -i enp1s0 -p tcp --dport 4190 -j DNAT --to-destination 10.100.0.10
          ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -o wg0 -p tcp --dport 4190 -d 10.100.0.10 -j SNAT --to-source 10.100.0.1
        '';

        postShutdown = ''
          # Port 25
          ${pkgs.iptables}/bin/iptables -D FORWARD -i enp1s0 -o wg0 -p tcp --syn --dport 25 -m conntrack --ctstate NEW -j ACCEPT
          ${pkgs.iptables}/bin/iptables -D FORWARD -i wg0 -o enp1s0 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
          ${pkgs.iptables}/bin/iptables -t nat -D PREROUTING -i enp1s0 -p tcp --dport 25 -j DNAT --to-destination 10.100.0.10
          ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -o wg0 -p tcp --dport 25 -d 10.100.0.10 -j SNAT --to-source 10.100.0.1
          # Port 80
          ${pkgs.iptables}/bin/iptables -D FORWARD -i enp1s0 -o wg0 -p tcp --syn --dport 80 -m conntrack --ctstate NEW -j ACCEPT
          ${pkgs.iptables}/bin/iptables -D FORWARD -i wg0 -o enp1s0 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
          ${pkgs.iptables}/bin/iptables -t nat -D PREROUTING -i enp1s0 -p tcp --dport 80 -j DNAT --to-destination 10.100.0.10
          ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -o wg0 -p tcp --dport 80 -d 10.100.0.10 -j SNAT --to-source 10.100.0.1
          # Port 110
          ${pkgs.iptables}/bin/iptables -D FORWARD -i enp1s0 -o wg0 -p tcp --syn --dport 110 -m conntrack --ctstate NEW -j ACCEPT
          ${pkgs.iptables}/bin/iptables -D FORWARD -i wg0 -o enp1s0 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
          ${pkgs.iptables}/bin/iptables -t nat -D PREROUTING -i enp1s0 -p tcp --dport 110 -j DNAT --to-destination 10.100.0.10
          ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -o wg0 -p tcp --dport 110 -d 10.100.0.10 -j SNAT --to-source 10.100.0.1
          # Port 143
          ${pkgs.iptables}/bin/iptables -D FORWARD -i enp1s0 -o wg0 -p tcp --syn --dport 143 -m conntrack --ctstate NEW -j ACCEPT
          ${pkgs.iptables}/bin/iptables -D FORWARD -i wg0 -o enp1s0 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
          ${pkgs.iptables}/bin/iptables -t nat -D PREROUTING -i enp1s0 -p tcp --dport 143 -j DNAT --to-destination 10.100.0.10
          ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -o wg0 -p tcp --dport 143 -d 10.100.0.10 -j SNAT --to-source 10.100.0.1
          # Port 443
          # ${pkgs.iptables}/bin/iptables -D FORWARD -i enp1s0 -o wg0 -p tcp --syn --dport 443 -m conntrack --ctstate NEW -j ACCEPT
          # ${pkgs.iptables}/bin/iptables -D FORWARD -i wg0 -o enp1s0 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
          # ${pkgs.iptables}/bin/iptables -t nat -D PREROUTING -i enp1s0 -p tcp --dport 443 -j DNAT --to-destination 10.100.0.10
          # ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -o wg0 -p tcp --dport 443 -d 10.100.0.10 -j SNAT --to-source 10.100.0.1
          # Port 465
          ${pkgs.iptables}/bin/iptables -D FORWARD -i enp1s0 -o wg0 -p tcp --syn --dport 465 -m conntrack --ctstate NEW -j ACCEPT
          ${pkgs.iptables}/bin/iptables -D FORWARD -i wg0 -o enp1s0 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
          ${pkgs.iptables}/bin/iptables -t nat -D PREROUTING -i enp1s0 -p tcp --dport 465 -j DNAT --to-destination 10.100.0.10
          ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -o wg0 -p tcp --dport 465 -d 10.100.0.10 -j SNAT --to-source 10.100.0.1
          # Port 587
          ${pkgs.iptables}/bin/iptables -D FORWARD -i enp1s0 -o wg0 -p tcp --syn --dport 587 -m conntrack --ctstate NEW -j ACCEPT
          ${pkgs.iptables}/bin/iptables -D FORWARD -i wg0 -o enp1s0 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
          ${pkgs.iptables}/bin/iptables -t nat -D PREROUTING -i enp1s0 -p tcp --dport 587 -j DNAT --to-destination 10.100.0.10
          ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -o wg0 -p tcp --dport 587 -d 10.100.0.10 -j SNAT --to-source 10.100.0.1
          # Port 993
          ${pkgs.iptables}/bin/iptables -D FORWARD -i enp1s0 -o wg0 -p tcp --syn --dport 993 -m conntrack --ctstate NEW -j ACCEPT
          ${pkgs.iptables}/bin/iptables -D FORWARD -i wg0 -o enp1s0 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
          ${pkgs.iptables}/bin/iptables -t nat -D PREROUTING -i enp1s0 -p tcp --dport 993 -j DNAT --to-destination 10.100.0.10
          ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -o wg0 -p tcp --dport 993 -d 10.100.0.10 -j SNAT --to-source 10.100.0.1
          # Port 995
          ${pkgs.iptables}/bin/iptables -D FORWARD -i enp1s0 -o wg0 -p tcp --syn --dport 995 -m conntrack --ctstate NEW -j ACCEPT
          ${pkgs.iptables}/bin/iptables -D FORWARD -i wg0 -o enp1s0 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
          ${pkgs.iptables}/bin/iptables -t nat -D PREROUTING -i enp1s0 -p tcp --dport 995 -j DNAT --to-destination 10.100.0.10
          ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -o wg0 -p tcp --dport 995 -d 10.100.0.10 -j SNAT --to-source 10.100.0.1
          # Port 4190
          ${pkgs.iptables}/bin/iptables -D FORWARD -i enp1s0 -o wg0 -p tcp --syn --dport 4190 -m conntrack --ctstate NEW -j ACCEPT
          ${pkgs.iptables}/bin/iptables -D FORWARD -i wg0 -o enp1s0 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
          ${pkgs.iptables}/bin/iptables -t nat -D PREROUTING -i enp1s0 -p tcp --dport 4190 -j DNAT --to-destination 10.100.0.10
          ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -o wg0 -p tcp --dport 4190 -d 10.100.0.10 -j SNAT --to-source 10.100.0.1
        '';
      };
    };
  };

  # services programs

  services.openssh.enable = true;

  services.fail2ban.enable = true;

  # environment & packages

  environment.systemPackages = with pkgs; [
    openssl
    lsof

    helix
    git
    lazygit
  ];

  environment.variables = {
    EDITOR = "hx";
    VISUAL = "hx";
  };

  # users and home-manager

  users.users.abe = {
    isNormalUser = true;
    initialPassword = "password";
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  };

  system.stateVersion = "23.11";
}
