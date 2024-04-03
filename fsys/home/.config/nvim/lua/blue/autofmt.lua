local M = {}

M.setup = function()
	require("conform").setup({
		notify_on_error = false,
		format_on_save = function(bufnr)
			local disable_filetypes = { c = true, cpp = true }
			return {
				timeout_ms = 500,
				lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
			}
		end,
		-- these can be install through mason.
		-- Either pre install from this config,
		-- or adhoc using the MasonInstall commands
		formatters_by_ft = {
			lua = { "stylua" },
			yaml = { "yamlfmt" },
			python = { "isort", "black" },
		},
	})
end

return M
