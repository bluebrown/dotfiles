require("blue.settings")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- configure neovim with lazy
require("lazy").setup({
  dir = vim.fn.stdpath("config") .. "/lua/blue/plugins",
  main = "blue.plugins.main",
  opts = {},
  dependencies = {
    -- theme
    { "catppuccin/nvim" },
    { "nvim-tree/nvim-web-devicons", enabled = true },
    -- treesitter
    { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
    { "nvim-treesitter/nvim-treesitter-textobjects" },
    -- lsp
    { "neovim/nvim-lspconfig" },
    { "williamboman/mason.nvim" },
    { "williamboman/mason-lspconfig.nvim" },
    { "WhoIsSethDaniel/mason-tool-installer.nvim" },
    -- linter
    { "mfussenegger/nvim-lint" },
    -- auto formatter
    { "stevearc/conform.nvim" },
    -- code completion
    { "hrsh7th/nvim-cmp" },
    { "hrsh7th/cmp-path" },
    { "hrsh7th/cmp-nvim-lsp" },
    { "L3MON4D3/LuaSnip", build = "make install_jsregexp" },
    { "saadparwaiz1/cmp_luasnip" },
    { "rafamadriz/friendly-snippets" },
    -- fuzzy finder
    { "nvim-lua/plenary.nvim" },
    { "nvim-telescope/telescope.nvim" },
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    { "nvim-telescope/telescope-ui-select.nvim" },
    -- git integration
    { "lewis6991/gitsigns.nvim" },
    -- file operations
    { "stevearc/oil.nvim" },
    -- AI assistance
    { "github/copilot.vim", enabled = true },
    -- help and hints
    { "folke/neodev.nvim", enabled = false },
    { "folke/which-key.nvim", enabled = false },
  },
})
