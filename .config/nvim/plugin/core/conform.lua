vim.pack.add({ "https://github.com/stevearc/conform.nvim" })

local ok, plugin = pcall(require, "conform")
if not ok then
  vim.notify("conform not found", vim.log.levels.WARN)
  return
end

local ok, settings = pcall(require, "settings")
local format = ok and settings.format or {}

plugin.setup({
  formatters_by_ft = format,
})

local group = vim.api.nvim_create_augroup("ConformAutoFormat", { clear = true })

function enable()
  vim.api.nvim_create_autocmd("BufWritePre", {
    group = group,
    pattern = "*",
    callback = function(args) require("conform").format({ bufnr = args.buf }) end,
  })
end

function disable() vim.api.nvim_clear_autocmds({ group = group }) end

vim.api.nvim_create_user_command("ConformEnable", enable, { desc = "Enable Conform Auto Formatting" })
vim.api.nvim_create_user_command("ConformDisable", disable, { desc = "Disable Conform Auto Formatting" })

enable()
