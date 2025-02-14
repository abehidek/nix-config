{
  machineId,
  ...
}:

let
  homeFiles = [
    ".screenrc"
    ".config/nushell/history.txt"
  ];
  homeDirectories = [
    # $HOME
    "ProgramasRFB"
    ".var"
    ".mozilla"
    ".vscode"
    ".zen"
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
    "Documents"
    "Downloads"
    "Music"
    "Pictures"
    "Public"
    "Templates"
    "Videos"

    # $XDG_DATA_HOME
    ".local/share/icons"
    ".local/share/direnv"
    ".local/share/waydroid"
    ".local/share/flatpak"
    {
      directory = ".local/share/keyrings";
      mode = "0700";
    }

    # $XDG_STATE_HOME
    ".local/state/lazygit"
    ".local/state/cosmic-comp"
    ".local/state/cosmic"
    ".local/state/pop-launcher"

    # $XDG_CONFIG_HOME
    ".config/sops"
    ".config/cosmic"
    ".config/Code"
    ".config/lazygit"
    ".config/obsidian"
    ".config/discord"
    ".config/Bitwarden"

    # $XDG_CACHE_HOME
    ".cache/starship"
  ];
in
{
  environment.etc.machine-id.text = machineId;

  environment.persistence."/persist" = {
    enable = true;
    hideMounts = true;
    directories = [
      "/etc/nixos"
      "/var/log"
      "/var/lib/sops-nix"
      "/var/lib/bluetooth"
      "/var/lib/nixos"
      "/var/lib/systemd/coredump"
      "/var/lib/waydroid"
      "/var/lib/flatpak"
      "/etc/NetworkManager/system-connections"
      "/etc/mullvad-vpn"
    ];
    files = [
      "/etc/ssh/ssh_host_ed25519_key.pub"
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
      "/etc/ssh/ssh_host_rsa_key"
    ];
    users."naohiro" = {
      directories = homeDirectories;
      files = homeFiles;
    };
    users."nina" = {
      directories = homeDirectories;
      files = homeFiles;
    };
    users."abe" = {
      directories = homeDirectories;
      files = homeFiles;
    };
  };
}
