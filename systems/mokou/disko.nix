{ lib, ... }: {
  boot.initrd.postDeviceCommands = lib.mkAfter ''
    zfs rollback -r rpool/local/root@empty
  '';

  disko.devices = {
    disk = {
      main = {
        device = "/dev/disk/by-id/nvme-nvme.126f-4141303030303030303030303030303030323736-535344203132384742-00000001";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            NIXOS_ESP = {
              type = "EF00";
              size = "512M";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                extraArgs = [ "-n NIXOS_ESP" ];
              };
            };
            NIXOS_SWAP = {
              size = "4G";
              type = "8200";
              content = {
                type = "swap";
                resumeDevice = true; # resume from hiberation from this device
              };
            };
            NIXOS_ROOT = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "rpool";
              };
            };
          };
        };
      };
    };

    zpool = {
      rpool = {
        type = "zpool";
        rootFsOptions = {
          acltype = "posixacl";
          canmount = "off";
          compression = "lz4";
          normalization = "formD";
          atime = "off";
          xattr = "sa";
        };
        mountpoint = null;
        options = {
          ashift = "12";
          autotrim = "on";
        };

        datasets = {
          local = {
            type = "zfs_fs";
            options.canmount = "off";
          };

          safe = {
            type = "zfs_fs";
            options.canmount = "off";
          };

          "local/root" = {
            type = "zfs_fs";
            options = {
              mountpoint = "legacy";
            };
            mountpoint = "/";
            postCreateHook = "zfs snapshot rpool/local/root@empty";
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
    };
  };
}
