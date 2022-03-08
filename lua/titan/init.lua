local M = {}

M.packer_config = require("titan.packer-config").config()

local default_opts = {
}

function M.setup(conf)
  conf = vim.tbl_deep_extend('force', default_opts, conf or {})

  require('titan.global')
  require("titan.treesitter").setup()
  require("titan.lsp").setup()
  require("titan.formatting").setup()
  require("titan.keybindings").setup()
  require("titan.options").setup()
  require("titan.tabby-config").setup()

  -- nvim-tree
  local nvim_tree = require("nvim-tree")
  nvim_tree.setup {
    auto_close = true,
  }

  -- Gitsigns
  require('gitsigns').setup {
    signs = {
      add = { text = '+' },
      change = { text = '~' },
      delete = { text = '_' },
      topdelete = { text = '‾' },
      changedelete = { text = '~' },
    },
  }

  -- Telescope
  require('telescope').setup {
    defaults = {
      mappings = {
        i = {
          ['<C-u>'] = false,
          ['<C-d>'] = false,
        },
      },
    },
  }

  -- Create window splits easier. The default
  -- way is Ctrl-w,v and Ctrl-w,s. I remap
  -- this to vv and ss
  vim.keymap.set('n', 'vv', '<C-w>v', { noremap=true, silent=true, nowait=true })
  vim.keymap.set('n', 'ss', '<C-w>s', { noremap=true, silent=true, nowait=true })

  -- Clear current search highlight by double tapping //
  vim.api.nvim_set_keymap('n', '//', ':nohlsearch<CR>', { silent = true })

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


  --Enable Comment.nvim
  require('Comment').setup()

  --Remap space as leader key
  vim.api.nvim_set_keymap('', '<Space>', '<Nop>', { noremap = true, silent = true })
  vim.g.mapleader = ' '
  vim.g.maplocalleader = ' '

  --Remap for dealing with word wrap
  vim.api.nvim_set_keymap('n', 'k', "v:count == 0 ? 'gk' : 'k'", { noremap = true, expr = true, silent = true })
  vim.api.nvim_set_keymap('n', 'j', "v:count == 0 ? 'gj' : 'j'", { noremap = true, expr = true, silent = true })

  -- Highlight on yank
  vim.cmd [[
    augroup YankHighlight
      autocmd!
      autocmd TextYankPost * silent! lua vim.highlight.on_yank()
    augroup end
  ]]

  --Map blankline
  vim.g.indent_blankline_char = '┊'
  vim.g.indent_blankline_filetype_exclude = { 'help', 'packer' }
  vim.g.indent_blankline_buftype_exclude = { 'terminal', 'nofile' }
  vim.g.indent_blankline_show_trailing_blankline_indent = false

  -- vim-startify
  vim.g.startify_change_to_vcs_root = 1

  if vim.fn.has('macunix') then
    vim.api.nvim_command('set rtp+=/opt/homebrew/opt/fzf')
  end

  -- gutentags
  vim.g.gutentags_cache_dir = "~/.cache/gutentags"

  -- Enable telescope fzf native
  require('telescope').load_extension 'fzf'

  -- toggleterm
  local toggleterm = require("toggleterm")

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
        term:send("eval $(desk load)")
      end

      term.opened = true
    end,
  }

  function _G.set_terminal_keymaps()
    local opts = {noremap = true}
    vim.api.nvim_buf_set_keymap(0, 't', '<esc>', [[<C-\><C-n>]], opts)
    vim.api.nvim_buf_set_keymap(0, 't', '<C-h>', [[<C-\><C-n><C-W>h]], opts)
    vim.api.nvim_buf_set_keymap(0, 't', '<C-j>', [[<C-\><C-n><C-W>j]], opts)
    vim.api.nvim_buf_set_keymap(0, 't', '<C-k>', [[<C-\><C-n><C-W>k]], opts)
    vim.api.nvim_buf_set_keymap(0, 't', '<C-l>', [[<C-\><C-n><C-W>l]], opts)
  end

  -- if you only want these mappings for toggle term use term://*toggleterm#* instead
  vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')

  require('telescope').load_extension("termfinder")

  vim.g["test#custom_strategies"] = {
    toggleterm = function(cmd)
      toggleterm.exec(cmd)
    end,
  }

  vim.g["test#strategy"] = "toggleterm"
  vim.g["test#ruby#use_binstubs"] = 0
  vim.g["test#ruby#bundle_exec"] = 0

  -- TODO:
  -- If terminal is hidden when tests finish: show notification
  -- Add movement keys to terminal setup
end

return M
-- vim: ts=2 sts=2 sw=2 et
