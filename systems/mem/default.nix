{ pkgs, inputs, outputs, lib, config, modulesPath, ...}:

{
  imports = [
    (modulesPath + "/virtualisation/proxmox-lxc.nix") # https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/programs/git.nix
    ../global
    inputs.arion.nixosModules.arion
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

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [
      intel-media-driver # LIBVA_DRIVER_NAME=iHD
      intel-compute-runtime # OpenCL filter support (hardware tonemapping and subtitle burn-in)
      intel-ocl
      libva
      libvdpau-va-gl
      vaapiVdpau
      (vaapiIntel.override { enableHybridCodec = true; })  # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
      libdrm
    ];
  };

  networking = {
    wireguard.enable = true;
    wg-quick.interfaces = {
      # Mullvad Device: Witty Python
      wg0 = {
        address = [ "10.69.121.134/32" "fc00:bbbb:bbbb:bb01::6:7985/128" ];
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
            publicKey = "xUDPh13sY127m+7d05SOQAzzNCyufTjaGwCXkWsIjkw=";
            allowedIPs = [ "0.0.0.0/0" "::0/0" ];
            endpoint = "149.78.184.194:51820";
          }
        ];
      };
    };
    firewall = {
      enable = true;
      allowedTCPPorts = [ 7575 ];
    };
  };

  services.resolved.enable = true;

  services.xserver = {
    enable = true;
  };

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

  services.sonarr = {
    enable = true;
    openFirewall = true;
    group = "media";
  };

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

  services.prowlarr= {
    enable = true;
    openFirewall = true;
  };

  virtualisation = {
    docker = {
      enable = true;
      package = pkgs.docker;
    };

    arion = {
      backend = "docker";
      projects.homarr.settings = {
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
        };
      };
    };
  };

  programs = {
    git.enable = true;
  };

  environment = {
    systemPackages = with pkgs; [
      # tui
      helix lazygit btop intel-gpu-tools
      # cli
      hello
      lsof neofetch
      libva-utils pciutils
      glxinfo
      # jellyfin
      jellyfin
      jellyfin-web
      jellyfin-ffmpeg
      # virtualisation
      docker-compose
    ];

    variables = {
      EDITOR = "hx";
      VISUAL = "hx";
    };
  };

  users.groups = {
    media = {
      members = [
        "root" "abe"
        "jellyfin" "deluge"
        "radarr" "sonarr"
        "lidarr" "bazarr"
      ];
    };
  };

  users.users = {
    root.initialPassword = "nixos";
    root.extraGroups = [ "video" "render" ];
    jellyfin.extraGroups = [
      "audio" "video" "render"
    ];
    abe = {
      isNormalUser = true;
      initialPassword = "password";
      extraGroups = [
        "wheel" "video" "audio"
        "docker" "render"
      ];
    };
  };

  system.stateVersion = lib.version;
}
