{
  description = "A very basic flake";
  inputs = {
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-22.05";
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      # url = "github:nix-community/home-manager/release-22.05";
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-gaming.url = github:fufexan/nix-gaming;
    hyprland = {
      url = "github:vaxerski/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-colors.url = github:misterio77/nix-colors;
  };
  outputs = inputs:
    let
      mkMachine = import ./lib/mkMachine.nix;
    in {
      nixosConfigurations.flex5i = mkMachine "flex5i" rec {
        inherit inputs;
        system = "x86_64-linux";
        users = ["abe" "eba"];
      };
      nixosConfigurations.ssd = mkMachine "ssd" rec {
        inherit inputs;
        system = "x86_64-linux";
        users = ["abe"];
      };
      nixosConfigurations.wsl = mkMachine "wsl" rec {
        inherit inputs;
        system = "x86_64-linux";
        users = ["abe"];
      };
    };
}
