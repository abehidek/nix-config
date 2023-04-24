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
      keyring.enable = true;
      docker = {
        enable = true;
        users = allUsers;
      };
    };
    desktop = {
      hyprland.enable = true;
      displayManager.tuigreet = {
        enable = true;
        defaultSessionCmd = "Hyprland";
      };
    };
    dev = {
      android = {
        enable = true;
        users = [ "abe" ];
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
      libinput.enable = true;
      layout = "us,br";
      xkbVariant = "intl,abnt2";
      xkbOptions = "grp:win_space_toggle";
    };
    fstrim.enable = true;
    gvfs.enable = true;
    udisks2.enable = true;
  };

  environment.systemPackages = with pkgs; [ 
    brightnessctl
    pulseaudio-ctl
    # playerctl
  ];

  system.stateVersion = "22.05";
}
