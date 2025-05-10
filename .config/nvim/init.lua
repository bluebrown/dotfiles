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

local path_package = vim.fn.stdpath("data") .. "/site/"
local mini_path = path_package .. "pack/deps/start/mini.nvim"
if not vim.loop.fs_stat(mini_path) then
  vim.cmd("echo \"Installing `mini.nvim`\" | redraw")
  local clone_cmd = {
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/echasnovski/mini.nvim",
    mini_path,
  }
  vim.fn.system(clone_cmd)
  vim.cmd("packadd mini.nvim | helptags ALL")
  vim.cmd("echo \"Installed `mini.nvim`\" | redraw")
end

require("mini.deps").setup({
  path = {
    snapshot = vim.fn.stdpath("config") .. "/.minideps.lua",
    package = path_package,
  },
})

require("packages")
