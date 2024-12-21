{
  # config,
  # lib,
  pkgs,
  # modulesPath,
  nixpkgs,
  all,
  impermanence,
  microvm,
  ...
}:

{
  imports = [ microvm.nixosModules.host ];

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

  microvm.vms."test-mvm01" = {
    inherit pkgs;
    config = import ./vm/test-microvm.nix;
    specialArgs = {
      inherit nixpkgs all impermanence;
      name = "test-mvm01";
    };
  };
}
