{ config, pkgs, ... }:
let
  colorscheme = import ../theme/colorscheme;
in {
  # imports = [
  #   ../../xdg
  # ];
  environment = {
    systemPackages = with pkgs; [ any-nix-shell ];
  };
  users.defaultUserShell = pkgs.zsh;
  home-manager.users.abe = {
    programs.zsh = {
      enable = true;
      # source $DOTFILES/scripts/ifcd.sh
      initExtraFirst = ''
        any-nix-shell zsh --info-right | source /dev/stdin
        alias ranger='ranger --choosedir=$HOME/.rangerdir; LASTDIR=`cat $HOME/.rangerdir`; cd "$LASTDIR"'
      '';
      # 
      enableCompletion = true;
      enableSyntaxHighlighting = true;
      history = {
        size = 5000;
        path = "$XDG_DATA_HOME/zsh/history";
      };
      oh-my-zsh = {
        enable = true;
        plugins = [ "git" "web-search" "copydir" "dirhistory" ];
        theme = "robbyrussell";
      };
      zplug = {
        enable = true;
        plugins = [
          { name = "zsh-users/zsh-autosuggestions"; } # Simple plugin installation
          { name = "supercrabtree/k"; }
        # { name = "romkatv/powerlevel10k"; tags = [ as:theme depth:1 ]; } # Installations with   additional options. For the list of options, please refer to Zplug README.
        ];
      };
    };
  };
}
