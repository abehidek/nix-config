{
  # config,
  # lib,
  # pkgs,
  # modulesPath,
  # nixpkgs,
  # home-manager,
  # nur,
  # modules,
  # paths,
  # all,
  # all-users,
  # nix-secrets,
  # sops-nix,
  disko,
  # impermanence,
  # nixos-cosmic,
  # nix-flatpak,

  # id-machine,
  id-disk,
  name-zpool,
  ...
}:

# Do not modify this file!, disko doesn't support fs changes and this file only runs once (when formatting disk)
{
  imports = [ disko.nixosModules.disko ];

  disko.devices.disk.disk1 = {
    device = id-disk;
    type = "disk";
    content.type = "gpt";
    content.partitions = {
      ESP = {
        size = "512M";
        type = "EF00";
        content = {
          type = "filesystem";
          format = "vfat";
          mountpoint = "/boot";
          mountOptions = [ "umask=0077" ];
        };
      };
      swap = {
        size = "4G";
        type = "8200";
        content = {
          type = "swap";
          resumeDevice = true; # resume from hiberation from this device
        };
      };
      zfs = {
        size = "100%";
        content = {
          type = "zfs";
          pool = name-zpool;
        };
      };
    };
  };

  disko.devices.zpool.${name-zpool} = {
    type = "zpool";
    mountpoint = null;
    rootFsOptions = {
      compression = "zstd";
      normalization = "formD";
      atime = "off";
      xattr = "sa";
      acltype = "posixacl";
      "com.sun:auto-snapshot" = "false";
    };
    options = {
      ashift = "12";
      autotrim = "on";
    };

    datasets."local" = {
      type = "zfs_fs";
      options.canmount = "off";
    };

    datasets."safe" = {
      type = "zfs_fs";
      options.canmount = "off";
    };

    datasets = {
      "local/root" = {
        type = "zfs_fs";
        options.mountpoint = "legacy";
        mountpoint = "/";

        postCreateHook = "zfs snapshot ${name-zpool}/local/root@empty";
      };
      "local/nix" = {
        type = "zfs_fs";
        options.mountpoint = "legacy";
        mountpoint = "/nix";
      };
      "safe/persist" = {
        type = "zfs_fs";
        options.mountpoint = "legacy";
        mountpoint = "/persist";
      };
    };
  };
}
