local M = {}

M.CTX_LIST = "kubectl config get-contexts -o=name"
M.CTX_USE = "kubectl config use-context"
M.NS_LIST = "kubectl get ns --no-headers -o=custom-columns=NAME:.metadata.name"
M.NS_USE = "kubectl config set-context --current --namespace"

local make_action = function(list_cmd, use_cmd, title)
	return function()
		vim.notify("Loading...")
		vim.ui.select(vim.fn.systemlist(list_cmd), { prompt = title }, function(item)
			if not item or item == "" then
				return
			end
			vim.notify(vim.fn.system(use_cmd .. " " .. item))
		end)
	end
end

M.setup = function()
	pcall(require("which-key").register, { ["<leader>k"] = { name = "(k)ubernetes" } })

	vim.keymap.set("n", "<leader>kc", make_action(M.CTX_LIST, M.CTX_USE, "Select Context"), { desc = "(c)ontext" })
	vim.keymap.set("n", "<leader>kn", make_action(M.NS_LIST, M.NS_USE, "Select Namespace"), { desc = "(n)amespace" })
end

return M
