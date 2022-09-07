# Flex5i system config

{ inputs, lib, config, pkgs, unstable, name, ... }: {
  imports = [
    ./hardware.nix
    # ../../modules/dev
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
      zsh.enable = true;
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
    editors = {
      vscodium = {
        enable = true;
      };
    };
    # to do dev
  };

  environment = {
    systemPackages = with pkgs; [
      inputs.nix-gaming.packages.${pkgs.system}.osu-lazer-bin
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
      # GUI
    ];
  };

  xdg = {
    portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-wlr
        xdg-desktop-portal-gtk
      ];
      # gtkUsePortal = true;
    };
    # mime.defaultApplications = {
    #   "image/jpeg" = "feh.desktop";
    #   "image/png" = "feh.desktop";
    #   "inode/directory" = "nemo.desktop";
    #   "application/x-directory" = "nemo.desktop";
    # };
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
    gvfs.enable = true;
    tlp = {
      enable = true;
      settings = { TLP_PERSISTENT_DEFAULT = 0; };
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
    doas.enable = true;
    doas.extraRules = [{
      groups = [ "doas" "wheel" ];
      keepEnv = true;
      persist = true;
    }];
    sudo.enable = true;
    rtkit.enable = true;
    protectKernelImage = true;
  };

  system.stateVersion = "21.11";
}
