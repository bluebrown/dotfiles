vim.pack.add({
  { src = "https://github.com/neovim/nvim-lspconfig" },
})

vim.keymap.set("n", "grq", vim.diagnostic.setqflist)

vim.diagnostic.config({
  virtual_lines = {
    current_line = true,
  },
  signs = true,
  update_in_insert = false,
  underline = true,
  severity_sort = true,
  float = winconf,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "",
      [vim.diagnostic.severity.WARN] = "",
      [vim.diagnostic.severity.INFO] = "",
      [vim.diagnostic.severity.HINT] = "󰌵",
    },
  },
})

local ok, settings = pcall(require, "settings")
local lsp = ok and settings.lsp or {}

if ok then
  for _, ls in pairs(lsp) do
    vim.lsp.enable(ls)
  end
end
