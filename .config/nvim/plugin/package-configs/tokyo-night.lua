local ok, plugin = pcall(require, "tokyonight")
if not ok then
  vim.notify("tokyonight.nvim not found", vim.log.levels.WARN)
  return
end

plugin.setup({
  transparent = true,
})
