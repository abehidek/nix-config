{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.user.shell;
in {
  imports = [];

  options.modules.user.shell = {
    zsh = {
      rice = mkEnableOption "Enables zsh home-manager rice";
    };
  };

  config = (mkMerge [
    (mkIf cfg.zsh.rice (mkMerge [
      {
        programs.zsh = {
          enable = true;
          enableCompletion = true;
          syntaxHighlighting = {
            enable = true;
          };
          history = {
            size = 5000;
            path = "$HOME/.local/share/zsh/history";
          };
          zplug = {
            enable = true;
            plugins = [
              { name = "zsh-users/zsh-autosuggestions"; }
              { name = "supercrabtree/k"; }
            ];
          };
          initExtraFirst = ''
            ${pkgs.any-nix-shell}/bin/any-nix-shell zsh --info-right | source /dev/stdin
          '';
          oh-my-zsh = {
            enable = true;
            plugins = [ "git" "web-search" "copypath" "dirhistory" ];
          };
        };
      }
    ]))
  ]);
}
