{ lib, config, pkgs, ... }: {
  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ];
      substituters = [
        "https://hyprland.cachix.org"
        "https://devenv.cachix.org"
        "https://nix-gaming.cachix.org"
      ];
      trusted-public-keys = [
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
        "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
      ];
    };
  };

  nixpkgs = { config.allowUnfree = true; };

  services = {
    openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        PermitRootLogin = "no";
      };
    };
  };

  users.users."abe".openssh.authorizedKeys.keys = [
    # ssd public ssh key
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOA5zXdXt8fMb9jHJyxAutrISXSftCp4qbjwAoY09stu hidek.abe@outlook.com"
    # flex5i public ssh key
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILvkS1l2u8X51LIkU84LtwZwhhWqMB7eU2/YLaMKiuWF hidek.abe@outlook.com"
    # wsl public ssh key
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICXLv+5v+QoKEB6RZ1LvrpbVTuU7ZB6xIi/QUnyD58X+ hidek.abe@outlook.com"
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

  environment.systemPackages = with pkgs; [ wget cachix ];
}
