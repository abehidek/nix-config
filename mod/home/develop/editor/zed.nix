{
  config,
  lib,
  # pkgs,
  # modulesPath,
  ...
}:
let
  cfg = config."hidekxyz"."home"."develop"."editor"."zed";
in
{
  options."hidekxyz"."home"."develop"."editor"."zed" = with lib; {
    font = mkOption {
      type = types.str;
      default = "FiraCode Nerd Font";
    };
    theme = {
      mode = mkOption {
        type = types.str;
        default = "dark";
      };
      light = mkOption {
        type = types.str;
        default = "Solarized Light";
      };
      dark = mkOption {
        type = types.str;
        default = "One Dark";
      };
    };
  };

  config = lib.mkMerge [
    {
      programs.zed-editor = {
        enable = true;
        extensions = [
          "nix"
          "toml"
        ];
        userSettings = {
          soft_wrap = "editor_width";
          terminal.font_family = cfg.font;
          theme = {
            mode = cfg.theme.mode;
            light = cfg.theme.light;
            dark = cfg.theme.dark;
          };
        };
      };
    }
  ];
}
