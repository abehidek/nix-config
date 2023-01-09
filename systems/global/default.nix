{ lib, config, pkgs, ... }: {
  nix = {
    settings.auto-optimise-store = true;
    settings.experimental-features = [ "nix-command" "flakes" ];    
  };
  
  nixpkgs = { config.allowUnfree = true; };

  services = {
    openssh = {
      enable = true;
      passwordAuthentication = false;
      permitRootLogin = "no";
    };
  };

  programs = {
    mtr.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  environment.shellAliases = {
    sysc = "sudo nixos-rebuild switch --flake";
  };
}
