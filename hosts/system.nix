# Multiple hosts system config

{ lib, config, pkgs, unstable, user, ... }: {
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

  programs = {
    mtr.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  environment = {
    systemPackages = with pkgs; [
      wget
      git
      killall
    ];
    variables.EDITOR = "vim";
    variables.DOTFILES = "$HOME/dotfiles";
  };
}
