local M = {}

function M.setup()
  -- Options from kickstart.nvim

  --Set highlight on search
  vim.o.hlsearch = true

  --Make line numbers default
  vim.wo.number = true

  --Enable mouse mode
  vim.o.mouse = 'a'

  --Enable break indent
  vim.o.breakindent = true

  --Save undo history
  vim.opt.undofile = true

  --Case insensitive searching UNLESS /C or capital in search
  vim.o.ignorecase = true
  vim.o.smartcase = true

  --Decrease update time
  vim.o.updatetime = 250
  vim.wo.signcolumn = 'yes'

  -- Set completeopt to have a better completion experience
  vim.o.completeopt = 'menuone,noselect'

  -- End kickstart.nvim options

  --Set colorscheme
  vim.o.termguicolors = true
  vim.cmd [[colorscheme lunarized]]

  -- Use visual bell
  vim.o.visualbell = true

  -- Enable hidden buffers
  vim.o.hidden = true

  -- Automatically reload files changed outside of vim
  vim.o.autoread = true

  -- Enable system clipboard
  vim.o.clipboard = "unnamedplus"

  --Incremental live completion (note: this is now a default on master)
  vim.o.inccommand = 'nosplit'

  --Decrease update time
  vim.o.updatetime = 250
  vim.opt.timeoutlen = 500
  vim.opt.ttimeoutlen = 10
  vim.wo.signcolumn = 'yes'

  --Indenting/tabs/spaces
  vim.o.autoindent = true
  vim.o.smartindent = true
  vim.o.smarttab = true
  vim.o.shiftwidth = 2
  vim.o.softtabstop = 2
  vim.o.tabstop = 2
  vim.o.expandtab = true

  --Don't show mode (lualine does it already)
  vim.o.showmode = false

  --Make sure we can see context above/below the cursor
  vim.o.scrolloff = 5

  -- Configure Beacon
  vim.g.beacon_size = 90
  vim.g.beacon_minimal_jump = 25
  vim.g.beacon_ignore_filetypes = { "fzf" }

  -- Setup cursorhold
  -- vim.g.cursorhold_updatetime = 100
end

return M
