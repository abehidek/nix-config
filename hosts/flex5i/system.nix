# Flex5i system config

{ inputs, lib, config, pkgs, unstable, name, ... }: {
  imports = [
    ./hardware.nix
  ];

  modules = {
    hardware = {
      audio.enable = true;
      audio.users = ["abe"];
      network = {
        hostName = "flex5i";
        useNetworkManager = true;
      };
    };
    shell = {
      zsh = {
        enable = true;
        defaultShellUsers = ["abe"];
      };
      tmux.enable = true;
      direnv.enable = true;
      direnv.preventGC = true;
    };
    services = {
      docker = {
        enable = true;
        users = ["abe"];
      };
      virt-manager = {
        enable = true;
        auto-startup = false;
      };
      ssh = { enable = true; };
    };
    desktop = {
      hyprland.enable = true;
      auto-startup = {
        enable = true;
        type = "console";
        environment = "Hyprland";
      };
    };
  };

  environment = {
    systemPackages = with pkgs; [
      gnome.seahorse
      gnome.gnome-keyring
      libsecret
      brightnessctl
      pulseaudio-ctl
      playerctl
      pavucontrol
      lm_sensors
      xdg-utils
      shared-mime-info
      android-studio
    ];
  };

  xdg = {
    portal = {
      enable = true;
      wlr.enable = true;
    };
  };

  boot = {
    cleanTmpDir = true;
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
    pulseaudio.enable = false;
    sensor.iio.enable = true;
    opengl = {
      enable = true;
      driSupport = true;
      extraPackages = [ pkgs.intel-compute-runtime ];
    };
  };

  time.timeZone = "America/Sao_Paulo";
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "ter-i24b";
    packages = [ pkgs.terminus_font ];
    earlySetup = true;
    keyMap = "br-abnt2";
  };

  services = {
    xserver.libinput.enable = true;
    gnome.gnome-keyring.enable = true;
    fstrim.enable = true;
    gvfs.enable = false;
    tlp = {
      enable = true;
      settings = {
        TLP_PERSISTENT_DEFAULT = 0;
        CPU_MAX_PERF_ON_AC=100;
        CPU_MAX_PERF_ON_BAT=30;
      };
    };
  };

  fonts = {
    fonts = with pkgs; [
      # Regular fonts
      (nerdfonts.override {
        fonts = [ "FiraCode" "DroidSansMono" "FiraMono" ];
      })
      dejavu_fonts
      font-awesome

      # Japanese fonts
      rictydiminished-with-firacode
      hanazono
      ipafont
      kochi-substitute
    ];
    fontconfig = {
      defaultFonts = {
        monospace = [ "DejaVu Sans Mono" "IPAGothic" ];
        sansSerif = [ "DejaVu Sans" "IPAPGothic" ];
        serif = [ "DejaVu Serif" "IPAPMincho" ];
      };
    };
  };

  security = {
    sudo.enable = true;
    rtkit.enable = true;
    protectKernelImage = true;
  };

  programs.adb.enable = true;
  users.users.abe.extraGroups = ["adbusers"];

  system.stateVersion = "21.11";
}
