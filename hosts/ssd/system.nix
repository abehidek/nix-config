# Flex5i system config

{ lib, config, pkgs, unstable, name, nix-gaming, ... }: {
  imports = [
    ./hardware.nix
  ];

  modules.shell = {
    zsh.enable = true;
    tmux.enable = true;
    direnv.enable = true;
    direnv.preventGC = true;
  };

  modules.desktop = {
    kde.enable = true;
    auto-startup = {
      enable = true;
      type = "sddm";
    };
  };

  modules.vscodium = {
    enable = true;
  };

  modules.ssh = { enable = true; };
  
  modules.docker = {
    enable = true;
    user = "abe";
  };

  networking = { 
    hostName = "ssd"; 
    networkmanager.enable = true;
  };

  time.timeZone = "America/Sao_Paulo";

  i18n.defaultLocale = "en_US.UTF-8";

  services.xserver.layout = "us";

  sound.enable = true;
  hardware.pulseaudio.enable = true;
  services.xserver.libinput.enable = true;

  environment.systemPackages = with pkgs; [
    # GUI
    firefox
    # Development
    vim helix
    dbeaver insomnia lazygit
    wget git inotify-tools
    elixir nodejs yarn python310
    # Misc
    neofetch
  ];

  system.stateVersion = "22.05";
}
