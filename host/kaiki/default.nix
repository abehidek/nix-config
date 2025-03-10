{
  # config,
  # lib,
  pkgs,
  # modulesPath,
  nixpkgs,
  # home-manager,
  # nur,
  paths,
  nixos-hardware,
  all,
  ...
}:

{
  imports = [
    "${nixpkgs}/nixos/modules/installer/sd-card/sd-image.nix"
    "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"

    nixos-hardware.nixosModules.raspberry-pi-4

    (all { inherit pkgs nixpkgs paths; })
  ];

  disabledModules = [
    "profiles/all-hardware.nix"
    "profiles/base.nix"
  ];

  nixpkgs.overlays = [
    (final: super: {
      makeModulesClosure = x: super.makeModulesClosure (x // { allowMissing = true; });
    })
  ];

  # hardware and boot

  hardware.raspberry-pi."4" = {
    apply-overlays-dtmerge.enable = true;
    fkms-3d.enable = true;
  };

  # system basics

  fileSystems."/" = {
    device = "/dev/disk/by-label/NIXOS_SD";
    fsType = "ext4";
    options = [ "noatime" ];
  };

  time.timeZone = "America/Sao_Paulo";
  i18n.defaultLocale = "en_US.UTF-8";

  networking = {
    networkmanager.enable = true;
    hostName = "kaiki";
  };

  # services programs

  services.openssh.enable = true;

  # environment & packages

  environment.systemPackages = with pkgs; [
    libraspberrypi
    raspberrypi-eeprom
    neofetch
    pfetch
    helix
    htop
  ];

  # users and home-manager
  users.users."abe" = {
    isNormalUser = true;
    initialPassword = "password";
    extraGroups = [
      "wheel"
      "video"
      "audio"
      "libvirtd"
      "networkmanager"
    ];
  };

  system.stateVersion = "25.01";
}
