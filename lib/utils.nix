{ lib, ... }:

let
  inherit (lib) mkOption types;
in
rec {
  mkOpt  = type: default:
    mkOption { inherit type default; };

  mkOpt' = type: default: description:
    mkOption { inherit type default description; };

  mkBoolOpt = default: mkOption {
    inherit default;
    type = types.bool;
    example = true;
  };

  mkHomeManager = name: {homeManagerModule, ...}: args@{pkgs, unstable, ...}: {
    imports = [
      (import homeManagerModule)
      ../rf-modules/home.nix
      (import ../hosts/home.nix { inherit args; user = "abe"; })
    ];
  };
}
