{ pkgs, ... }:
{
  programs.java = { enable = true; package = pkgs.jdk; };
  environment = {
    variables.JDK_HOME = "${pkgs.jdk}";
    systemPackages = with pkgs; [
      # eclipses.eclipse-java 
      # jetbrains.idea-community
      #python39Full
      #python39Packages.pillow
      # nodejs
      # jetbrains.pycharm-community
    ];
  };
  home-manager.users.abe = {
    programs = {
      direnv.enable = true;
      direnv.nix-direnv.enable = true;
    };
  };
  nix.extraOptions = ''
    keep-outputs = true
    keep-derivations = true
  '';

  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "abe" ];
}