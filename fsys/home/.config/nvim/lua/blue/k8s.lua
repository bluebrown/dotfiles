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

M.setup = function()
  pcall(require("which-key").register, { ["<leader>k"] = { name = "(k)ubernetes" } })
  vim.keymap.set("n", "<leader>kc", M.switch_context, { desc = "(c)ontext" })
  vim.keymap.set("n", "<leader>kn", M.switch_namespace, { desc = "(n)amespace" })
end

return M
