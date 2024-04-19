local M = {}

M.setup = function()
  local ook, oil = pcall(require, "oil")
  if not ook then return end
  oil.setup({ default_file_explorer = true })
  vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
end

return M
