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
    -- some tools to help neovim beginners
    { "folke/neodev.nvim" },
    { "folke/which-key.nvim" },
    -- theme
    { "catppuccin/nvim" },
    { "lewis6991/gitsigns.nvim" },
    -- AI assistance
    { "github/copilot.vim" },
    -- treesitter
    { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
    { "nvim-treesitter/nvim-treesitter-textobjects" },
    -- lsp
    { "neovim/nvim-lspconfig" },
    { "williamboman/mason.nvim" },
    { "williamboman/mason-lspconfig.nvim" },
    { "WhoIsSethDaniel/mason-tool-installer.nvim" },
    -- autofmt
    { "stevearc/conform.nvim" },
    -- telescope
    { "nvim-lua/plenary.nvim" },
    { "nvim-telescope/telescope.nvim" },
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    { "nvim-telescope/telescope-ui-select.nvim" },
    -- completion
    { "hrsh7th/nvim-cmp" },
    { "hrsh7th/cmp-path" },
    { "hrsh7th/cmp-nvim-lsp" },
    { "L3MON4D3/LuaSnip", build = "make install_jsregexp" },
    { "saadparwaiz1/cmp_luasnip" },
    { "rafamadriz/friendly-snippets" },
    -- linter
    { "mfussenegger/nvim-lint" },
    -- sin
    "nvim-neo-tree/neo-tree.nvim",
    "MunifTanjim/nui.nvim",
  },
})
