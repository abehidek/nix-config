local opt = vim.opt
local g = vim.g

-- dofile("/home/abe/.config/nvim/nvim-tree.lua")
-- dofile("/home/abe/.config/nvim/treesitter.lua")
-- Indentation

local telescope = require('telescope')

telescope.setup {
    pickers = {
        find_files = {
            hidden = true
        }
    }
}

opt.smartindent = true
opt.autoindent = true
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true


-- UI theme

opt.termguicolors = true
opt.cursorline = true
opt.number = true

opt.mouse = "a"
g.mapleader = ' '
