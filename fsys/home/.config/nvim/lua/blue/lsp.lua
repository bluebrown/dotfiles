local M = {}

M.setup = function(opts)
	local capabilities = vim.lsp.protocol.make_client_capabilities()
	if pcall(require, "cmp_nvim_lsp") then
		capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())
	end

	require("mason").setup()

	require("mason-tool-installer").setup({ ensure_installed = opts.tools or {} })

	-- configure the language servers dynamically, as we encounter them in this handler
	require("mason-lspconfig").setup({
		handlers = {
			function(sn)
				local conf = opts.lsp[sn] or {}
				-- extend the extra capabilities from the options with the ones from neovim and cmp
				conf.capabilities = vim.tbl_deep_extend("force", {}, capabilities, conf.capabilities or {})
				require("lspconfig")[sn].setup(conf)
			end,
		},
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

			if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
				-- TODO: implement inlay hints
			end

			local map = function(keys, func, desc)
				vim.keymap.set("n", keys, func, { buffer = ev.buf, desc = "LSP: " .. desc })
			end

			-- create context specific keymaps here
			map("K", function() _ = vim.diagnostic.open_float() or vim.lsp.buf.hover() end, "Hover Documentation")

			map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
			map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
			map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
			map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")
			map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

			map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
			map("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

			map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
			map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
		end,
	})
end

return M
