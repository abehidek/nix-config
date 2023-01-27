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
    dev = {
      android = {
        enable = true;
        users = [ "abe" ];
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

  # Security
  security = {
    sudo.enable = true;
    rtkit.enable = true;
    protectKernelImage = true;
  };

  # Internalisation
  time.timeZone = "America/Sao_Paulo";
  i18n.defaultLocale = "pt_BR.UTF-8";
  console = {
    font = "ter-i24b";
    packages = [ pkgs.terminus_font ];
    earlySetup = true;
    keyMap = "br-abnt2";
  };

  # Network
  networking = {
    networkmanager.enable = true;
    hostName = "ssd";
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
      displayManager.sddm.enable = true;
      desktopManager.plasma5.enable = true;
      libinput.enable = true;
      layout = "us,br";
      xkbVariant = "intl,abnt2";
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
    xclip
    # playerctl
  ];

  system.stateVersion = "22.05";
}
