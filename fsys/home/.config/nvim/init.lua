local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- langauge to linter mapping
local linter = {
	markdown = { "markdownlint" },
	yaml = { "yamllint" },
	terraform = { "tflint", "tfsec" },
}

-- langauge to formatter mapping
local formatter = {
	lua = { "stylua" },
	sh = { "shfmt" },
	yaml = { "yamlfmt" },
	go = { "goimports" },
	python = { "isort", "black" },
}

-- list of langauge servers
local server = {
	"lua_ls",
	"bash-language-server",
	"gopls",
	"zls",
	"pyright",
	"terraform-ls",
}

-- list of treesitter parsers
local parser = {
	"lua",
	"vim",
	"vimdoc",
	"markdown",
	"query",
}

-- create a flat list of tools, to pass it to mason
local tools = vim.fn.flatten({
	vim.tbl_values(server),
	vim.tbl_values(linter),
	vim.tbl_values(formatter),
})

-- configure neovim with lazy
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
		require("blue.treesitter").setup({ parsers = parser })
		require("blue.lsp").setup({ tools = tools })
		require("blue.linter").setup({ linters_by_ft = linter })
		require("blue.formatter").setup({ formatters_by_ft = formatter })
		require("blue.completion").setup()

		-- custom functionality
		require("blue.k8s").setup()
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
		"nvim-telescope/telescope-ui-select.nvim",
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
