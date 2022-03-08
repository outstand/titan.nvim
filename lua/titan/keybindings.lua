local M = {}

function M.setup()
  -- which-key
  local wk = require('which-key')
  local t_builtin = require('telescope.builtin')
  local nvim_tree = require("nvim-tree")
  local function find_files()
    t_builtin.find_files({
      hidden = true,
      no_ignore = true,
    })
  end
  wk.setup {
    window = {
      border = "single"
    }
  }
  wk.register({
    f = {
      name = "telescope finders",
      b = { t_builtin.buffers, "Lists open buffers" },
      f = { find_files, "Find file" },
      h = { t_builtin.help_tags, "Lists available help tags " },
      t = { t_builtin.tags, "Lists tags in current directory " },
      g = { t_builtin.live_grep, "Search for a string" },
      ['?'] = { t_builtin.oldfiles, "Lists previously open files" },
    },
    l = {
      name = "telescope LSP",
      a = { t_builtin.diagostics, "Lists diagnostics" },
      d = { t_builtin.lsp_definitions, "Goto definition" },
      D = { t_builtin.lsp_type_definitions, "Goto type definition" },
      r = { t_builtin.lsp_references, "Lists LSP references" },
      i = { t_builtin.lsp_implementations, "Goto implementation" },
      s = { t_builtin.lsp_document_symbols, "Lists LSP document symbols" },
      w = { t_builtin.lsp_dynamic_workspace_symbols, "Dynamically Lists LSP for all workspace symbols" },
    },
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
    o = {
      name = "open",
      d = { function() nvim_tree.toggle(true) end, "Open directory" },
      f = { function() nvim_tree.find_file(true) end, "Focus file in directory" },
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
