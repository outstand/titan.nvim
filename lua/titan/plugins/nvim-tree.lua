local M = {}

local config = {
}

function M.setup(opts)
  config = vim.tbl_deep_extend('force', config, opts or {})

  local nvim_tree = require("nvim-tree")
  nvim_tree.setup {
    auto_close = true,
  }

  -- which-key
  local wk = require('which-key')
  wk.register({
    o = {
      name = "open",
      d = { function() nvim_tree.toggle(true) end, "Open directory" },
      f = { function() nvim_tree.find_file(true) end, "Focus file in directory" },
    },
  }, { prefix = "<leader>" })

end

return M
