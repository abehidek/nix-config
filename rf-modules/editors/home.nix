{ lib, config, pkgs, unstable, name, user, ... }: {
  imports = [
    ./vim.nix
    ./vscodium.nix
    ./helix.nix
  ];
}