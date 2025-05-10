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

local cmp_winconf = cmp.config.window.bordered({
  winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
})

cmp.setup({
  window = {
    completion = cmp_winconf,
    documentation = cmp_winconf,
  },
  snippet = {
    expand = function(args) luasnip.lsp_expand(args.body) end,
  },
  completion = { completeopt = "menu,menuone,noinsert" },

  mapping = cmp.mapping.preset.insert({
    ["<C-n>"] = cmp.mapping.select_next_item(),
    ["<C-p>"] = cmp.mapping.select_prev_item(),
    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-y>"] = cmp.mapping.confirm({ select = true }),
    ["<C-Space>"] = cmp.mapping.complete({}),

    ["<C-l>"] = cmp.mapping(function()
      if luasnip.expand_or_locally_jumpable() then luasnip.expand_or_jump() end
    end, { "i", "s" }),

    ["<C-h>"] = cmp.mapping(function()
      if luasnip.locally_jumpable(-1) then luasnip.jump(-1) end
    end, { "i", "s" }),
  }),

  sources = {
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "path" },
  },
})
