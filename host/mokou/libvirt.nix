{
  # config,
  # lib,
  pkgs,
  # modulesPath,
  # nixpkgs,
  # modules,
  # paths,
  # all,
  # disko,
  # impermanence,
  # microvm,
  nixvirt,

  # id-machine,
  # id-disk,
  # name-zpool,

  test-ubuntu,
  opnsense,
  # silence,
  # amiya,
  ...
}:
let
  importDomain = name: domain: import domain { inherit pkgs nixvirt name; };
in
{
  imports = [ nixvirt.nixosModules.default ];

  # setup daemon
  virtualisation.libvirtd = {
    enable = true;
    qemu.package = pkgs.qemu_kvm;
    qemu.runAsRoot = true;
    qemu.ovmf.enable = true;
    qemu.verbatimConfig = ''
      spice_listen = "::1"
    '';
  };

  virtualisation.libvirt = {
    enable = true;
    connections."qemu:///system" = {
      networks = [
        {
          active = false;
          definition = nixvirt.lib.network.writeXML {
            name = "default";
            uuid = "6aec104f-3126-458a-918e-54e2b9e66b18";
            forward.mode = "nat";
            bridge.name = "virbr0";
            mac.address = "52:54:00:1f:7b:b0";
            ip = {
              address = "192.168.122.1";
              netmask = "255.255.255.0";
              dhcp = {
                range = {
                  start = "192.168.122.2";
                  end = "192.168.122.254";
                };
              };
            };
          };
        }
      ];
      pools = [
        {
          active = true;
          definition = nixvirt.lib.pool.writeXML {
            name = "default";
            uuid = "5f67b3f0-148e-4c7d-ae37-fa82e3a44d0c";
            type = "dir";
            target.path = "/var/lib/libvirt/images";
          };
        }
        {
          active = true;
          definition = nixvirt.lib.pool.writeXML {
            name = "iso";
            uuid = "5f67b3f0-148e-4c7d-ae37-fa82e3a44d0d";
            type = "dir";
            target.path = "/var/lib/libvirt/iso";
          };
        }
      ];
      domains = [
        (importDomain "test-ubuntu" test-ubuntu)
        (importDomain "opnsense" opnsense)
      ];
    };
  };
}
