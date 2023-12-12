<h1 align="center">
  <br>
  <img src="https://raw.githubusercontent.com/NixOS/nixos-artwork/521e1b0a899074ca7a701c17e357c63c13d54133/logo/nix-snowflake.svg" width="100px" height="100px" alt="nix snowflake logo" />
  <br>
  Systems Nix Config
  <br>
</h1>

<h4 align="center">One config. One setup. One place</h4>

<p align="center">
  <a href="https://nixos.org"><img src="https://img.shields.io/badge/os-nixos-blue" alt="NixOS"></a>
  <a href="https://builtwithnix.org"><img src="https://img.shields.io/badge/lang-nix-lightblue" alt="Nix"></a>
  <a href="https://swaywm.org"><img src="https://img.shields.io/badge/wm-xmonad-darkblue" alt="Hyprland"></a>
  <a href="https://helix-editor.com"><img src="https://img.shields.io/badge/editor-helix-purple" alt="Helix"></a>
  <a href="https://www.zsh.org"><img src="https://img.shields.io/badge/shell-zsh-black" alt="Zsh"></a>
</p>

<p align="center">
  <a href="#about">About</a> •
  <a href="#key-features">Key Features</a> •
  <a href="#system-details">System Details</a> •
  <!-- <a href="#getting-started">Getting Started</a> • -->
  <a href="#faq">FAQ</a> •
  <a href="#roadmap">Roadmap</a> •
  <!-- <a href="#support">Support</a> • -->
  <a href="#license">License</a>
</p>

<!-- ![screenshot](screenshots/1.jpg) -->

## About

The whole idea of customizing your own system always is appealing to a lot of people, however, most people don't dive too much into, just change some basic configuration, but, like some other people, I wanted to customize it more and give it my identity.
Still, to get all things to work properly is a unending process, and track all your changes on the system is kinda impossible if you don't know how to ngl.

Nix and NixOS solves some of these problems, you can create reproducible builds and also revert changes that you did on the system, there is a lot of other tools too. I recommend you to give it a try too.

Currently I'm learning more about the Nix language and NixOS, it's a steep learning curve since it has so many things to grasp and is so different from the traditional linux distro (like the filesystem, nix store, etc). So right now, most of the code is not so complicated and rather simple, but I guess everyone starts somewhere `¯\_(ツ)_/¯`.

This repo contains all dotfiles to create an identical system to which I'm using (including programs and its configurations), feel free to test it on a machine or virtual machine.

Don't expect these dotfiles to work since there are a lot of factors to include, but instead, try to adapt it to your machine.
Also, if someone is interest I would love to chat about this topic since I have so much to learn.

## Key Features

- Multiple host configurations (laptop, bootable ssd and WSL2)
- Configured x11 and wayland desktop environments (Xmonad, Hyprland and Sway)
- Commonly used modules for configuring system.
- Home manager configuration as a NixOS system module (allows to rebuild the system once instead of twice)
  - Each user has it's own Home manager configuration file labeled as the user name.
  - Home manager modules for configuring each application in user space.
- Secrets management using GPG.

## System Details

### Avaiable hosts:

- Flex5i (Ideapad laptop)
- SSD (240GB External SSD)
- WSL2 NixOS (Main Desktop)

### Flex5i Partition Scheme (UEFI)

| Partition Label | Description                                                           |
| --------------- | --------------------------------------------------------------------- |
| NIXOS-BOOT      | EFI partition contains basic files to load the Operating System.      |
| NIXOS-ROOT      | Root partition, where linux operating system and its files is stored. |
| NIXOS-SWAP      | Assistant and overflow space for RAM.                                 |

<!-- ## Getting Started

All of this Nix code is avaiable to use the way you want to use, however, worth noting that not necessarily all configuration will fit in your machine.

### Prerequisites

If you are in the NixOS installer, you will need to setup your partition scheme as the same way of the partition scheme inside <a href="#system-details">systems details section</a>

since this repository manages only NixOS configuration, you will need:

- NixOS
- Git (easily installed on the NixOS setup by using `nix-shell -p git`)

### Installing and Running

To access it's configuration, it's necessary to first clone this repository in your machine.

```bash
# Clone this repository
$ git clone https://github.com/abehidek/dotfiles

# Go into the repository
$ cd dotfiles
``` -->

<!--
## FAQ

### Is it any good?

[yes.](https://news.ycombinator.com/item?id=3067434)
-->

## Roadmap

- [ ] Install [Lunacy](https://flathub.org/apps/details/com.icons8.Lunacy) through flatpak using [declarative-nix-flatpak](https://github.com/yawnt/declarative-nix-flatpak)
- [x] Move to xmonad due to better compatibility provided X11.
- [ ] Proper GTK and QT theming based on the nix-colors base16 colorscheme.
- [x] Config public SSH keys on hosts.
- [ ] Simplify this README.
- [x] [Refactor all this codebase and minify overall complexity](https://github.com/abehidek/nix-config/pull/4)
- [x] Config properly zsh.
- [x] Try out Hyprland.
- [x] Migrate old module style to proper configurable NixOS modules.
- [x] Setup NixOS WSL2 properly
- [ ] Use Disko for formatting disks with nix expressions.
- [x] Understand better overlays and [new nix flake commands](https://tonyfinn.com/blog/nix-from-first-principles-flake-edition/).
- [ ] Proper flake config for Raspberry Pi 400 (as a server) and WSL (as dev env).
- [ ] Create some useful eww widgets.
- [x] Decrease the number of installed packages and RAM consumption

## Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement".
Don't forget to give the project a star! Thanks again!

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

<!-- ## Support

You can also support us by:

<p align="left">
  <a href="https://www.buymeacoffee.com" target="_blank"><img src="https://www.buymeacoffee.com/assets/img/custom_images/purple_img.png" alt="Buy Me A Coffee" style="height: 41px !important;width: 174px !important;box-shadow: 0px 3px 2px 0px rgba(190, 190, 190, 0.5) !important;-webkit-box-shadow: 0px 3px 2px 0px rgba(190, 190, 190, 0.5) !important;" ></a> &nbsp &nbsp
  <a href="https://www.patreon.com">
    <img src="https://c5.patreon.com/external/logo/become_a_patron_button@2x.png" width="160">
  </a>
</p> -->

## License

MIT.

## Acknowledgments

These sources helped me to accomplish this project.

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

### XMonad WM

- https://gist.github.com/kodeFant/f08ffd89eab932028fe84a92aa90974f
- https://wiki.haskell.org/Xmonad/Config_archive
- https://www.youtube.com/playlist?list=PL5--8gKSku144jIsizdhdxq_fKTmBBGBA
- https://www.youtube.com/watch?v=T0i65NXP5P4
- https://github.com/gvolpe/nix-config
- https://nixos.wiki/wiki/XMonad

## You may also like...

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
- https://github.com/MatthewCroughan/nixcfg
- https://github.com/iguoliveira/nix-config

---

> [hidek.xyz](https://hidek.xyz) &nbsp;&middot;&nbsp;
> GitHub [@abehidek](https://github.com/abehidek) &nbsp;&middot;&nbsp;
> Twitter [@guilhermehabe](https://twitter.com/guilhermehabe)
