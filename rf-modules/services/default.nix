{ lib, config, pkgs, unstable, name, user, ... }: {
  imports = [
    ./docker.nix
    ./ssh.nix
    ./virt-manager.nix
  ];
}