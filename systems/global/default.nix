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

  users.users."abe".openssh.authorizedKeys.keys = [
    # SSD public ssh keys
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOA5zXdXt8fMb9jHJyxAutrISXSftCp4qbjwAoY09stu hidek.abe@outlook.com"
  ];

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
