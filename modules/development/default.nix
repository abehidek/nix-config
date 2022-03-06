{ pkgs, ... }:
{
  programs.java = { enable = true; package = pkgs.jdk; };
  environment = {
    variables.JDK_HOME = "${pkgs.jdk}";
    systemPackages = with pkgs; [
      # eclipses.eclipse-java 
      jetbrains.idea-community
      pythonFull
      nodejs
      # jetbrains.pycharm-community
    ];
  };

  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "abe" ];
}