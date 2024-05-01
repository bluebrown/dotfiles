--@ native

-- map leader
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- settings
vim.opt.undofile = true
vim.opt.scrolloff = 10
vim.opt.wrap = false
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
  add("neovim/nvim-lspconfig")
  local lspconfig = require("lspconfig")
  local caps = vim.lsp.protocol.make_client_capabilities()
  vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)
  lspconfig["gopls"].setup({ capabilities = caps })
end)

-- linter
later(function()
  add("mfussenegger/nvim-lint")
  require("lint").linters_by_ft = {
    sh = { "shellcheck" },
    markdown = { "markdownlint" },
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
  add("stevearc/oil.nvim")
  require("oil").setup({ default_file_explorer = true })
  vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
end)

later(function() add("github/copilot.vim") end)

--@ custom

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

vim.keymap.set("n", "<leader>ksc", to_choice(cmd_context), { desc = "(c)ontext" })
vim.keymap.set("n", "<leader>ksn", to_choice(cmd_namespace), { desc = "(n)amespace" })
