local M = {}

M.setup = function()
	require("catppuccin").setup({
		transparent_background = true,
		show_end_of_buffer = true,
		term_colors = true,
	})

	vim.cmd.colorscheme("catppuccin")

	vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
	vim.api.nvim_set_hl(0, "WinSeparator", { bg = "none" })

	local winconf = {
		border = "rounded",
		max_width = 80,
	}

	vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, winconf)
	vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, winconf)
	vim.diagnostic.config({
		virtual_text = false,
		signs = true,
		update_in_insert = false,
		underline = true,
		severity_sort = true,
		float = winconf,
	})

	pcall(require("lspconfig.ui.windows").default_options, winconf)
end

return M
