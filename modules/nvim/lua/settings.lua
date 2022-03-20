local opt = vim.opt
local g = vim.g

dofile("/home/abe/.config/nvim/nvim-tree.lua")
-- dofile("/home/abe/.config/nvim/treesitter.lua")

g.mapleader = ' '

-- Indentation
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