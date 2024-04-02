local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local actions = require("telescope.actions")

local function runcmd(cmd)
  return function(prompt_bufnr, map)
    actions.select_default:replace(function()
      actions.close(prompt_bufnr)
      local selection = action_state.get_selected_entry()
      local stdout = vim.fn.system(cmd .. " " .. selection.value)
      vim.notify(string.sub(stdout, 1, -2))
    end)
    return true
  end
end

local function use_context(opts)
  local conf = require("telescope.config").values
  local action_state = require("telescope.actions.state")
  pickers
      .new(opts, {
        prompt_title = "Kube Contexts",
        finder = finders.new_oneshot_job(
          { "bash", "-ec", "kubectl config view -o=go-template='{{range .contexts}}{{println .name}}{{end}}'" },
          opts
        ),
        sorter = conf.generic_sorter(opts),
        attach_mappings = runcmd("kubectl config use-context"),
      })
      :find()
end

local function use_namespace(opts)
  local conf = require("telescope.config").values
  local action_state = require("telescope.actions.state")
  pickers
      .new(opts, {
        prompt_title = "Kube Namespaces",
        finder = finders.new_oneshot_job(
          { "bash", "-ec", "kubectl get namespaces -o=go-template='{{range .items}}{{println .metadata.name}}{{end}}'" },
          opts
        ),
        sorter = conf.generic_sorter(opts),
        attach_mappings = runcmd("kubectl config set-context --current --namespace"),
      })
      :find()
end

return require("telescope").register_extension({
  exports = {
    use_context = use_context,
    use_namespace = use_namespace,
  },
})
