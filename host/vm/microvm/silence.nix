{
  # config,
  # lib,
  pkgs,
  # modulesPath,
  nixpkgs,
  modules,
  paths,
  all,
  impermanence,
  name,
  id-machine,
  mac,
  ...
}:

{
  imports = [
    (all { inherit pkgs nixpkgs paths; })
    impermanence.nixosModules.impermanence
    modules.vm.microvm.guest
  ];

  hidekxyz.vm.microvm.guest = {
    inherit mac;
    hostName = name;
    hostId = id-machine;
    memSize = 512 * 5;
    imageSize = 1024 * 32;

    persistence.dirs = [
      "/var/lib/docker"
      "/var/lib/postgresql"
    ];
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      5432 # postgresql
      6443 # k3s
    ];
  };

  # services and programs

  services.nginx = {
    enable = true;
    config = ''
      events {}

      stream {
        upstream k3s_servers {
          server 10.0.0.111:6443;
          server 10.0.0.112:6443;
        }

        server {
          listen      6443;
          proxy_pass  k3s_servers;
        }
      }
    '';
  };

  services.postgresql =
    let
      userName = "k3s";
      userPwd = "password";
    in
    {
      enable = true;
      ensureDatabases = [ userName ];
      enableTCPIP = true;
      authentication = pkgs.lib.mkOverride 10 ''
        #...
        #type database DBuser origin-address auth-method
        local all      all     trust
        # ipv4
        host  all      all     127.0.0.1/32   trust
        host  all      all     10.0.0.48/24   trust
        # ipv6
        host all       all     ::1/128        trust
      '';
      initialScript = pkgs.writeText "backend-initScript" ''
        CREATE ROLE ${userName} WITH LOGIN PASSWORD '${userPwd}' CREATEDB;
        CREATE DATABASE ${userName};
        GRANT ALL PRIVILEGES ON DATABASE ${userName} TO ${userName};
        GRANT ALL ON SCHEMA public TO k3s;
      '';
    };

  environment.systemPackages = with pkgs; [
    stress
    htop
    lazygit
    helix
    fastfetch
    hello
    cowsay
  ];

  users.mutableUsers = false;
  users.users."abe" = {
    uid = 1000;
    isNormalUser = true;
    initialPassword = "password";
    extraGroups = [
      "wheel"
      "video"
      "audio"
    ];
  };

  system.stateVersion = "25.05";
}
