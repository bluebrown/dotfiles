local M = {}

M.setup = function(opts)
  local opts = opts or {}

  local lint = require("lint")
  lint.linters_by_ft = opts.linters_by_ft or {}

  local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
  vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
    group = lint_augroup,
    callback = function() require("lint").try_lint() end,
  })
end

return M
