{
  description = "hidek.xyz c NixOS ecosystem";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixpkgs.follows = "nixos-cosmic/nixpkgs"; # flex5i de

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
    in
    {
      paths = import ./paths.nix;

      fns = import (outputs.paths.functions "default.nix");

      all = import (outputs.paths.hosts "all.nix");

      all-users = import (outputs.paths.users "all.nix");

      nixosConfigurations = {
        # desktops
        "flex5i" = lib.nixosSystem {
          system = "x86_64-linux";
          modules = [ (outputs.paths.hosts "flex5i") ];
          specialArgs = {
            inherit nixpkgs home-manager nur;
            paths = outputs.paths;
            all = outputs.all;
            all-users = outputs.all-users;
            nix-secrets = inputs.nix-secrets;
            sops-nix = inputs.sops-nix;
            disko = inputs.disko;
            impermanence = inputs.impermanence;
            nixos-cosmic = inputs.nixos-cosmic;
            nix-flatpak = inputs.nix-flatpak;
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
            fns = outputs.fns;
            all = outputs.all;
            disko = inputs.disko;
            impermanence = inputs.impermanence;
            microvm = inputs.microvm;
            nixvirt = inputs.nixvirt;
          };
        };

        ## zeta (206)
        "zeta.mem" = lib.nixosSystem {
          /*
            LXC container in `zeta` host
            running Proxmox hypervisor
          */
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
    };
}
