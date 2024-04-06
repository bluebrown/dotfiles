local M = {}

M.setup = function()
  -- global options

  vim.g.mapleader = " "
  vim.g.maplocalleader = " "

  vim.opt.updatetime = 250
  vim.opt.timeoutlen = 1000
  vim.opt.undofile = true
  vim.opt.mouse = "a"
  vim.opt.scrolloff = 10

  -- behavior options

  vim.opt.wrap = false
  -- vim.opt.breakindent = true

  vim.opt.splitright = true
  vim.opt.splitbelow = true

  -- vim.opt.expandtab = true
  -- vim.opt.tabstop = 2
  -- vim.opt.softtabstop = 2
  -- vim.opt.shiftwidth = 2
  -- vim.opt.smartindent = true

  -- vim.opt.inccommand = "split"
  vim.opt.incsearch = true
  vim.opt.ignorecase = true
  vim.opt.smartcase = true

  -- visual options

  vim.opt.hlsearch = true
  vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

  vim.opt.signcolumn = "yes:2"
  vim.opt.number = true
  vim.opt.relativenumber = true
  vim.opt.cursorline = true

  vim.opt.list = true
  vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

  -- key mappings

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

  vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous [D]iagnostic message" })
  vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next [D]iagnostic message" })
  vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic [E]rror messages" })
  vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

  vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

  vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
  vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
  vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
  vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

  -- auto commands

  vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking (copying) text",
    group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
    callback = function() vim.highlight.on_yank() end,
  })

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
end

return M
