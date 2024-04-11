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

  local ok, lcfg = pcall(require, "lspconfig.ui.windows")
  if ok then
    lcfg.default_opts({ border = winconf.border })
    -- TOODO: the below is set by the ui.windows module.
    -- maybe we should do something with it:
    -- api.nvim_win_set_option(win_id, 'winhl', 'FloatBorder:LspInfoBorder')
  end

  vim.fn.sign_define("DiagnosticSignError", { text = " ", texthl = "DiagnosticSignError" })
  vim.fn.sign_define("DiagnosticSignWarn", { text = " ", texthl = "DiagnosticSignWarn" })
  vim.fn.sign_define("DiagnosticSignInfo", { text = " ", texthl = "DiagnosticSignInfo" })
  vim.fn.sign_define("DiagnosticSignHint", { text = "󰌵", texthl = "DiagnosticSignHint" })

  local sok, signs = pcall(require, "gitsigns")
  if sok then signs.setup() end
end

return M
