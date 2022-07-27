# Flex5i system config

{ lib, config, pkgs, unstable, name, user, ... }: {
  imports = [
    ./hardware.nix

    ../../modules/hardware/audio.nix # Enables pipewire audio
    ../../modules/desktop/sway # Enable sway on the system
    ../../modules/dev
    ../../modules/shell/zsh

    ../../modules/services/network.nix # Enables networking
    ../../modules/services/ssh.nix # Enables openssh

    ../../rf-modules/hello.nix
    ../../rf-modules/docker.nix
  ];

  modules.docker = {
    enable = true;
    user = "abe";
  };

  modules.hello = {
    enable = true;
    greeter = "Abe";
  };

  # nixpkgs.config.chromium.commandLineArgs =
    # "---enable-features=UseOzonePlatform --ozone-platform=wayland -enable-features=VaapiVideoDecoder";

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
      # GUI
      pcmanfm
      unstable.cinnamon.nemo
    ];
  };

  xdg = {
    portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-wlr
        xdg-desktop-portal-gtk
      ];
      gtkUsePortal = true;
    };
    mime.defaultApplications = {
      "image/jpeg" = "feh.desktop";
      "image/png" = "feh.desktop";
      "inode/directory" = "nemo.desktop";
      "application/x-directory" = "nemo.desktop";
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
