{
  # config,
  # lib,
  pkgs,
  # modulesPath,
  # nixpkgs,
  nixvirt,
  name,
  ...
}:

{
  active = false;
  definition = nixvirt.lib.domain.writeXML {
    inherit name;
    type = "kvm";
    uuid = "bc5bf7c0-8533-4758-8e51-8bc0637fd6a9";
    vcpu.count = 1;
    memory = {
      count = 2;
      unit = "GiB";
    };
    memoryBacking = {
      source.type = "memfd";
      access.mode = "shared";
    };

    os = {
      type = "hvm";
      arch = "x86_64";
      machine = "pc-q35-9.1";

      boot = [
        { dev = "cdrom"; }
        { dev = "hd"; }
      ];
    };

    features = {
      acpi = { };
      apic = { };
    };

    cpu.mode = "host-passthrough";

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

    devices.emulator = "${pkgs.qemu}/bin/qemu-system-x86_64";

    devices.disk = [
      {
        type = "file";
        device = "disk";
        source.file = "/var/lib/libvirt/images/${name}.qcow2";
        target.dev = "vda";
        target.bus = "virtio";
        driver = {
          name = "qemu";
          type = "qcow2";
          discard = "unmap";
        };
      }
      {
        type = "file";
        device = "cdrom";
        readonly = true;
        target.dev = "vdb";
        target.bus = "sata";
        driver.name = "qemu";
      }
    ];

    devices.interface = {
      type = "bridge";
      model.type = "virtio";
      source.bridge = "enp4br0";
      mac.address = "52:54:00:61:7c:64";
    };

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

    devices.sound.model = "ich9";

    devices.audio = {
      id = 1;
      type = "spice";
    };

    devices.video = {
      type = "qxl";
      ram = 65536;
      vram = 65536;
      vgamem = 16384;
      heads = 1;
      primary = true;
    };

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
