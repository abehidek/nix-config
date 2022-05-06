{ lib, config, pkgs, name, ... }: {
  services.openssh = {
    enable = true;
  };
}
