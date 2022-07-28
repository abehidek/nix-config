
{ lib, config, pkgs, unstable, name, user, ... }:
with lib;
let cfg = config.modules.ssh;
in {
  options.modules.ssh = {
    enable = utils.mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    services.openssh = {
      enable = true;
    };
  };
}
