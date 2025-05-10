vim.api.nvim_create_autocmd("InsertLeave", {
  desc = "Use relative number in normal mode",
  group = vim.api.nvim_create_augroup("bluebrown-number-relative", { clear = true }),
  pattern = "*",
  callback = function() vim.opt.relativenumber = true end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  callback = function() vim.highlight.on_yank() end,
})
