vim.pack.add({ "https://github.com/stevearc/conform.nvim" })

local ok, plugin = pcall(require, "conform")
if not ok then
  vim.notify("conform not found", vim.log.levels.WARN)
  return
end

local ok, settings = pcall(require, "settings")
local format = ok and settings.format or {}

plugin.setup({
  format_on_save = { timeout_ms = 2000, lsp_format = "fallback" },
  formatters_by_ft = format,
})
