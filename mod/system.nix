{
  config,
  lib,
  # pkgs,
  # modulesPath,
  ...
}:
let
  cfg = config."hidekxyz"."system";
in
{
  options."hidekxyz"."system" = {
    hostname = lib.mkOption { type = lib.types.str; };
    timeZone = lib.mkOption {
      type = lib.types.str;
      default = "America/Sao_Paulo";
    };
    i18n = lib.mkOption {
      type = lib.types.str;
      default = "en_US.UTF-8";
    };
  };

  config = {
    networking.hostName = cfg.hostname;
    time.timeZone = cfg.timeZone;
    i18n.defaultLocale = cfg.i18n;
  };
}
