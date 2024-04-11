local M = {}

-- langauge to linter mapping
M.linter = {
  markdown = { "markdownlint" },
  terraform = { "tflint", "tfsec" },
  sh = { "shellcheck" },
}

-- langauge to formatter mapping
M.formatter = {
  markdown = { "prettier" },
  lua = { "stylua" },
  sh = { "shfmt" },
  yaml = { "yamlfmt" },
  go = { "goimports" },
  python = { "isort", "black" },
  json = { "prettier" },
}

-- langauge server and optional extra config
M.server = {
  lua_ls = {},
  bashls = {},
  gopls = {},
  zls = {},
  pyright = {},
  terraformls = {},
  yamlls = {
    settings = {
      redhat = { telemetry = { enabled = false } },
      yaml = {
        schemas = {
          kubernetes = "*",
          ["http://json.schemastore.org/kustomization"] = "kustomization.yaml",
        },
      },
    },
  },
  clangd = {
    capabilities = { offsetEncoding = "utf-8" },
  },
}

-- list of treesitter parsers
M.parser = {
  "lua",
  "vim",
  "vimdoc",
  "markdown",
  "query",
}

-- create a flat list of tools, to pass it to mason
M.tools = function()
  return vim.fn.flatten({
    vim.tbl_keys(M.server),
    vim.tbl_values(M.linter),
    vim.tbl_values(M.formatter),
  })
end

M.setup = function(opts)
  local opts = opts or {}

  -- the theme is loaded right after the settings
  -- in hope to avoid flickering
  require("blue.plugins.theme").setup()

  -- these are some plugins for beginners.
  -- for example which-key to help with keybindings
  require("blue.plugins.noob").setup()

  -- these plugins turn neovim into an IDE
  require("blue.plugins.finder").setup()
  require("blue.plugins.treesitter").setup({ parsers = M.parser })
  require("blue.plugins.lsp").setup({ tools = M.tools(), lsp = M.server })
  require("blue.plugins.linter").setup({ linters_by_ft = M.linter })
  require("blue.plugins.formatter").setup({ formatters_by_ft = M.formatter })
  require("blue.plugins.completion").setup()

  -- custom functionality
  require("blue.plugins.k8s").setup()

  -- this is sin
  require("blue.plugins.filetree").setup()
end

return M
