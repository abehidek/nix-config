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

  microvm.vms."test-mvm01" = {
    inherit pkgs;
    config = import ./vm/test-microvm.nix;
    specialArgs = {
      inherit nixpkgs all impermanence;
      name = "test-mvm01";
    };
  };

  microvm.vms."apps" = {
    inherit pkgs;
    config = import ./vm/apps.nix;
    specialArgs = {
      inherit nixpkgs all impermanence;
      name = "apps";
    };
  };

  # k3s postgresql and nginx
  microvm.vms."irene-01" = {
    inherit pkgs;
    config = import ./vm/k3s/irene-01.nix;
    specialArgs = {
      inherit nixpkgs all impermanence;
      name = "irene-01";
    };
  };

  # k3s worker
  microvm.vms."ray-01" = {
    inherit pkgs;
    config = import ./vm/k3s/ray.nix;
    specialArgs = {
      inherit nixpkgs all impermanence;
      name = "ray-01";
      machineId = "9fcd46289ccf4ad0b16a048223c6ba2d";
      macAddress = "b8:ae:cc:cf:71:c0";
    };
  };

  microvm.vms."ray-02" = {
    inherit pkgs;
    config = import ./vm/k3s/ray.nix;
    specialArgs = {
      inherit nixpkgs all impermanence;
      name = "ray-02";
      machineId = "a72f6995c69f4408a926493563bb3930";
      macAddress = "b8:ae:cc:cf:71:c1";
    };
  };

  microvm.vms."ray-03" = {
    inherit pkgs;
    config = import ./vm/k3s/ray.nix;
    specialArgs = {
      inherit nixpkgs all impermanence;
      name = "ray-03";
      machineId = "f9d3269bd6d942c7bd1c810e468141ed";
      macAddress = "ea:c7:19:bd:65:cc";
    };
  };

  # k3s server
  microvm.vms."sebas-01" = {
    inherit pkgs;
    config = import ./vm/k3s/sebas-01.nix;
    specialArgs = {
      inherit nixpkgs all impermanence;
      name = "sebas-01";
    };
  };

  microvm.vms."sebas-02" = {
    inherit pkgs;
    config = import ./vm/k3s/sebas-02.nix;
    specialArgs = {
      inherit nixpkgs all impermanence;
      name = "sebas-02";
    };
  };
}
