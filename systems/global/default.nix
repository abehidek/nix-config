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

  environment.shellAliases = {
    sysc = "sudo nixos-rebuild switch --flake";
  };
}
