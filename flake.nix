{
  description = "hidek.xyz c NixOS ecosystem";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixpkgs.follows = "nixos-cosmic/nixpkgs"; # flex5i de

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nur.url = "github:nix-community/NUR";

    # secrets
    sops-nix.url = "github:mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    nix-secrets = {
      url = "git+ssh://git@github.com/abehidek/nix-secrets.git?ref=main&shallow=1";
      flake = false;
    };

    # misc
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    nixos-cosmic.url = "github:lilyinstarlight/nixos-cosmic";
    nix-flatpak.url = "github:gmodena/nix-flatpak";

    impermanence.url = "github:nix-community/impermanence";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    microvm.url = "github:astro/microvm.nix";
    microvm.inputs.nixpkgs.follows = "nixpkgs";

    nixvirt.url = "https://flakehub.com/f/AshleyYakeley/NixVirt/*.tar.gz";
    nixvirt.inputs.nixpkgs.follows = "nixpkgs";

    arion.url = "github:hercules-ci/arion";

    deploy-rs.url = "github:serokell/deploy-rs";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nur,
      ...
    }@inputs:
    let
      inherit (self) outputs;
      lib = nixpkgs.lib // home-manager.lib;
      supportedSystems = [ "x86_64-linux" ];
      forAllSystems = lib.genAttrs supportedSystems;
    in
    {
      paths = import ./paths.nix;

      fns = import (outputs.paths.functions "default.nix");

      all = import (outputs.paths.hosts "all.nix");

      all-users = import (outputs.paths.users "all.nix");

      modules.host = import ./mod;

      nixosConfigurations = {
        # desktops
        "flex5i" = lib.nixosSystem {
          system = "x86_64-linux";
          modules = [ (outputs.paths.hosts "flex5i") ];
          specialArgs = {
            inherit nixpkgs home-manager nur;
            modules = outputs.modules;
            paths = outputs.paths;
            all = outputs.all;
            all-users = outputs.all-users;
            nix-secrets = inputs.nix-secrets;
            sops-nix = inputs.sops-nix;
            disko = inputs.disko;
            impermanence = inputs.impermanence;
            nixos-cosmic = inputs.nixos-cosmic;
            nix-flatpak = inputs.nix-flatpak;

            id-machine = "0c9ff5c1b06f402f8095327b7633e332";
            id-disk = "/dev/disk/by-id/nvme-SSSTC_CL1-4D256_SS1C86490L2BR17P6972";
            name-zpool = "zroot";
          };
        };

        "wsl-t16" = lib.nixosSystem {
          system = "x86_64-linux";
          modules = [ (outputs.paths.hosts "wsl-t16") ];
          specialArgs = {
            inherit nixpkgs home-manager;
            paths = outputs.paths;
            all = outputs.all;
            all-users = outputs.all-users;
            nix-secrets = inputs.nix-secrets;
            sops-nix = inputs.sops-nix;
            nixos-wsl = inputs.nixos-wsl;
          };
        };

        # servers
        "mokou" = lib.nixosSystem {
          /*
            2nd home server
            intent to use for services without
            data integrity needs (non-important data e.g.)
          */
          system = "x86_64-linux";
          modules = [ (outputs.paths.hosts "mokou") ];
          specialArgs = {
            inherit nixpkgs;
            paths = outputs.paths;
            all = outputs.all;
            disko = inputs.disko;
            impermanence = inputs.impermanence;
            microvm = inputs.microvm;
            nixvirt = inputs.nixvirt;

            id-machine = "e8ccbf623edf4dd6aa83732a65ce08cb";
            id-disk = "/dev/disk/by-id/nvme-SSD_128GB_AA000000000000000276";
            name-zpool = "mroot";

            test-ubuntu = outputs.vms.libvirt."test-ubuntu";
            opnsense = outputs.vms.libvirt."opnsense";
            silence = outputs.vms.microvm."silence";
          };
        };

        "kaiki" = lib.nixosSystem {
          /*
            3rd home server (lab)
            used for quickly experimentation without messing
            with other working services
          */
          system = "aarch64-linux";
          modules = [ (outputs.paths.hosts "kaiki/kaiki.nix") ];
          specialArgs = {
            inherit nixpkgs;
            paths = outputs.paths;
            nixos-hardware = inputs.nixos-hardware;
            all = outputs.all;
            nix-secrets = inputs.nix-secrets;
            sops-nix = inputs.sops-nix;
            impermanence = inputs.impermanence; # impermanence for kaiki vms
            microvm = inputs.microvm;

            suzuki = outputs.vms.microvm."suzuki";
          };
        };

        /*
          LXC containers in `zeta` host
          running Proxmox hypervisor
        */

        ## zeta (200)
        "zeta.net" = lib.nixosSystem {
          system = "x86_64-linux";
          modules = [ (outputs.paths.hosts "zeta/net.nix") ];
          specialArgs = {
            inherit nixpkgs;
            paths = outputs.paths;
            all = outputs.all;
            arion = inputs.arion;
          };
        };

        ## zeta (205)
        "zeta.fin" = lib.nixosSystem {
          system = "x86_64-linux";
          modules = [ (outputs.paths.hosts "zeta/fin.nix") ];
          specialArgs = {
            inherit nixpkgs;
            paths = outputs.paths;
            all = outputs.all;
            arion = inputs.arion;
          };
        };

        ## zeta (206)
        "zeta.mem" = lib.nixosSystem {
          system = "x86_64-linux";
          modules = [ (outputs.paths.hosts "zeta/mem.nix") ];
          specialArgs = {
            inherit nixpkgs;
            paths = outputs.paths;
            all = outputs.all;
            arion = inputs.arion;
          };
        };
      };

      homeConfigurations = {
        "abe@flex5i" = lib.homeManagerConfiguration {
          modules = [ (outputs.paths.users "abe/flex5i.nix") ];
          pkgs = import nixpkgs {
            system = "x86_64-linux";
            config.allowUnfree = true;
          };
          extraSpecialArgs = {
            paths = outputs.paths;
            all-users = outputs.all-users;
            nix-secrets = inputs.nix-secrets;
            sops-nix = inputs.sops-nix;
          };
        };

        "abe@wsl-t16" = lib.homeManagerConfiguration {
          modules = [ (outputs.paths.users "abe/wsl-t16.nix") ];
          pkgs = import nixpkgs {
            system = "x86_64-linux";
            config.allowUnfree = true;
          };
          extraSpecialArgs = {
            paths = outputs.paths;
            all-users = outputs.all-users;
            nix-secrets = inputs.nix-secrets;
            sops-nix = inputs.sops-nix;
          };
        };
      };

      packages = forAllSystems (system: {
        "kaiki-image-sd-card" = outputs.nixosConfigurations."kaiki".config.system.build.sdImage;
      });

      devShells = forAllSystems (system: {
        "k3s" = import (outputs.paths.devs "k3s.nix") { inherit nixpkgs system; };
      });

      vms = {
        libvirt = {
          "test-ubuntu" = outputs.paths.vms "libvirt/test-ubuntu.nix";
          "opnsense" = outputs.paths.vms "libvirt/opnsense.nix";
        };
        microvm = {
          "irene" = outputs.paths.vms "microvm/irene.nix";
          "ray" = outputs.paths.vms "microvm/ray.nix";
          "sebas" = outputs.paths.vms "microvm/sebas.nix";
          "suzuki" = outputs.paths.vms "microvm/suzuki.nix";
          "silence" = outputs.paths.vms "microvm/silence.nix";
        };
      };

      deploy.nodes = {
        "mokou" = {
          hostname = "10.0.0.100";
          sshUser = "abe";
          remoteBuild = true;
          profiles.system = {
            user = "root";
            path = inputs.deploy-rs.lib."x86_64-linux".activate.nixos self.nixosConfigurations."mokou";
          };
        };
        "kaiki" = {
          hostname = "10.0.1.1"; # 1G eth cable
          # hostname = "10.0.1.2"; # 2.4Ghz wifi
          sshUser = "abe";
          remoteBuild = true;
          profiles.system = {
            user = "root";
            path = inputs.deploy-rs.lib."aarch64-linux".activate.nixos self.nixosConfigurations."kaiki";
          };
        };
        "net" = {
          hostname = "10.0.0.200";
          sshUser = "abe";
          remoteBuild = true;
          profiles.system = {
            user = "root";
            path = inputs.deploy-rs.lib."x86_64-linux".activate.nixos self.nixosConfigurations."zeta.net";
          };
        };
        "fin" = {
          hostname = "10.0.0.205";
          sshUser = "abe";
          remoteBuild = true;
          profiles.system = {
            user = "root";
            path = inputs.deploy-rs.lib."x86_64-linux".activate.nixos self.nixosConfigurations."zeta.fin";
          };
        };
        "mem" = {
          hostname = "10.0.0.206";
          sshUser = "abe";
          remoteBuild = true;
          profiles.system = {
            user = "root";
            path = inputs.deploy-rs.lib."x86_64-linux".activate.nixos self.nixosConfigurations."zeta.mem";
          };
        };
      };

      checks = builtins.mapAttrs (
        system: deployLib: deployLib.deployChecks self.deploy
      ) inputs.deploy-rs.lib;
    };
}
