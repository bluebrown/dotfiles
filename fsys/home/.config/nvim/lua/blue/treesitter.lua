local M = {}

M.setup = function(...)
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
		textobjects = {
			select = {
				enable = true,
				lookahead = true,
				keymaps = {
					["af"] = "@function.outer",
					["if"] = "@function.inner",
					["ac"] = "@class.outer",
					["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
					["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
				},
				selection_modes = {
					["@parameter.outer"] = "v", -- charwise
					["@function.outer"] = "V", -- linewise
					["@class.outer"] = "<c-v>", -- blockwise
				},
				include_surrounding_whitespace = true,
			},
		},
	})
end

return M
