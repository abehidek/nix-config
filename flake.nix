{
  description = "A very basic flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-21.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = { url = github:nix-community/home-manager; inputs.nixpkgs.follows = "nixpkgs"; };
  };
  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, ... }:
    let 
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; config.allowUnfree = true; };
      unstable = import nixpkgs-unstable { inherit system; config.allowUnfree = true; };
      lib = nixpkgs.lib;
    in {
      nixosConfigurations = {
        flex5i = lib.nixosSystem { 
          inherit system;
          specialArgs = { inherit unstable; };
          modules = [
            ./hosts/flex5i/system.nix
            ./hosts/system.nix

            home-manager.nixosModules.home-manager {
              home-manager =
                let
                  user = "abe";
                in {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = { inherit unstable user; };
                users.abe = {
                  imports = [
                    ./hosts/flex5i/abe.nix
                    ./hosts/home.nix
                  ];
                };
              };
            }
          ];
        };
      };
    };
}
