{ lib, config, pkgs, unstable, name, user, ... }:
with lib;
let cfg = config.modules.services.virt-manager;
in {
  options.modules.services.virt-manager = {
    enable = utils.mkBoolOpt false;
    auto-startup = utils.mkBoolOpt false;
  };

  config = mkIf cfg.enable (mkMerge [
    {
      environment.systemPackages = with pkgs; [ virt-manager ];
      virtualisation.libvirtd.enable = true;
      programs.dconf.enable = true;
    }
    (mkIf cfg.auto-startup {
      virtualisation.libvirtd.onBoot = "start";
    })
    (mkIf (cfg.auto-startup == false) {
      virtualisation.libvirtd.onBoot = "ignore";
    })
  ]);
}
