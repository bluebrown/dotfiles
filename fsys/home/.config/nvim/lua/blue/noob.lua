local M = {}

M.setup = function(...)
  require("which-key").setup()
  -- which-key will block after each key press.
  -- so, timeoutlen will not work as usual.
  -- hence, we set a very low value,
  -- to get faster feedback from which-key
  vim.opt.timeoutlen = 250

  -- patch other tools to understand neovim
  require("neodev").setup({})
end

return M
