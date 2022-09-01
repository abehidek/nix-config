{ lib, config, pkgs, unstable, name, user, ... }:
with lib;
let cfg = config.modules.desktop;
in {
  imports = [
    ./hyprland
    ./sway
    ./kde.nix
  ];

  options.modules.desktop = {
    enable = mkEnableOption "Install a Graphic Interface";
    auto-startup = mkOption {
      type = types.submodule {
        options = {
          enable = mkEnableOption "Enable automatic environment startup through display manager or console script";
          type = mkOption {
            type = types.enum ["console" "sddm"];
          };
          environment = mkOption {
            type = types.enum ["Hyprland" "sway"];
          }; 
        };
      };
    };
  };

  config = mkIf cfg.enable (mkMerge [
    (mkIf cfg.auto-startup.enable (mkMerge [
      (mkIf (cfg.auto-startup.type == "console") {
        environment.loginShellInit = ''
        if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
          exec ${cfg.auto-startup.environment}
        fi
        '';
      })
      (mkIf (cfg.auto-startup.type == "sddm") {
        services.xserver = {
          enable = true;
          displayManager.sddm.enable = true;        
        };
      })
    ]))
  ]);
}
