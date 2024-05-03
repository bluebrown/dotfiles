--@ native

-- map leader
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- settings
vim.opt.undofile = true
vim.opt.scrolloff = 10
vim.opt.wrap = false

-- sane splits
vim.opt.splitright = true
vim.opt.splitbelow = true

-- visual
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
vim.opt.signcolumn = "yes:2"
vim.opt.cursorline = true

-- better search
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- smart number
vim.opt.number = true
vim.opt.relativenumber = true

vim.api.nvim_create_autocmd("InsertEnter", {
  desc = "use absolute number in insert mode",
  group = vim.api.nvim_create_augroup("bluebrown-number-absolute", { clear = true }),
  pattern = "*",
  callback = function() vim.opt.relativenumber = false end,
})

vim.api.nvim_create_autocmd("InsertLeave", {
  desc = "Use relative number in normal mode",
  group = vim.api.nvim_create_augroup("bluebrown-number-relative", { clear = true }),
  pattern = "*",
  callback = function() vim.opt.relativenumber = true end,
})

-- highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  callback = function() vim.highlight.on_yank() end,
})

-- terminal escape hatch
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- fat finger support
vim.cmd([[
     cnoreabbrev W! w!
     cnoreabbrev W1 w!
     cnoreabbrev w1 w!
     cnoreabbrev Q! q!
     cnoreabbrev Q1 q!
     cnoreabbrev q1 q!
     cnoreabbrev Qa! qa!
     cnoreabbrev Qall! qall!
     cnoreabbrev Wa wa
     cnoreabbrev Wq wq
     cnoreabbrev wQ wq
     cnoreabbrev WQ wq
     cnoreabbrev wq1 wq!
     cnoreabbrev Wq1 wq!
     cnoreabbrev wQ1 wq!
     cnoreabbrev WQ1 wq!
     cnoreabbrev W w
     cnoreabbrev Q q
     cnoreabbrev Qa qa
     cnoreabbrev Qall qall
 ]])

--@ plugins

local path_package = vim.fn.stdpath("data") .. "/site/"
local mini_path = path_package .. "pack/deps/start/mini.nvim"
if not vim.loop.fs_stat(mini_path) then
  vim.cmd('echo "Installing `mini.nvim`" | redraw')
  local clone_cmd = { "git", "clone", "--filter=blob:none", "https://github.com/echasnovski/mini.nvim", mini_path }
  vim.fn.system(clone_cmd)
  vim.cmd("packadd mini.nvim | helptags ALL")
  vim.cmd('echo "Installed `mini.nvim`" | redraw')
end
require("mini.deps").setup({ path = { package = path_package } })
local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

-- mini plugins collections
now(function() add("echasnovski/mini.nvim") end)

-- theme
now(function() vim.cmd("colorscheme randomhue") end)

-- syntax highlighting
later(function()
  add({
    source = "nvim-treesitter/nvim-treesitter",
    hooks = { post_checkout = function() vim.cmd("TSUpdate") end },
  })
  require("nvim-treesitter.install").prefer_git = true
  ---@diagnostic disable-next-line: missing-fields
  require("nvim-treesitter.configs").setup({
    auto_install = false,
    highlight = { enable = true, additional_vim_regex_highlighting = false },
    incremental_selection = { enable = false },
    indent = { enable = false },
  })
end)

-- langauge server
-- needs to load early so lsp attach runs on first bufEnter
now(function()
  vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist)
  add("neovim/nvim-lspconfig")
  local lspconfig = require("lspconfig")
  lspconfig.gopls.setup({})
  lspconfig.rust_analyzer.setup({})
end)

-- linter
later(function()
  add("mfussenegger/nvim-lint")
  require("lint").linters_by_ft = {
    sh = { "shellcheck" },
    --    markdown = { "markdownlint" },
    terraform = { "tflint", "tfsec" },
  }
  local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
  vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
    group = lint_augroup,
    callback = function() require("lint").try_lint() end,
  })
end)

-- auto format
later(function()
  add("stevearc/conform.nvim")
  require("conform").setup({
    formatters_by_ft = {
      lua = { "stylua" },
      go = { "gofmt", "goimports" },
      python = { "isort", "black" },
    },
    notify_on_error = false,
    format_on_save = function(buf)
      local disable_filetypes = { c = true, cpp = true }
      return {
        timeout_ms = 500,
        lsp_fallback = not disable_filetypes[vim.bo[buf].filetype],
      }
    end,
  })
end)

-- auto completion
later(function() require("mini.completion").setup() end)

-- fuzzy finder
later(function()
  require("mini.pick").setup()
  vim.keymap.set("n", "<leader>sf", MiniPick.builtin.files)
  vim.keymap.set("n", "<leader>sg", MiniPick.builtin.grep_live)
end)

-- show git diff
later(function() require("mini.diff").setup() end)

-- buffer based file edits
later(function()
  require("mini.files").setup()
  vim.keymap.set("n", "-", MiniFiles.open)
end)

--@wsl
if vim.fn.has("wsl") then
  vim.g.clipboard = {
    name = "WslClipboard",
    cache_enabled = 0,
    copy = {
      ["+"] = "clip.exe",
      ["*"] = "clip.exe",
    },
    paste = {
      ["+"] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
      ["*"] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
    },
  }
end
