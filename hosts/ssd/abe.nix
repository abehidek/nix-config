# Home-Manager config for ssd abe user

args@{ lib, config, pkgs, unstable, ... }: {
  home.stateVersion = "22.05";
  imports = [
    (import ../home.nix { inherit args; user = "abe"; })
    ../../modules/editors/neovim/home.nix
  ];
  home.packages = with pkgs; [
    # exodus
    obsidian
  ];
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableSyntaxHighlighting = true;
    history = {
      size = 5000;
      path = "$HOME/.local/share/zsh/history";
    };
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "web-search" "copypath" "dirhistory" ];
    };
    zplug = {
      enable = true;
      plugins = [
        { name = "zsh-users/zsh-autosuggestions"; }
        { name = "supercrabtree/k"; }
      ];
    };
  };
  programs = {
    git = {
      enable = true;
      userEmail = "hidek.abe@outlook.com";
      userName = "abehidek";
      extraConfig = {
        core = {
          filemode = false;
        };
        safe = {
          directory = "/shared/ws/zettelkasten";
        };
      };
    };
  };
}
