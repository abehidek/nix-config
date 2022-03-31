{ config, pkgs, ... }:
{
  imports = [
    ../nvim
  ];
  services = {
    mysql.enable = true;
    mysql.package = pkgs.mysql80;
  };
  #programs.java = { enable = true; package = pkgs.jdk; };
  environment = {
    # variables.JDK_HOME = "${pkgs.jdk}";
    systemPackages = with pkgs; [
      # Tools
      # github-desktop 
      # IDE
      vscode # eclipses.eclipse-java jetbrains.idea-community jetbrains.pycharm-community
      #nodePackages.stylelint
      nodePackages.typescript-language-server
      # Programming Languages and its Package Managers
      # python310
      # nodejs
    ];
  };
  #virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "abe" ];
  home-manager.users.abe = {
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
