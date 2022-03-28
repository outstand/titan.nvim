local M = {}

local config = {
}

function M.setup(opts)
  config = vim.tbl_deep_extend('force', config, opts or {})

  --Set statusbar
  local lunarized_lualine = require('lunarized.lualine')
  local function toggleterm_statusline()
    return 'ToggleTerm #' .. vim.b.toggle_number
  end
  local custom_toggleterm = {
    sections = {
      lualine_a = {'mode'},
      lualine_b = { toggleterm_statusline },
    },
    inactive_sections = {
      lualine_c = { toggleterm_statusline },
    },
    filetypes = { 'toggleterm' },
  }

  require('lualine').setup {
    options = {
      icons_enabled = true,
      theme = lunarized_lualine,
      component_separators = '|',
      section_separators = '',
    },
    sections = {
      lualine_a = {'mode'},
      lualine_b = {'branch', 'diff', 'diagnostics'},
      lualine_c = {'filename', "require'lsp-status'.status()"},
      lualine_x = {'encoding', 'fileformat', 'filetype'},
      lualine_y = {'progress'},
      lualine_z = {'location'}
    },
    extensions = {
      custom_toggleterm,
      'fugitive',
      'nvim-tree',
      'quickfix',
    },
  }
end

return M
