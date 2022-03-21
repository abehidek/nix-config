{ config, pkgs, ... }:
let
  colorscheme = import ../theme/colorscheme;
  unstable = import (builtins.fetchTarball https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz) { config = config.nixpkgs.config; };
in
{
  home-manager.users.abe = {
    home = {
      file = {
        ".config/nvim/settings.lua".source = ./lua/settings.lua;
        ".config/nvim/nvim-tree.lua".source = ./lua/nvim-tree.lua;
        #".config/nvim/treesitter.lua".source = ./lua/treesitter.lua;
      };
    };
    programs.neovim = {
      enable = true;
      package = unstable.neovim-unwrapped;
      vimAlias = true;
      viAlias = true;

      withNodeJs = true;
      withPython3 = true;
      #withRuby = true;

      extraConfig = ''
        luafile $XDG_CONFIG_HOME/nvim/settings.lua
        colorscheme nord
        let g:airline_theme='base16_nord'
      '';

        # nmap <C-p> :NvimTreeToggle <CR>
        # map ; :
      plugins = with pkgs.vimPlugins; [
        indent-blankline-nvim
        toggleterm-nvim

        # theme
        nord-nvim
        vimade

        # air line
        vim-airline
        vim-airline-clock
        vim-airline-themes

        # nerdtree
        nerdtree
        nerdtree-git-plugin
        
        # git
        lazygit-nvim
        vim-signify

        # utils
        telescope-nvim
        vim-polyglot

        # langs
        vim-elixir
        vim-nix
        vim-javascript
        haskell-vim
        dart-vim-plugin
        rust-vim
      ];
    };
  };
}