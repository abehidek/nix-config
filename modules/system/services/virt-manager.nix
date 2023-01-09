{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.system.services;
in {
  options.modules.system.services = {
    virt-manager = {
      enable = mkEnableOption "Enables virt-manager";
      users = mkOption { type = types.listOf (types.str); };
      autostart = mkEnableOption "Automatically starts on boot";
    };
  };

  config =
  let
    forAllUsers = genAttrs (cfg.virt-manager.users);
  in (mkMerge [
    (mkIf cfg.virt-manager.enable (mkMerge [
      {
        environment.systemPackages = with pkgs; [ virt-manager ];
        virtualisation.libvirtd.enable = true;
        programs.dconf.enable = true;
        users.users = forAllUsers (user: {
          extraGroups = [ "libvirtd" ];
        });
      }
      (mkIf cfg.virt-manager.autostart {
        virtualisation.libvirtd.onBoot = "start";
      })
      (mkIf (cfg.virt-manager.autostart == false) {
        virtualisation.libvirtd.onBoot = "ignore";
      })
    ]))
  ]);
}
