{ lib, config, pkgs, unstable, ... }: {
  users.users = {
    abe = {
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
    openssh.enable = true;
    gnome.gnome-keyring.enable = true;
    gvfs.enable = true;
  };

  environment.variables = { DOTFILES = "$HOME/dotfiles"; };

  programs = {
    mtr.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  environment.systemPackages = with pkgs; [
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
  ];
}
