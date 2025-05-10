vim.opt.number = true
vim.opt.relativenumber = true

vim.api.nvim_create_autocmd("InsertEnter", {
  desc = "use absolute number in insert mode",
  group = vim.api.nvim_create_augroup("bluebrown-number-absolute", { clear = true }),
  pattern = "*",
  callback = function() vim.opt.relativenumber = false end,
})

vim.api.nvim_create_autocmd("InsertLeave", {
  desc = "Use relative number in normal mode",
  group = vim.api.nvim_create_augroup("bluebrown-number-relative", { clear = true }),
  pattern = "*",
  callback = function() vim.opt.relativenumber = true end,
})
