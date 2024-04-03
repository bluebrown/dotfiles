local function ensure_deps(deps)
	local path = vim.fn.stdpath("data") .. "/site/pack/deps/start/"
	vim.fn.mkdir(path, "p")
	vim.opt.rtp:prepend(path)
	for _, dep in ipairs(deps) do
		local name = dep:match(".*/(.*)")
		local dep_path = path .. name
		if not (vim.uv or vim.loop).fs_stat(dep_path) then
			local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/" .. dep, dep_path })
			vim.notify(out)
		end
	end
end

local deps = {
	-- theme
	"catppuccin/nvim",
	-- infamous the silver searcher
	"github/copilot.vim",
	-- tree sitter
	"nvim-treesitter/nvim-treesitter",
	-- lsp, mason and glue
	"neovim/nvim-lspconfig",
	"williamboman/mason.nvim",
	"williamboman/mason-lspconfig.nvim",
	"WhoIsSethDaniel/mason-tool-installer.nvim",
	-- auto formatting
	"stevearc/conform.nvim",
	-- telescope
	"nvim-lua/plenary.nvim",
	"nvim-telescope/telescope.nvim",
	-- cmp
	"hrsh7th/nvim-cmp",
	"hrsh7th/cmp-path",
	"hrsh7th/cmp-nvim-lsp",
	"L3MON4D3/LuaSnip",
	"saadparwaiz1/cmp_luasnip",
	"rafamadriz/friendly-snippets",
	-- extended motions
	"folke/which-key.nvim",
	"echasnovski/mini.nvim",
	"nvim-treesitter/nvim-treesitter-textobjects",
}

-- uncommented to speed up startup
ensure_deps(deps)

-- set the mapleader before doing anything else.
-- this is important because many plugins use the mapleader
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- go easy on the eyes
require("catppuccin").setup({
	transparent_background = true,
	show_end_of_buffer = true,
	term_colors = true,
})
vim.cmd.colorscheme("catppuccin")
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
vim.api.nvim_set_hl(0, "WinSeparator", { bg = "none" })

-- enable tree sitter
require("nvim-treesitter.configs").setup({
	ensure_installed = { "c", "lua", "vim", "vimdoc", "query" },
	auto_install = true,
	sync_install = false,
	ignore_install = {},
	modules = {},
	highlight = {
		enable = true,
	},
	indent = {
		enable = true,
	},
})

-- configure lsp
local capabilities = vim.lsp.protocol.make_client_capabilities()
if pcall(require, "cmp_nvim_lsp") then
	capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())
end

require("mason").setup()
require("mason-tool-installer").setup({ ensure_installed = { "lua_ls" } })
require("mason-lspconfig").setup({
	handlers = { function(sn) require("lspconfig")[sn].setup({ capabilities = capabilities }) end },
})

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

		local client = vim.lsp.get_client_by_id(ev.data.client_id)

		if client and client.server_capabilities.documentHighlightProvider then
			vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
				buffer = ev.buf,
				callback = vim.lsp.buf.document_highlight,
			})
			vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
				buffer = ev.buf,
				callback = vim.lsp.buf.clear_references,
			})
		end

		local map = function(keys, func, desc)
			vim.keymap.set("n", keys, func, { buffer = ev.buf, desc = "LSP: " .. desc })
		end

		-- create context specific keymaps here
		map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
		map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
		map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
		map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")
		map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
		map("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
		map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
		map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
		map("K", vim.lsp.buf.hover, "Hover Documentation")
		map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
	end,
})

-- configure auto formatting
require("conform").setup({
	notify_on_error = false,
	format_on_save = function(bufnr)
		local disable_filetypes = { c = true, cpp = true }
		return {
			timeout_ms = 500,
			lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
		}
	end,
	-- these are installed by mason, hopefully
	formatters_by_ft = {
		lua = { "stylua" },
		yaml = { "yamlfmt" },
		python = { "isort", "black" },
	},
})

--  telescope
local tlsc = require("telescope")

tlsc.setup({
	pickers = {
		find_files = {
			find_command = { "rg", "--files", "--iglob", "!.git", "--hidden" },
		},
		grep_string = {
			additional_args = { "--hidden" },
		},
		live_grep = {
			additional_args = { "--hidden" },
		},
	},
})

local tlsc_builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>sh", tlsc_builtin.help_tags, { desc = "[S]earch [H]elp" })
vim.keymap.set("n", "<leader>sk", tlsc_builtin.keymaps, { desc = "[S]earch [K]eymaps" })
vim.keymap.set("n", "<leader>sf", tlsc_builtin.find_files, { desc = "[S]earch [F]iles" })
vim.keymap.set("n", "<leader>ss", tlsc_builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
vim.keymap.set("n", "<leader>sw", tlsc_builtin.grep_string, { desc = "[S]earch current [W]ord" })
vim.keymap.set("n", "<leader>sg", tlsc_builtin.live_grep, { desc = "[S]earch by [G]rep" })
vim.keymap.set("n", "<leader>sd", tlsc_builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
vim.keymap.set("n", "<leader>sr", tlsc_builtin.resume, { desc = "[S]earch [R]esume" })
vim.keymap.set("n", "<leader>s.", tlsc_builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
vim.keymap.set("n", "<leader><leader>", tlsc_builtin.buffers, { desc = "[ ] Find existing buffers" })

vim.keymap.set(
	"n",
	"<leader>/",
	function()
		tlsc_builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
			winblend = 10,
			previewer = false,
		}))
	end,
	{ desc = "[/] Fuzzily search in current buffer" }
)

vim.keymap.set(
	"n",
	"<leader>s/",
	function()
		tlsc_builtin.live_grep({
			grep_open_files = true,
			prompt_title = "Live Grep in Open Files",
		})
	end,
	{ desc = "[S]earch [/] in Open Files" }
)

vim.keymap.set(
	"n",
	"<leader>sn",
	function() tlsc_builtin.find_files({ cwd = vim.fn.stdpath("config") }) end,
	{ desc = "[S]earch [N]eovim files" }
)

tlsc.load_extension("kube")
local extensions = require("telescope").extensions
vim.keymap.set("n", "<leader>kc", extensions.kube.use_context, { desc = "[K]ube [C]ontext" })
vim.keymap.set("n", "<leader>kn", extensions.kube.use_namespace, { desc = "[K]ube [N]amespace" })

-- auto completion
require("luasnip.loaders.from_vscode").lazy_load()

local cmp = require("cmp")
local luasnip = require("luasnip")
luasnip.config.setup({})

local cmp_winconf = cmp.config.window.bordered({
	winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
})

cmp.setup({
	window = {
		completion = cmp_winconf,
		documentation = cmp_winconf,
	},
	snippet = {
		expand = function(args) luasnip.lsp_expand(args.body) end,
	},
	completion = { completeopt = "menu,menuone,noinsert" },
	sources = {
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
		{ name = "path" },
	},
	mapping = cmp.mapping.preset.insert({
		["<C-n>"] = cmp.mapping.select_next_item(),
		["<C-p>"] = cmp.mapping.select_prev_item(),
		["<C-b>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-y>"] = cmp.mapping.confirm({ select = true }),
		["<C-Space>"] = cmp.mapping.complete({}),
		["<C-l>"] = cmp.mapping(function()
			if luasnip.expand_or_locally_jumpable() then luasnip.expand_or_jump() end
		end, { "i", "s" }),
		["<C-h>"] = cmp.mapping(function()
			if luasnip.locally_jumpable(-1) then luasnip.jump(-1) end
		end, { "i", "s" }),
	}),
})

-- fin
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes"
vim.opt.cursorline = true

vim.opt.updatetime = 250
vim.opt.timeoutlen = 1000
vim.opt.undofile = true
vim.opt.mouse = "a"
vim.opt.scrolloff = 10

vim.opt.breakindent = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.inccommand = "split"
vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

vim.opt.hlsearch = true
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

vim.cmd([[
     cnoreabbrev W! w!
     cnoreabbrev W1 w!
     cnoreabbrev w1 w!
     cnoreabbrev Q! q!
     cnoreabbrev Q1 q!
     cnoreabbrev q1 q!
     cnoreabbrev Qa! qa!
     cnoreabbrev Qall! qall!
     cnoreabbrev Wa wa
     cnoreabbrev Wq wq
     cnoreabbrev wQ wq
     cnoreabbrev WQ wq
     cnoreabbrev wq1 wq!
     cnoreabbrev Wq1 wq!
     cnoreabbrev wQ1 wq!
     cnoreabbrev WQ1 wq!
     cnoreabbrev W w
     cnoreabbrev Q q
     cnoreabbrev Qa qa
     cnoreabbrev Qall qall
 ]])

vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous [D]iagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next [D]iagnostic message" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic [E]rror messages" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function() vim.highlight.on_yank() end,
})

vim.api.nvim_create_autocmd("InsertEnter", {
	desc = "use absolute number in insert mode",
	group = vim.api.nvim_create_augroup("bluebrown-number-absolute", { clear = true }),
	pattern = "*",
	callback = function() vim.opt.relativenumber = false end,
})

vim.api.nvim_create_autocmd("InsertLeave", {
	desc = "Use relative number in normal mode",
	group = vim.api.nvim_create_augroup("bluebrown-number-relative", { clear = true }),
	pattern = "*",
	callback = function() vim.opt.relativenumber = true end,
})

local winconf = {
	border = "rounded",
	max_width = 80,
}

require("lspconfig.ui.windows").default_options = winconf
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, winconf)
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, winconf)
vim.diagnostic.config({
	virtual_text = false, -- dont show inline message
	signs = true, -- show signs in the sign column
	update_in_insert = false, -- update white typing
	underline = true, -- underline tokens with diagnostics
	severity_sort = true, -- sort by severity
	float = winconf,
})

-- -- extend motions
-- local ai = require("mini.ai")
-- local ts_spec = ai.gen_spec.treesitter
-- ai.setup({
--   n_lines = 500,
--   custom_textobjects = {
--     f = ts_spec({ a = "@function.outer", i = "@function.inner" }, {}),
--     c = ts_spec({ a = "@class.outer", i = "@class.inner" }, {}),
--     o = ts_spec({
--       a = { "@block.outer", "@conditional.outer", "@loop.outer" },
--       i = { "@block.inner", "@conditional.inner", "@loop.inner" },
--     }, {}),
--   }
-- })
--
-- -- make suround behave like tpope's vim-surround
-- require('mini.surround').setup({
--   mappings = {
--     add = 'ys',
--     delete = 'ds',
--     find = '',
--     find_left = '',
--     highlight = '',
--     replace = 'cs',
--     update_n_lines = '',
--
--     -- Add this only if you don't want to use extended mappings
--     suffix_last = '',
--     suffix_next = '',
--   },
--   search_method = 'cover_or_next',
-- })
--
-- -- Remap adding surrounding to Visual mode selection
-- vim.keymap.del('x', 'ys')
-- vim.keymap.set('x', 'S', [[:<C-u>lua MiniSurround.add('visual')<CR>]], { silent = true })
--
-- -- Make special mapping for "add surrounding for line"
-- vim.keymap.set('n', 'yss', 'ys_', { remap = true })
--
-- local wk = require("which-key")
-- wk.setup({})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
