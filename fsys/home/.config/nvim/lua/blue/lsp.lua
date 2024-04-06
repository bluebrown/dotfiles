local M = {}

local function cli_hov(client, buf, map) map("K", vim.lsp.buf.hover, "Hover Documentation") end

local function cli_find(client, buf, map)
  map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
  map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
  map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
  map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")
  -- map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
  map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
  map("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
end

local function cli_refac(client, buf, map)
  map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
  map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
end

local function cli_dochi(client, buf, map)
  if client.server_capabilities.documentHighlightProvider then
    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
      buffer = buf,
      callback = vim.lsp.buf.document_highlight,
    })
    vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
      buffer = buf,
      callback = vim.lsp.buf.clear_references,
    })
  end
end

local function cli_inlay(client, buf, map) end

local function cli_signat(client, buf, map) end

local function cli_setup(ev)
  local cli = vim.lsp.get_client_by_id(ev.data.client_id)
  if not cli then return end

  vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

  local map = function(keys, func, desc)
    vim.keymap.set("n", keys, func, {
      buffer = ev.buf,
      desc = "LSP: " .. desc,
    })
  end

  cli_hov(cli, ev.buf, map)
  cli_find(cli, ev.buf, map)
  cli_refac(cli, ev.buf, map)
  cli_dochi(cli, ev.buf, map)
  cli_signat(cli, ev.buf, map)
  cli_inlay(cli, ev.buf, map)
end

M.srv_caps = function()
  local caps = vim.lsp.protocol.make_client_capabilities()
  ok, cmp = pcall(require, "cmp_nvim_lsp")
  if ok then caps = vim.tbl_deep_extend("force", caps, cmp.default_capabilities()) end
  return caps
end

M.srv_cfg_mason = function(configs, handle, tools)
  require("mason").setup()
  require("mason-tool-installer").setup({ ensure_installed = tools or {} })
  require("mason-lspconfig").setup({
    handlers = {
      function(sn) return handle(sn, configs[sn] or {}) end,
    },
  })
end

M.srv_cfg_manual = function(configs, handle)
  for sn, ucfg in pairs(configs) do
    handle(sn, ucfg)
  end
  vim.env.PATH = vim.fn.printf("%s/mason/bin:%s", vim.fn.stdpath("data"), vim.env.PATH)
end

M.setup = function(opts)
  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspConfig", {}),
    callback = cli_setup,
  })

  local caps = M.srv_caps()

  local function srv_setup(sn, ucfg)
    ucfg.capabilities = vim.tbl_deep_extend("force", caps, ucfg.capabilities or {})
    require("lspconfig")[sn].setup(ucfg)
  end

  if opts.manual then
    M.srv_cfg_manual(opts.lsp, srv_setup)
  else
    M.srv_cfg_mason(opts.lsp, srv_setup, opts.tools)
  end
end

return M
