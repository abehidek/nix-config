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
        ".config/nvim/keymaps.lua".source = ./lua/keymaps.lua;

        ".config/nvim/plugins/nvim-tree.lua".source = ./lua/plugins/nvim-tree.lua;
        ".config/nvim/plugins/telescope.lua".source = ./lua/plugins/telescope.lua;
        #".config/nvim/treesitter.lua".source = ./lua/treesitter.lua;
      };
    };
    programs.neovim = {
      enable = true;
      package = unstable.neovim-unwrapped;
      vimAlias = true;
      viAlias = true;
      withRuby = true;
      withNodeJs = true;
      withPython3 = true;
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

        # Tree
        # nerdtree
        # nerdtree-git-plugin
        nvim-tree-lua
        
        # git
        lazygit-nvim
        vim-signify

        # utils
        telescope-nvim
        vim-polyglot
        markdown-preview-nvim

        # langs
        vim-elixir
        vim-nix
        vim-javascript
        haskell-vim
        dart-vim-plugin
        vim-flutter
        rust-vim
      ];
      extraConfig = ''
        luafile $XDG_CONFIG_HOME/nvim/settings.lua
      '';
    };
  };
}