{ ... }: {
  disko.devices = {
    disk = {
      main = {
        device = "/dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_drive-scsi0";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            NIXOS_BOOT = {
              type = "EF00";
              size = "512M";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                extraArgs = [ "-n NIXOS_BOOT" ];
              };
            };
            NIXOS_ROOT = {
              end = "-4GB";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
                extraArgs = [ "-L NIXOS_ROOT" ];
              };
            };

            NIXOS_SWAP = {
              size = "100%";
              content = {
                type = "swap";
                randomEncryption = true;
                resumeDevice = true;  # resume from hiberation from this device
                # extraArgs = [ "-L NIXOS_SWAP" ];
              };
            };
          };
        };
      };
    };
  };
}
