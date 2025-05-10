local ok, plugin = pcall(require, "conform")
if not ok then
  vim.notify("conform not found", vim.log.levels.WARN)
  return
end

plugin.setup({
  format_on_save = { timeout_ms = 2000, lsp_format = "fallback" },
  formatters_by_ft = require("settings").format,
})
