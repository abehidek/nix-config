{
  # config,
  # lib,
  pkgs,
  # modulesPath,
  nixpkgs,
  paths,
  all,
  impermanence,
  name,
  machineId,
  macAddress,
  ...
}:
{
  imports = [
    (all { inherit pkgs nixpkgs paths; })
    impermanence.nixosModules.impermanence
  ];

  # networking

  microvm.interfaces = [
    {
      type = "tap";
      id = "vm-${name}";
      mac = macAddress;
    }
  ];

  networking = {
    networkmanager.enable = false;
    hostName = name;
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      5432 # postgresql
      6443 # k3s
    ];
    allowedUDPPorts = [ 6443 ];
  };

  networking.useNetworkd = true;

  systemd.network = {
    enable = true;
    networks."19-docker" = {
      matchConfig.Name = "veth*";
      linkConfig = {
        Unmanaged = true;
      };
    };
    networks."20-lan" = {
      matchConfig.Type = "ether";
      networkConfig = {
        IPv6AcceptRA = true;
        DHCP = "yes";
      };
    };
  };

  # hardware and boot

  microvm = {
    hypervisor = "qemu";
    socket = "control.socket";
    mem = 512;
    balloonMem = 512 * 7;
  };

  /*
    It is highly recommended to share the host's nix-store
    with the VMs to prevent building huge images.
  */
  microvm.shares = [
    {
      source = "/nix/store";
      mountPoint = "/nix/.ro-store";
      tag = "ro-store";
      proto = "virtiofs";
    }
    {
      source = "/var/lib/microvms/${name}/persist"; # before creating the vm, please create this folder beforehand
      mountPoint = "/persist";
      tag = "persist";
      proto = "virtiofs";
    }
  ];

  microvm.volumes = [
    {
      mountPoint = "/var";
      image = "var.img";
      size = 8192;
    }
  ];

  fileSystems."/persist".neededForBoot = true;

  environment.etc.machine-id.text = machineId;

  environment.persistence."/persist" = {
    enable = true;
    hideMounts = true;
    directories = [
      "/etc/nixos"
      "/var/log"
      "/var/lib/sops-nix"
      "/var/lib/nixos"
      "/var/lib/systemd/coredump"
      "/etc/NetworkManager/system-connections"
      "/var/lib/docker"
      "/var/lib/postgresql"
    ];
    files = [
      "/etc/ssh/ssh_host_ed25519_key.pub"
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
      "/etc/ssh/ssh_host_rsa_key"
    ];
  };

  environment.persistence."/persist".users."abe".directories = [
    ".local/state/lazygit"
    ".config/sops"
    ".config/lazygit"
    "Desktop"
  ];

  # system basics

  time.timeZone = "America/Sao_Paulo";
  i18n.defaultLocale = "en_US.UTF-8";

  security.sudo = {
    enable = true;
    extraConfig = ''
      Defaults  lecture="never"
    '';
  };

  # services programs

  services.nginx = {
    enable = true;
    config = ''
      events {}

      stream {
        upstream k3s_servers {
          server 10.0.0.107:6443;
          server 10.0.0.108:6443;
        }

        server {
          listen      6443;
          proxy_pass  k3s_servers;
        }
      }
    '';
  };

  services.postgresql =
    let
      userName = "k3s";
      userPwd = "password";
    in
    {
      enable = true;
      ensureDatabases = [ userName ];
      enableTCPIP = true;
      authentication = pkgs.lib.mkOverride 10 ''
        #...
        #type database DBuser origin-address auth-method
        local all      all     trust
        # ipv4
        host  all      all     127.0.0.1/32   trust
        host  all      all     10.0.0.48/24   trust
        # ipv6
        host all       all     ::1/128        trust
      '';
      initialScript = pkgs.writeText "backend-initScript" ''
        CREATE ROLE ${userName} WITH LOGIN PASSWORD '${userPwd}' CREATEDB;
        CREATE DATABASE ${userName};
        GRANT ALL PRIVILEGES ON DATABASE ${userName} TO ${userName};
        GRANT ALL ON SCHEMA public TO k3s;
      '';
    };

  # environment & packages

  environment.systemPackages = with pkgs; [
    neofetch
    stress
    htop
    lazygit
    helix
  ];

  users.mutableUsers = false;
  users.users."abe" = {
    uid = 1000;
    isNormalUser = true;
    initialPassword = "password";
    extraGroups = [
      "wheel"
      "video"
      "audio"
    ];
  };

  system.stateVersion = "25.05";
}
