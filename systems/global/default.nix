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
    # ssd public ssh key
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOA5zXdXt8fMb9jHJyxAutrISXSftCp4qbjwAoY09stu hidek.abe@outlook.com"
    # flex5i public ssh key
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILvkS1l2u8X51LIkU84LtwZwhhWqMB7eU2/YLaMKiuWF hidek.abe@outlook.com"
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

  environment.systemPackages = with pkgs; [ wget ];
}
