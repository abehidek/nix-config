{
  # config,
  # lib,
  pkgs,
  # modulesPath,
  nixpkgs,
  all,
  impermanence,
  name,
  ...
}:
{
  imports = [
    (all { inherit pkgs nixpkgs; })
    impermanence.nixosModules.impermanence
  ];

  networking.hostName = name;

  microvm.interfaces = [
    {
      type = "tap";
      id = "vm-${name}";
      mac = "02:00:00:00:00:01";
    }
  ];

  # It is highly recommended to share the host's nix-store
  # with the VMs to prevent building huge images.
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
      size = 2048;
    }
  ];

  microvm = {
    hypervisor = "qemu";
    socket = "control.socket";
    mem = 512;
    balloonMem = 512 * 7;
  };

  fileSystems."/persist".neededForBoot = true;

  environment.etc.machine-id.text = "9fcd46289ccf4ad0b16a048223c6ba1d";

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
    ];
    files = [
      "/etc/ssh/ssh_host_ed25519_key.pub"
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
      "/etc/ssh/ssh_host_rsa_key"
    ];
  };

  environment.persistence."/persist".users."abe".directories = [
    # xdg-user-dirs
    "Desktop"
    # $XDG_DATA_HOME
    {
      directory = ".local/share/keyrings";
      mode = "0700";
    }
    # $XDG_STATE_HOME
    ".local/state/lazygit"
    # $XDG_CONFIG_HOME
    ".config/sops"
    ".config/lazygit"
  ];

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
        Gateway = "10.0.0.1";
        DNS = [ "1.1.1.1" ];
        IPv6AcceptRA = true;
        DHCP = "no";
        Address = [ "10.0.0.13/24" ];
      };
    };
  };

  time.timeZone = "America/Sao_Paulo";
  i18n.defaultLocale = "en_US.UTF-8";

  security.sudo = {
    enable = true;
    extraConfig = ''
      Defaults  lecture="never"
    '';
  };

  virtualisation.docker.enable = true;

  users.mutableUsers = false;
  users.users."abe" = {
    uid = 1000;
    isNormalUser = true;
    initialPassword = "password";
    extraGroups = [
      "wheel"
      "video"
      "audio"
      "docker"
    ];
  };

  environment.systemPackages = with pkgs; [
    neofetch
    stress
    htop
  ];

  system.stateVersion = "25.05";
}
