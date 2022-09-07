{ lib, config, pkgs, unstable, name, user, ... }:
with lib;
let cfg = config.hm-modules.desktop.term.kitty;
in {
  options.hm-modules.desktop.term.kitty = {
    enable = mkEnableOption false;
  };

  config = mkIf cfg.enable {
    programs.kitty = {
      enable = true;
      font.name = "FiraCode Nerd Font";
      font.size = 16;
      extraConfig = ''
        disable_ligatures never
        cursor_shape block
        placement_strategy top-left
      '';
      settings = {
        #allow_remote_control = false;
        # background_opacity = "0.9";
        dynamic_background_opacity = true;
        window_padding_width = 0;
      };
    };
  };
}
