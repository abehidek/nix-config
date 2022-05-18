# Multiple hosts system config

{ lib, config, pkgs, unstable, user, ... }: {
  imports = [
    ../modules/services/network.nix # Enables networking
    ../modules/services/ssh.nix # Enables openssh
  ];
  users.users = {
    ${user} = {
      isNormalUser = true;
      initialPassword = "password";
      shell = pkgs.zsh;
      extraGroups = [
        "wheel"
        "doas"
        "video"
        "audio"
        "jackaudio"
        "networkmanager"
        "libvirtd"
      ];
    };
  };

  nix = {
    autoOptimiseStore = true;
    package = pkgs.nixFlakes;
    extraOptions = "experimental-features = nix-command flakes";
  };

  nixpkgs = { config.allowUnfree = true; };

  services = {
    gnome.gnome-keyring.enable = true;
    gvfs.enable = true;
  };

  programs = {
    mtr.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  environment = {
    systemPackages = with pkgs; [
      xterm
      vim
      wget
      git
      killall
      gnome.seahorse
      gnome.gnome-keyring
      libsecret
      brightnessctl
      pulseaudio-ctl
      playerctl
      pavucontrol
      lm_sensors
      xdg-utils
      shared-mime-info
      # GUI
      # pcmanfm
      unstable.cinnamon.nemo
    ];
    variables.EDITOR = "vim";
    variables.DOTFILES = "$HOME/dotfiles";
  };

  xdg = {
    portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-wlr
        xdg-desktop-portal-gtk
      ];
      gtkUsePortal = true;
    };
    mime.defaultApplications = {
      "image/jpeg" = "feh.desktop";
      "image/png" = "feh.desktop";
      "inode/directory" = "nemo.desktop";
      "application/x-directory" = "nemo.desktop";
    };
  };
}
