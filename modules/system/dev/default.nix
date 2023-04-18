{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.system.dev;
in {
  options.modules.system.dev = {
    android = {
      enable = mkEnableOption "Enable android development";
      users = mkOption { type = types.listOf (types.str); };
      enableAndroidStudio = mkEnableOption "Install android studio pkg";
    };
  };

  config =
  let
    forAllUsers = genAttrs (cfg.android.users);
  in (mkMerge [
    (mkIf cfg.android.enable (mkMerge[
      {
        programs.adb.enable = true;
        users.users = forAllUsers (user: {
          extraGroups = [ "adbusers" ];
        });
      }
      (mkIf cfg.android.enableAndroidStudio {
        environment.systemPackages = with pkgs; [ android-studio ];
      })
    ]))
  ]);
}
