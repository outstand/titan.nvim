local M = {}

M.packer_config = require("titan.packer-config").config()

local config = {
}

function M.setup(opts)
  config = vim.tbl_deep_extend('force', config, opts or {})

  require('titan.global')
  require("titan.treesitter").setup()
  require("titan.lsp").setup()
  require("titan.formatting").setup()
  require("titan.keybindings").setup()
  require("titan.options").setup()

  require("titan.plugins").setup(config.plugins)

  -- Create window splits easier. The default
  -- way is Ctrl-w,v and Ctrl-w,s. I remap
  -- this to vv and ss
  vim.keymap.set('n', 'vv', '<C-w>v', { noremap=true, silent=true, nowait=true })
  vim.keymap.set('n', 'ss', '<C-w>s', { noremap=true, silent=true, nowait=true })

  -- Clear current search highlight by double tapping //
  vim.api.nvim_set_keymap('n', '//', ':nohlsearch<CR>', { silent = true })


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

  if vim.fn.has('macunix') then
    vim.api.nvim_command('set rtp+=/opt/homebrew/opt/fzf')
  end

  -- gutentags
  vim.g.gutentags_cache_dir = "~/.cache/gutentags"
end

return M
-- vim: ts=2 sts=2 sw=2 et
