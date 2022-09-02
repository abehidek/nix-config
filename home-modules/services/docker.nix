
{ lib, config, pkgs, unstable, name, user, ... }:
with lib;
let cfg = config.modules.services.docker;
in {
  options.modules.services.docker = {
  };

  config = {
  };
}
