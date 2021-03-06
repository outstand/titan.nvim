local M = {}

local config = {
}

function M.setup(opts)
  config = vim.tbl_deep_extend('force', config, opts or {})

  local ok, toggleterm = pcall(require, "toggleterm")
  if ok then
    vim.g["test#custom_strategies"] = {
      toggleterm = function(cmd)
        toggleterm.exec(cmd)
      end,
    }

    vim.g["test#strategy"] = "toggleterm"
  end

  vim.g["test#ruby#use_binstubs"] = 0
  vim.g["test#ruby#bundle_exec"] = 0

  -- TODO:
  -- If terminal is hidden when tests finish: show notification
end

return M
