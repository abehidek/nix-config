{ lib, config, pkgs, unstable, ... }:

let colorscheme = import ../../themes/colorscheme;
in {
  home = {
    file = {
      ".config/nvim/settings.lua".source = ./lua/settings.lua;
      ".config/nvim/keymaps.lua".source = ./lua/keymaps.lua;
      ".config/nvim/whichkey.lua".source = ./lua/whichkey.lua;
      ".config/nvim/plugins/nvim-tree.lua".source = ./lua/plugins/nvim-tree.lua;
      ".config/nvim/plugins/telescope.lua".source = ./lua/plugins/telescope.lua;
      ".config/nvim/plugins/cmp.lua".source = ./lua/plugins/cmp.lua;
      ".config/nvim/plugins/lsp.lua".source = ./lua/plugins/lsp.lua;
      ".config/nvim/plugins/autopairs.lua".source = ./lua/plugins/autopairs.lua;
      ".config/nvim/plugins/toggleterm.lua".source =
        ./lua/plugins/toggleterm.lua;
      ".config/nvim/plugins/bufferline.lua".source =
        ./lua/plugins/bufferline.lua;
      ".config/nvim/plugins/null-ls.lua".source = ./lua/plugins/null-ls.lua;
      ".config/nvim/plugins/treesitter.lua".source =
        ./lua/plugins/treesitter.lua;
      ".config/nvim/plugins/lspsaga.lua".source = ./lua/plugins/lspsaga.lua;
      ".config/nvim/git.lua".source = ./lua/git.lua;
    };
    sessionVariables = { JAVALSP = "${unstable.java-language-server}"; };
    packages = with unstable; [
      sshfs
      # neovim-remote
      # -- Language Servers for Neovim
      ripgrep # To make telescope live_grep work properly
      sumneko-lua-language-server
      # rust-analyzer
      rnix-lsp
      # haskell-language-server
      java-language-server
      nodePackages.pyright
      nodePackages.live-server
      nodePackages.svelte-language-server
      nodePackages.typescript-language-server
      nodePackages.vscode-css-languageserver-bin
      nodePackages.vscode-html-languageserver-bin
      # nodePackages.typescript-language-server
      # nodePackages.typescript
      # nodePackages.vue-language-server
      clang # For compiling treesitter languages
      python39Packages.flake8
      # -- Code formatters
      stylua
      nodePackages.prettier
      nodePackages.eslint
      black
      nixfmt
      shellcheck
      shellharden
      # nodePackages.eslint_d
    ];
  };
  programs.neovim = {
    enable = true;
    package = unstable.neovim-unwrapped;
    plugins = with unstable.vimPlugins; [
      # -- theme and appearance
      indent-blankline-nvim
      nord-nvim
      vimade
      vim-startify
      # vim-airline
      # vim-airline-themes
      # -- utils
      vim-rooter
      markdown-preview-nvim
      direnv-vim
      toggleterm-nvim
      nvim-autopairs
      nvim-colorizer-lua
      which-key-nvim
      # -- telescope
      telescope-nvim
      # -- buffers
      bufferline-nvim
      vim-bbye
      # -- tree
      nvim-tree-lua
      nvim-web-devicons
      # --git
      gitsigns-nvim
      vim-fugitive
      # -- language support
      # -- formatting
      null-ls-nvim
      # -- cmp and lsp
      nvim-cmp
      cmp-buffer
      cmp-path
      cmp-cmdline
      cmp_luasnip
      # vim-lsc
      nvim-lspconfig
      cmp-nvim-lsp
      lspsaga-nvim
      # -- snippets
      luasnip
      friendly-snippets
      # -- highlighting
      (unstable.vimPlugins.nvim-treesitter.withPlugins
        (plugins: unstable.tree-sitter.allGrammars))
      # -- languages
      # vim-elixir
      vim-nix
      vim-javascript
      vim-jsx-pretty
      vim-jsx-typescript
      # haskell-vim
      # rust-vim
    ];
    extraConfig = ''
      luafile $XDG_CONFIG_HOME/nvim/settings.lua
    '';
  };
}
