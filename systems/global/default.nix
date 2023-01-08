{ lib, config, pkgs, ... }: {
  nix = {
    settings.auto-optimise-store = true;
    settings.experimental-features = [ "nix-command" "flakes" ];    
  };
  
  nixpkgs = { config.allowUnfree = true; };
}
