local ok, install = pcall(require, "nvim-treesitter.install")
if not ok then
  vim.notify("nvim-treesitter.install not found", vim.log.levels.WARN)
  return
end

local ok, configs = pcall(require, "nvim-treesitter.configs")
if not ok then
  vim.notify("nvim-treesitter.configs not found", vim.log.levels.WARN)
  return
end

install.prefer_git = true

configs.setup({
  auto_install = false,
  highlight = { enable = true, additional_vim_regex_highlighting = false },
  incremental_selection = { enable = false },
  indent = { enable = false },
  ensure_installed = require("settings").syntax,
})
