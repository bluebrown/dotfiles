local M = {}

M.setup = function()
  require("catppuccin").setup({
    transparent_background = true,
    show_end_of_buffer = true,
    term_colors = true,
    default_integrations = true,
    integrations = {
      treesitter = true,
      cmp = true,
      native_lsp = {
        enabled = true,
        inlay_hints = {
          background = true,
        },
      },
    },
  })

  vim.cmd.colorscheme("catppuccin")

  local winconf = {
    border = "rounded",
    max_width = 80,
  }

  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, winconf)
  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, winconf)
  vim.diagnostic.config({
    virtual_text = false,
    signs = true,
    update_in_insert = false,
    underline = true,
    severity_sort = true,
    float = winconf,
  })

  require("lspconfig.ui.windows").default_options = winconf

  require("gitsigns").setup()
end

return M
