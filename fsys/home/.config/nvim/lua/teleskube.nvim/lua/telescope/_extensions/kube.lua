local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local runcmd = function(cmd)
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
  setup = function(ext_config, config)
    vim.notify("teleskube setup")
  end,
  exports = {
    use_context = use_context,
    use_namespace = use_namespace,
  },
})
