name: { nixpkgs, home-manager, unstable }:
[
  # { nixpkgs.overlays = overlays; } # Apply system overlay
  ../system.nix ./system.nix
  ({ libs, config, pkgs, ...}: {
    users.users = {
      abe = {
        isNormalUser = true;
        initialPassword = "password";
        shell = pkgs.bash;
        extraGroups = [
          "wheel" "video" "audio" "networkmanager" "docker"
        ];
      };
    };
  })
  home-manager.nixosModules.home-manager {
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      extraSpecialArgs = { inherit unstable; };
      users = {
        abe = { lib, config, pkgs, unstable, user, ... }: {
          imports =
          [
            (import ./abe.nix { inherit config unstable lib pkgs; user = "abe"; })
            (import ../home.nix { inherit config unstable lib pkgs; user = "abe"; })
          ];
        };
      };
    };
  }
]
