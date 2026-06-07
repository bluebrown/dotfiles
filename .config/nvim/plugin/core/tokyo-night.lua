vim.pack.add({ "https://github.com/folke/tokyonight.nvim" })

local ok, plugin = pcall(require, "tokyonight")
if not ok then
  vim.notify("tokyonight not found", vim.log.levels.WARN)
  return
end

plugin.setup({
  transparent = true,
})
