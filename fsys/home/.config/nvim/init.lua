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

-- wsl clipboard
if vim.fn.has("wsl") then
  vim.g.clipboard = {
    name = "WslClipboard",
    cache_enabled = 0,
    copy = { ["+"] = "clip.exe", ["*"] = "clip.exe" },
    paste = {
      ["+"] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
      ["*"] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
    },
  }
end

--@ plugins
local path_package = vim.fn.stdpath("data") .. "/site/"
local mini_path = path_package .. "pack/deps/start/mini.nvim"
if not vim.loop.fs_stat(mini_path) then
  vim.cmd('echo "Installing `mini.nvim`" | redraw')
  local clone_cmd = {
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/echasnovski/mini.nvim",
    mini_path,
  }
  vim.fn.system(clone_cmd)
  vim.cmd("packadd mini.nvim | helptags ALL")
  vim.cmd('echo "Installed `mini.nvim`" | redraw')
end
require("mini.deps").setup({ path = { package = path_package } })
local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

-- style
now(function()
  add("catppuccin/nvim")
  require("catppuccin").setup({
    transparent_background = true,
    show_end_of_buffer = true,
    term_colors = true,
    default_integrations = true,
    integrations = {
      treesitter = true,
      cmp = true,
      native_lsp = {
        enabled = true,
        inlay_hints = {
          background = true,
        },
      },
    },
  })
  vim.cmd.colorscheme("catppuccin")
end)

-- extra styles
later(function()
  vim.fn.sign_define("DiagnosticSignError", { text = " ", texthl = "DiagnosticSignError" })
  vim.fn.sign_define("DiagnosticSignWarn", { text = " ", texthl = "DiagnosticSignWarn" })
  vim.fn.sign_define("DiagnosticSignInfo", { text = " ", texthl = "DiagnosticSignInfo" })
  vim.fn.sign_define("DiagnosticSignHint", { text = "󰌵", texthl = "DiagnosticSignHint" })

  local winconf = { border = "rounded", max_width = 80 }

  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, winconf)
  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, winconf)

  vim.diagnostic.config({
    virtual_text = true,
    signs = true,
    update_in_insert = false,
    underline = true,
    severity_sort = true,
    float = winconf,
  })

  local ok, lcfg = pcall(require, "lspconfig.ui.windows")
  if ok then lcfg.default_opts({ border = winconf.border }) end
end)

-- buffer based file edits
now(function()
  add("stevearc/oil.nvim")
  require("oil").setup({
    default_file_explorer = true,
    delete_to_trash = true,
    skip_confirm_for_simple_edits = true,
    view_options = {
      show_hidden = true,
      natural_order = true,
      is_always_hidden = function(name, _)
        if name == ".." then return true end
        if name == ".git" then return true end
      end,
    },
    win_options = {
      wrap = true,
    },
  })
  vim.keymap.set("n", "-", "<CMD>Oil<CR>")
end)

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

now(function()
  add("williamboman/mason.nvim")
  require("mason").setup()
end)

-- langauge server
-- needs to load early so lsp attach runs on first bufEnter
now(function()
  add("neovim/nvim-lspconfig")
  local lc = require("lspconfig")
  --
  -- NOTE: servers have to be installed manually!
  lc.gopls.setup({})

  -- - "K" is mapped in Normal mod to |vim.lsp.buf.hover()|
  -- - "grn" is mapped in Normal mode to |vim.lsp.buf.rename()|
  -- - "gra" is mapped in Normal and Visual mode to |vim.lsp.buf.code_action()|
  -- - "grr" is mapped in Normal mode to |vim.lsp.buf.references()|
  -- - CTRL-S is mapped in Insert mode to |vim.lsp.buf.signature_help()|
  vim.keymap.set("n", "grd", vim.lsp.buf.definition)
  vim.keymap.set("n", "grq", vim.diagnostic.setqflist)
end)

-- linter
later(function()
  add("mfussenegger/nvim-lint")
  require("lint").linters_by_ft = {
    markdown = { "markdownlint" },
    sh = { "shellcheck" },
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
      markdown = { "markdownlint" },
      json = { "jq" },
      sh = { "shfmt" },
      c = { "clang-format" },
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

-- fuzzy finder
later(function()
  add({
    source = "nvim-telescope/telescope.nvim",
    depends = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-fzf-native.nvim",
      "nvim-telescope/telescope-ui-select.nvim",
    },
  })
  require("telescope").setup({
    defaults = {
      mappings = {
        i = { ["<c-enter>"] = "to_fuzzy_refine" },
      },
    },
    pickers = {
      find_files = { find_command = { "rg", "--files", "--iglob", "!.git", "--hidden" } },
      grep_string = { additional_args = { "--hidden" } },
      live_grep = { additional_args = { "--hidden" } },
    },
    extensions = {
      ["ui-select"] = { require("telescope.themes").get_dropdown() },
    },
  })
  pcall(require("telescope").load_extension, "fzf")
  pcall(require("telescope").load_extension, "ui-select")
  local builtin = require("telescope.builtin")
  vim.keymap.set("n", "<leader>ss", builtin.builtin)
  vim.keymap.set("n", "<leader>sh", builtin.help_tags)
  vim.keymap.set("n", "<leader>sk", builtin.keymaps)
  vim.keymap.set("n", "<leader>sf", builtin.find_files)
  vim.keymap.set("n", "<leader>sw", builtin.grep_string)
  vim.keymap.set("n", "<leader>sg", builtin.live_grep)
  vim.keymap.set("n", "<leader>sd", builtin.diagnostics)
  vim.keymap.set("n", "<leader>sr", builtin.resume)
  vim.keymap.set("n", "<leader>s.", builtin.oldfiles)
  vim.keymap.set("n", "<leader><leader>", builtin.buffers)
  vim.keymap.set(
    "n",
    "<leader>/",
    function()
      builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
        winblend = 10,
        previewer = false,
      }))
    end
  )
  vim.keymap.set(
    "n",
    "<leader>s/",
    function()
      builtin.live_grep({
        grep_open_files = true,
        prompt_title = "Live Grep in Open Files",
      })
    end
  )
end)

later(function()
  add("L3MON4D3/LuaSnip")
  add("hrsh7th/nvim-cmp")
  add("saadparwaiz1/cmp_luasnip")
  add("hrsh7th/cmp-nvim-lsp")
  add("hrsh7th/cmp-path")

  local cmp = require("cmp")
  local luasnip = require("luasnip")
  luasnip.config.setup({})

  local cmp_winconf = cmp.config.window.bordered({
    winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
  })

  cmp.setup({
    window = {
      completion = cmp_winconf,
      documentation = cmp_winconf,
    },
    snippet = {
      expand = function(args) luasnip.lsp_expand(args.body) end,
    },
    completion = { completeopt = "menu,menuone,noinsert" },

    mapping = cmp.mapping.preset.insert({
      ["<C-n>"] = cmp.mapping.select_next_item(),
      ["<C-p>"] = cmp.mapping.select_prev_item(),
      ["<C-b>"] = cmp.mapping.scroll_docs(-4),
      ["<C-f>"] = cmp.mapping.scroll_docs(4),
      ["<C-y>"] = cmp.mapping.confirm({ select = true }),
      ["<C-Space>"] = cmp.mapping.complete({}),

      ["<C-l>"] = cmp.mapping(function()
        if luasnip.expand_or_locally_jumpable() then luasnip.expand_or_jump() end
      end, { "i", "s" }),

      ["<C-h>"] = cmp.mapping(function()
        if luasnip.locally_jumpable(-1) then luasnip.jump(-1) end
      end, { "i", "s" }),
    }),
    sources = {
      { name = "nvim_lsp" },
      { name = "luasnip" },
      { name = "path" },
    },
  })
end)

-- mini plugins collections
later(function() add("echasnovski/mini.nvim") end)

-- show git diff
later(function() require("mini.diff").setup() end)
