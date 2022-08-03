name: { nixpkgs, home-manager, unstable }:
[
  # { nixpkgs.overlays = overlays; } # Apply system overlay
  ../system.nix ./system.nix
  ({ libs, config, pkgs, ...}: {
    users.users = {
      abe = {
        isNormalUser = true;
        initialPassword = "password";
        shell = pkgs.zsh;
        extraGroups = [
          "wheel"
          "doas"
          "video"
          "audio"
          "jackaudio"
          "networkmanager"
          "libvirtd"
        ];
      };
      guest = {
        isNormalUser = true;
        initialPassword = "password";
        shell = pkgs.bash;
        extraGroups = [
          # "wheel"
          "doas"
          "video"
          "audio"
          "jackaudio"
          "networkmanager"
          "libvirtd"
        ];
      };
    };
  })
  home-manager.nixosModules.home-manager {
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
    home-manager.extraSpecialArgs = { inherit unstable; };
    home-manager.users = {
      abe = { lib, config, pkgs, unstable, user, ... }: {
        imports =
        [
          (import ./abe.nix { inherit config unstable lib pkgs; user = "abe"; })
          (import ../home.nix { inherit config unstable lib pkgs; user = "abe"; })
        ];
      };

      guest = { lib, config, pkgs, unstable, user, ... }: {
        imports =
        [
          (import ./guest.nix { inherit config unstable lib pkgs; user = "guest"; })
          (import ../home.nix { inherit config unstable lib pkgs; user = "guest"; })
        ];
      };
    };
  }
]
