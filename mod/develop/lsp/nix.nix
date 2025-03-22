{
  config,
  lib,
  pkgs,
  # modulesPath,
  ...
}:
let
  cfg = config."hidekxyz"."vm"."microvm"."guest";
in
{
  options."hidekxyz"."vm"."microvm"."guest" = with lib; {
    formatter = {
      enable = mkOption {
        type = types.bool;
        default = true;
      };
    };
  };

  config = lib.mkMerge [
    {
      nix.nixPath = [ "nixpkgs=${pkgs.path}" ];
      environment.systemPackages = [ pkgs.nixd ];
    }
    (lib.mkIf cfg.formatter.enable {
      environment.systemPackages = [ pkgs.nixfmt-rfc-style ];
    })
  ];
}
