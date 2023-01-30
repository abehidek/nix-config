{
  description = "My personal NixOS configurations";
  inputs = {
    env.url = "github:abehidek/env.nix";
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable"; # nixpkgs/nixos-22.05
    stable.url = "github:nixos/nixpkgs/nixos-22.11";
    home-manager = {
      url = "github:nix-community/home-manager"; # home-manager/release-22.05
      inputs.nixpkgs.follows = "nixpkgs";
    };
    misterio77.url = github:misterio77/nix-config;
    nix-colors.url = github:misterio77/nix-colors;
    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    vscode-server.url = "github:msteen/nixos-vscode-server";
  };
  outputs = {
    self,
    nixpkgs,
    stable,
    home-manager,
    ... 
  } @ inputs:

  let
    inherit (self) outputs;
    supportedSystems = [ "x86_64-linux" ];
    forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
  in rec {
    nixosModules = import ./modules/system;

    userModules = import ./modules/user;

    nixosConfigurations = rec {
      flex5i = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [  ./systems/flex5i ];
        specialArgs = { inherit inputs outputs; };
      };

      ssd = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [  ./systems/ssd ];
        specialArgs = { inherit inputs outputs; };
      };

      wsl = stable.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./systems/wsl ];
        specialArgs = { inherit inputs outputs; };
      };
    };

    devShells = forAllSystems (system: {
      xmonad = import ./shells/xmonad.nix { 
        inherit nixpkgs system inputs outputs;
      };
    });
  };
}
