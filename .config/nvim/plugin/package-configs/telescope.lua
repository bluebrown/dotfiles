local ok, plugin = pcall(require, "telescope")
if not ok then
  vim.notify("telescope not found", vim.log.levels.WARN)
  return
end

plugin.setup({
  defaults = {
    mappings = {
      i = { ["<c-enter>"] = "to_fuzzy_refine" },
    },
  },
  pickers = {
    find_files = { find_command = { "rg", "--files", "--iglob", "!.git", "--hidden" } },
    grep_string = { additional_args = { "--hidden" } },
    live_grep = { additional_args = { "--hidden" } },
  },
  extensions = {
    ["ui-select"] = { require("telescope.themes").get_dropdown() },
  },
})

pcall(require("telescope").load_extension, "fzf")
pcall(require("telescope").load_extension, "ui-select")
local builtin = require("telescope.builtin")

vim.keymap.set("n", "<leader>ss", builtin.builtin)
vim.keymap.set("n", "<leader>sh", builtin.help_tags)
vim.keymap.set("n", "<leader>sk", builtin.keymaps)
vim.keymap.set("n", "<leader>sf", builtin.find_files)
vim.keymap.set("n", "<leader>sw", builtin.grep_string)
vim.keymap.set("n", "<leader>sg", builtin.live_grep)
vim.keymap.set("n", "<leader>sd", builtin.diagnostics)
vim.keymap.set("n", "<leader>sr", builtin.resume)
vim.keymap.set("n", "<leader>s.", builtin.oldfiles)
vim.keymap.set("n", "<leader><leader>", builtin.buffers)

vim.keymap.set(
  "n",
  "<leader>/",
  function()
    builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
      winblend = 10,
      previewer = false,
    }))
  end
)

vim.keymap.set(
  "n",
  "<leader>s/",
  function()
    builtin.live_grep({
      grep_open_files = true,
      prompt_title = "Live Grep in Open Files",
    })
  end
)
