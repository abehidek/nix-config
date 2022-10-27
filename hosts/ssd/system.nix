# Flex5i system config

{ lib, config, pkgs, unstable, name, nix-gaming, ... }: {
  imports = [
    ./hardware.nix
  ];

  modules = {
    hardware = {
      audio.enable = true;
      audio.users = ["abe"];
      network = {
        hostName = "ssd";
        useNetworkManager = true;
      };
    };
    shell = {
      zsh = {
        enable = true;
        defaultShellUsers = ["abe"];
      };
      tmux.enable = true;
      direnv.enable = true;
      direnv.preventGC = true;
    };
    services = {
      docker = {
        enable = true;
        users = ["abe"];
      };
      ssh = { enable = true; };
    };
    desktop = {
      kde.enable = true;
      auto-startup = {
        enable = true;
        type = "sddm";
      };
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

  time.timeZone = "America/Sao_Paulo";
  i18n.defaultLocale = "pt_BR.UTF-8";
  services.xserver.layout = "us,br";
  services.xserver.xkbVariant = "intl,abnt2";
  services.xserver.libinput.enable = true;
  services.xserver.videoDrivers = [ "displaylink" "modesetting" ];
  services.fstrim.enable = true;
  programs.adb.enable = true;
  users.users.abe.extraGroups = ["adbusers"];

  environment.systemPackages = with pkgs; [ displaylink android-studio  ];

  system.stateVersion = "22.05";
}
