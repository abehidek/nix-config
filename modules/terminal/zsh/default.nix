{ lib, config, pkgs, ... }:
let colorscheme = import ../theme/colorscheme;
in {
  # imports = [
  #   ../../xdg
  # ];
  environment = { systemPackages = with pkgs; [ any-nix-shell ]; };
  users.defaultUserShell = pkgs.zsh;
  home-manager.users.abe = {
    programs.zsh = {
      enable = true;
      initExtraFirst = ''
        if [ -n "$NVIM_LISTEN_ADDRESS" ]; then
            alias nvim=nvr -cc split --remote-wait +'set bufhidden=wipe'
        fi

        if [ -n "$NVIM_LISTEN_ADDRESS" ]; then
            export VISUAL="nvr -cc split --remote-wait +'set bufhidden=wipe'"
            export EDITOR="nvr -cc split --remote-wait +'set bufhidden=wipe'"
        else
            export VISUAL="nvim"
            export EDITOR="nvim"
        fi
        any-nix-shell zsh --info-right | source /dev/stdin
        alias ranger='ranger --choosedir=$HOME/.rangerdir; LASTDIR=`cat $HOME/.rangerdir`; cd "$LASTDIR"'
      '';
      enableCompletion = true;
      enableSyntaxHighlighting = true;
      history = {
        size = 5000;
        path = "$XDG_DATA_HOME/zsh/history";
      };
      oh-my-zsh = {
        enable = true;
        plugins = [ "git" "web-search" "copydir" "dirhistory" ];
      };
      zplug = {
        enable = true;
        plugins = [
          { name = "zsh-users/zsh-autosuggestions"; }
          { name = "supercrabtree/k"; }
        ];
      };
      plugins = [
        {
          name = "powerlevel10k";
          src = pkgs.zsh-powerlevel10k;
          file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
        }
        {
          name = "powerlevel10k-config";
          src = lib.cleanSource ../p10k;
          file = "p10k.zsh";
        }
      ];
    };
  };
}
