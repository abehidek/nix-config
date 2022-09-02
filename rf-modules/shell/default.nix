{ lib, config, pkgs, unstable, name, user, ... }: {
  imports = [
    ./zsh
    ./direnv
    ./tmux.nix
  ];
}