{
  description = "A very basic flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-22.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-gaming.url = github:fufexan/nix-gaming;
  };
  outputs = inputs:
    let mkHost = import ./lib/mkHost.nix;
    in {
      nixosConfigurations.flex5i = mkHost "flex5i" rec {
        inherit inputs;
        system = "x86_64-linux";
        system-modules = import ./hosts/flex5i/modules.nix;
      };
      nixosConfigurations.wsl = mkHost "wsl" rec {
        inherit inputs;
        system = "x86_64-linux";
        system-modules = import ./hosts/flex5i/modules.nix;
      };
      nixosConfigurations.ssd = mkHost "ssd" rec {
        inherit inputs;
        system = "x86_64-linux";
        system-modules = import ./hosts/ssd/modules.nix;
      };
    };
}
