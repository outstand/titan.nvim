local M = {}

function M.setup()
  -- Treesitter configuration
  -- Parsers must be installed manually via :TSInstall
  local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
  parser_config.ruby = {
    install_info = {
      url = "https://github.com/tree-sitter/tree-sitter-ruby",
      revision = "c91960320d0f337bdd48308a8ad5500bd2616979", -- v0.20.0
      files = { "src/parser.c", "src/scanner.cc" },
    },
  }

  require('nvim-treesitter.configs').setup {
    ensure_installed = {
      'bash',
      'comment',
      'css',
      'dockerfile',
      -- 'elixir',
      'erlang',
      'gitcommit',
      'gitignore',
      'go',
      'graphql',
      'heex',
      'html',
      'http',
      'javascript',
      'json',
      'json5',
      'lua',
      'make',
      'markdown',
      'nix',
      'python',
      'regex',
      'ruby',
      'rust',
      'terraform',
      'toml',
      'tsx',
      'typescript',
      'vim',
      'yaml',
    },
    highlight = {
      enable = true, -- false will disable the whole extension
      disable = {
        "elixir"
      }
    },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = 'gnn',
        node_incremental = 'grn',
        scope_incremental = 'grc',
        node_decremental = 'grm',
      },
    },
    indent = {
      enable = false,
    },
    textobjects = {
      select = {
        enable = true,
        lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
        keymaps = {
          -- You can use the capture groups defined in textobjects.scm
          ['af'] = '@function.outer',
          ['if'] = '@function.inner',
          ['ac'] = '@class.outer',
          ['ic'] = '@class.inner',
        },
      },
      move = {
        enable = true,
        set_jumps = true, -- whether to set jumps in the jumplist
        goto_next_start = {
          [']m'] = '@function.outer',
          [']]'] = '@class.outer',
        },
        goto_next_end = {
          [']M'] = '@function.outer',
          [']['] = '@class.outer',
        },
        goto_previous_start = {
          ['[m'] = '@function.outer',
          ['[['] = '@class.outer',
        },
        goto_previous_end = {
          ['[M'] = '@function.outer',
          ['[]'] = '@class.outer',
        },
      },
    },
    playground = {
      enable = true,
      disable = {},
      updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
      persist_queries = false, -- Whether the query persists across vim sessions
      keybindings = {
        toggle_query_editor = 'o',
        toggle_hl_groups = 'i',
        toggle_injected_languages = 't',
        toggle_anonymous_nodes = 'a',
        toggle_language_display = 'I',
        focus_language = 'f',
        unfocus_language = 'F',
        update = 'R',
        goto_node = '<cr>',
        show_help = '?',
      },
    },
  }
end

return M
