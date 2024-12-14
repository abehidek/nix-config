{
  config,
  lib,
  pkgs,
  # modulesPath,
  nixpkgs,
  home-manager,
  nur,
  all,
  all-users,
  nix-secrets,
  sops-nix,
  disko,
  impermanence,
  nixos-cosmic,
  nix-flatpak,
  ...
}:

let
  device = "/dev/disk/by-id/nvme-SSSTC_CL1-4D256_SS1C86490L2BR17P6972";
  zpool_name = "zroot";
in
{
  nixpkgs.config.allowUnfree = true;

  imports = [
    home-manager.nixosModules.home-manager
    nur.modules.nixos.default
    (all { inherit pkgs nixpkgs; })
    sops-nix.nixosModules.sops
    disko.nixosModules.disko
    impermanence.nixosModules.impermanence
    nixos-cosmic.nixosModules.default
    nix-flatpak.nixosModules.nix-flatpak

    (import ./impermanence.nix { machineId = "0c9ff5c1b06f402f8095327b7633e332"; })
    (import ./disko.nix { inherit device zpool_name; })

    ./hardware.nix
  ];

  nix.settings.max-jobs = 4;

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

  boot.initrd.kernelModules = [ "i915" ];
  boot.initrd.supportedFilesystems = [ "zfs" ];
  boot.supportedFilesystems = [
    "zfs"
    "ntfs"
  ];

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

  # sops

  sops = {
    defaultSopsFile = "${builtins.toString nix-secrets}/secrets.yaml";
    validateSopsFiles = false;
    age = {
      sshKeyPaths = [ "/persist/etc/ssh/ssh_host_ed25519_key" ];
      generateKey = true;
      keyFile = "/var/lib/sops-nix/key.txt";
    };

    secrets = {
      "files/cred-hidek@hako" = { };
      "passwords/user-abe@flex5i" = { };
      "keys/ssh-abe@flex5i" = {
        path = "/root/.ssh/id_ed25519"; # private repo access on "sudo nixos-rebuild switch" bc sudo runs w/ sudo user
      };
    };
  };

  # system basics

  time.timeZone = "America/Sao_Paulo";
  i18n.defaultLocale = "en_US.UTF-8";

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      # $LIBVA_DRIVER_NAME=iHD
      intel-media-driver
      # $LIBVA_DRIVER_NAME=i965
      (intel-vaapi-driver.override { enableHybridCodec = true; })
      libvdpau-va-gl
    ];
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
  };

  networking = {
    networkmanager.enable = true;
    hostName = "flex5i";
    hostId = "f9ed0640"; # required by ZFS
  };

  security.sudo = {
    enable = true;
    extraConfig = ''
      Defaults  lecture="never"
    '';
  };

  fileSystems."/home/abe/mnt/hako" = {
    device = "//smb.hon.hidek.xyz/hako";
    fsType = "cifs";
    options = [
      "rw"
      "x-systemd.automount"
      "x-systemd.requires=network-online.target"
      "x-systemd.after=network-online.target"
      "credentials=${config.sops.secrets."files/cred-hidek@hako".path}"
      "uid=${toString config.users.users."abe".uid}"
      "gid=${toString config.users.groups."users".gid}"
    ];
  };

  # services programs

  services.desktopManager.cosmic.enable = true;
  services.displayManager.cosmic-greeter.enable = true;

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      nerd-fonts.fira-code
      fira
      ipafont
    ];

    fontconfig = {
      defaultFonts = {
        serif = [
          "Fira Serif"
          "IPAPMincho"
        ];
        sansSerif = [
          "Fira Sans"
          "IPAPGothic"
        ];
        monospace = [
          "FiraCode Nerd Font"
          "IPAGothic"
        ];
      };
    };
  };

  virtualisation.waydroid.enable = true;

  services.zfs = {
    autoScrub.enable = true;
    autoSnapshot.enable = true;
  };

  services.xserver.xkb = {
    layout = "br,us";
    variant = "abnt2,alt-intl";
    options = "grp:win_space_toggle";
  };

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.waylandFrontend = true;
    fcitx5.addons = with pkgs; [
      fcitx5-gtk
      fcitx5-mozc
    ];
  };

  services.flatpak = {
    enable = true;
    update.auto.enable = false;
    uninstallUnmanaged = true;
    update.onActivation = true;
    remotes = [
      {
        name = "flathub";
        location = "https://flathub.org/repo/flathub.flatpakrepo";
      }
      {
        name = "flathub-beta";
        location = "https://flathub.org/beta-repo/flathub-beta.flatpakrepo";
      }
    ];
    packages = [
      {
        appId = "io.github.zen_browser.zen";
        origin = "flathub";
      }
    ];
  };

  programs.nix-ld = {
    enable = true;
    package = pkgs.nix-ld-rs; # only for NixOS 24.05
  };

  programs.firefox.enable = true;

  # environment & packages

  environment.sessionVariables = {
    COSMIC_DATA_CONTROL_ENABLED = 1;
    NIXOS_OZONE_WL = "1";
    LIBVA_DRIVER_NAME = "iHD";
    VISUAL = "hx";
    EDITOR = "hx";
  };

  environment.systemPackages = with pkgs; [
    home-manager
    cifs-utils
    wget
    tldr
    git
    vscode
    nixfmt-rfc-style
    nixd
    htop
    btop
    helix
    lazygit
    zellij
    age
    sops
    virt-manager

    pfetch
    neofetch
    pkgs.nur.repos.mic92.hello-nur
  ];

  # users and home-manager

  home-manager.useGlobalPkgs = true;
  home-manager.extraSpecialArgs = {
    inherit all-users nix-secrets sops-nix;
  };

  users.mutableUsers = false;

  sops.secrets."passwords/user-abe@flex5i".neededForUsers = true;

  home-manager.users."abe" = import ../../u/abe/${config.networking.hostName}.nix;
  users.users."abe" = {
    uid = 1000;
    isNormalUser = true;
    hashedPasswordFile = config.sops.secrets."passwords/user-abe@flex5i".path;
    extraGroups = [
      "wheel"
      "video"
      "audio"
      "libvirtd"
    ];
    packages = with pkgs; [
      obsidian
      discord
      bitwarden
      irpf
    ];
  };

  users.users."naohiro" = {
    isNormalUser = true;
    initialPassword = "password";
    extraGroups = [
      "video"
      "audio"
    ];
    packages = with pkgs; [
      chromium
      irpf
    ];
  };

  users.users."nina" = {
    isNormalUser = true;
    initialPassword = "password";
    extraGroups = [
      "video"
      "audio"
    ];
    packages = with pkgs; [
      obsidian
      chromium
      bitwarden
    ];
  };

  system.stateVersion = "24.11";
}
