{
  config,
  lib,
  pkgs,
  # modulesPath,
  nixpkgs,
  # home-manager,
  # nur,
  all,
  # all-users,
  # nix-secrets,
  # sops-nix,
  disko,
  impermanence,
  microvm,
  nixvirt,
  ...
}:

let
  device = "/dev/disk/by-id/nvme-SSD_128GB_AA000000000000000276";
  zpool_name = "mroot";
in
{
  imports = [
    (import ./microvm.nix {
      inherit
        config
        lib
        pkgs
        nixpkgs
        all
        impermanence
        ;
    })
    (all { inherit pkgs nixpkgs; })
    disko.nixosModules.disko
    impermanence.nixosModules.impermanence
    microvm.nixosModules.host
    nixvirt.nixosModules.default

    (import ./disko.nix { inherit device zpool_name; })
    (import ./impermanence.nix { machineId = "e8ccbf623edf4dd6aa83732a65ce08cb"; })

    ./hardware.nix
  ];

  # hardware and boot

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";

  fileSystems."/persist".neededForBoot = true;

  boot.consoleLogLevel = 0;

  boot.kernelParams = [
    "quiet"
    "elevator=none"
    "udev.log_level=3"
    "zfs.zfs_arc_max=${toString (512 * 1048576)}" # max of 512mb for ZFS
    "intel_iommu=on"
  ];

  boot.initrd.supportedFilesystems = [ "zfs" ];
  boot.supportedFilesystems = [ "zfs" ];

  boot.zfs = {
    forceImportRoot = false;
    devNodes = lib.mkDefault "/dev/disk/by-id";
  };

  boot.initrd.systemd = {
    enable = lib.mkDefault true;
    services.reset = {
      description = "Rollback root filesystem to a pristine state on boot";
      wantedBy = [ "initrd.target" ];
      after = [ "zfs-import-${zpool_name}.service" ];
      before = [ "sysroot.mount" ];
      path = with pkgs; [ zfs ];
      unitConfig.DefaultDependencies = "no";
      serviceConfig.Type = "oneshot";
      script = "zfs rollback -r ${zpool_name}/local/root@empty";
    };

    services.enable_vfio = {
      description = "Enable vfio for specific devices";
      wantedBy = [ "initrd.target" ];
      before = [ "systemd-udevd.service" ];
      unitConfig.DefaultDependencies = "no";
      serviceConfig.Type = "oneshot";
      script = ''
        DEVS="0000:04:00.0 0000:05:00.0"
        for DEV in $DEVS; do
          echo "vfio-pci" > /sys/bus/pci/devices/$DEV/driver_override
        done
        modprobe -i vfio-pci
      ''; # enp4s0 enp5s0
    };
  };

  zramSwap.enable = true;

  # system basics

  time.timeZone = "America/Sao_Paulo";
  i18n.defaultLocale = "en_US.UTF-8";

  networking = {
    networkmanager.enable = true;
    hostName = "mokou";
    hostId = "f9ed0642"; # required by ZFS
  };

  security.sudo = {
    enable = true;
    extraConfig = ''
      Defaults  lecture="never"
    '';
  };

  # services programs

  services.zfs = {
    autoScrub.enable = true;
    autoSnapshot.enable = true;
  };

  virtualisation.libvirtd = {
    enable = true;
    qemu.package = pkgs.qemu_kvm;
    qemu.runAsRoot = true;
    qemu.ovmf.enable = true;
  };

  virtualisation.libvirt = {
    enable = true;
    connections."qemu:///system" = {
      networks = [
        {
          active = true;
          definition = nixvirt.lib.network.writeXML {
            name = "default";
            uuid = "6aec104f-3126-458a-918e-54e2b9e66b18";
            forward.mode = "nat";
            bridge.name = "virbr0";
            mac.address = "52:54:00:1f:7b:b0";
            ip = {
              address = "192.168.122.1";
              netmask = "255.255.255.0";
              dhcp = {
                range = {
                  start = "192.168.122.2";
                  end = "192.168.122.254";
                };
              };
            };
          };
        }
      ];
      pools = [
        {
          active = true;
          definition = nixvirt.lib.pool.writeXML {
            name = "default";
            uuid = "5f67b3f0-148e-4c7d-ae37-fa82e3a44d0c";
            type = "dir";
            target.path = "/var/lib/libvirt/images";
          };
        }
        {
          active = true;
          definition = nixvirt.lib.pool.writeXML {
            name = "iso";
            uuid = "5f67b3f0-148e-4c7d-ae37-fa82e3a44d0d";
            type = "dir";
            target.path = "/var/lib/libvirt/iso";
          };
        }
      ];
      domains = [
        (import ./test-ubuntu24.04-01.nix { inherit pkgs nixvirt; })
        (import ./vm-opnsense.nix {
          inherit pkgs nixvirt;
          name = "vm-opnsense-01";
        })
      ];
    };
  };

  # environment & packages

  environment.sessionVariables = {
    VISUAL = "hx";
    EDITOR = "hx";
  };

  environment.systemPackages = with pkgs; [
    home-manager
    wget
    git
    htop
    helix
    lazygit
    age
    sops
    neofetch
    pfetch
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
      "networkmanager"
      "libvirtd"
    ];
  };

  system.stateVersion = "24.11";
}
