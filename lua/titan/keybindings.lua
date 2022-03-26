local M = {}

function M.setup()
  -- which-key
  local wk = require('which-key')

  wk.setup {
    window = {
      border = "single"
    }
  }
  wk.register({
    d = {
      name = "debugger",
      l = {
        name = "lua",
        l = { "<Plug>(Luadev-RunLine)", "Execute the current line" },
        r = { "<Plug>(Luadev-Run)", "Execute lua code over a movement or text object" },
        w = { "<Plug>(Luadev-RunWord)", "Eval identifier under cursor" },
      },
    },
    r = {
      name = "runners",
      f = { "<cmd>Format<cr>", "Format" },
      r = { "", "Run _repl"}, -- TODO
      t = { "<cmd>TestNearest<cr>", "Run _test under cursor"},
      T = { "<cmd>TestNearest<cr>", "Run _test under cursor (background)"}, -- TODO
      a = { "<cmd>TestFile<cr>", "Run _all tests for file"},
      A = { "<cmd>TestFile<cr>", "Run _all tests for file (background)"}, -- TODO
      l = { "<cmd>TestLast<cr>", "Run _last test"},
      L = { "<cmd>TestLast<cr>", "Run _last test (background)"}, -- TODO
      v = { "<cmd>TestVisit<cr>", "Open last test file used"},
    },
    t = {
      name = "terminal",
      f = { "<cmd>ToggleTerm direction=float<cr>", "Float" },
      h = { "<cmd>ToggleTerm direction=horizontal<cr>", "Horizontal" },
      v = { "<cmd>ToggleTerm direction=vertical<cr>", "Vertical" },
    },
  }, { prefix = "<leader>" })

  -- Diagnostic keymaps
  vim.api.nvim_set_keymap('n', '<leader>e', '<cmd>lua vim.diagnostic.open_float()<CR>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', '<leader>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', { noremap = true, silent = true })
end

return M
