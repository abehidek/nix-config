
{ lib, config, pkgs, unstable, name, user, ... }:
with lib;
let cfg = config.modules.services.ssh;
in {
  options.modules.services.ssh = {
    enable = utils.mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    services.openssh = {
      enable = true;
    };
  };
}
