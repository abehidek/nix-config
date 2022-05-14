#!/bin/sh
pushd ~/dotfiles
# sudo nixos-rebuild switch -I nixos-config=./hosts/flex5i/system.nix
sudo nixos-rebuild switch --flake .#flex5i
popd
