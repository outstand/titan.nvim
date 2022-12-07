local M = {}

local plugin_specs = nil
local function use(plugin_spec)
  plugin_specs[#plugin_specs + 1] = {
    spec = plugin_spec,
    line = debug.getinfo(2, 'l').currentline,
  }
end

function M.reset()
  plugin_specs = {}
end

function M.config()
  M.reset()

  use 'wbthomason/packer.nvim' -- Package manager

  use 'outstand/titan.nvim'

  use 'tpope/vim-fugitive' -- Git commands in nvim
  use 'tpope/vim-rhubarb' -- Fugitive-companion to interact with github
  use 'numToStr/Comment.nvim' -- "gc" to comment visual regions/lines
  use 'ludovicchabant/vim-gutentags' -- Automatic tags management
  -- UI to select things (files, grep results, open buffers...)
  use { 'nvim-telescope/telescope.nvim', requires = { 'nvim-lua/plenary.nvim' } }
  use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
  -- Add indentation guides even on blank lines
  use 'lukas-reineke/indent-blankline.nvim'
  -- Add git related info in the signs columns and popups
  use { 'lewis6991/gitsigns.nvim', requires = { 'nvim-lua/plenary.nvim' } }
  -- Github coauthors
  use "cwebster2/github-coauthors.nvim"
  -- Highlight, edit, and navigate code using a fast incremental parsing library
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate'
  }
  -- Additional textobjects for treesitter
  use 'nvim-treesitter/nvim-treesitter-textobjects'
  use 'neovim/nvim-lspconfig' -- Collection of configurations for built-in LSP client
  use "williamboman/mason.nvim"
  use "williamboman/mason-lspconfig.nvim"
  use 'hrsh7th/nvim-cmp' -- Autocompletion plugin
  use 'hrsh7th/cmp-nvim-lsp'
  use 'saadparwaiz1/cmp_luasnip'
  use 'L3MON4D3/LuaSnip' -- Snippets plugin

  use 'mfussenegger/nvim-dap'
  use "rcarriga/nvim-dap-ui"
  use "theHamsta/nvim-dap-virtual-text"
  use "jbyuki/one-small-step-for-vimkind"

  -- Language enhancements
  use "jose-elias-alvarez/typescript.nvim"

  -- Customizations
  use "rktjmp/lush.nvim"
  use "rktjmp/shipwright.nvim"
  use "ryansch/lunarized"
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons' }
  }
  use "folke/which-key.nvim"
  use {
      'goolord/alpha-nvim',
      requires = { 'kyazdani42/nvim-web-devicons' },
      config = function ()
          require'alpha'.setup(require'alpha.themes.startify'.config)
      end
  }
  use {
    'kyazdani42/nvim-tree.lua',
    requires = {
      'kyazdani42/nvim-web-devicons',
    },
  }
  use 'tpope/vim-eunuch'
  use 'christoomey/vim-tmux-navigator'
  use {'pwntester/octo.nvim' }
  -- use "editorconfig/editorconfig-vim"
  use 'tpope/vim-rails'
  use 'tpope/vim-rake'
  use 'tpope/vim-rvm'
  use 'rafamadriz/friendly-snippets' -- TODO: Set up
  use 'sheerun/vim-polyglot'
  use 'bfredl/nvim-luadev'
  use 'outstand/logger.nvim'
  use 'nvim-lua/lsp-status.nvim'
  use 'mhartington/formatter.nvim'
  use {
    'rcarriga/nvim-notify',
    config = function()
      vim.notify = require("notify")
    end,
  }

  use {
    "folke/trouble.nvim",
    requires = "kyazdani42/nvim-web-devicons",
    config = function()
      require("trouble").setup {}
    end
  }

  use "vim-test/vim-test"
  use 'ThePrimeagen/harpoon'
  use 'akinsho/toggleterm.nvim'
  use 'tknightz/telescope-termfinder.nvim'
  use "nanozuki/tabby.nvim"

  return plugin_specs
end

return M
