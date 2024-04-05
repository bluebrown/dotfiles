local M = {}

-- langauge to linter mapping
M.linter = {
  markdown = { "markdownlint" },
  terraform = { "tflint", "tfsec" },
}

-- langauge to formatter mapping
M.formatter = {
  lua = { "stylua" },
  sh = { "shfmt" },
  yaml = { "yamlfmt" },
  go = { "goimports" },
  python = { "isort", "black" },
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

M.setup = function()
  -- the native settings should come first
  -- so other plugins can use the values
  require("blue.settings").setup()

  -- the theme is loaded right after the settings
  -- in hope to avoid flickering
  require("blue.theme").setup()

  -- these are some plugins for beginners.
  -- for example which-key to help with keybindings
  require("blue.noob").setup()

  -- these plugins turn neovim into an IDE
  require("blue.finder").setup()
  require("blue.treesitter").setup({ parsers = M.parser })
  require("blue.lsp").setup({ tools = M.tools(), lsp = M.server })
  require("blue.linter").setup({ linters_by_ft = M.linter })
  require("blue.formatter").setup({ formatters_by_ft = M.formatter })
  require("blue.completion").setup()

  -- custom functionality
  require("blue.k8s").setup()
end

return M
