{
  config,
  lib,
  # pkgs,
  modulesPath,
  # nixpkgs,
  # modules,
  # paths,
  # all,
  # disko,
  # impermanence,
  # microvm,
  # nixvirt,

  # id-machine,
  # id-disk,
  # name-zpool,

  # test-ubuntu,
  # opnsense,
  # silence,
  # amiya,
  ...
}:
{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];
  boot.initrd.kernelModules = [ ];
  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "ahci"
    "nvme"
    "usbhid"
    "usb_storage"
    "sd_mod"
    "vfio-pci" # new
  ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
