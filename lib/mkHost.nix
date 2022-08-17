# This function creates a NixOS system based on our VM setup for a
# particular architecture.
name: { nixpkgs, home-manager, system, nixpkgs-unstable, system-modules, nix-gaming}:

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
  specialArgs = { inherit lib unstable name currentSystem currentSystemName nix-gaming; };
  modules = system-modules name rec {
    inherit nixpkgs home-manager unstable;
  };

  # We expose some extra arguments so that our modules can parameterize
  # better based on these values.
}

