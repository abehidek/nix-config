# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
  [ # Include the results of the hardware scan.
    ./hardware.nix

    # Modules used by the system
    ../../modules/wm/sway.nix # Sway Window Manager
    ../../modules/gtk # GTK Theming 
    ../../modules/xdg # XDG Settings
    ../../modules/users/abe.nix # Home Manager 
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  hardware.opengl.extraPackages = [
    pkgs.intel-compute-runtime
  ];

  hardware.cpu.intel.updateMicrocode = true;

  networking.hostName = "abe-nixos"; # Define your hostname.
  networking.networkmanager.enable = true;
  # networking.networkmanager.wifi.backend = "iwd";
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Set your time zone.
  time.timeZone = "America/Sao_Paulo";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.wlp0s20f3.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "pt_BR.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "br-abnt2";
  };
  
  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  services = {
    xserver.libinput.enable = true;
    gnome.gnome-keyring.enable = true;
    pipewire.enable = true;
  };
  
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.abe = {
    isNormalUser = true;
    initialPassword = "password";
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    vim wget git nnn htop
    #chromium 
    brave gnome.nautilus vscode
    gnome.seahorse gnome.gnome-keyring libsecret
    brightnessctl
    pulseaudio-ctl playerctl pavucontrol
    xdg-utils
    virtualbox
    libsForQt5.dolphin
    ungoogled-chromium
    # libsForQt5.qt5.qtwayland
  ];

  nixpkgs.config.chromium.commandLineArgs = "--enable-features=VaapiVideoDecoder";



  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "abe" ];

  #programs.qt5ct.enable = true;
  fonts.fonts = with pkgs; [ nerdfonts font-awesome fira-code fira-code-symbols ];

  xdg.mime.removedAssociations = {
    "inode/directory" = "code.desktop";
  };

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

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?
}

