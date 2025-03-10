{
  config,
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
  nixpkgs.config.allowUnfree = true;

  nixpkgs.config.permittedInsecurePackages = [
    "dotnet-sdk-6.0.428"
    "aspnetcore-runtime-6.0.36"
  ];

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
  boot.extraModulePackages = [ config.boot.kernelPackages.wireguard ];
  boot.kernel.sysctl = {
    "net.ipv4.ping_group_range" = "0 1000";
  };

  # system basics

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver # LIBVA_DRIVER_NAME=iHD
      intel-compute-runtime # OpenCL filter support (hardware tonemapping and subtitle burn-in)
      intel-ocl
      libva
      libvdpau-va-gl
      vaapiVdpau
      (vaapiIntel.override { enableHybridCodec = true; }) # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
      libdrm
    ];
  };

  networking = {
    wireguard.enable = true;

    # Mullvad Device: Sharp Koi
    wg-quick.interfaces.wg0 = {
      address = [
        "10.65.38.154/32"
        "fc00:bbbb:bbbb:bb01::2:2699/128"
      ];
      listenPort = 51820;
      privateKeyFile = "/home/abe/wireguard/witty-python.private.key";
      dns = [ "10.64.0.1" ];
      postUp = ''
        # Mark packets on the wg0 interface
        wg set wg0 fwmark 51820
        # Forbid anything else which doesn't go through wireguard VPN on
        # ipV4 and ipV6
        ${pkgs.iptables}/bin/iptables -A OUTPUT \
          ! -d 10.0.0.0/24 \
          ! -o wg0 \
          -m mark ! --mark $(wg show wg0 fwmark) \
          -m addrtype ! --dst-type LOCAL \
          -j REJECT
        ${pkgs.iptables}/bin/ip6tables -A OUTPUT \
          ! -o wg0 \
          -m mark ! --mark $(wg show wg0 fwmark) \
          -m addrtype ! --dst-type LOCAL \
          -j REJECT
      '';
      postDown = ''
        ${pkgs.iptables}/bin/iptables -D OUTPUT \
          ! -o wg0 \
          -m mark ! --mark $(wg show wg0 fwmark) \
          -m addrtype ! --dst-type LOCAL \
          -j REJECT
        ${pkgs.iptables}/bin/ip6tables -D OUTPUT \
          ! -o wg0 -m mark \
          ! --mark $(wg show wg0 fwmark) \
          -m addrtype ! --dst-type LOCAL \
          -j REJECT
      '';

      peers = [
        {
          publicKey = "NKscQ4mm24nsYWfpL85Cve+BKIExR0JaysldUtVSlzg=";
          allowedIPs = [
            "0.0.0.0/0"
            "::0/0"
          ];
          endpoint = "37.19.221.130:51820";
        }
      ];
    };

    firewall.enable = true;
    firewall.allowedTCPPorts = [
      7575
      8080
      8191
      9090
    ];
  };

  # services programs

  virtualisation.docker.enable = true;

  virtualisation.arion.backend = "docker";

  virtualisation.arion.projects = {
    "flaresolverr".settings = {
      project.name = "flaresolverr";
      services.flaresolverr.service = {
        image = "ghcr.io/flaresolverr/flaresolverr:latest";
        container_name = "flaresolverr";
        restart = "unless-stopped";
        environment."LOG_LEVEL" = "debug";
        ports = [ "8191:8191" ];
      };
    };

    "linkding".settings = {
      project.name = "linkding";
      services.linkding.service = {
        image = "sissbruecker/linkding:latest";
        container_name = "\$\{LD_CONTAINER_NAME:-linkding\}";
        restart = "unless-stopped";
        env_file = [ "/home/abe/linkding/env" ];
        ports = [
          "9090:9090"
        ];
        volumes = [
          "/home/abe/linkding/data:/etc/linkding/data"
        ];
      };
    };

    "homarr".settings = {
      project.name = "homarr";
      services.homarr.service = {
        image = "ghcr.io/ajnart/homarr:latest";
        container_name = "homarr";
        restart = "unless-stopped";
        network_mode = "host";
        ports = [
          "7575:7575"
        ];
        volumes = [
          "/var/run/docker.sock:/var/run/docker.sock"
          "/home/abe/homarr/configs:/app/data/configs"
          "/home/abe/homarr/icons:/app/public/icons"
          "/home/abe/homarr/data:/data"
        ];
        healthcheck = {
          interval = "30s";
          timeout = "10s";
          retries = 5;
          test = [
            "CMD"
            "curl"
            "-f"
            "http://localhost:7575"
          ];
        };
      };
    };
  };

  services.resolved.enable = true;

  services.xserver.enable = true;

  services.jellyfin = {
    enable = true;
    package = pkgs.jellyfin;
    openFirewall = true;
  };

  services.jellyseerr = {
    enable = true;
    openFirewall = true;
  };

  services.deluge = {
    enable = true;
    openFirewall = true;
    group = "media";

    web = {
      enable = true;
      openFirewall = true;
    };
  };

  services.radarr = {
    enable = true;
    openFirewall = true;
    group = "media";
  };

  # services.sonarr = {
  #   enable = true;
  #   openFirewall = true;
  #   group = "media";
  # };

  services.lidarr = {
    enable = true;
    openFirewall = true;
    group = "media";
  };

  services.bazarr = {
    enable = true;
    openFirewall = true;
    group = "media";
  };

  services.prowlarr = {
    enable = true;
    openFirewall = true;
  };

  services.miniflux = {
    enable = true;
    adminCredentialsFile = "/home/abe/miniflux/admin-credentials";
    config = {
      LISTEN_ADDR = "0.0.0.0:8080";
    };
  };

  programs.git.enable = true;

  # environment & packages

  environment.variables = {
    EDITOR = "hx";
    VISUAL = "hx";
  };

  environment.systemPackages = with pkgs; [
    # tui
    helix
    lazygit
    btop
    intel-gpu-tools
    # cli
    hello
    lsof
    neofetch
    pfetch
    libva-utils
    pciutils
    glxinfo
    # jellyfin
    jellyfin
    jellyfin-web
    jellyfin-ffmpeg
    # virtualisation
    docker-compose
  ];

  # users and home-manager

  users.groups.media.members = [
    "root"
    "abe"
    "jellyfin"
    "deluge"
    "radarr"
    "sonarr"
    "lidarr"
    "bazarr"
  ];

  users.users.root.initialPassword = "nixos";
  users.users.root.extraGroups = [
    "video"
    "render"
  ];

  users.users.jellyfin.extraGroups = [
    "audio"
    "video"
    "render"
  ];

  users.users.abe = {
    isNormalUser = true;
    initialPassword = "password";
    extraGroups = [
      "wheel"
      "video"
      "audio"
      "docker"
      "render"
    ];
  };

  system.stateVersion = "24.11";
}
