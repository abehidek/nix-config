{ lib, config, pkgs, name, ... }: {
  networking = {
    hostName = "${name}";
    networkmanager.enable = true;
    useNetworkd = true;
    useDHCP = false;
    interfaces.wlp0s20f3.useDHCP = true;
  };
}
