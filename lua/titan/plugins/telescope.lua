local M = {}

local config = {
  defaults = {
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
        ['<C-a>'] = "select_all",
      },
    },
  },
  pickers = {
    buffers = {
      sort_mru = true,
    },
  },
}

function M.setup(opts)
  config = vim.tbl_deep_extend('force', config, opts or {})

  require('telescope').setup(config)

  -- Enable telescope fzf native
  require('telescope').load_extension 'fzf'

  -- Enable githubcoauthors
  require('telescope').load_extension('githubcoauthors')

  -- which-key
  local wk = require('which-key')
  local t_builtin = require('telescope.builtin')

  local function find_command()
    return { "fd", "--type", "f", "--no-ignore-vcs" }
  end

  local function find_files()
    t_builtin.find_files({
        find_command = find_command,
        hidden = true,
    })
  end

  wk.register({
    f = {
      name = "telescope finders",
      b = { t_builtin.buffers, "Lists open buffers" },
      c = { require('telescope').extensions.githubcoauthors.coauthors, "Add coauthors" },
      f = { find_files, "Find file" },
      h = { t_builtin.help_tags, "Lists available help tags " },
      t = { t_builtin.tags, "Lists tags in current directory " },
      g = { t_builtin.live_grep, "Search for a string" },
      ['?'] = { t_builtin.oldfiles, "Lists previously open files" },
    },
    l = {
      name = "telescope LSP",
      a = { t_builtin.diagostics, "Lists diagnostics" },
      d = { t_builtin.lsp_definitions, "Goto definition" },
      D = { t_builtin.lsp_type_definitions, "Goto type definition" },
      r = { t_builtin.lsp_references, "Lists LSP references" },
      i = { t_builtin.lsp_implementations, "Goto implementation" },
      s = { t_builtin.lsp_document_symbols, "Lists LSP document symbols" },
      w = { t_builtin.lsp_dynamic_workspace_symbols, "Dynamically Lists LSP for all workspace symbols" },
    },
  }, { prefix = "<leader>" })

end

return M
