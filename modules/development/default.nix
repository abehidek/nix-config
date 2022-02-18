{ pkgs, ... }:
{
  programs.java = { enable = true; };

  environment.systemPackages = with pkgs; [
    eclipses.eclipse-java 
    virtualbox
  ];

  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "abe" ];
}