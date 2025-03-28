-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny

lvim.format_on_save.enabled = true
lvim.keys.insert_mode["jj"] = "<Esc>"
lvim.keys.normal_mode["<leader>p"] = "_dp"
lvim.keys.normal_mode["<C-t>"] = "<cmd>w<CR> <cmd>w<CR>"
vim.api.nvim_set_keymap('n', '<C-t>', '<C-w>w', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>r', ':Scalpel', { noremap = true, silent = true })
vim.opt.relativenumber = true
vim.g.NERDTreeWinSize = 20

lvim.builtin.which_key.mappings["t"] = {
  name = "Trouble",
  l = { "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", "References" },
  s = { "<cmd>Trouble symbols toggle focus=false<cr>", "Symbols" },
  d = { "<cmd>Trouble diagnostics toggle focus=true filter.buf=0<cr>", "Diagnostics" },
  q = { "<cmd>Trouble qflist toggle<cr>", "QuickFix" },
  L = { "<cmd>Trouble loclist toggle<cr>", "LocationList" },
  w = { "<cmd>Trouble diagnostics toggle focus=true<cr>", "Diagnostics" },
}

-- Null-ls Config
local linters = require "lvim.lsp.null-ls.linters"
linters.setup {
  { command = 'eslint', filetypes = { "typescript", "typescriptreact" } }
}

local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
  { name = 'prettier', filetypes = { "typescript", "typescriptreact" } }
}

-- Users Plugins-----------
lvim.plugins = {
  {
    'wassimk/scalpel.nvim',
    version = "*",
    config = true,
    keys = {
      {
        '<leader>r',
        function()
          require('scalpel').substitute()
        end,
        mode = { 'n', 'x' },
        desc = 'substitute word(s)',
      },
    },
  },
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({})
    end,
  },
  {
    "zbirenbaum/copilot-cmp",
    config = function()
      require("copilot_cmp").setup({
        suggestion = { enabled = false },
        panel = { enabled = false }
      })
    end
  },
  {
    "folke/trouble.nvim",
    opts = {}, -- for default options, refer to the configuration section for custom setup.
    cmd = "Trouble",
    keys = {
      {
        "<leader>tw",
        "<cmd>Trouble diagnostics toggle focus=true<cr>",
        desc = "Diagnostics (Trouble)",
      },
      {
        "<leader>td",
        "<cmd>Trouble diagnostics toggle focus=true filter.buf=0<cr>",
        desc = "Buffer Diagnostics (Trouble)",
      },
      {
        "<leader>ts",
        "<cmd>Trouble symbols toggle focus=false<cr>",
        desc = "Symbols (Trouble)",
      },
      {
        "<leader>tl",
        "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
        desc = "LSP Definitions / references / ... (Trouble)",
      },
      {
        "<leader>tL",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "Location List (Trouble)",
      },
      {
        "<leader>tq",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "Quickfix List (Trouble)",
      },
    },
  },
  {
    "Pocco81/auto-save.nvim",
    config = function()
      require("auto-save").setup {
        enabled = true,
        -- your config goes here
        -- or just leave it empty :)
      }
    end,
  },
  {
    "ThePrimeagen/vim-be-good",
  },
}

-- Below config is required to prevent copilot overriding Tab with a suggestion
-- when you're just trying to indent!
local has_words_before = function()
  if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then return false end
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match("^%s*$") == nil
end
local on_tab = vim.schedule_wrap(function(fallback)
  local cmp = require("cmp")
  if cmp.visible() and has_words_before() then
    cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
  else
    fallback()
  end
end)
lvim.builtin.cmp.mapping["<Tab>"] = on_tab
