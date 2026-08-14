{ inputs, self, ... }:

{
  flake.nixosConfigurations."flex5i" = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules."flex5i"
      self.nixosModules."flex5iDisko"
      self.nixosModules."flex5iHardware"
      self.nixosModules."flex5iImpermanence"
    ];
  };

  flake.homeConfigurations = {
    "abe@flex5i" = inputs.home-manager.lib.homeManagerConfiguration {
      modules = [ self.modules.homeManager."abe@flex5i" ];
      pkgs = import inputs.nixpkgs {
        system = "x86_64-linux";
        config.allowUnfree = true;
      };
    };

    "naohiro@flex5i" = inputs.home-manager.lib.homeManagerConfiguration {
      modules = [ self.modules.homeManager."naohiro@flex5i" ];
      pkgs = import inputs.nixpkgs {
        system = "x86_64-linux";
        config.allowUnfree = true;
      };
    };
  };

  flake.nixosModules."flex5i" =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      name-zpool = "zroot";
    in
    {
      imports = [
        inputs.home-manager.nixosModules.home-manager
        inputs.nur.modules.nixos.default
        inputs.sops-nix.nixosModules.sops
      ];

      environment.systemPackages = with pkgs; [
        spotify
        claude-code
        wget
        cachix
        deploy-rs
        cmatrix
        nixos-rebuild-ng
        home-manager
        lm_sensors
        cifs-utils
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
        dbeaver-bin
        cowsay
        gparted
        fastfetch
        code-cursor
        inputs.zen-browser.packages."x86_64-linux".twilight
        chromium

        # backup terminals
        foot
        xterm

        pfetch
        pkgs.nur.repos.mic92.hello-nur
      ];

      networking.hostName = "flex5i";
      time.timeZone = "America/Sao_Paulo";
      i18n.defaultLocale = "pt_BR.UTF-8";

      nixpkgs.config.allowUnfree = true;

      nix.settings = {
        max-jobs = 4;
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        trusted-users = [
          "root"
          "abe"
          "gabe"
          "@wheel"
          "@admin"
        ];
        substituters = [
          "https://cosmic.cachix.org/"
          "https://microvm.cachix.org"
        ];
        trusted-public-keys = [
          "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE="
          "microvm.cachix.org-1:oXnBc6hRE3eX5rSYdRyMYXnfzcCxC7yKPTbZXALsqys="
        ];
      };

      programs.gnupg.agent = {
        enable = true;
        enableSSHSupport = true;
      };

      users.users."abe".openssh.authorizedKeys.keys = [
        (builtins.readFile "${self}/keys/abe@flex5i.pub")
        (builtins.readFile "${self}/keys/abe@wsl.pub")
        (builtins.readFile "${self}/keys/abe@kal'tsit.pub")
      ];

      nix.settings.auto-optimise-store = true;
      programs.mtr.enable = true;

      services.gnome.gnome-keyring.enable = true;
      security.pam.services."cosmic-greeter".enableGnomeKeyring = true;

      services.openssh = {
        enable = true;
        settings = {
          PasswordAuthentication = false;
          PermitRootLogin = "no";
        };
      };

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
      nixpkgs.config.permittedInsecurePackages = [
        "electron-39.8.10"
      ];

      services.hardware.bolt.enable = true;

      # sops

      sops = {
        defaultSopsFile = "${toString inputs.nix-secrets}/secrets.yaml";
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
        device = "//192.168.15.6/hako";
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
      services.system76-scheduler.enable = true;

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

      # i18n.inputMethod = {
      # enable = true;
      # type = "fcitx5";
      # fcitx5.waylandFrontend = true;
      # fcitx5.addons = with pkgs; [
      #   fcitx5-gtk
      #   fcitx5-mozc
      # ];
      # };

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

      # users and home-manager

      users.mutableUsers = false;

      users.groups.shared = { };

      sops.secrets."passwords/user-abe@flex5i".neededForUsers = true;

      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        extraSpecialArgs = {
          nix-secrets = inputs.nix-secrets;
          sops-nix = inputs.sops-nix;
        };
        users."abe" = self.modules.homeManager."abe@flex5i";
        users."naohiro" = self.modules.homeManager."naohiro@flex5i";
      };

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
          "shared"
        ];
        packages = with pkgs; [
          obsidian
          discord
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
          "shared"
        ];
        packages = with pkgs; [
          chromium
          irpf
        ];
      };

      system.stateVersion = "24.11";

    };

  flake.nixosModules."flex5iDisko" =
    { ... }:
    let
      id-disk = "/dev/disk/by-id/nvme-SSSTC_CL1-4D256_SS1C86490L2BR17P6972";
      name-zpool = "zroot";
    in
    {
      imports = [ inputs.disko.nixosModules.disko ];

      disko.devices.disk.disk1 = {
        device = id-disk;
        type = "disk";
        content.type = "gpt";
        content.partitions = {
          ESP = {
            size = "512M";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [ "umask=0077" ];
            };
          };
          swap = {
            size = "4G";
            type = "8200";
            content = {
              type = "swap";
              resumeDevice = true; # resume from hiberation from this device
            };
          };
          zfs = {
            size = "100%";
            content = {
              type = "zfs";
              pool = name-zpool;
            };
          };
        };
      };

      disko.devices.zpool.${name-zpool} = {
        type = "zpool";
        mountpoint = null;
        rootFsOptions = {
          compression = "zstd";
          normalization = "formD";
          atime = "off";
          xattr = "sa";
          acltype = "posixacl";
          "com.sun:auto-snapshot" = "false";
        };
        options = {
          ashift = "12";
          autotrim = "on";
        };

        datasets."local" = {
          type = "zfs_fs";
          options.canmount = "off";
        };

        datasets."safe" = {
          type = "zfs_fs";
          options.canmount = "off";
        };

        datasets = {
          "local/root" = {
            type = "zfs_fs";
            options.mountpoint = "legacy";
            mountpoint = "/";

            postCreateHook = "zfs snapshot ${name-zpool}/local/root@empty";
          };
          "local/nix" = {
            type = "zfs_fs";
            options.mountpoint = "legacy";
            mountpoint = "/nix";
          };
          "safe/persist" = {
            type = "zfs_fs";
            options.mountpoint = "legacy";
            mountpoint = "/persist";
          };
        };
      };
    };

  flake.nixosModules."flex5iHardware" =
    {
      config,
      lib,
      modulesPath,
      ...
    }:
    {
      imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

      boot.kernelModules = [ "kvm-intel" ];
      boot.extraModulePackages = [ ];
      boot.initrd.availableKernelModules = [
        "xhci_pci"
        "nvme"
        "usb_storage"
        "sd_mod"
        "rtsx_pci_sdmmc"
      ];

      # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
      # (the default) this is the recommended approach. When using systemd-networkd it's
      # still possible to use this option, but it's recommended to use it in conjunction
      # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
      networking.useDHCP = lib.mkDefault true;
      # networking.interfaces.wlp0s20f3.useDHCP = lib.mkDefault true;

      nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
      hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    };

  flake.nixosModules."flex5iImpermanence" =
    { ... }:
    let
      id-machine = "0c9ff5c1b06f402f8095327b7633e332";
      homeFiles = [
        ".screenrc"
        ".config/nushell/history.txt"
        ".config/cosmic-initial-setup-done"
      ];
      homeDirectories = [
        # $HOME
        "ProgramasRFB"
        ".var"
        ".mozilla"
        ".vscode"
        ".zen"
        ".kube"
        {
          directory = ".gnupg";
          mode = "0700";
        }
        {
          directory = ".ssh";
          mode = "0700";
        }
        {
          directory = ".nixops";
          mode = "0700";
        }

        # xdg-user-dirs
        "Desktop"
        "Documents"
        "Downloads"
        "Music"
        "Pictures"
        "Public"
        "Templates"
        "Videos"

        # $XDG_DATA_HOME
        ".local/share/icons"
        ".local/share/direnv"
        ".local/share/waydroid"
        ".local/share/zed"
        {
          directory = ".local/share/keyrings";
          mode = "0700";
        }

        # $XDG_STATE_HOME
        ".local/state/lazygit"
        ".local/state/cosmic-comp"
        ".local/state/cosmic"
        ".local/state/pop-launcher"

        # $XDG_CONFIG_HOME
        ".config/sops"
        ".config/cosmic"
        ".config/Code"
        ".config/lazygit"
        ".config/obsidian"
        ".config/discord"
        ".config/Bitwarden"
        ".config/gh"

        # $XDG_CACHE_HOME
        ".cache/starship"
      ];
    in
    {
      imports = [ inputs.impermanence.nixosModules.impermanence ];

      # required for impermanence to work
      fileSystems."/persist".neededForBoot = true;
      environment.etc.machine-id.text = id-machine;

      # opts
      environment.persistence."/persist" = {
        enable = true;
        hideMounts = true;
        directories = [
          # Systemd requires /usr dir to be populated
          "/usr/systemd-placeholder"

          "/etc/nixos"
          "/var/log"
          "/var/lib/cosmic-greeter"
          "/var/lib/sops-nix"
          "/var/lib/bluetooth"
          "/var/lib/nixos"
          "/var/lib/systemd/coredump"
          "/var/lib/waydroid"
          "/etc/NetworkManager/system-connections"
          "/etc/mullvad-vpn"

          {
            directory = "/home/shared";
            user = "root";
            group = "shared";
            mode = "u=rwx,g=rwx,o=";
          }
        ];
        files = [
          "/etc/ssh/ssh_host_ed25519_key.pub"
          "/etc/ssh/ssh_host_ed25519_key"
          "/etc/ssh/ssh_host_rsa_key.pub"
          "/etc/ssh/ssh_host_rsa_key"
        ];
        users."naohiro" = {
          directories = homeDirectories;
          files = homeFiles;
        };
        users."abe" = {
          directories = homeDirectories;
          files = homeFiles;
        };
      };
    };
}
