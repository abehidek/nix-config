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

  hardware = {
    cpu.intel.updateMicrocode = true;
    bluetooth.enable = true;
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [ intel-compute-runtime intel-media-driver libva ];
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
  i18n.defaultLocale = "en_US.UTF-8";
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
      allowedTCPPorts = [
        22  # SSH
        80  # HTTP
        8080
        5000
        4000
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

  sound.enable = true;
  hardware.pulseaudio = {
    enable = false;
    extraConfig = "unload-module module-suspend-on-idle";
    support32Bit = true;
  };

  # Desktop
  programs.dconf.enable = true; # Necessary for GTK

  xdg.portal = {
    enable = true;
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

    gvfs.enable = true; # Gnome virtual filesystem (used by gnome nautilus)

    tlp = { # Optimizing linux battery life
      enable = true;
      settings = {
        TLP_PERSISTENT_DEFAULT = 0;
        CPU_MAX_PERF_ON_AC=100;
        CPU_MAX_PERF_ON_BAT=30;
      };
    };
  };

  environment.sessionVariables = {
    MOZ_USE_XINPUT2 = "1"; # improves firefox touchscreen support
  };

  environment.systemPackages = with pkgs; [ 
    brightnessctl
    pulseaudio
    pulseaudio-ctl
    qjackctl
    # playerctl
    rofi
    gnome.dconf-editor
    inputs.devenv.packages.${pkgs.system}.default
    inputs.nix-gaming.packages.${pkgs.system}.osu-stable
  ];

  system.stateVersion = "21.11";
}
