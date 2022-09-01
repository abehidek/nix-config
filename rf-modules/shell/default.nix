{ lib, config, pkgs, unstable, name, user, ... }: {
  imports = [
    ./zsh.nix
    ./direnv.nix
    ./tmux.nix
  ];
}