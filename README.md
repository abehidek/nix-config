# Systems Dotfile

### Using:
[![NixOS](https://img.shields.io/badge/os-nixos-blue)](https://nixos.org/)
![WSL](https://img.shields.io/badge/os-wsl2-lightgrey)
[![Nix](https://img.shields.io/badge/lang-nix-purple)](https://builtwithnix.org/)
[![Sway](https://img.shields.io/badge/wm-sway-lightblue)](https://swaywm.org/)
[![Neovim](https://img.shields.io/badge/editor-neovim-green)](https://neovim.io/)
[![Zsh](https://img.shields.io/badge/shell-zsh-black)](https://www.zsh.org/)

### About

The whole idea of customizing your own system always is appealing to a lot of people, however, most people don't dive too much into, just change some basic configuration, but, like some other people, I wanted to customize it more and give it my identity.
Still, to get all things to work properly is a unending process, and track all your changes on the system is kinda impossible if you don't know how to ngl.

Nix and NixOS solves some of these problems, you can create reproducible builds and also revert changes that you did on the system, there is a lot of other tools too. I recommend you to give it a try too.

Currently I'm learning more about the Nix language and NixOS, it's a steep learning curve since it has so many things to grasp and is so different from the traditional linux distro (like the filesystem, nix store, etc). So right now, most of the code is not so complicated and rather simple, but I guess everyone starts somewhere `¯\_(ツ)_/¯`.

This repo contains all dotfiles to create an identical system to which I'm using (including programs and its configurations), feel free to test it on a machine or virtual machine.

Don't expect these dotfiles to work since there are a lot of factors to include, but instead, try to adapt it to your machine.
Also, if someone is interest I would love to chat about this topic since I have so much to learn.

### System

##### Screenshots

![image1](assets/readme/rice00.png)
![image2](assets/readme/rice01.png)
![image3](assets/readme/rice02.png)
![image4](assets/readme/rice03.png)
![image5](assets/readme/rice04.png)
![image6](assets/readme/rice05.png)
![image7](assets/readme/rice06.png)

##### Details

| Name | Detail |
|---|---|
| Shell | Zsh |
| WM | Sway |
| Terminal | Kitty |
| Browser | Firefox |
| Wallpaper | [frenzy-exists wallpapers](https://github.com/FrenzyExists/wallpapers) |

> Planning on moving to xmonad because X11 compatibility.

##### Partition Scheme
| Partition Label | Description |
|---|---|
| NIXOS-BOOT | EFI partition contains basic files to load the Operating System. |
| NIXOS-ROOT | Root partition, where linux operating system and its files is stored. |
| NIXOS-SWAP | Assistant and overflow space for RAM. |

### Learn more about Nix and NixOS
#### (I used these materials A LOT in order to be able to create this repo):
##### Basics and Fundamentals
- https://linktr.ee/nixos
- https://nixos.wiki/wiki/Sway
- https://wiki.archlinux.org/title/Sway
- https://nixos.org/learn
- https://github.com/swaywm/sway/wiki/
- https://github.com/nix-community/home-manager/blob/master/modules/services/window-managers/i3-sway/sway.nix
- https://specific.solutions.limited/blog/wayland-sway-window-manager
- https://rycee.gitlab.io/home-manager/options.html#opt-wayland.windowManager.sway.enable
- https://www.reddit.com/r/swaywm/comments/hmtdr9/how_do_you_guys_change_settings_in_sway/
- https://www.youtube.com/channel/UCSW5DqTyfOI9sUvnFoCjBlQ/videos
- https://youtu.be/AGVXJ-TIv3Y

##### Some other dotfiles repo I use to understand better:
- https://github.com/hlissner/dotfiles
- https://github.com/KubqoA/dotfiles
- https://github.com/alternateved/nixos-config
- https://github.com/darch7/swaywm
- https://github.com/MatthiasBenaets/nixos-config
- https://github.com/wiltaylor/dotfiles
- https://github.com/Misterio77/nix-colors
- https://github.com/Misterio77/nix-config
- https://github.com/shaunsingh/nix-darwin-dotfiles
- https://github.com/kclejeune/system

##### Configuring Neovim from scratch
- https://github.com/notusknot/dotfiles-nix
- https://www.youtube.com/c/ChrisAtMachine
