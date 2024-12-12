{
  # config,
  # lib,
  pkgs,
  nixpkgs,
  all,
  impermanence,
  ...
}:

{
  networking.useNetworkd = true;

  systemd.network = {
    enable = true;

    # declare br0 as net bridge
    netdevs."br0".netdevConfig = {
      Name = "br0";
      Kind = "bridge";
    };

    # bridge lan interface w/ vm interfaces
    networks."10-lan" = {
      networkConfig.Bridge = "br0";
      matchConfig.Name = [
        "enp2s0" # host lan interface
        "vm-*" # pattern for vm interfaces (see vm-test1 tap interface)
      ];
    };

    # assign IP and config for the bridge (routable, IPv6AcceptRA etc.)
    networks."10-lan-bridge" = {
      matchConfig.Name = "br0";
      linkConfig.RequiredForOnline = "routable";
      networkConfig = {
        Gateway = "10.0.0.1";
        DNS = [ "1.1.1.1" ];
        IPv6AcceptRA = true;
        Address = [
          "10.0.0.64/24"
          "2001:db8::a/64"
        ];
      };
    };
  };

  microvm.vms."vm-test3" = {
    # The package set to use for the microvm. This also determines the microvm's architecture.
    # Defaults to the host system's package set if not given.
    # pkgs = import nixpkgs { system = "x86_64-linux"; };
    inherit pkgs;

    # (Optional) A set of special arguments to be passed to the MicroVM's NixOS modules.
    specialArgs = { inherit nixpkgs all impermanence; };

    # The configuration for the MicroVM.
    # Multiple definitions will be merged as expected.
    config = import ./vm-test3.nix;
  };
}
