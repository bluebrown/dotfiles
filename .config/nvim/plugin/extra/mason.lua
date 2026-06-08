vim.pack.add({ "https://github.com/mason-org/mason.nvim" })

local ok, plugin = pcall(require, "mason")
if not ok then
  vim.notify("mason not found", vim.log.levels.WARN)
  return
end

plugin.setup()

local ok, settings = pcall(require, "settings")
if not ok then
  vim.notify("settings not found", vim.log.levels.WARN)
  return
end

local want = {}
local need = {}

for key, values in pairs(settings.lint or {}) do
  for _, value in pairs(values) do
    want[value] = true
  end
end

for key, values in pairs(settings.format or {}) do
  for _, value in pairs(values) do
    if value == "hcl" then value = "hclfmt" end
    want[value] = true
  end
end

for tool, _ in pairs(want) do
  if vim.fn.executable(tool) ~= 1 then table.insert(need, tool) end
end

if #need > 0 then vim.cmd({ cmd = "MasonInstall", args = need }) end
