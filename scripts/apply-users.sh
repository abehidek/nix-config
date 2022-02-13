#!/bin/sh
pushd ~/.dotfiles
home-manager switch -f ./hosts/abe/home.nix
popd
