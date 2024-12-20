{
  # config,
  # lib,
  pkgs,
  # modulesPath,
  nixvirt,
  name,
  ...
}:

{
  active = true;
  definition = nixvirt.lib.domain.writeXML {
    inherit name;
    type = "kvm";
    uuid = "52054974-b2e3-4308-bfd0-94a78f01131b";
    vcpu.count = 2;
    memory.count = 4;
    memory.unit = "GiB";
    memoryBacking.source.type = "memfd";
    memoryBacking.access.mode = "shared";

    os = {
      type = "hvm";
      arch = "x86_64";
      machine = "pc-q35-9.1";

      loader = {
        readonly = true;
        type = "pflash";
        format = "raw";
        path = "/run/libvirt/nix-ovmf/OVMF_CODE.fd";
      };

      boot = [
        { dev = "cdrom"; }
        { dev = "hd"; }
      ];
    };

    features = {
      acpi = { };
      apic = { };
      vmport.state = false;
    };

    cpu.mode = "host-passthrough";

    clock = {
      offset = "utc";
      timer = [
        {
          name = "rtc";
          tickpolicy = "catchup";
        }
        {
          name = "pit";
          tickpolicy = "delay";
        }
        {
          name = "hpet";
          present = false;
        }
      ];
    };

    pm.suspend-to-mem.enabled = false;
    pm.suspend-to-disk.enabled = false;

    devices.emulator = "${pkgs.qemu}/bin/qemu-system-x86_64";

    devices.disk = [
      {
        type = "file";
        device = "disk";
        source.file = "/var/lib/libvirt/images/vm-opnsense-01.qcow2";
        target.dev = "vda";
        target.bus = "virtio";
        driver.name = "qemu";
        driver.type = "qcow2";
      }
      {
        type = "file";
        device = "cdrom";
        readonly = true;
        target.dev = "sda";
        target.bus = "sata";
        driver.name = "qemu";
        driver.type = "raw";
      }
    ];

    devices.channel = [
      {
        type = "unix";
        target = {
          type = "virtio";
          name = "org.qemu.guest_agent.0";
        };
      }
      {
        type = "spicevmc";
        target = {
          type = "virtio";
          name = "com.redhat.spice.0";
        };
      }
    ];

    devices.input = [
      {
        type = "tablet";
        bus = "usb";
      }
      {
        type = "mouse";
        bus = "ps2";
      }
      {
        type = "keyboard";
        bus = "ps2";
      }
    ];

    devices.graphics = {
      type = "spice";
      autoport = true;
      listen.type = "address";
      listen.address = "127.0.0.1";
    };

    devices.sound.model = "ich6";

    devices.audio.id = 1;
    devices.audio.type = "spice";

    devices.video = {
      type = "qxl";
      ram = 65536;
      vram = 65536;
      vgamem = 16384;
      heads = 1;
      primary = true;
    };

    devices.hostdev = [
      {
        mode = "subsystem";
        type = "pci";
        managed = false;
        source.address.bus = 5;
      }
      {
        mode = "subsystem";
        type = "pci";
        managed = false;
        source.address.bus = 4;
      }
    ];

    devices.redirdev = [
      {
        bus = "usb";
        type = "spicevmc";
      }
      {
        bus = "usb";
        type = "spicevmc";
      }
      {
        bus = "usb";
        type = "spicevmc";
      }
      {
        bus = "usb";
        type = "spicevmc";
      }
    ];
  };
}
