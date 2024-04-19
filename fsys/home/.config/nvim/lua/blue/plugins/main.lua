local M = {}

M.linter = {
  markdown = { "markdownlint" },
  terraform = { "tflint", "tfsec" },
  sh = { "shellcheck" },
}

M.formatter = {
  markdown = { "prettier" },
  lua = { "stylua" },
  sh = { "shfmt" },
  yaml = { "yamlfmt" },
  go = { "goimports" },
  python = { "isort", "black" },
  json = { "prettier" },
  c = { "clang-format" },
}

M.server = {
  lua_ls = {},
  bashls = {},
  gopls = {},
  zls = {},
  pyright = {},
  terraformls = {},
  yamlls = {},
  clangd = { capabilities = { offsetEncoding = "utf-8" } },
}

M.parser = {
  "lua",
  "vim",
  "vimdoc",
  "markdown",
  "query",
}

M.tools = function()
  return vim.fn.flatten({
    vim.tbl_keys(M.server),
    vim.tbl_values(M.linter),
    vim.tbl_values(M.formatter),
  })
end

M.setup = function()
  require("blue.plugins.theme").setup()
  require("blue.plugins.treesitter").setup({ parsers = M.parser })
  require("blue.plugins.lsp").setup({ tools = M.tools(), lsp = M.server })
  require("blue.plugins.linter").setup({ linters_by_ft = M.linter })
  require("blue.plugins.formatter").setup({ formatters_by_ft = M.formatter })
  require("blue.plugins.completion").setup()
  require("blue.plugins.finder").setup()
  require("blue.plugins.files").setup()
  require("blue.plugins.hints").setup()
  require("blue.plugins.k8s").setup()
end

return M
