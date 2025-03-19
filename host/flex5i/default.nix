{
  config,
  lib,
  pkgs,
  # modulesPath,
  nixpkgs,
  home-manager,
  nur,
  modules,
  paths,
  all,
  all-users,
  nix-secrets,
  sops-nix,
  # disko,
  # impermanence,
  nixos-cosmic,
  zen-browser,

  # id-machine,
  # id-disk,
  name-zpool,
  ...
}:

{
  imports = [
    home-manager.nixosModules.home-manager
    nur.modules.nixos.default
    sops-nix.nixosModules.sops
    nixos-cosmic.nixosModules.default
    modules.host.system

    (all { inherit pkgs nixpkgs paths; })
    ./disko.nix
    ./hardware.nix
    ./impermanence.nix
  ];

  # hidekxyz

  hidekxyz.system = {
    hostname = "flex5i";
  };

  # nix build opts
  nixpkgs.config.allowUnfree = true;
  nix.settings.max-jobs = 4;

  # hardware and boot

  boot.loader = {
    systemd-boot.enable = true;
    systemd-boot.configurationLimit = 5;
    efi.canTouchEfiVariables = true;
    efi.efiSysMountPoint = "/boot";
  };

  boot.initrd = {
    kernelModules = [ "i915" ];
    supportedFilesystems = [ "zfs" ];
    systemd = {
      enable = lib.mkDefault true;
      services."reset" = {
        description = "Rollback root filesystem to a pristine state on boot";
        wantedBy = [ "initrd.target" ];
        after = [ "zfs-import-${name-zpool}.service" ];
        before = [ "sysroot.mount" ];
        path = with pkgs; [ zfs ];
        unitConfig.DefaultDependencies = "no";
        serviceConfig.Type = "oneshot";
        script = "zfs rollback -r ${name-zpool}/local/root@empty";
      };
    };
  };

  boot = {
    consoleLogLevel = 0;
    zfs.forceImportRoot = false;
    zfs.devNodes = lib.mkDefault "/dev/disk/by-id";
    supportedFilesystems = [
      "zfs"
      "ntfs"
    ];
    kernelParams = [
      "quiet"
      "elevator=none"
      "udev.log_level=3"
      "zfs.zfs_arc_max=${toString (512 * 1048576)}" # max of 512mb for ZFS
    ];
  };

  zramSwap.enable = true;

  # cross arch compilation
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  nix.settings.extra-platforms = config.boot.binfmt.emulatedSystems;

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
    hostId = "f9ed0640"; # required by ZFS
    extraHosts = ''
      10.0.20.1 nginx03.k3s.lan
      10.0.20.1 longhorn.k3s.lan
    '';
  };

  security.sudo = {
    enable = true;
    extraConfig = ''
      Defaults  lecture="never"
    '';
  };

  fileSystems."/home/abe/mnt/hako" = {
    device = "//10.0.0.201/hako";
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

  services.mullvad-vpn.enable = true;

  services.fstrim.enable = true;

  security.polkit.enable = true;

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

  programs.nix-ld.enable = true;

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
    nixos-rebuild-ng
    home-manager
    lm_sensors
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
    mullvad-vpn
    cbonsai
    dbeaver-bin
    cowsay
    gparted
    fastfetch
    zen-browser.packages.${pkgs.system}.default

    # backup terminals
    foot
    xterm

    osu-lazer
    pfetch
    neofetch
    pkgs.nur.repos.mic92.hello-nur
  ];

  # users and home-manager

  home-manager.useGlobalPkgs = true;
  home-manager.extraSpecialArgs = {
    inherit
      paths
      all-users
      nix-secrets
      sops-nix
      ;
  };

  users.mutableUsers = false;

  sops.secrets."passwords/user-abe@flex5i".neededForUsers = true;

  home-manager.users."abe" = import (paths.users "abe/${config.networking.hostName}.nix");
  users.users."abe" = {
    uid = 1000;
    isNormalUser = true;
    hashedPasswordFile = config.sops.secrets."passwords/user-abe@flex5i".path;
    extraGroups = [
      "wheel"
      "video"
      "audio"
      "libvirtd"
      "networkmanager"
    ];
    packages = with pkgs; [
      obsidian
      discord
      bitwarden
      irpf
      kubectl
      rpi-imager
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
