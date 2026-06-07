vim.pack.add({ "https://github.com/nvim-mini/mini.diff" })

local ok, plugin = pcall(require, "mini.diff")
if not ok then
  vim.notify("mini.diff not found", vim.log.levels.WARN)
  return
end

plugin.setup()
