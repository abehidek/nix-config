# Multiple hosts system config

{ lib, config, pkgs, unstable, ... }: {
  nix = {
    autoOptimiseStore = true;
    settings.experimental-features = ["nix-command" "flakes"];  
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
