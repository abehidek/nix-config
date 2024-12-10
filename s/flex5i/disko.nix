{
  device,
  zpool_name,
}:

{
  disko.devices.disk.disk1 = {
    inherit device;
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
          pool = zpool_name;
        };
      };
    };
  };

  disko.devices.zpool.${zpool_name} = {
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

        postCreateHook = "zfs snapshot ${zpool_name}/local/root@empty";
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
