{ lib, config, pkgs, unstable, name, user, ... }: {
  imports = [
    ./zsh.nix
    ./direnv
    ./tmux.nix
  ];
}