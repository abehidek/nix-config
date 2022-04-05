#!/bin/sh
pushd ~/dotfiles
sudo nixos-rebuild switch -I nixos-config=./hosts/flex5i/system.nix
popd
