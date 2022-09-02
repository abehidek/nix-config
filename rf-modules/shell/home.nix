{ lib, config, pkgs, unstable, name, user, ... }: {
  imports = [
    ./direnv/home.nix
    ./zsh/home.nix
  ];
}