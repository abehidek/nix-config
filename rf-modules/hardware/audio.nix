{ lib, config, pkgs, unstable, name, user, ... }:
with lib;
let cfg = config.modules.hardware.audio;
in {
  imports = [];

  options.modules.hardware.audio = {
    enable = utils.mkBoolOpt false;
    users = mkOption {
      type = types.listOf (types.str);
    };
  };

  config = let forAllUsers = lib.genAttrs (cfg.users);
  in mkIf cfg.enable (mkMerge [
    {
      security.rtkit.enable = true;
      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        jack.enable = true;
      };

      users.users = forAllUsers (user: let 
        # these two are the same:
        # extraGroups = users.users."${user}".extraGroups;
        extraGroups = self."${user}".extraGroups;
        in {
          extraGroups = ["audio"];
        }
      );
    }
  ]);  
}
