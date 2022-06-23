local opt = vim.opt
local cmd = vim.cmd

-- local configdir = tostring(os.getenv("XDG_CONFIG_HOME"))
local configdir = "/home/abe/.config"
-- Indentation

local options = {
	backup = false, -- creates a backup file
	clipboard = "unnamedplus", -- allows neovim to access the system clipboard
	cmdheight = 1, -- more space in the neovim command line for displaying messages
	completeopt = { "menuone", "noselect" }, -- mostly just for cmp
	conceallevel = 0, -- so that `` is visible in markdown files
	fileencoding = "utf-8", -- the encoding written to a file
	hlsearch = true, -- highlight all matches on previous search pattern
	ignorecase = true, -- ignore case in search patterns
	mouse = "a", -- allow the mouse to be used in neovim
	pumheight = 10, -- pop up menu height
	showmode = false, -- we don't need to see things like -- INSERT -- anymore
	showtabline = 2, -- always show tabs
	smartcase = true, -- smart case
	smartindent = false, -- make indenting smarter again
	autoindent = true,
	splitbelow = true, -- force all horizontal splits to go below current window
	splitright = true, -- force all vertical splits to go to the right of current window
	swapfile = false, -- creates a swapfile
	termguicolors = true, -- set term gui colors (most terminals support this)
	timeoutlen = 1000, -- time to wait for a mapped sequence to complete (in milliseconds)
	undofile = true, -- enable persistent undo
	updatetime = 300, -- faster completion (4000ms default)
	writebackup = false, -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
	expandtab = true, -- convert tabs to spaces
	shiftwidth = 2, -- the number of spaces inserted for each indentation
	tabstop = 2, -- insert 2 spaces for a tab
	cursorline = true, -- highlight the current line
	number = true, -- set numbered lines
	relativenumber = true, -- set relative numbered lines
	numberwidth = 2, -- set number column width to 2 {default 4}
	signcolumn = "yes", -- always show the sign column, otherwise it would shift the text each time
	-- wrap = true,                            -- display lines as one long line
	scrolloff = 8, -- is one of my fav
	sidescrolloff = 8,
	--guifont = "monospace:h17",               -- the font used in graphical neovim applications
}
vim.opt.shortmess:append("c")

for k, v in pairs(options) do
	vim.opt[k] = v
end

require("colorizer").setup()
dofile(configdir .. "/nvim/keymaps.lua")
dofile(configdir .. "/nvim/whichkey.lua")
dofile(configdir .. "/nvim/git.lua")
dofile(configdir .. "/nvim/plugins/nvim-tree.lua")
dofile(configdir .. "/nvim/plugins/telescope.lua")
dofile(configdir .. "/nvim/plugins/cmp.lua")
dofile(configdir .. "/nvim/plugins/lsp.lua")
dofile(configdir .. "/nvim/plugins/autopairs.lua")
dofile(configdir .. "/nvim/plugins/toggleterm.lua")
dofile(configdir .. "/nvim/plugins/bufferline.lua")
dofile(configdir .. "/nvim/plugins/null-ls.lua")
dofile(configdir .. "/nvim/plugins/treesitter.lua")
dofile(configdir .. "/nvim/plugins/lspsaga.lua")
dofile(configdir .. "/nvim/plugins/lualine.lua")

cmd("autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o")
cmd("autocmd BufEnter * silent! lcd %:p:h")
cmd("set whichwrap+=<,>,[,],h,l")
cmd([[set iskeyword+=-]])
vim.opt.background = "dark"
cmd("colorscheme gruvbox")
cmd("highlight clear SignColumn")
cmd("let g:airline_theme='base16_nord'")
cmd("let g:airline_powerline_fonts = 1")
cmd("set breakindent")
cmd("set formatoptions=l")
cmd("set lbr")
cmd("set hidden")
cmd([[
  set foldlevelstart=99
  set foldmethod=expr
  set foldexpr=nvim_treesitter#foldexpr()
]])
