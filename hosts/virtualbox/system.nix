# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
  [ # Include the results of your hardware scan.
    ./hardware.nix

    # Modules used by the system
    ../../users/abe.nix # Home Manager 
    ../../modules/wm/vm-sway.nix # Sway Window Manager inside Virtualbox
    ../../modules/waybar # Waybar settings
    ../../modules/gtk # GTK Theming 
    ../../modules/qt # QT Theming
    ../../modules/xdg # XDG Settings
    # ../../modules/development # Dev settings
    ../../modules/terminal
  ];

  # Use the systemd-boot EFI boot loader.
  boot = {
    kernel.sysctl = { "fs.inotify.max_user_watches" = 524288; }; # https://code.visualstudio.com/docs/setup/linux#_visual-studio-code-is-unable-to-watch-for-file-changes-in-this-large-workspace-error-enospc
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
  };
  
  hardware = {
    cpu.intel.updateMicrocode = true;
    opengl = {
      enable = true;
      driSupport = true;
      extraPackages = [ pkgs.intel-compute-runtime ];
    };
    bluetooth.enable = false;
    pulseaudio.enable = false;
  };
  

  networking = {
    hostName = "abe-nixos-vm"; # Define your hostname.
    # networkmanager.enable = true;
    # networkmanager.wifi.backend = "iwd";
    # wireless.enable = true;  # Enables wireless support via wpa_supplicant.
    # The global useDHCP flag is deprecated, therefore explicitly set to false here.
    # Per-interface useDHCP will be mandatory in the future, so this generated config
    # replicates the default behaviour.
    useDHCP = false;
    interfaces.enp0s3.useDHCP = true;
    # Configure network proxy if necessary
    # proxy.default = "http://user:password@proxy:port/";
    # proxy.noProxy = "127.0.0.1,localhost,internal.domain";
    # Open ports in the firewall.
    # networking.firewall.allowedTCPPorts = [ ... ];
    # networking.firewall.allowedUDPPorts = [ ... ];
    # Or disable the firewall altogether.
    # networking.firewall.enable = false;
  };

  # Set your time zone.
  time.timeZone = "America/Sao_Paulo";

  # Select internationalisation properties.
  i18n.defaultLocale = "pt_BR.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "br-abnt2";
  };
  
  services = {
    # Enable CUPS to print documents.
    # printing.enable = true;
    xserver.libinput.enable = true;
    gnome.gnome-keyring.enable = true;

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
    # xserver.wacom.enable = true;
    mpd = {
      enable = true;
      musicDirectory = "/home/abe/Música";
      user = "abe";
      extraConfig = ''
        audio_output {
          type "pipewire"
          name "My PipeWire Output"
        }
      '';
    };
  };

  systemd.services.mpd.environment = {
      # https://gitlab.freedesktop.org/pipewire/pipewire/-/issues/609
      XDG_RUNTIME_DIR = "/run/user/1000"; # User-id 1000 must match above user. MPD will look inside this directory for the PipeWire socket.
  };
  
  security.rtkit.enable = true;
  
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.abe = {
    isNormalUser = true;
    initialPassword = "password";
    extraGroups = [ "wheel" "video" "audio" "jackaudio" "networkmanager" ]; # Enable ‘sudo’ for the user.
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    vim wget git htop killall
    gnome.seahorse gnome.gnome-keyring libsecret
    brightnessctl pulseaudio-ctl playerctl pavucontrol
    # ffmpeg libmpeg2 libmad libdv a52dec faac faad2 flac jasper lame libtheora libvorbis xorg.libXv opusfile wavpack x264 xvidcore smpeg
    # libwacom xf86_input_wacom
    # xorg.xinput xinput_calibrator foot
  ];
  
  fonts.fonts = with pkgs; [ font-awesome fira-code fira-code-symbols ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

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

