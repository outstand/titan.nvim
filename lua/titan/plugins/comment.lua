local M = {}

local config = {
}

function M.setup(opts)
  config = vim.tbl_deep_extend('force', config, opts or {})

  require('Comment').setup(config)
end

return M
