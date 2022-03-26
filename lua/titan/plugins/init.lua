local M = {}

local config = {
}

function M.setup(opts)
  config = vim.tbl_deep_extend('force', config, opts or {})

  require("titan.plugins.telescope").setup(config.telescope)
  require("titan.plugins.nvim-tree").setup(config.telescope)
end

return M
