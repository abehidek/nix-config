# This function creates a NixOS system based on our VM setup for a
# particular architecture.
name: { inputs, system, users }:

let
  inherit (inputs) self nixpkgs nixpkgs-unstable home-manager;
  unstable = import nixpkgs-unstable {
    inherit system;
    config.allowUnfree = true;
  };
  lib = nixpkgs.lib.extend (self: super: { utils = import ./utils.nix { inherit nixpkgs; lib = self; }; });
  mkHome = {user, name}: args@{pkgs, unstable, ...}: {
    imports = [
      inputs.nix-colors.homeManagerModule
      (import ../hosts/${name}/${user}.nix)
      ../rf-modules/home.nix
      (import ../hosts/home.nix { inherit args user; })
    ];
  };
  forAllUsers = lib.genAttrs (users);
  pkgs = import nixpkgs {
    inherit system;
    config = { allowUnfree = true; };
    overlays = import ../overlays;
  };
in
lib.nixosSystem rec {
  inherit pkgs system;
  specialArgs = { inherit inputs lib unstable name; };
  modules = [
    ../hosts/system.nix
    ../hosts/${name}/system.nix
    ../rf-modules
    ({ lib, config, pkgs, ...}: {
      users.users = forAllUsers (user: {
        isNormalUser = true;
        initialPassword = "password";
        extraGroups = [
          "wheel" "doas" "video"
          "audio" "jackaudio"
          "networkmanager" "libvirtd"
        ];
      });
    })
    home-manager.nixosModules.home-manager {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.extraSpecialArgs = { inherit unstable inputs; };
      home-manager.users = forAllUsers (user: mkHome { inherit user name; } );
    }
  ];
}

