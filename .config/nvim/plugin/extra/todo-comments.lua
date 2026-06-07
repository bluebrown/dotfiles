vim.pack.add({ "https://github.com/folke/todo-comments.nvim" })

local ok, plugin = pcall(require, "todo-comments")
if not ok then
  vim.notify("todo-comments not found", vim.log.levels.WARN)
  return
end

plugin.setup({
  search = { pattern = [[\b(KEYWORDS)(\([^\)]*\))?:]] },
  highlight = { pattern = [[.*<((KEYWORDS)%(\(.{-1,}\))?):]] },
})
