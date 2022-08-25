# Flex5i system config

{ lib, config, pkgs, unstable, name, nix-gaming, ... }: {
  imports = [
    ./hardware.nix
  ];

  boot.loader = {
    grub = {
      enable = true;
      version = 2;
      efiSupport = true;
      efiInstallAsRemovable = true;
      device = "nodev";
    };
    efi = { efiSysMountPoint = "/boot"; };
  };

  networking = { 
    hostName = "ssd"; 
    networkmanager.enable = true;
  };

  time.timeZone = "America/Sao_Paulo";

  i18n.defaultLocale = "en_US.UTF-8";

  services.xserver.enable = true;

  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
  services.xserver.layout = "us";

  sound.enable = true;
  hardware.pulseaudio.enable = true;
  services.xserver.libinput.enable = true;

  environment.systemPackages = with pkgs; [
    vim wget
    git elixir nodejs yarn python310
    dbeaver insomnia
  ];

  virtualisation.docker.enable = true;

  system.stateVersion = "22.05";
}
