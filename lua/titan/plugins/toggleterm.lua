local M = {}

local config = {
  desk_integration = true,
}

function M.setup(opts)
  config = vim.tbl_deep_extend('force', config, opts or {})

  -- toggleterm
  local toggleterm = require("toggleterm")

  local function on_first_open(term)
    if config.desk_integration then
      term:send("eval $(desk load)")
    end
  end

  toggleterm.setup{
    size = function(term)
      if term.direction == "horizontal" then
        return 20
      elseif term.direction == "vertical" then
        return vim.o.columns * 0.4
      end
    end,
    persist_size = false,
    on_open = function(term)
      term.opened = term.opened or false

      if not term.opened then
        on_first_open(term)
      end

      term.opened = true
    end,
  }

  function _G.set_terminal_keymaps()
    local keymap_opts = {noremap = true}
    vim.api.nvim_buf_set_keymap(0, 't', '<esc>', [[<C-\><C-n>]], keymap_opts)
    vim.api.nvim_buf_set_keymap(0, 't', '<C-h>', [[<C-\><C-n><C-W>h]], keymap_opts)
    vim.api.nvim_buf_set_keymap(0, 't', '<C-j>', [[<C-\><C-n><C-W>j]], keymap_opts)
    vim.api.nvim_buf_set_keymap(0, 't', '<C-k>', [[<C-\><C-n><C-W>k]], keymap_opts)
    vim.api.nvim_buf_set_keymap(0, 't', '<C-l>', [[<C-\><C-n><C-W>l]], keymap_opts)
  end

  -- if you only want these mappings for toggle term use term://*toggleterm#* instead
  vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')

  require('telescope').load_extension("termfinder")
end

return M
