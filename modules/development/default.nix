{ config, pkgs, ... }:
let 
  unstable = import (fetchTarball https://nixos.org/channels/nixos-unstable/nixexprs.tar.xz) { config.allowUnfree = true; };
in
{
  services = {
    mysql.enable = true;
    mysql.package = pkgs.mysql80;
  };
  #virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "abe" ];
  home-manager.users.abe = {
    imports = [
      ../nvim
    ];
    home = {
      packages = with unstable; [
        vscode # eclipses.eclipse-java jetbrains.idea-community jetbrains.pycharm-community
      ];
    };
    programs = {
      direnv.enable = true;
      git = {
        enable = true;
        userName = "abehidek";
        userEmail = "hidek.abe@outlook.com";
        extraConfig = {
            init = { defaultBranch = "main"; };
        };
      };
      gh = {
        enable = true;
      };
      gpg = {
        enable = true;
      };
    };
    services.lorri.enable = true;
  };
}

