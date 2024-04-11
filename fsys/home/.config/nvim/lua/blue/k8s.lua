local M = {}

local function fmt(current)
  return function(item) return item == current and string.format("%s (current)", item) or item end
end

local function on_select(switch_cmd)
  return function(item)
    if not item or item == "" then return end
    local msg = vim.fn.system(string.format("%s %s", switch_cmd, item))
    vim.notify(vim.trim(msg))
  end
end

local function to_choice(cmd)
  return function()
    vim.ui.select(
      vim.fn.systemlist(cmd.list),
      { format_item = fmt(vim.fn.system(cmd.current)), prompt = cmd.prompt },
      on_select(cmd.switch)
    )
  end
end

local cmd_context = {
  prompt = "Select context",
  current = "kubectl config view --minify -o jsonpath='{.contexts[].name}'",
  list = "kubectl config get-contexts -o=name",
  switch = "kubectl config use-context",
}

local cmd_namespace = {
  prompt = "Select namespace",
  current = "kubectl config view --minify -o jsonpath='{..namespace}'",
  list = "kubectl get ns --no-headers -o=custom-columns=NAME:.metadata.name",
  switch = "kubectl config set-context --current --namespace",
}

M.switch_context = to_choice(cmd_context)
M.switch_namespace = to_choice(cmd_namespace)

local function describe(kind)
  vim.print("Describe %s in current namespace", kind)
  local previewers = require("telescope.previewers")
  local pickers = require("telescope.pickers")
  local sorters = require("telescope.sorters")
  local finders = require("telescope.finders")
  local actions = require("telescope.actions")
  pickers
    .new({}, {
      results_title = vim.print("List of %s", kind),
      finder = finders.new_oneshot_job({ "kubectl", "get", kind, "-o=name" }, {}),
      sorter = sorters.get_fuzzy_file(),
      previewer = previewers.new_buffer_previewer({
        keep_last_buf = true,
        define_preview = function(self, entry)
          require("telescope.previewers.utils").job_maker({ "kubectl", "describe", entry.value }, self.state.bufnr, {
            value = entry.value,
            bufname = self.state.bufname,
            cwd = self.state.cwd,
            callback = function(bufnr) require("telescope.previewers.utils").highlighter(bufnr, "bash") end,
          })
        end,
      }),
      attach_mappings = function(prompt_bufnr)
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
          local bufnur = require("telescope.state").get_global_key("last_preview_bufnr")
          vim.api.nvim_set_current_buf(bufnur)
        end)
        return true
      end,
    })
    :find()
end

M.setup = function()
  local wok, wk = pcall(require, "which-key")

  if wok then
    wk.register({ ["<leader>k"] = { name = "(k)ubernetes" } })
    wk.register({ ["<leader>ks"] = { name = "(s)witch" } })
  end

  vim.keymap.set("n", "<leader>ksc", M.switch_context, { desc = "(c)ontext" })
  vim.keymap.set("n", "<leader>ksn", M.switch_namespace, { desc = "(n)amespace" })

  local _, tok = pcall(require, "telescope")
  if tok then
    if wok then wk.register({ ["<leader>kd"] = { name = "(d)escribe" } }) end

    vim.keymap.set("n", "<leader>kdn", function() describe("nodes") end, { desc = "nodes" })
    vim.keymap.set("n", "<leader>kdc", function() describe("configmaps") end, { desc = "configmaps" })
    vim.keymap.set("n", "<leader>kds", function() describe("secrets") end, { desc = "secrets" })
    vim.keymap.set("n", "<leader>kdp", function() describe("pods") end, { desc = "pods" })
    vim.keymap.set("n", "<leader>kdi", function() describe("ingresses") end, { desc = "ingresses" })
  end
end

return M
