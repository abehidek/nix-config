{ lib, config, pkgs, unstable, name, user, ... }:
with lib;
let cfg = config.modules.shell.direnv;
in {
  imports = [];

  options.modules.shell.direnv = {
    enable = utils.mkBoolOpt false;
    preventGC = utils.mkBoolOpt false;
  };

  config = mkIf cfg.enable (mkMerge [
    {
      environment.systemPackages = with pkgs; [ direnv nix-direnv ];
    }
    (mkIf cfg.preventGC {
      nix.extraOptions = ''
        keep-outputs = true
        keep-derivations = true
      '';
    })
  ]);
}
