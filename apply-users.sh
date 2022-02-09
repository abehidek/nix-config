#!/bin/sh
pushd ~/.dotfiles
home-manager switch -f ./users/abe/home.nix
popd
