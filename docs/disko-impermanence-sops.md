## Disko, Impermanence and SOPS

Unfortunatly, Disko does not allow to modify a filesystem so easily, as in the example:
```
ESP 512MB + ext4 100% -> ESP 512MB + zfs 100%
```

For Disko to do it's job properly, it's important to run on a fresh NixOS installer (you can use nixos-anywhere to run off another computer with nix and thus not filling up the NixOS installer tmpfs which is RAM)

- [Disko repository](https://github.com/nix-community/disko)
- [Impermanence repository](https://github.com/nix-community/impermanence)
- [Quickstart Guide: nixos-anywhere](https://github.com/nix-community/nixos-anywhere/blob/main/docs/quickstart.md)
  Allow running nixos-install remotely with disko config
- [OpenZFS - NixOS Root on ZFS](https://openzfs.github.io/openzfs-docs/Getting%20Started/NixOS/Root%20on%20ZFS.html)
- [OpenZFS - NixOS](https://openzfs.github.io/openzfs-docs/Getting%20Started/NixOS)
- [Erase your darlings excelent article](https://grahamc.com/blog/erase-your-darlings/)
- [NixOS: tmpfs as home excelent article](https://elis.nu/blog/2020/06/nixos-tmpfs-as-home/)
- [NixOS Wiki ZFS article](https://nixos.wiki/wiki/ZFS)
- [NixOS Wiki Impermanence article](https://nixos.wiki/wiki/Impermanence)
- [ZFS tuning cheat sheet](https://jrs-s.net/2018/08/17/zfs-tuning-cheat-sheet/)
- [Excelent reddit thread about impermanence setups](https://www.reddit.com/r/NixOS/comments/12teoou/file_system_choice_for_impermanence_setup/)
- [Impermanence hackernews post](https://news.ycombinator.com/item?id=37218289v)
- [Disko SWAP partition bug](https://github.com/nix-community/disko/issues/456)
- [NixOS as a server, part 1: impermanence article](https://guekka.github.io/nixos-server-1/)
- [What impermanence module does?](https://discourse.nixos.org/t/what-does-impermanence-add-over-built-in-functionality)


## Source code examples:
- https://github.com/zmitchell/nixos-configs/blob/main/stacks/zfs_single_drive.nix
- https://github.com/djacu/nixos-config