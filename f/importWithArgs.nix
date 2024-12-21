{
  config,
  lib,
  pkgs,
  modulesPath,
  nixpkgs,
  ...
}:

# takes a path w/ some additional args and import it.
path: specialArgs:
(import path (
  specialArgs
  // {
    inherit
      config
      lib
      pkgs
      modulesPath
      nixpkgs
      ;
  }
))
