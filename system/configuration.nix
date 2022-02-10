# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "abe-nixos"; # Define your hostname.
  networking.networkmanager.enable = true;
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

  # Enable the X11 windowing system.
  # services.xserver.enable = true;
  # Enable Wayland Compositor
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraPackages = with pkgs; [ wofi xwayland alacritty wl-clipboard swaylock swayidle waybar ];
  };
  
  # Enable Desktop Environment.
  

  # Configure keymap in X11
  # services.xserver.layout = "br";
  # services.xserver.xkbModel = "abnt2";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;
  programs.light.enable = true;
  services.gnome.gnome-keyring.enable = true;


  # systemd.services.display-handler = {
  #   wantedBy = [ "multi-user.target" ];
  #   path = [ pkgs.nix ];
  #   script = "${/home/abe/.dotfiles/monitorChange.py}";
  #   serviceConfig = {
  #     Restart = "always";
  #     RestartSec = 0;
  #   };
  # }; 
  # systemd.services.displayhandler = {
  #   description = "displayhandler";
  #   serviceConfig = {
  #     Type = "oneshot";
  #     User = "root";
  #     ExecStart = "nix-shell -p 'python3' --run 'python3 /home/abe/.dotfiles/monitorChange.py'";
  #   };
  #   wantedBy = [ "multi-user.target"];
  # };
  # systemd.services.displayhandler.enable = true;
  
  # systemd.services.displayhandler.enable = true; 
    # my-script = pkgs.writeScript "monitorChange.py" ''
    #   #!${pkgs.python}/bin/python
    #   import subprocess
    #   import time

    #   command = "xinput --map-to-output 12 eDP-1"
    #   print("Running...")

    #   def get_res():
    #       # get resolution
    #       xr = subprocess.check_output(["xrandr"]).decode("utf-8").split()
    #       pos = xr.index("current")
    #       return [int(xr[pos+1]), int(xr[pos+3].replace(",", "") )]

    #   res1 = get_res()
    #   while True:
    #       time.sleep(5)
    #       res2 = get_res()
    #       if res2 != res1:
    #           subprocess.Popen(["/bin/sh", "-c", command])
    #       res1 = res2    
    # '';
    # in {
    #   script = "${my-script}";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.abe = {
    isNormalUser = true;
    initialPassword = "password";
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim wget git
    brave
    gnome.seahorse gnome.gnome-keyring libsecret
    brightnessctl
    pcmanfm
    pulseaudio-ctl playerctl pavucontrol
    htop
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

