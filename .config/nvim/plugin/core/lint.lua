vim.pack.add({ "https://github.com/mfussenegger/nvim-lint" })

local ok, plugin = pcall(require, "lint")
if not ok then
  vim.notify("lint not found", vim.log.levels.WARN)
  return
end

local ok, settings = pcall(require, "settings")
local lint = ok and settings.lint or {}

plugin.linters_by_ft = lint

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  callback = function()
    local ok, v = pcall(plugin.try_lint)
    if not ok then vim.notify(v, vim.log.levels.WARN) end

    local ok, v = pcall(plugin.try_lint, "codespell")
    if not ok then vim.notify(v, vim.log.levels.WARN) end
  end,
})
