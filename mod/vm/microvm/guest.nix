{
  config,
  lib,
  # pkgs,
  # modulesPath,
  ...
}:
let
  cfg = config."hidekxyz"."vm"."microvm"."guest";
in
{
  options."hidekxyz"."vm"."microvm"."guest" = with lib; {
    hostName = mkOption { type = types.str; };
    hostId = mkOption { type = types.str; };
    mac = mkOption { type = types.str; };
    memSize = mkOption { type = types.ints.positive; };
    imageSize = mkOption { type = types.ints.positive; };
    persistence = {
      dirs = mkOption {
        type = types.listOf (types.str);
        default = [ ];
      };
      files = mkOption {
        type = types.listOf (types.str);
        default = [ ];
      };
      userDirs = mkOption {
        type = types.listOf (types.str);
        default = [ ];
      };
    };
  };

  config = {
    # microvm opts

    microvm = {
      hypervisor = "qemu";
      socket = "control.socket";
      mem = 512;
      balloonMem = cfg.memSize;
      interfaces = [
        {
          mac = cfg.mac;
          type = "tap";
          id = "vm-${cfg.hostName}";
        }
      ];
      volumes = [
        {
          mountPoint = "/var";
          image = "var.img";
          size = cfg.imageSize;
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
          source = "/var/lib/microvms/${cfg.hostName}/persist"; # before creating the vm, please create this folder beforehand
          mountPoint = "/persist";
          tag = "persist";
          proto = "virtiofs";
        }
      ];
    };

    # networking

    networking = {
      hostName = cfg.hostName;
      networkmanager.enable = false;
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

    # persistence

    fileSystems."/persist".neededForBoot = true;
    environment.etc.machine-id.text = cfg.hostId;

    environment.persistence."/persist" = {
      enable = true;
      hideMounts = true;
      directories = [
        "/etc/nixos"
        "/var/log"
        "/var/lib/sops-nix"
        "/var/lib/nixos"
        "/var/lib/systemd/coredump"
      ] ++ cfg.persistence.dirs;
      files = [
        "/etc/ssh/ssh_host_ed25519_key.pub"
        "/etc/ssh/ssh_host_ed25519_key"
        "/etc/ssh/ssh_host_rsa_key.pub"
        "/etc/ssh/ssh_host_rsa_key"
      ] ++ cfg.persistence.files;
    };

    environment.persistence."/persist".users."abe".directories = [
      ".local/state/lazygit"
      ".config/sops"
      ".config/lazygit"
      "Desktop"
    ] ++ cfg.persistence.userDirs;

    # system basics
    time.timeZone = "America/Sao_Paulo";
    i18n.defaultLocale = "en_US.UTF-8";

    security.sudo = {
      enable = true;
      extraConfig = ''
        Defaults  lecture="never"
      '';
    };
  };
}
