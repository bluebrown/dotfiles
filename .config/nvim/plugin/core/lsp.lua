vim.pack.add({
  { src = "https://github.com/neovim/nvim-lspconfig" },
})

vim.keymap.set("n", "grq", vim.diagnostic.setqflist)

vim.diagnostic.config({
  virtual_lines = {
    current_line = true,
  },
  update_in_insert = false,
  underline = true,
  severity_sort = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "",
      [vim.diagnostic.severity.WARN] = "",
      [vim.diagnostic.severity.INFO] = "",
      [vim.diagnostic.severity.HINT] = "󰌵",
    },
  },
})

-- defaults:
-- - "gra" (Normal and Visual mode) is mapped to |vim.lsp.buf.code_action()|
-- - "gri" is mapped to |vim.lsp.buf.implementation()|
-- - "grn" is mapped to |vim.lsp.buf.rename()|
-- - "grr" is mapped to |vim.lsp.buf.references()|
-- - "grt" is mapped to |vim.lsp.buf.type_definition()|
-- - "grx" is mapped to |vim.lsp.codelens.run()|
-- - "gO" is mapped to |vim.lsp.buf.document_symbol()|
-- - CTRL-S (Insert mode) is mapped to |vim.lsp.buf.signature_help()|
vim.keymap.set("n", "grf", vim.diagnostic.open_float)
vim.keymap.set("n", "grq", vim.diagnostic.setqflist)
vim.keymap.set("n", "grd", vim.lsp.buf.definition)
vim.keymap.set("n", "grD", vim.lsp.buf.declaration)

local ok, settings = pcall(require, "settings")
local lsp = ok and settings.lsp or {}

if ok then
  for _, ls in pairs(lsp) do
    vim.lsp.enable(ls)
  end
end
