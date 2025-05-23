{
  description = "hidek.xyz c NixOS ecosystem";

  inputs = {
    # repos
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";

    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    nixpkgs-unstable-cosmic = {
      url = "github:nixos/nixpkgs?ref=nixos-unstable";
      follows = "nixos-cosmic/nixpkgs"; # flex5i de
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur.url = "github:nix-community/NUR";

    # secrets management
    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-secrets = {
      url = "git+ssh://git@github.com/abehidek/nix-secrets.git?ref=main&shallow=1";
      flake = false;
    };

    # system, tools & deployments
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence.url = "github:nix-community/impermanence";

    microvm = {
      url = "github:astro/microvm.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvirt = {
      url = "https://flakehub.com/f/AshleyYakeley/NixVirt/*.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    arion.url = "github:hercules-ci/arion";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    deploy-rs.url = "github:serokell/deploy-rs";

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    nix-rosetta-builder = {
      url = "github:cpick/nix-rosetta-builder";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ## programs, services & desktop
    nixos-cosmic.url = "github:lilyinstarlight/nixos-cosmic";

    zen-browser.url = "github:0xc000022070/zen-browser-flake";

    playit.url = "github:pedorich-n/playit-nixos-module";

    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    # nix-homebrew.url = "git+https://github.com/zhaofengli/nix-homebrew?ref=refs/pull/71/merge";

    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };

    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };

    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      nixpkgs-unstable-cosmic,
      home-manager,
      nur,
      nix-darwin,
      ...
    }@inputs:
    let
      inherit (self) outputs;
      lib = nixpkgs.lib // home-manager.lib;
      supportedSystems = [
        "x86_64-linux"
        "x86_64-darwin"
        "aarch64-linux"
        "aarch64-darwin"
      ];
      forAllSystems = lib.genAttrs supportedSystems;
    in
    {
      paths = import ./paths.nix;

      fns = import (outputs.paths.functions "default.nix");

      old-all = import (outputs.paths.hosts "old-all.nix");

      old-all-users = import (outputs.paths.users "old-all.nix");

      modules = import ./mod;

      nixosConfigurations = {
        # desktops
        "flex5i" = nixpkgs-unstable-cosmic.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [ (outputs.paths.hosts "flex5i/flex5i.nix") ];
          specialArgs = {
            nixpkgs = nixpkgs-unstable-cosmic;
            inherit home-manager nur;
            modules = outputs.modules;
            paths = outputs.paths;
            all-users = outputs.old-all-users;
            nix-secrets = inputs.nix-secrets;
            sops-nix = inputs.sops-nix;
            disko = inputs.disko;
            impermanence = inputs.impermanence;
            nixos-cosmic = inputs.nixos-cosmic;
            zen-browser = inputs.zen-browser;

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
            all = outputs.old-all;
            all-users = outputs.old-all-users;
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
            modules = outputs.modules;
            paths = outputs.paths;
            all = outputs.old-all;
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
            amiya = outputs.vms.microvm."amiya";
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
            modules = outputs.modules;
            paths = outputs.paths;
            nixos-hardware = inputs.nixos-hardware;
            all = outputs.old-all;
            nix-secrets = inputs.nix-secrets;
            sops-nix = inputs.sops-nix;
            impermanence = inputs.impermanence; # impermanence for kaiki vms
            microvm = inputs.microvm;

            suzuki = outputs.vms.microvm."suzuki";
          };
        };

        "roxy" = lib.nixosSystem {
          system = "x86_64-linux";
          modules = [ (outputs.paths.hosts "roxy/roxy.nix") ];
          specialArgs = {
            inherit nixpkgs;
            modules = outputs.modules;
            paths = outputs.paths;
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
            all = outputs.old-all;
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
            all = outputs.old-all;
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
            all = outputs.old-all;
            arion = inputs.arion;
          };
        };

        ## zeta (206)
        "zeta.meeru" = lib.nixosSystem {
          system = "x86_64-linux";
          modules = [ (outputs.paths.hosts "zeta/meeru.nix") ];
          specialArgs = {
            inherit nixpkgs;
            paths = outputs.paths;
            all = outputs.old-all;
            arion = inputs.arion;
          };
        };

        ## zeta (234)
        "zeta.mc" = lib.nixosSystem {
          system = "x86_64-linux";
          modules = [ (outputs.paths.hosts "zeta/mc.nix") ];
          specialArgs = {
            inherit nixpkgs;
            modules = outputs.modules;
            paths = outputs.paths;
            all = outputs.old-all;
            arion = inputs.arion;
            playit = inputs.playit;
          };
        };

        # templates
        "templates.lxc.aoi" = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [ (outputs.paths.templates "lxc/aoi.nix") ];
        };

        "templates.lxc.beta" = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [ (outputs.paths.templates "lxc/beta.nix") ];
        };
      };

      darwinConfigurations."kal'tsit" = nix-darwin.lib.darwinSystem {
        modules = [ (outputs.paths.hosts "kal'tsit/kal'tsit.nix") ];
        specialArgs = {
          inherit home-manager nur;
          nixpkgs = inputs.nixpkgs-unstable;
          modules = outputs.modules;
          paths = outputs.paths;
          nix-secrets = inputs.nix-secrets;
          sops-nix = inputs.sops-nix;
          nix-homebrew = inputs.nix-homebrew;
          homebrew-core = inputs.homebrew-core;
          homebrew-cask = inputs.homebrew-cask;
          homebrew-bundle = inputs.homebrew-bundle;
          nix-rosetta-builder = inputs.nix-rosetta-builder;

          hostName = "kal'tsit";
          rev = self.rev or self.dirtyRev or null;
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
            all-users = outputs.old-all-users;
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
            all-users = outputs.old-all-users;
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
        "meli" = import (outputs.paths.devs "meli.nix") { inherit nixpkgs system; };
      });

      vms = {
        libvirt = {
          "test-ubuntu" = outputs.paths.vms "libvirt/test-ubuntu.nix";
          "opnsense" = outputs.paths.vms "libvirt/opnsense.nix";
        };
        microvm = {
          # kaiki
          "suzuki" = outputs.paths.vms "microvm/suzuki.nix";

          # mokou
          "silence" = outputs.paths.vms "microvm/silence.nix";
          "amiya" = outputs.paths.vms "microvm/amiya.nix";
        };
      };

      deploy.nodes = {
        "flex5i" = {
          hostname = "10.0.0.48";
          sshUser = "abe";
          remoteBuild = true;
          profiles.system = {
            user = "root";
            path = inputs.deploy-rs.lib."x86_64-linux".activate.nixos self.nixosConfigurations."flex5i";
          };
        };
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
          # hostname = "10.0.1.1"; # 1G eth cable
          hostname = "10.0.1.2"; # 2.4Ghz wifi
          sshUser = "abe";
          remoteBuild = false;
          profiles.system = {
            user = "root";
            path = inputs.deploy-rs.lib."aarch64-linux".activate.nixos self.nixosConfigurations."kaiki";
          };
        };
        "roxy" = {
          hostname = "roxy";
          sshUser = "abe";
          remoteBuild = false;
          profiles.system = {
            user = "root";
            path = inputs.deploy-rs.lib."x86_64-linux".activate.nixos self.nixosConfigurations."roxy";
          };
        };

        # zeta
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
        "meeru" = {
          hostname = "10.0.0.210";
          sshUser = "abe";
          remoteBuild = true;
          profiles.system = {
            user = "root";
            path = inputs.deploy-rs.lib."x86_64-linux".activate.nixos self.nixosConfigurations."zeta.meeru";
          };
        };
        "mc" = {
          hostname = "10.0.0.234";
          sshUser = "abe";
          remoteBuild = true;
          profiles.system = {
            user = "root";
            path = inputs.deploy-rs.lib."x86_64-linux".activate.nixos self.nixosConfigurations."zeta.mc";
          };
        };
      };

      checks = builtins.mapAttrs (
        system: deployLib: deployLib.deployChecks self.deploy
      ) inputs.deploy-rs.lib;
    };
}
