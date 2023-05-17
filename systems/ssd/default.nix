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
      nushell = {
        enable = true;
        defaultShellUsers = allUsers;
      };
      zsh = {
        enable = true;
        defaultShellUsers = [];
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
      udiskie = {
        enable = true;
        users = allUsers;
      };
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

  hardware = {
    cpu.intel.updateMicrocode = true;
    bluetooth.enable = false;
    opengl = {
      enable = true;
      driSupport = true;
      extraPackages = with pkgs; [ intel-compute-runtime intel-media-driver libva ];
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
      layout = "br,us";
      xkbVariant = "abnt2,alt-intl";
      xkbOptions = "grp:win_space_toggle";
    };
    fstrim.enable = true;
    gvfs.enable = true;
  };

  environment.sessionVariables = {
    MOZ_USE_XINPUT2 = "1"; # improves firefox touchscreen support
  };

  environment.systemPackages = with pkgs; [ 
    brightnessctl
    pulseaudio-ctl
    # playerctl
  ];

  system.stateVersion = "22.05";
}
