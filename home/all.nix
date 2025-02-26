{
  pkgs,
  userName,
  stateVersion,
  ...
}:

{
  home = {
    username = userName;
    homeDirectory = "/home/${userName}";
    stateVersion = stateVersion;

    packages = with pkgs; [
      home-manager
    ];
  };
}
