local M = {}

local config = {
  signs = {
    add = { text = '+' },
    change = { text = '~' },
    delete = { text = '_' },
    topdelete = { text = '‾' },
    changedelete = { text = '~' },
  },
}

function M.setup(opts)
  config = vim.tbl_deep_extend('force', config, opts or {})

  -- Gitsigns
  require('gitsigns').setup(config)
end

return M
