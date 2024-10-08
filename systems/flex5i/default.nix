{ pkgs, inputs, outputs, lib, ... }: 
let
  allUsers = [ "abe" "naohiro" ];
  forAllUsers = lib.genAttrs (allUsers);
in {
  imports = [
    ./hardware.nix
    ../global
    inputs.home-manager.nixosModules.home-manager
  ] ++ (builtins.attrValues outputs.nixosModules);

  modules.system = {
    shell = {
      tmux.enable = false;
      nushell = {
        enable = true;
        defaultShellUsers = allUsers;
      };
      zsh = {
        enable = true;
        defaultShellUsers = [];
      };
      direnv = {
        enable = true;
        users = allUsers;
      };
    };
    services = {
      keyring.enable = true;
      polkit.enable = true;
      docker = {
        enable = true;
        users = allUsers;
      };
      virt-manager = {
        enable = false;
        users = allUsers;
        autostart = true;
      };
    };
    desktop = {
      hyprland.enable = false;
      udiskie = {
        enable = true;
        users = allUsers;
      };
      displayManager.tuigreet = {
        enable = false;
        defaultSessionCmd = "Hyprland";
      }; 
    };
  };

  # User config & Home Manager
  users.users = forAllUsers (user: {
    isNormalUser = true;
    initialPassword = "password";
    extraGroups = [ "wheel" "video" "audio" ];
  });

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users = forAllUsers (user: import ./${user}.nix { inherit user; });
    extraSpecialArgs = { inherit inputs outputs; };
  };

  nixpkgs.config.permittedInsecurePackages = [
    "electron-25.9.0"
    "electron-21.4.0"
    "electron-12.2.3"
  ];

  # Boot and Drivers
  boot = {
    tmp.cleanOnBoot = true;
    kernel.sysctl = { "fs.inotify.max_user_watches" = 524288; };
    loader = {
      systemd-boot.enable = true;
      systemd-boot.editor = false;
      efi.canTouchEfiVariables = true;
    };
  };

  systemd.services.NetworkManager-wait-online.enable = lib.mkForce false;

  hardware = {
    cpu.intel.updateMicrocode = true;
    bluetooth = {
      enable = true;
      powerOnBoot = false;
    };
    opengl = {
      enable = true;
      extraPackages = with pkgs; [ 
        intel-compute-runtime
        intel-media-driver
        libva
        vaapiVdpau
        libvdpau-va-gl
        (vaapiIntel.override { enableHybridCodec = true; }) 
      ];
    };
    opentabletdriver.enable = true;
  };

  # Security
  security = {
    sudo.enable = true;
    rtkit.enable = true;
    protectKernelImage = true;
  };

  # Internalisation
  time.timeZone = "America/Sao_Paulo";
  i18n = {
    defaultLocale = "en_US.UTF-8";
    supportedLocales = [
      "en_US.UTF-8/UTF-8"
      "ja_JP.UTF-8/UTF-8"
      "pt_BR.UTF-8/UTF-8"
    ];
    extraLocaleSettings = {
      LANGUAGE ="";
      LC_ADDRESS = "pt_BR.UTF-8";
      LC_COLLATE = "en_US.UTF-8";
      LC_CTYPE = "pt_BR.UTF-8";
      LC_IDENTIFICATION = "pt_BR.UTF-8";
      LC_MEASUREMENT = "pt_BR.UTF-8";
      LC_MESSAGES = "en_US.UTF-8";
      LC_MONETARY = "pt_BR.UTF-8";
      LC_NAME = "pt_BR.UTF-8";
      LC_NUMERIC = "pt_BR.UTF-8";
      LC_PAPER = "pt_BR.UTF-8";
      LC_TELEPHONE = "pt_BR.UTF-8";
      LC_TIME = "pt_BR.UTF-8";
    };
  };
  console = {
    font = "ter-i24b";
    packages = [ pkgs.terminus_font ];
    earlySetup = true;
    keyMap = "br-abnt2";
  };

  # Network
  networking = {
    networkmanager.enable = true;
    hostName = "flex5i";
    firewall = {
      enable = true;
      trustedInterfaces = [ "p2p-wl+" ];
      allowedUDPPorts = [ 7236 5353 ];
      allowedTCPPorts = [
        22  # SSH
        80  # HTTP
        8080
        5000
        4000
        8000
        7236 7250
        443 # HTTPS
      ];
    };
  };

  # Audio
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    wireplumber.enable = true;
  };

  hardware.pulseaudio = {
    enable = false;
    extraConfig = "unload-module module-suspend-on-idle";
    support32Bit = true;
  };

  # Desktop
  programs.dconf.enable = true; # Necessary for GTK
  programs.virt-manager.enable = true;

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = [
      #pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-gnome
      pkgs.xdg-desktop-portal-wlr
    ];
    # extraPortals = with pkgs; [ xdg-desktop-portal-gtk ]; Cinnamon already adds it
  };

  services = {
    xserver = {
      enable = true;

      layout = "br,us";
      xkbVariant = "abnt2,alt-intl";
      xkbOptions = "grp:win_space_toggle";

      libinput = {
        enable = true;
        touchpad = {
          naturalScrolling = true;
          accelProfile = "flat";
        };
      };

      displayManager.lightdm.enable = true;

      desktopManager.cinnamon = {
        enable = true;
      };

      windowManager.dwm = {
        enable = true;
        package = pkgs.dwm.overrideAttrs (old: rec {
          src = ../../config/dwm;
        });
      };
    };

    dwm-status = {
      enable = true;
      order = [ "audio" "cpu_load" "backlight" "network" "battery" "time" ];
    };

    picom = {
      enable = true; # Compositor
    };

    fstrim.enable = true; # Enables periodic SSD TRIM of mounted partitions

    gvfs.enable = true; # Gnome virtual filesystem (used by gnome nautilus and nemo)

    tlp = { # Optimizing linux battery life
      enable = true;
      settings = {
        TLP_PERSISTENT_DEFAULT = 0;
        CPU_MAX_PERF_ON_AC=100;
        CPU_MAX_PERF_ON_BAT=30;
      };
    };

    tailscale.enable = true;
  };

  environment.sessionVariables = {
    MOZ_USE_XINPUT2 = "1"; # improves firefox touchscreen support
  };

  environment.systemPackages = with pkgs; [ 
    brightnessctl
    pulseaudio
    pulseaudio-ctl
    qjackctl qpwgraph
    # playerctl
    rofi
    gnome.dconf-editor
    gnome-network-displays
    inputs.devenv.packages.${pkgs.system}.default
    inputs.nix-gaming.packages.${pkgs.system}.osu-stable
    cifs-utils
  ];

  fonts.packages = with pkgs; [ dejavu_fonts ipafont kochi-substitute ];

  system.stateVersion = "21.11";
}
