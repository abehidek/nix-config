### About

The whole idea of customizing your own system always is appealing to a lot of people, however, most people don't dive too much into, just change some basic configuration, but, like some other people, I wanted to customize it more and give it my identity.
Still, to get all things to work properly is a unending process, and track all your changes on the system is kinda impossible if you don't know how to ngl.
Nix and NixOS solves some of these problems, you can create reproducible builds and also revert changes that you did on the system, there is a lot of other tools too. I recommend you to give it a try too.
Currently I'm learning more about the Nix language and NixOS, it's a steep learning curve since it has so many things to grasp and is so different from the traditional linux distro (like the filesystem, nix store, etc). So right now, most of the code is not so complicated and rather simple, but I guess everyone starts somewhere ¯\_(ツ)_/¯.
This repo contains all dotfiles to create an identical system to which I'm using (including programs and its configurations), feel free to test it on a machine or virtual machine.
Don't expect these dotfiles to work since there are a lot of factors to include, but instead, try to adapt it to your machine.
Also, if someone is interest I would love to chat about this topic since I have so much to learn.

### System
##### Details

| Shell | Bash |
|---|---|
| WM | Sway |
| Terminal | Alacritty |
| Browser | Brave |
| Wallpaper | [nordic-wallpapers](https://github.com/linuxdotexe/nordic-wallpapers) |

##### Partition Scheme
| Partition Label | Description |
|---|---|
| NIXBOOT | EFI partition contains basic files to load the Operating System. |
| NIXROOT | Root partition, where linux operating system and its files is stored. |
| NIXSWAP | Assistant and overflow space for RAM. |

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

##### Some other dotfiles repo I use to understand better:
- https://github.com/hlissner/dotfiles
- https://github.com/KubqoA/dotfiles
- https://github.com/alternateved/nixos-config
- https://github.com/darch7/swaywm

