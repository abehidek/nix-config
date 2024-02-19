{ pkgs, inputs, outputs, lib, config, modulesPath, ...}:

{
  imports = [
    (modulesPath + "/virtualisation/proxmox-lxc.nix") # https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/programs/git.nix
    ../global
  ];

  proxmoxLXC = {
    privileged = false;
    manageNetwork = false;
    manageHostName = false;
  };

  systemd.suppressedSystemUnits = [
    "dev-mqueue.mount"
    "sys-kernel-debug.mount"
    "sys-fs-fuse-connections.mount"
  ];

  boot.loader.grub.enable = false;
  boot.kernel.sysctl = {
    "net.ipv4.ping_group_range" = "0 1000";
  };

  networking = {
    nameservers = [ "1.1.1.1" "1.0.0.1" ];
    firewall = {
      enable = true;
      allowedTCPPorts = [
        25 80 110 143
        443 465 587
        993 995 4190

        8080 # mailcow admin
      ];
    };

    wireguard.enable = true;
    wireguard.interfaces.wg0 = {
      ips = [ "10.100.0.10/24" ];
      privateKeyFile = "/home/abe/wireguard/private";

      peers = [
        # Roxy
        {
          publicKey = "xLFRMckFCt1B0x6Vf1hsYUlF7QAMupVuqQ09uCI49i0=";
          allowedIPs = [ "10.100.0.1" ];
          endpoint = "216.238.102.51:51820";
          persistentKeepalive = 25;
        }
      ];
    };
  };

  programs = {
    git.enable = true;
  };

  services.fail2ban = {
    enable = true;
  };

  virtualisation = {
    docker = {
      enable = true;
      package = pkgs.docker;
    };
  };

  environment = {
    systemPackages = with pkgs; [
      # tui
      helix lazygit hello
      # cli
      lsof neofetch htop
      # virtualisation
      docker-compose
      # utils
      openssl certbot
    ];

    variables = {
      EDITOR = "hx";
      VISUAL = "hx";
    };
  };

  users.users = {
    root.initialPassword = "nixos";
    abe = {
      isNormalUser = true;
      initialPassword = "password";
      extraGroups = [ "wheel" "video" "audio" "docker" ];
    };
  };

  system.stateVersion = lib.version;
}
