<div align="center">
  <img src="https://raw.githubusercontent.com/NixOS/nixos-artwork/521e1b0a899074ca7a701c17e357c63c13d54133/logo/nix-snowflake.svg" width="100px" height="100px" alt="nix snowflake logo" />
  <h1>Systems Dotfiles</h1>

[![NixOS](https://img.shields.io/badge/os-nixos-blue)](https://nixos.org/)
[![Nix](https://img.shields.io/badge/lang-nix-lightblue)](https://builtwithnix.org/)
[![Sway](https://img.shields.io/badge/wm-hyprland-darkblue)](https://swaywm.org/)
[![Neovim](https://img.shields.io/badge/editor-helix-purple)](https://neovim.io/)
[![Zsh](https://img.shields.io/badge/shell-zsh-black)](https://www.zsh.org/)

</div>

## About

The whole idea of customizing your own system always is appealing to a lot of people, however, most people don't dive too much into, just change some basic configuration, but, like some other people, I wanted to customize it more and give it my identity.
Still, to get all things to work properly is a unending process, and track all your changes on the system is kinda impossible if you don't know how to ngl.

Nix and NixOS solves some of these problems, you can create reproducible builds and also revert changes that you did on the system, there is a lot of other tools too. I recommend you to give it a try too.

Currently I'm learning more about the Nix language and NixOS, it's a steep learning curve since it has so many things to grasp and is so different from the traditional linux distro (like the filesystem, nix store, etc). So right now, most of the code is not so complicated and rather simple, but I guess everyone starts somewhere `¯\_(ツ)_/¯`.

This repo contains all dotfiles to create an identical system to which I'm using (including programs and its configurations), feel free to test it on a machine or virtual machine.

Don't expect these dotfiles to work since there are a lot of factors to include, but instead, try to adapt it to your machine.
Also, if someone is interest I would love to chat about this topic since I have so much to learn.

## System

### Roadmap

- [ ] Install [Lunacy](https://flathub.org/apps/details/com.icons8.Lunacy) through flatpak using [declarative-nix-flatpak](https://github.com/yawnt/declarative-nix-flatpak)
- [ ] Move to xmonad due to better compatibility provided X11.
- [ ] Proper GTK and QT theming based on the nix-colors base16 colorscheme.
- [ ] Config public SSH keys on hosts.
- [ ] Config properly zsh.
- [x] Try out Hyprland.
- [x] Migrate old module style to proper configurable NixOS modules.
- [ ] Understand better overlays and new nix flake commands.
- [ ] Proper flake config for Raspberry Pi 400 (as a server) and WSL (as dev env).
- [ ] Create some useful eww widgets.
- [ ] Decrease the number of installed packages and RAM consumption

### Details

#### Avaiable hosts:

- Flex5i (Ideapad laptop)
- SSD (240GB External SSD)

#### Flex5i Partition Scheme (UEFI)

| Partition Label | Description                                                           |
| --------------- | --------------------------------------------------------------------- |
| NIXOS-BOOT      | EFI partition contains basic files to load the Operating System.      |
| NIXOS-ROOT      | Root partition, where linux operating system and its files is stored. |
| NIXOS-SWAP      | Assistant and overflow space for RAM.                                 |

#### SSD Partition Scheme (UEFI)

// todo

## Learn more about Nix and NixOS

### Some docs, blog posts and videos about Nix and NixOS

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
- https://gvolpe.com/blog/xmonad-polybar-nixos/#rofi

### Some other dotfiles repo I use to understand better:

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
- https://github.com/sebastiant/dotfiles

### Configuring Neovim from scratch

- https://github.com/notusknot/dotfiles-nix
- https://www.youtube.com/c/ChrisAtMachine
