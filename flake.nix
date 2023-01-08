{
  description = "My personal NixOS configurations";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable"; # nixpkgs/nixos-22.05
    home-manager = {
      url = "github:nix-community/home-manager"; # home-manager/release-22.05
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # nix-colors.url = github:misterio77/nix-colors;
    # vscode-server.url = "github:msteen/nixos-vscode-server";
    # nixos-wsl.url = "github:nix-community/NixOS-WSL";
  };
  outputs = {
    self,
    nixpkgs,
    home-manager,
    ... 
  }@inputs:

  let inherit (self) outputs;
  in rec {
    nixosModules = import ./modules/system;

    nixosConfigurations = rec {
      flex5i = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [  ./systems/flex5i ];
        specialArgs = { inherit inputs outputs; };
      };
    };
  };
}
