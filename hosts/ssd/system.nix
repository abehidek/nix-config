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

  time.timeZone = "America/Sao_Paulo";
  i18n.defaultLocale = "en_US.UTF-8";
  services.xserver.layout = "us";
  services.xserver.libinput.enable = true;
  services.fstrim.enable = true;

  system.stateVersion = "22.05";
}
