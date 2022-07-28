{
  description = "A very basic flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, ... }:
    let mkHost = import ./lib/mkHost.nix;
    in {
      nixosConfigurations.flex5i = mkHost "flex5i" rec {
        inherit home-manager nixpkgs nixpkgs-unstable;
        system = "x86_64-linux";
        user = "abe";
      };
      nixosConfigurations.wsl = mkHost "wsl" rec {
        inherit home-manager nixpkgs nixpkgs-unstable;
	      system = "x86_64-linux";
	      user = "abe";
      }; 
    };
}
