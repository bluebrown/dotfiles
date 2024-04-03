local M = {}

M.setup = function(...)
	require("blue.settings").setup()
	require("blue.theme").setup()
	require("blue.maps").setup()
	require("blue.treesitter").setup()
	require("blue.lsp").setup()
	require("blue.autofmt").setup()
	require("blue.completion").setup()
	require("blue.telescope").setup()
end

return M
