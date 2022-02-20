{ pkgs, ... }:
{
  programs.java = { enable = true; package = pkgs.jdk; };
  environment = {
    # variables.JAVA_HOME = "/lib/java";
    systemPackages = with pkgs; [
      eclipses.eclipse-java 
      # jetbrains.idea-community
      # jdk
    ];
  };

  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "abe" ];
}