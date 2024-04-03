local M = {}

M.setup = function(...)
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

	pcall(require("telescope").load_extension, "fzf")

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
end

return M
