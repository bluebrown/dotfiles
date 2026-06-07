-- set leader to space
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- enable history
vim.opt.undofile = true

-- sane splits
vim.opt.splitright = true
vim.opt.splitbelow = true

-- some appearance
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 16
vim.opt.signcolumn = "yes:2"
vim.opt.cursorline = true
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
