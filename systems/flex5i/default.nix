{ pkgs, inputs, outputs, lib, ... }: 
let
  allUsers = [ "abe" ];
  forAllUsers = lib.genAttrs (allUsers);
in {
  imports = [
    ./hardware.nix
    ../global
    inputs.home-manager.nixosModules.home-manager
  ] ++ (builtins.attrValues outputs.nixosModules);

  modules.system = {
    shell = {
      tmux.enable = true;
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
        enable = true;
        users = allUsers;
        autostart = true;
      };
    };
    desktop = {
      hyprland.enable = true;
      udiskie = {
        enable = true;
        users = allUsers;
      };
      displayManager.tuigreet = {
        enable = true;
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
    "electron-21.4.0"
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
    bluetooth.enable = false;
    opengl = {
      enable = true;
      driSupport = true;
      extraPackages = with pkgs; [ intel-compute-runtime intel-media-driver libva ];
    };
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
    wireplumber.enable = true;
  };

  sound.enable = true;
  hardware.pulseaudio = {
    enable = false;
    extraConfig = "unload-module module-suspend-on-idle";
    support32Bit = true;
  };

  # Desktop
  services = {
    xserver = {
      enable = true;
      layout = "br";
      xkbVariant = "abnt2";
      libinput = {
        enable = true;
        touchpad = {
          naturalScrolling = true;
          accelProfile = "flat";
        };
      };
    };
    fstrim.enable = true;
    gvfs.enable = true;
    tlp = {
      enable = true;  # will disable this FOR NOW, wait till you see gnome
      # enable = false;  # needed to disable cause gnome
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
    pulseaudio-ctl
    # playerctl
  ];

  system.stateVersion = "21.11";
}
