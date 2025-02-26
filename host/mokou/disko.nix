{
  disko,
  device,
  zpool_name,
}:

{
  imports = [ disko.nixosModules.disko ];

  # partition table type
  disko.devices.disk.disk1 = {
    inherit device;
    type = "disk";
    content.type = "gpt";
  };

  # partitions and formatting
  disko.devices.disk.disk1.content.partitions = {
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
      size = "8G";
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

  # ZFS pool settings
  disko.devices.zpool.${zpool_name} = {
    type = "zpool";
    mountpoint = null;
    options = {
      ashift = "12";
      autotrim = "on";
    };
    rootFsOptions = {
      compression = "zstd";
      normalization = "formD";
      atime = "off";
      xattr = "sa";
      acltype = "posixacl";
      "com.sun:auto-snapshot" = "false";
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
