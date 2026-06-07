local ok, settings = pcall(require, "settings")
if not ok then return end

if settings.theme then pcall(vim.cmd, { cmd = "colorscheme", args = { settings.theme } }) end
