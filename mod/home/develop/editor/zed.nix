{
  config,
  lib,
  # pkgs,
  # modulesPath,
  ...
}:
let
  cfg = config."hidekxyz"."home"."develop"."editor"."zed";
  mkIfElse =
    p: yes: no:
    lib.mkMerge [
      (lib.mkIf p yes)
      (lib.mkIf (!p) no)
    ];

in
{
  options."hidekxyz"."home"."develop"."editor"."zed" = with lib; {
    font = mkOption {
      type = types.str;
      default = "FiraCode Nerd Font";
    };
    shell = {
      program = mkOption {
        type = types.str;
        default = "system";
      };
      args = mkOption {
        type = types.listOf (types.str);
        default = [ ];
      };
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
          buffer_font_family = cfg.font;
          terminal.font_family = cfg.font;
          theme = {
            mode = cfg.theme.mode;
            light = cfg.theme.light;
            dark = cfg.theme.dark;
          };
        };
      };
    }
    (mkIfElse (builtins.length cfg.shell.args > 0)
      {
        programs.zed-editor.userSettings.terminal.shell.with_arguments = {
          program = cfg.shell.program;
          args = cfg.shell.args;
        };
      }
      {
        programs.zed-editor.userSettings.terminal.shell.program = cfg.shell.program;
      }
    )
  ];
}
