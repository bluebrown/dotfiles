local ok, plugin = pcall(require, "mason")
if not ok then
  vim.notify("mason not found", vim.log.levels.WARN)
  return
end

plugin.setup()

local settings = require("settings")

local want = {}
local need = {}

for key, values in pairs(settings.lint) do
  for _, value in pairs(values) do
    want[value] = true
  end
end

for key, values in pairs(settings.format) do
  for _, value in pairs(values) do
    if value == "hcl" then value = "hclfmt" end
    want[value] = true
  end
end

for tool, _ in pairs(want) do
  local p = vim.fn.stdpath("data") .. "/mason/packages/" .. tool
  if not vim.loop.fs_stat(p) then table.insert(need, tool) end
end

if #need > 0 then vim.cmd({ cmd = "MasonInstall", args = need }) end
