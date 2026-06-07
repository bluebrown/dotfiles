return {
  theme = "tokyonight",
  syntax = {
    "bash",
    "json",
    "yaml",
    "toml",
    "python",
    "go",
  },
  lsp = {
    "gopls",
  },
  lint = {
    sh = { "shellcheck" },
  },
  format = {
    go = { "goimports" },
    sh = { "shfmt" },
    lua = { "stylua" },
    json = { "jq" },
    yaml = { "yamlfmt" },
    toml = { "taplo" },
  },
}
