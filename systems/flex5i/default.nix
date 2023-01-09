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
      zsh = {
        enable = true;
        users = allUsers;
        rice = true;
      };
      direnv = {
        enable = true;
        users = allUsers;
      };
    };
    services = {
      docker = {
        enable = true;
        users = allUsers;
      };
    };
  };

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

  # Boot and Drivers
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
    opengl = {
      enable = true;
      driSupport = true;
      extraPackages = [ pkgs.intel-compute-runtime ];
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
  };

  # Audio
  sound.enable = true;
  hardware.pulseaudio = {
    enable = true;
    extraConfig = "unload-module module-suspend-on-idle";
  };

  # Desktop
  services = {
    xserver = {
      enable = true;
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
      libinput.enable = true;
    };
    gnome.gnome-keyring.enable = true;
    fstrim.enable = true;
    gvfs.enable = true;
    udisks2.enable = true;
    tlp = {
      enable = false; # needed to disable cause gnome
      settings = {
        TLP_PERSISTENT_DEFAULT = 0;
        CPU_MAX_PERF_ON_AC=100;
        CPU_MAX_PERF_ON_BAT=30;
      };
    };
  };

  environment.systemPackages = with pkgs; [ 
    # Handle OS keyrings
    gnome.seahorse
    gnome.gnome-keyring
    libsecret

    brightnessctl
    pulseaudio-ctl
    # playerctl
  ];

  system.stateVersion = "21.11";
}