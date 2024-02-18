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
  boot.extraModulePackages = [ config.boot.kernelPackages.wireguard ];
  boot.kernel.sysctl = {
    "net.ipv4.ping_group_range" = "0 1000";
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 80 443 8080 ];
    wireguard.enable = true;
    wg-quick.interfaces = {
      wg0 = {
        privateKeyFile = "/home/abe/wireguard/privatekey";
        address = [ "10.100.0.2/24" ];

        peers = [
          # Roxy
          {
            publicKey = "OhX7LDv+XDV5s0CqYNjcUbhFLjZO9zZTEWvHjKBmyXA=";
            allowedIPs = [ "10.100.0.1/24" ];
            endpoint = "216.238.102.51:55107";
            persistentKeepalive = 25;
          }
        ];
      };
    };
  };


  virtualisation = {
    docker = {
      enable = true;
      package = pkgs.docker;
    };
    podman = {
      enable = true;
      # Create docker alias for podman and use as replacement
      dockerCompat = false;
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  programs = {
    git.enable = true;
  };

  environment = {
    systemPackages = with pkgs; [
      # tui
      helix lazygit
      # cli
      lsof neofetch htop
      # virtualisation
      docker-compose
      podman-compose
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
      extraGroups = [ "wheel" "video" "audio" "docker" "podman" ];
    };
  };

  system.stateVersion = lib.version;
}
