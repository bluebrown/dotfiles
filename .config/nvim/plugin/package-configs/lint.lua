local ok, plugin = pcall(require, "lint")
if not ok then
  vim.notify("lint not found", vim.log.levels.WARN)
  return
end

plugin.linters_by_ft = require("settings").lint

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  callback = function() require("lint").try_lint() end,
})
