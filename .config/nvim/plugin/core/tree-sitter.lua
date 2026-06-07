vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if name:lower() == "nvim-treesitter" and (kind == "install" or kind == "update") then
      if not ev.data.active then vim.cmd.packadd("nvim-treesitter") end
      vim.cmd("TSUpdate")
    end
  end,
})

vim.pack.add({ "https://github.com/nvim-treesitter/nvim-treesitter" })

local ok, plugin = pcall(require, "nvim-treesitter")
if not ok then
  vim.notify("nvim-treesitter not found", vim.log.levels.WARN)
  return
end

local ok, settings = pcall(require, "settings")
local syntax = ok and settings.syntax or {}

plugin.setup({ install_dir = vim.fn.stdpath("data") .. "/site" })
plugin.install(syntax)

vim.api.nvim_create_autocmd("FileType", {
  pattern = syntax,
  callback = function()
    vim.treesitter.start()
    vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
    vim.wo[0][0].foldmethod = "expr"
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})
