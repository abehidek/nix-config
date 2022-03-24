#!/bin/sh
pushd ~/dotfiles
doas nixos-rebuild switch -I nixos-config=./hosts/flex5i/system.nix
popd
