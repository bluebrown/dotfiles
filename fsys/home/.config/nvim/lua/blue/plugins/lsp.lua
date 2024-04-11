local M = {}

local function client_setup(ev)
  local client = vim.lsp.get_client_by_id(ev.data.client_id)
  if not client then return end

  vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

  local map = function(keys, func, desc)
    vim.keymap.set("n", keys, func, {
      buffer = ev.buf,
      desc = "LSP: " .. desc,
    })
  end

  map("K", vim.lsp.buf.hover, "Hover Documentation")
  map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
  map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
  map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")

  local tok, builtin = pcall(require, "telescope.builtin")
  if tok then
    map("gd", builtin.lsp_definitions, "[G]oto [D]efinition")
    map("gr", builtin.lsp_references, "[G]oto [R]eferences")
    map("gI", builtin.lsp_implementations, "[G]oto [I]mplementation")
    map("<leader>D", builtin.lsp_type_definitions, "Type [D]efinition")
    map("<leader>ds", builtin.lsp_document_symbols, "[D]ocument [S]ymbols")
    map("<leader>ws", builtin.lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
  end

  if client.server_capabilities.documentHighlightProvider then
    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
      buffer = ev.buf,
      callback = vim.lsp.buf.document_highlight,
    })
    vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
      buffer = ev.buf,
      callback = vim.lsp.buf.clear_references,
    })
  end
end

M.server_capabilities = function()
  local caps = vim.lsp.protocol.make_client_capabilities()
  local ok, cmp = pcall(require, "cmp_nvim_lsp")
  if ok then caps = vim.tbl_deep_extend("force", caps, cmp.default_capabilities()) end
  return caps
end

-- fully managed setup using mason
M.server_setup_mason = function(configs, handle, tools)
  require("mason").setup()
  require("mason-tool-installer").setup({ ensure_installed = tools or {} })
  require("mason-lspconfig").setup({
    handlers = {
      function(sn) return handle(sn, configs[sn] or {}) end,
    },
  })
end

-- this setups up the servers based on the provided configs
-- but does not setup mason or the tools
M.server_setup_eject = function(configs, handle)
  for sn, ucfg in pairs(configs) do
    handle(sn, ucfg)
  end
  -- with some luck, there are still some tools installed
  vim.env.PATH = vim.fn.printf("%s/mason/bin:%s", vim.fn.stdpath("data"), vim.env.PATH)
end

M.setup = function(opts)
  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspConfig", {}),
    callback = client_setup,
  })

  local caps = M.server_capabilities()

  local function srv_setup(sn, ucfg)
    ucfg.capabilities = vim.tbl_deep_extend("force", caps, ucfg.capabilities or {})
    require("lspconfig")[sn].setup(ucfg)
  end

  if opts.eject then
    M.server_setup_eject(opts.lsp, srv_setup)
  else
    M.server_setup_mason(opts.lsp, srv_setup, opts.tools)
  end
end

return M
