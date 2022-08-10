local M = {}

local mason_lspconfig = require "mason-lspconfig"
local lspconfig = require 'lspconfig'

local util = require("titan.util")

local lsp_status = require("lsp-status")
lsp_status.config {
  current_function = false,
  diagnostics = false,
  status_symbol = '',
}
lsp_status.register_progress()

local function on_attach(client, bufnr)
  local opts = { noremap = true, silent = true }
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'i', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>so', [[<cmd>lua require('telescope.builtin').lsp_document_symbols()<CR>]], opts)

  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>so', [[<cmd>lua require('telescope.builtin').lsp_document_symbols()<CR>]], opts)

  lsp_status.on_attach(client)
end

-- nvim-cmp supports additional completion capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)
capabilities = vim.tbl_extend('keep', capabilities or {}, lsp_status.capabilities)

local function lsp_setup(server_name, opts)
  logger.debug("Adding", server_name, "to lspconfig")
  lspconfig[server_name].setup(opts)
end

local function build_command(server_name, path, args)
  args = args or {}

  local exists, dir = util.workspace_has_file(path)
  logger.debug("workspace_has_file", exists, dir)
  if exists then
    dir = vim.fn.expand(dir)
    logger.fmt_debug("%s: %s %s", server_name, dir, args)
    return vim.list_extend({ dir }, args)
  else
    return nil
  end
end

local function lsp_cmd_override(server_name, opts, cmd_path, args)
  args = args or {}

  local cmd = build_command(server_name, cmd_path, args)
  if cmd ~= nil then
    opts.cmd = cmd
  end

  opts.on_new_config = function(new_config, _)
    local new_cmd = build_command(server_name, cmd_path, args)
    if new_cmd ~= nil then
      new_config.cmd = new_cmd
    end
  end
end

function M.setup()
  require("mason").setup()
  mason_lspconfig.setup {
    ensure_installed = {
      'clangd',
      'rust_analyzer',
      'pyright',
      'terraformls',
      'bashls',
      'elixirls',
      'solargraph',
      'tsserver',
      'sumneko_lua',
    },
  }

  -- vim.lsp.set_log_level("trace")
  -- require("vim.lsp.log").set_format_func(vim.inspect)

  mason_lspconfig.setup_handlers {
    -- The first entry (without a key) will be the default handler
    -- and will be called for each installed server that doesn't have
    -- a dedicated handler.
    function (server_name) -- default handler (optional)
      local opts = {
        on_attach = on_attach,
        capabilities = capabilities,
      }

      lsp_setup(server_name, opts)
    end,

    ["elixirls"] = function(server_name)
      local opts = {
        on_attach = on_attach,
        capabilities = capabilities,
      }

      lsp_cmd_override(
        server_name,
        opts,
        ".elixir-ls-release/language_server.sh"
      )

      opts.settings = {
        elixirLS = {
          mixEnv = "test",
        }
      }

      lsp_setup(server_name, opts)
    end,

    ["solargraph"] = function(server_name)
      local opts = {
        on_attach = on_attach,
        capabilities = capabilities,
      }

      lsp_cmd_override(
        server_name,
        opts,
        ".bin/solargraph",
        { "stdio" }
      )

      opts.settings = {
        solargraph = {
          folding = false,
          logLevel = "debug",
        }
      }

      lsp_setup(server_name, opts)
    end,

    ["tsserver"] = function(server_name)
      local opts = {
        on_attach = on_attach,
        capabilities = capabilities,
      }

      lsp_cmd_override(
        server_name,
        opts,
        ".bin/typescript-language-server",
        { "--stdio" }
      )

      opts.init_options = {
        hostInfo = "neovim",
        logVerbosity = "verbose"
      }

      lsp_setup(server_name, opts)
    end,

    ["sumneko_lua"] = function(server_name)
      local opts = {
        on_attach = on_attach,
        capabilities = capabilities,
      }

      opts.settings = {
        Lua = {
          runtime = {
            -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
            version = 'LuaJIT',
          },
          diagnostics = {
            -- Get the language server to recognize the `vim` global
            globals = {'vim'},
          },
          workspace = {
            -- Make the server aware of Neovim runtime files
            library = vim.api.nvim_get_runtime_file("", true),
          },
          -- Do not send telemetry data containing a randomized but unique identifier
          telemetry = {
            enable = false,
          },
        },
      }

      lsp_setup(server_name, opts)
    end,
  }

  -- luasnip setup
  local luasnip = require 'luasnip'
  luasnip.filetype_extend("ruby", {"rails"})

  -- TODO: Figure out how to get autocomplete working for snippets
  -- nvim-cmp setup
  local cmp = require 'cmp'
  cmp.setup {
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    },
    mapping = {
      ['<C-p>'] = cmp.mapping.select_prev_item(),
      ['<C-n>'] = cmp.mapping.select_next_item(),
      ['<C-d>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.close(),
      ['<CR>'] = cmp.mapping.confirm {
        behavior = cmp.ConfirmBehavior.Replace,
        select = true,
      },
      ['<Tab>'] = function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        else
          fallback()
        end
      end,
      ['<S-Tab>'] = function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end,
    },
    sources = {
      { name = 'nvim_lsp' },
      { name = 'luasnip' },
    },
  }
end

return M
