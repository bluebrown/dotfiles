local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	dir = vim.fn.stdpath("config") .. "/lua/blue",
	main = "blue.main",
	opts = {},
	dependencies = {
		"github/copilot.vim",
		-- theme
		"catppuccin/nvim",
		-- maps
		"folke/which-key.nvim",
		-- treesitter
		{ "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
		"nvim-treesitter/nvim-treesitter-textobjects",
		-- lsp
		"neovim/nvim-lspconfig",
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		-- autofmt
		"stevearc/conform.nvim",
		-- telescope
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		-- completion
		"hrsh7th/nvim-cmp",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-nvim-lsp",
		{ "L3MON4D3/LuaSnip", build = "make install_jsregexp" },
		"saadparwaiz1/cmp_luasnip",
		"rafamadriz/friendly-snippets",
	},
})
