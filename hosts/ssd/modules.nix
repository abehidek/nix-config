name: { inputs, lib, nixpkgs, home-manager, unstable }:
[
  # { nixpkgs.overlays = overlays; } # Apply system overlay
  home-manager.nixosModules.home-manager {
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
    home-manager.extraSpecialArgs = { inherit unstable; };
    home-manager.users.abe = lib.utils.mkHomeManager "abe" {
      homeManagerModule = ./abe.nix;
    };
  }
  ../system.nix ./system.nix
  inputs.hyprland.nixosModules.default
  ({ lib, config, pkgs, ...}: {
    users.users = {
      abe = {
        isNormalUser = true;
        initialPassword = "password";
        extraGroups = [
          "wheel" "video" "audio" "networkmanager" "docker"
        ];
      };
    };
  })
]
