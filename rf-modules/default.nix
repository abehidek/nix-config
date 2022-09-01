{ lib, config, pkgs, unstable, ... }: {
  imports = [
    ./docker.nix
    ./hello.nix
    ./ssh.nix
    ./vscodium.nix
    ./zsh.nix
    ./desktop
    ./shell
    ./hardware
  ];
}