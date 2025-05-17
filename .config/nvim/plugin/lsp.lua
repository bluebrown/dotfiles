local winconf = { border = "rounded", max_width = 80 }

vim.diagnostic.config({
	virtual_text = { current_line = true },
	update_in_insert = false,
	underline = true,
	severity_sort = true,
	float = winconf,
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "",
			[vim.diagnostic.severity.WARN] = "",
			[vim.diagnostic.severity.INFO] = "",
			[vim.diagnostic.severity.HINT] = "󰌵",
		},
	},
})

local preview = vim.lsp.util.open_floating_preview

function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
	opts = opts or {}
	opts.border = opts.border or winconf.border
	opts.max_width = opts.max_width or winconf.max_width
	return preview(contents, syntax, opts, ...)
end

vim.keymap.set("n", "grf", vim.diagnostic.open_float)
vim.keymap.set("n", "grq", vim.diagnostic.setqflist)

vim.keymap.set("n", "grd", vim.lsp.buf.definition)
vim.keymap.set("n", "grD", vim.lsp.buf.declaration)

for _, ls in pairs(require("settings").lsp) do
	vim.lsp.enable(ls)
end

vim.keymap.set("n", "gK", function()
	local new_config = not vim.diagnostic.config().virtual_lines
	vim.diagnostic.config({ virtual_lines = new_config })
end, { desc = "Toggle diagnostic virtual_lines" })
