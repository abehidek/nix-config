# This function creates a NixOS system based on our VM setup for a
# particular architecture.
name: { inputs, system, system-modules }:

let
  inherit (inputs) self nixpkgs nixpkgs-unstable home-manager;
  unstable = import nixpkgs-unstable {
    inherit system;
    config.allowUnfree = true;
  };
  lib = nixpkgs.lib.extend (self: super: { utils = import ./utils.nix { inherit nixpkgs; lib = self; }; });
in
lib.nixosSystem rec {
  inherit system;
  specialArgs = { inherit inputs lib unstable name; };
  modules = system-modules name rec {
    inherit inputs nixpkgs home-manager unstable;
  } ++ [ ../rf-modules ];

  # We expose some extra arguments so that our modules can parameterize
  # better based on these values.
}

