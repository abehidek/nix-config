{ config, pkgs, ... }:
let
  colorscheme = import ../theme/colorscheme;
in {
  # imports = [
  #   ../../xdg
  # ];
  environment = {
    systemPackages = with pkgs; [ any-nix-shell ];
  };
  users.defaultUserShell = pkgs.zsh;
  home-manager.users.abe = {
    programs.zsh = {
      enable = true;
      initExtra = ''
        any-nix-shell zsh --info-right | source /dev/stdin
      '';
      enableCompletion = true;
      history = {
        size = 5000;
        path = "$HOME/.local/share/zsh/history";
      };
      oh-my-zsh = {
        enable = true;
        plugins = [ "git" ];
        theme = "robbyrussell";
      };
      zplug = {
        enable = true;
        plugins = [
        { name = "zsh-users/zsh-autosuggestions"; } # Simple plugin installation
        # { name = "romkatv/powerlevel10k"; tags = [ as:theme depth:1 ]; } # Installations with   additional options. For the list of options, please refer to Zplug README.
        ];
      };
      plugins = [
        {
          name = "zsh-nix-shell";
          file = "nix-shell.plugin.zsh";
          src = pkgs.fetchFromGitHub {
            owner = "chisui";
            repo = "zsh-nix-shell";
            rev = "v0.4.0";
            sha256 = "037wz9fqmx0ngcwl9az55fgkipb745rymznxnssr3rx9irb6apzg";
          };
        }
      ];
    };
  };
}