{
  config,
  lib,
  pkgs,
  # modulesPath,
  nixpkgs,
  all,
  impermanence,
  ...
}:
{
  imports = [
    (all { inherit pkgs nixpkgs; })
    impermanence.nixosModules.impermanence
  ];

  fileSystems."/persist".neededForBoot = true;

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

  environment.persistence."/persist".users.abe.directories = [
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
      source = "/var/lib/microvms/vm-test3/persist";
      mountPoint = "/persist";
      tag = "persist";
      proto = "virtiofs";
    }
  ];

  # Any other configuration for your MicroVM
  # [...]
  microvm = {
    hypervisor = "qemu";
    socket = "control.socket";
    mem = 4096;
    volumes = [
      {
        mountPoint = "/var";
        image = "var.img";
        size = 2048;
      }
    ];
    interfaces = [
      {
        type = "tap";
        id = "vm-test3";
        mac = "02:00:00:00:00:01";
      }
    ];
  };

  systemd.network = {
    enable = true;
    networks."20-lan" = {
      matchConfig.Type = "ether";
      networkConfig = {
        Address = [
          "10.0.0.13/24"
          "2001:db8::b/64"
        ];
        Gateway = "10.0.0.1";
        DNS = [ "1.1.1.1" ];
        IPv6AcceptRA = true;
        DHCP = "no";
      };
    };

    networks."19-docker" = {
      matchConfig.Name = "veth*";
      linkConfig = {
        Unmanaged = true;
      };
    };
  };

  time.timeZone = "America/Sao_Paulo";
  i18n.defaultLocale = "en_US.UTF-8";

  networking.hostName = "vm-test3";

  security.sudo = {
    enable = true;
    extraConfig = ''
      Defaults  lecture="never"
    '';
  };

  virtualisation.docker.enable = true;

  users.mutableUsers = false;
  users.users.abe = {
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

  environment.etc.machine-id.text = "9fcd46289ccf4ad0b16a048223c6ba1d";

  environment.systemPackages = with pkgs; [ neofetch ];

  system.stateVersion = "25.05";
}
