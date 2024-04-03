local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- global settings to control the plugins,
-- in a central place

local langage_servers = {
	"lua_ls",
	"bashls",
	"gopls",
	"zls",
	"pyright",
}

local linters_by_ft = {
	markdown = { "markdownlint" },
	yaml = { "yamllint" },
}

local formatters_by_ft = {
	lua = { "stylua" },
	sh = { "shfmt" },
	yaml = { "yamlfmt" },
	go = { "goimports" },
	python = { "isort", "black" },
}

-- configure neovim with lazy

local tools = vim.fn.flatten({
	vim.tbl_values(langage_servers),
	vim.tbl_values(linters_by_ft),
	vim.tbl_values(formatters_by_ft),
})

require("lazy").setup({
	dir = vim.fn.stdpath("config") .. "/lua/blue",
	config = function()
		-- the native settings should come first
		-- so other plugins can use the values
		require("blue.settings").setup()

		-- the theme is loaded right after the settings
		-- in hope to avoid flickering
		require("blue.theme").setup()

		-- these are some plugins for beginners.
		-- for example which-key to help with keybindings
		require("blue.noob").setup()

		-- these plugins turn neovim into an IDE
		require("blue.finder").setup()
		require("blue.treesitter").setup()
		require("blue.lsp").setup({ tools = tools })
		require("blue.linter").setup({ linters_by_ft = linters_by_ft })
		require("blue.formatter").setup({ formatters_by_ft = formatters_by_ft })
		require("blue.completion").setup()
	end,
	dependencies = {
		-- some tools to help neovim beginners
		"folke/neodev.nvim",
		"folke/which-key.nvim",
		-- theme
		"catppuccin/nvim",
		-- AI assistance
		"github/copilot.vim",
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
		-- linter
		"mfussenegger/nvim-lint",
	},
})
