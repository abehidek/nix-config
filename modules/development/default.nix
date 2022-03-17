{ config, pkgs, ... }:
{
  imports = [
    ../lunarvim
  ];
  programs.java = { enable = true; package = pkgs.jdk; };
  environment = {
    variables.JDK_HOME = "${pkgs.jdk}";
    systemPackages = with pkgs; [
      # Tools
      onefetch
      github-desktop 
      
      # IDE
      vscode # eclipses.eclipse-java jetbrains.idea-community jetbrains.pycharm-community
      
      # Programming Languages and its Package Managers
      # python310
      # nodejs
    ];
  };
  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "abe" ];
  home-manager.users.abe = {
    programs = {
      direnv.enable = true;
    };
    services.lorri.enable = true;
  };
}