{ pkgs, inputs, outputs, lib, config, modulesPath, ...}:

{
  imports = [
    (modulesPath + "/virtualisation/proxmox-lxc.nix") # https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/programs/git.nix
    ../global
    inputs.arion.nixosModules.arion
    inputs.playit-nixos-module.nixosModules.default
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
      allowedTCPPortRanges = [
        {
          from = 25000;
          to = 25100;
        }
        {
          from = 25500;
          to = 25600;
        }
        {
          from = 54000;
          to = 55000;
        }
      ];
      allowedTCPPorts = [ 8000 8080 8123 8443 25700 ];
      allowedUDPPorts = [ 19132 ];
    };
  };

  services.playit = {
    enable = true;
    secretPath = "/mnt/hako/mc/playit.gg/secret.toml";
  };

  virtualisation = {
    docker = {
      enable = true;
      package = pkgs.docker;
    };

    arion = {
      backend = "docker";
      projects."beta".settings = {
        project.name = "beta";
        services."beta".service = {
          build = {
            context = "/mnt/hako/mc/beta";
            dockerfile = "Dockerfile";
          };
          container_name = "beta_container";
          restart = "unless-stopped";
          ports = [
            "25700:25700"
          ];
          volumes = [
            "/mnt/hako/mc/beta/server:/server"
          ];
        };
      };
      projects.crafty.settings = {
        project.name = "crafty";
        services.crafty.service = {
          image = "registry.gitlab.com/crafty-controller/crafty-4:latest";
          container_name = "crafty_container";
          restart = "unless-stopped";
          environment = {
            TZ = "Etc/UTC";
          };
          ports = [
            "8000:8000"
            "8080:8080"
            "8443:8443" # HTTPS
            "8123:8123" # DYNMAP
            "19132:19132/udp" # BEDROCK
            "25500-25600:25500-25600" # MC SERV PORT RANGE
            "25000-25100:25000-25100" # DH SERV PORT RANGE
            "54045:54045"
            "54887:54887"
          ];
          volumes = [
            "/mnt/hako/mc/crafty/backups:/crafty/backups"
            "/mnt/hako/mc/crafty/logs:/crafty/logs"
            "/mnt/hako/mc/crafty/servers:/crafty/servers"
            "/mnt/hako/mc/crafty/config:/crafty/app/config"
            "/mnt/hako/mc/crafty/import:/crafty/import"
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
      helix lazygit
      # cli
      lsof neofetch htop
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
