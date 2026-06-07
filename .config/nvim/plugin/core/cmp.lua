vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if name:lower() == "luasnip" and (kind == "install" or kind == "update") then
      vim.print(vim.system({ "make", "install_jsregexp" }, { cwd = ev.data.path }):wait())
    end
  end,
})

vim.pack.add({
  { src = "https://github.com/L3MON4D3/LuaSnip" },
  { src = "https://github.com/hrsh7th/nvim-cmp" },
  { src = "https://github.com/saadparwaiz1/cmp_luasnip" },
  { src = "https://github.com/hrsh7th/cmp-nvim-lsp" },
  { src = "https://github.com/hrsh7th/cmp-path" },
})

local ok, cmp = pcall(require, "cmp")
if not ok then
  vim.notify("cmp not found", vim.log.levels.WARN)
  return
end

local ok, luasnip = pcall(require, "luasnip")
if not ok then
  vim.notify("luasnip not found", vim.log.levels.WARN)
  return
end

luasnip.config.setup({})

cmp.setup({
  snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
  mapping = cmp.mapping.preset.insert({}),
  sources = {
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "path" },
  },
})
