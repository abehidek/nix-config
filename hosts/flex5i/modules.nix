name: { inputs, nixpkgs, home-manager, unstable }:
[
  # { nixpkgs.overlays = overlays; } # Apply system overlay
  home-manager.nixosModules.home-manager {
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
    home-manager.extraSpecialArgs = { inherit unstable; };
    home-manager.users.abe = import ./abe.nix;
  }
  ../system.nix ./system.nix
  ({ lib, config, pkgs, ...}: {
    users.users = {
      abe = {
        isNormalUser = true;
        initialPassword = "password";
        shell = pkgs.zsh;
        extraGroups = [
          "wheel" "doas" "video"
          "audio" "jackaudio"
          "networkmanager" "libvirtd"
        ];
      };
    };
  })
]
