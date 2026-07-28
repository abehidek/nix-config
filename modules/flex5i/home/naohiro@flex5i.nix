{ inputs, self, ... }:

{
  flake.modules.homeManager."naohiro@flex5i" =
    { pkgs, ... }:
    let
      userName = "naohiro";
    in
    {
      imports = [
        inputs.sops-nix.homeManagerModules.sops
      ];

      home = {
        username = userName;
        stateVersion = "24.11";
        homeDirectory = if pkgs.stdenv.isDarwin then "/Users/${userName}" else "/home/${userName}";

        packages = with pkgs; [
          ani-cli
          home-manager
          hello
        ];
      };

      home.sessionVariables = {
        LANG = "pt_BR.UTF_8";
      };
    };
}
