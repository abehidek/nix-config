{
  description = "A very basic flake";
  inputs = {
    nixpkgs = { url = "github:nixos/nixpkgs/nixos-21.11"; };
    home-manager = { url = github:nix-community/home-manager; inputs.nixpkgs.follows = "nixpkgs"; };
  };
  outputs = { self, nixpkgs, home-manager, ... }:
    let 
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; config.allowUnfree = true; };
      lib = nixpkgs.lib;
    in {
      nixosConfigurations = {
        flex5i = lib.nixosSystem { 
          inherit system; 
          modules = [
            ./hosts/flex5i/system.nix
            home-manager.nixosModules.home-manager {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.abe = { imports = [ ./users/home.nix ]; };
              };
            }
          ];
        };
      };
    };
}
