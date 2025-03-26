{
  # config,
  # lib,
  # pkgs,
  # modulesPath,
  # nixpkgs,
  # modules,
  # paths,
  # all,
  # disko,
  impermanence,
  # microvm,
  # nixvirt,

  id-machine,
  # id-disk,
  # name-zpool,

  # test-ubuntu,
  # opnsense,
  # silence,
  # amiya,
  ...
}:

{
  imports = [ impermanence.nixosModules.impermanence ];

  # required for impermanence to work
  fileSystems."/persist".neededForBoot = true;
  environment.etc.machine-id.text = id-machine;

  environment.persistence."/persist" = {
    enable = true;
    hideMounts = true;
    directories = [
      "/etc/nixos"
      "/var/log"
      "/var/lib/sops-nix"
      "/var/lib/nixos"
      "/var/lib/systemd/coredump"
      "/etc/NetworkManager/system-connections"
      "/var/lib/libvirt"

      # deprecated
      "/var/lib/microvms/irene-01/persist"

      "/var/lib/microvms/silence-01/persist"
      "/var/lib/microvms/amiya-01/persist"
      "/var/lib/microvms/amiya-02/persist"
    ];
    files = [
      "/etc/ssh/ssh_host_ed25519_key.pub"
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
      "/etc/ssh/ssh_host_rsa_key"
    ];
  };

  environment.persistence."/persist".users."abe" = {
    directories = [
      # $HOME
      {
        directory = ".gnupg";
        mode = "0700";
      }
      {
        directory = ".ssh";
        mode = "0700";
      }
      {
        directory = ".nixops";
        mode = "0700";
      }

      # xdg-user-dirs
      "Desktop"

      # $XDG_DATA_HOME
      {
        directory = ".local/share/keyrings";
        mode = "0700";
      }

      # $XDG_STATE_HOME
      ".local/state/lazygit"

      # $XDG_CONFIG_HOME
      ".config/sops"
      ".config/lazygit"
    ];
  };
}
