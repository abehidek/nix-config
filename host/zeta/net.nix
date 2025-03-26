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

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      80
      81
      443
      8080
    ];
  };

  services.resolved.extraConfig = ''
    DNSStubListener=no
  '';

  # services programs

  virtualisation.docker.enable = true;

  virtualisation.arion.backend = "docker";

  virtualisation.arion.projects = {
    "nginx-proxy-manager".settings = {
      project.name = "nginx-proxy-manager";
      services."nginx-proxy-manager".service = {
        image = "jc21/nginx-proxy-manager:2.12.3";
        container_name = "nginx-proxy-manager";
        restart = "unless-stopped";
        network_mode = "host";
        ports = [
          "80:80"
          "81:81"
          "443:443"
          "443:443/udp"
        ];
        volumes = [
          "/home/abe/nginx-proxy-manager/data:/data"
          "/home/abe/nginx-proxy-manager/letsencrypt:/etc/letsencrypt"
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
