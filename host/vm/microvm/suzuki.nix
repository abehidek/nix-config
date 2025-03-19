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
  id-machine,
  mac,
  ...
}:
{
  imports = [
    (all { inherit pkgs nixpkgs paths; })
    impermanence.nixosModules.impermanence
  ];

  # microvm-guest opts

  microvm = {
    hypervisor = "qemu";
    socket = "control.socket";
    mem = 512;
    balloonMem = 512 * 3;
    interfaces = [
      {
        inherit mac;
        type = "tap";
        id = "vm-${name}";
      }
    ];
    volumes = [
      {
        mountPoint = "/var";
        image = "var.img";
        size = 8192;
      }
    ];
    shares = [
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
  };

  # networking

  networking = {
    hostName = name;
    networkmanager.enable = false;
    firewall.enable = false;
    useNetworkd = true;
  };

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

  fileSystems."/persist".neededForBoot = true;

  environment.etc.machine-id.text = id-machine;

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

  environment.systemPackages = with pkgs; [
    neofetch
    pfetch
    htop
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
