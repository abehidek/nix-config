
{ lib, config, pkgs, unstable, name, user, ... }:
with lib;
let cfg = config.modules.ssh;
in {
  options.modules.ssh = {
    enable = mkEnableOption "SSH service";
    default = false;
  };

  config = mkIf cfg.enable {
    services.openssh = {
      enable = true;
    };
  };
}
