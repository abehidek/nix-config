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
    disko = {     
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence.url = "github:nix-community/impermanence";
    hyprland.url = "github:hyprwm/Hyprland";
    misterio77.url = github:misterio77/nix-config;
    nix-colors.url = github:misterio77/nix-colors;
    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    vscode-server.url = "github:msteen/nixos-vscode-server";
    devenv.url = "github:cachix/devenv";
    nix-gaming.url = "github:fufexan/nix-gaming";
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
    packages = forAllSystems (system: import ./pkgs {
      inherit inputs outputs;
      pkgs = nixpkgs.legacyPackages.${system}; 
    });

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

      mail = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [  ./systems/mail ];
        specialArgs = { inherit inputs outputs; };
      };

      test = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [  ./systems/test ];
        specialArgs = { inherit inputs outputs; };
      };

      t16-wsl = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [  ./systems/t16 ];
        specialArgs = { inherit inputs outputs; };
      };

      portainer = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [  ./systems/portainer ];
        specialArgs = { inherit inputs outputs; };
      };

      "templates.lxc.aoi" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [  ./systems/templates/lxc/aoi ];
        specialArgs = { inherit inputs outputs; };
      };
    };

    homeConfigurations = {
      "abe@t16-wsl" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages."x86_64-linux";
        modules = [ ./systems/t16/abe.nix ];
        extraSpecialArgs = { inherit inputs outputs; };
      };
    };

    devShells = forAllSystems (system: {
      xmonad = import ./shells/xmonad.nix { 
        inherit nixpkgs system inputs outputs;
      };
    });
  };
}
