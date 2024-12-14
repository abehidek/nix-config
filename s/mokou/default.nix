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
    qemu.ovmf.packages = [
      (pkgs.OVMF.override {
        secureBoot = true;
        tpmSupport = true;
      }).fd
    ];
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
  users.users.abe = {
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
