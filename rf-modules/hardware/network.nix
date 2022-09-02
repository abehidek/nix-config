{ lib, config, pkgs, unstable, name, user, ... }:
with lib;
let cfg = config.modules.hardware.network;
in {
  imports = [];

  options.modules.hardware.network = {
    hostName = mkOption {
      type = types.str;
    };
    useNetworkManager = utils.mkBoolOpt true;
  };

  config = (mkMerge [
    {
      networking = {
        hostName = "${cfg.hostName}";
      };
    }
    (mkIf cfg.useNetworkManager {
      networking = {
        networkmanager.enable = true;
      };
    })
  ]);  
}
