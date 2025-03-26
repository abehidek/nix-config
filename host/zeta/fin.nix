{
  # config,
  # lib,
  pkgs,
  modulesPath,
  nixpkgs,
  paths,
  all,
  arion,
  ...
}:

{
  imports = [
    (modulesPath + "/virtualisation/proxmox-lxc.nix")
    (all { inherit pkgs nixpkgs paths; })

    arion.nixosModules.arion
  ];

  # hardware and boot

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

  # networking

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      80
      443
      3000
      4000
      8080
    ];
  };

  # services programs

  virtualisation.docker.enable = true;

  virtualisation.arion.backend = "docker";

  virtualisation.arion.projects = {
    "baikal".settings = {
      project.name = "baikal";
      services."baikal".service = {
        image = "ckulka/baikal:nginx";
        restart = "unless-stopped";
        ports = [ "4000:80" ];
        volumes = [
          "/home/abe/baikal/config:/var/www/baikal/config"
          "/home/abe/baikal/data:/var/www/baikal/Specific"
        ];
      };
    };

    "rmfakecloud".settings = {
      project.name = "rmfakecloud";
      services.rmfakecloud.service = {
        image = "ddvk/rmfakecloud:0.0.23";
        container_name = "rmfakecloud";
        restart = "unless-stopped";
        ports = [ "3000:3000" ];
        env_file = [ "/home/abe/rmfakecloud/env" ];
        volumes = [
          "/home/abe/rmfakecloud/data:/data"
          "/mnt/hako/life/references/books:/data/media/books"
          "/mnt/hako/life:/data/media/life"
        ];
      };
    };

  };

  programs.git.enable = true;

  environment = {
    systemPackages = with pkgs; [
      # tui
      helix
      lazygit
      # cli
      lsof
      neofetch
      htop
      fastfetch
      # virtualisation
      docker-compose
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
      extraGroups = [
        "wheel"
        "video"
        "audio"
        "docker"
      ];
    };
  };

  system.stateVersion = "24.11";
}
