{ lib, ... }: {
  boot.initrd.postDeviceCommands = lib.mkAfter ''
    zfs rollback -r rpool/local/root@empty
  '';

  disko.devices = {
    disk = {
      main = {
        device = "/dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_drive-scsi0";
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
              size = "2G";
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
          # checksum = "edonr";
          compression = "lz4";
          # dnodesize = "auto";
          # encryption does not appear to work in vm test; only use on real system
          # encryption = "aes-256-gcm";
          # keyformat = "passphrase";
          # keylocation = "prompt";
          normalization = "formD";
          # relatime = "on";
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
          # "safe/home" = {
          #   type = "zfs_fs";
          #   options.mountpoint = "legacy";
          #   mountpoint = "/home";
          # };
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
