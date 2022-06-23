{ lib, config, pkgs, ... }: {
  programs.zsh = {
    enable = true;
    profileExtra = ''
      [ "$(tty)" = "/dev/tty1" ] && exec sway
    '';
    initExtraFirst = ''
      P10K_INSTANT_PROMPT="$XDG_CACHE_HOME/p10k-instant-prompt-''${(%):-%n}.zsh"
      [[ ! -r "$P10K_INSTANT_PROMPT" ]] || source "$P10K_INSTANT_PROMPT"

      any-nix-shell zsh --info-right | source /dev/stdin
      alias ranger='ranger --choosedir=$HOME/.rangerdir; LASTDIR=`cat $HOME/.rangerdir`; cd "$LASTDIR"'
      clear
    '';
    envExtra = "";
    # if [ -n "$NVIM_LISTEN_ADDRESS" ]; then
    #     export VISUAL="nvr -cc split --remote-wait +'set bufhidden=wipe'"
    #     export EDITOR="nvr -cc split --remote-wait +'set bufhidden=wipe'"
    # else
    #     export VISUAL="nvim"
    #     export EDITOR="nvim"
    # fi
    # if [ -n "$NVIM_LISTEN_ADDRESS" ]; then
    #     alias nvim=nvr -cc split --remote-wait +'set bufhidden=wipe'
    # fi
    enableCompletion = true;
    enableSyntaxHighlighting = true;
    history = {
      size = 5000;
      path = ".local/share/zsh/history";
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
        src = lib.cleanSource ../../../config/p10k;
        file = "config.zsh";
      }
    ];
  };
}
