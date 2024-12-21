{
  # config,
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
}@args:

let
  device = "/dev/disk/by-id/nvme-SSD_128GB_AA000000000000000276";
  zpool_name = "mroot";
  machineId = "e8ccbf623edf4dd6aa83732a65ce08cb";
  importWithArgs = import ../../f/importWithArgs.nix args;
in
{
  imports = [
    (all { inherit pkgs nixpkgs; })
    ./hardware.nix

    (import ./disko.nix { inherit disko device zpool_name; })
    (import ./impermanence.nix { inherit impermanence machineId; })

    (importWithArgs ./libvirt.nix { inherit nixvirt; })
    (importWithArgs ./microvm.nix {
      inherit all impermanence microvm;
    })
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
