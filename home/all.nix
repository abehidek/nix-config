{
  pkgs,
  userName,
  stateVersion,
  ...
}:

{
  home = {
    username = userName;
    stateVersion = stateVersion;
    homeDirectory = if pkgs.stdenv.isDarwin then "/Users/${userName}" else "/home/${userName}";

    packages = with pkgs; [ home-manager ];
  };
}
