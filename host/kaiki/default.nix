{
  config,
  lib,
  pkgs,
  # modulesPath,
  nixpkgs,
  # home-manager,
  # nur,
  paths,
  fns,
  nixos-hardware,
  all,
  # nix-secrets,
  # sops-nix,
  impermanence,
  microvm,
  ...
}@args:
let
  importWithArgs = (fns.importWithArgs args);
in
{
  imports = [
    "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
    "${nixpkgs}/nixos/modules/installer/sd-card/sd-image.nix"

    nixos-hardware.nixosModules.raspberry-pi-4

    (all { inherit pkgs nixpkgs paths; })
    # sops-nix.nixosModules.sops

    (importWithArgs ./microvm.nix {
      inherit paths all impermanence;
      microvm = microvm;
    })
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

  # sops

  # sops = {
  #   defaultSopsFile = "${builtins.toString nix-secrets}/secrets.yaml";
  #   validateSopsFiles = false;
  #   age = {
  #     sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  #     generateKey = true;
  #     keyFile = "/var/lib/sops-nix/key.txt";
  #   };

  #   secrets = {
  #     "passwords/wifi-abe-userland" = { };
  #   };
  # };

  # networking

  systemd.network.wait-online.enable = false;
  boot.initrd.systemd.network.wait-online.enable = false;

  networking.useDHCP = lib.mkDefault true;

  networking = {
    networkmanager.enable = false;
    hostName = "kaiki";
    firewall.enable = false;
  };

  networking.wireless = {
    enable = true;
    userControlled.enable = true;
    # secretsFile = config.sops.secrets."passwords/wifi-abe-userland".path;
    # networks = {
    #   "abe-userland".pskRaw = "ext:psk_abe-userland";
    # };
  };

  networking.useNetworkd = true;
  systemd.network = {
    enable = true;

    netdevs."20-br0".netdevConfig = {
      Name = "br0";
      Kind = "bridge";
    };

    # networks."30-wlan0" = {
    #   matchConfig.Name = "wlan0";
    #   networkConfig.Bridge = "br0";
    #   linkConfig.RequiredForOnline = "enslaved";
    # };
    # networks."30-vm-suzuki-01" = {
    #   matchConfig.Name = "vm-suzuki-01";
    #   networkConfig.Bridge = "br0";
    #   linkConfig.RequiredForOnline = "enslaved";
    # };
    # networks."40-br0" = {
    #   matchConfig.Name = "br0";
    #   bridgeConfig = { };
    #   linkConfig.RequiredForOnline = "routable";
    # };
  };

  # hardware and boot

  hardware.raspberry-pi."4" = {
    apply-overlays-dtmerge.enable = true;
    fkms-3d.enable = true;
  };

  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;

  # system basics

  fileSystems."/" = {
    device = "/dev/disk/by-label/NIXOS_SD";
    fsType = "ext4";
    options = [ "noatime" ];
  };

  time.timeZone = "America/Sao_Paulo";
  i18n.defaultLocale = "en_US.UTF-8";

  programs.git.enable = true;

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
    hello
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
