local M = {}

M.setup = function()
  local ok, ntree = pcall(require, "neo-tree")
  if not ok then return end

  ntree.setup({
    filesystem = {
      follow_current_file = {
        enabled = true,
      },
      group_empty_dirs = true,
      hijack_netrw_behavior = "open_default",
      use_libuv_file_watcher = true,
    },
  })
end

return M
