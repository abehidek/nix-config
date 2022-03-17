{ config, pkgs, ... }:

{
  imports =
  [ # Include the results of your hardware scan.
    ./hardware.nix
    ../../users/abe.nix # Home Manager 
  ];

  # Use the systemd-boot EFI boot loader.
  boot = {
    cleanTmpDir = true;
    kernel.sysctl = { "fs.inotify.max_user_watches" = 524288; };
    loader = {
      systemd-boot.enable = true;
      systemd-boot.editor = false;
      efi.canTouchEfiVariables = true;
    };
  };
  
  # Physical hardware settings and opengl enabled for wayland
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

  networking = {
    hostName = "flex5i"; # Define your hostname.
    networkmanager.enable = true;
    useDHCP = false;
    interfaces.wlp0s20f3.useDHCP = true;
    # Configure network proxy if necessary
    # proxy.default = "http://user:password@proxy:port/";
    # proxy.noProxy = "127.0.0.1,localhost,internal.domain";
    # Open ports in the firewall.
    # networking.firewall.allowedTCPPorts = [ ... ];
    # networking.firewall.allowedUDPPorts = [ ... ];
    # Or disable the firewall altogether.
    # networking.firewall.enable = false;
  };

  # Locales config
  time.timeZone = "America/Sao_Paulo";
  i18n.defaultLocale = "pt_BR.UTF-8";
  console = {
    font = "Lat2-Terminus32";
    keyMap = "br-abnt2";
  };

  nix.autoOptimiseStore = true;

  services = {
    # Enable CUPS to print documents.
    # printing.enable = true;
    
    xserver.libinput.enable = true;
    gnome.gnome-keyring.enable = true;

    tlp = {
      enable = true;
      settings = {
        TLP_PERSISTENT_DEFAULT = 0;
      };
    };

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };    
  };

  fonts = {
    fonts = with pkgs; [ 
      # Regular fonts
      (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" "FiraMono" ]; }) 
      dejavu_fonts font-awesome
      
      # Japanese fonts
      rictydiminished-with-firacode
      hanazono ipafont kochi-substitute
    ];
    fontconfig = {
      defaultFonts = {
        monospace = [
          "DejaVu Sans Mono"
          "IPAGothic"
        ];
        sansSerif = [
          "DejaVu Sans"
          "IPAPGothic"
        ];
        serif = [
          "DejaVu Serif"
          "IPAPMincho"
        ];
      };
    };
  };
  
  # System security settings
  security = {
    rtkit.enable = true;
    protectKernelImage = true;
  };
  
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    vim wget git htop killall
    gnome.seahorse gnome.gnome-keyring libsecret
    brightnessctl pulseaudio-ctl playerctl pavucontrol lm_sensors
    # ffmpeg libmpeg2 libmad libdv a52dec faac faad2 flac jasper lame libtheora libvorbis xorg.libXv opusfile wavpack x264 xvidcore smpeg
    # libwacom xf86_input_wacom
    # xorg.xinput xinput_calibrator foot
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs = {
    mtr.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?
}
