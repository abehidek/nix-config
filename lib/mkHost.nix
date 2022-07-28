# This function creates a NixOS system based on our VM setup for a
# particular architecture.
name: { nixpkgs, home-manager, system, user, nixpkgs-unstable}:

let
  unstable = import nixpkgs-unstable {
    inherit system;
    config.allowUnfree = true;
  };
  currentSystemName = name;
  currentSystem = system;
  lib = nixpkgs.lib.extend (self: super: { utils = import ./utils.nix { inherit nixpkgs; lib = self; }; });
in
lib.nixosSystem rec {
  inherit system;
  specialArgs = { inherit lib unstable name user currentSystem currentSystemName; };
  modules = [
    # { nixpkgs.overlays = overlays; } # Apply system
    ../hosts/${name}/system.nix
    ../hosts/system.nix
    home-manager.nixosModules.home-manager {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.extraSpecialArgs = { inherit unstable user; };
      home-manager.users.${user} = {
        imports =  [
          ../hosts/home.nix
          (../. + "/hosts/${name}/${user}.nix")
        ];
      };
    }
  ];

  # We expose some extra arguments so that our modules can parameterize
  # better based on these values.
}

