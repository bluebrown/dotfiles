local M = {}

M.setup = function()
  ok, wk = pcall(require, "which-key")
  if ok then
    require("which-key").setup()
    -- which-key will block after each key press.
    -- so, timeoutlen will not work as usual.
    -- hence, we set a very low value,
    -- to get faster feedback from which-key
    vim.opt.timeoutlen = 250
  end

  ok, ndev = pcall(require, "neodev")
  if ok then
    -- patch other tools to understand neovim
    require("neodev").setup({})
  end
end

return M
