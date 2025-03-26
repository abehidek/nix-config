{
  # config,
  lib,
  pkgs,
  # modulesPath,
  # paths,
  ...
}:

{
  imports = [ ./all.nix ];

  options."hidekxyz"."all"."darwin" = { };

  config = lib.mkMerge [
    {
      nix.optimise.automatic = true;

      environment.systemPackages = with pkgs; [
        pipes
      ];
    }
  ];
}
