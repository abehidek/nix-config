{
  config,
  lib,
  pkgs,
  # modulesPath,
  ...
}:
let
  cfg = config."hidekxyz"."home"."all";
in
{
  options."hidekxyz"."home"."all" = with lib; {
    userName = mkOption { type = types.str; };
    stateVersion = mkOption { type = types.str; };
  };

  config = lib.mkMerge [
    {
      home = {
        username = cfg.userName;
        stateVersion = cfg.stateVersion;

        homeDirectory = if pkgs.stdenv.isDarwin then "/Users/${cfg.userName}" else "/home/${cfg.userName}";
        preferXdgDirectories = pkgs.stdenv.isLinux;

        packages = with pkgs; [ home-manager ];
      };
    }
  ];
}
