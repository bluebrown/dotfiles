return {
  theme = "tokyonight",
  syntax = {
    "bash",
    "python",
    "make",
    "json",
    "yaml",
    "toml",
    "go",
  },
  lsp = {
    "gopls",
  },
  lint = {
    sh = { "shellcheck" },
  },
  format = {
    sh = { "shfmt" },
    json = { "jq" },
    yaml = { "yamlfmt" },
    toml = { "taplo" },
    go = { "goimports" },
    lua = { "stylua" },
    markdown = { "mdformat" },
    ["*"] = { "codespell" },
  },
}
