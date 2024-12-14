{
  machineId,
  ...
}:

{
  environment.etc.machine-id.text = machineId;

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
      "/var/lib/microvms/vm-test3/persist"
      "/var/lib/libvirt"
    ];
    files = [
      "/etc/ssh/ssh_host_ed25519_key.pub"
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
      "/etc/ssh/ssh_host_rsa_key"
    ];
  };

  environment.persistence."/persist".users.abe = {
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
