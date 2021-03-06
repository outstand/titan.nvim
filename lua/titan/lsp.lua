local M = {}

local lsp_installer = require("nvim-lsp-installer")
lsp_installer.setup{
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

local lspconfig = require 'lspconfig'
local lsputil = require("lspconfig.util")

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

--- Build the language server command.
-- @param opts options
-- @param opts.name string Server name
-- @param opts.locations string[] Locations to search relative to the workspace root
-- @param opts.fallback_locations string[] Fallback locations to search relative to
--        nvim-lsp-installer root path or specified fallback_root
-- @param opts.fallback_root? string User customized fallback root. Defaults to
--        ~/.local/share/lsp
-- @return a string containing the command
local function language_server_cmd(opts)
  opts = opts or {}

  local locations = opts.locations or {}
  local fallback_locations = opts.fallback_locations or {}
  local fallback_root = opts.fallback_root or "~/.local/share/lsp"

  local root = util.workspace_root()
  if not root then
    root = vim.loop.cwd()
  end

  for _, location in ipairs(locations) do
    local exists, dir = util.dir_has_file(root, location)
    if exists then
      logger.fmt_debug("language_server_cmd: %s", vim.fn.expand(dir))
      return vim.fn.expand(dir)
    end
  end

  local root_dir

  local server_is_found, server = lsp_installer.get_server(opts.name)
  if server_is_found and server:is_installed() then
    root_dir = server.root_dir
  else
    root_dir = fallback_root
  end

  for _, location in ipairs(fallback_locations) do
    local exists, dir = util.dir_has_file(root_dir, location)
    if exists then
      logger.fmt_debug("language_server_cmd: %s", vim.fn.expand(dir))
      return vim.fn.expand(dir)
    end
  end

  local fallback = vim.fn.expand(lsputil.path.join(fallback_root, fallback_locations[#fallback_locations]))
  logger.fmt_debug("language_server_cmd: %s", fallback)
  return fallback
end

--- Build the elixir-ls command.
-- @param opts options
-- @param opts.fallback_dir string Path to use if locations don't contain the binary
local function elixirls_cmd(opts)
  opts = opts or {}
  opts = vim.tbl_deep_extend(
    "force",
    opts,
    {
      name = "elixirls",
      locations = {
        ".elixir-ls-release/language_server.sh",
        ".elixir_ls/release/language_server.sh",
      },
      fallback_locations = {
        "elixir-ls/language_server.sh",
      },
    }
  )

  return language_server_cmd(opts)
end

--- Build the solargraph command.
-- @param opts options
-- @param opts.fallback_dir string Path to use if locations don't contain the binary
local function solargraph_cmd(opts)
  opts = opts or {}
  opts = vim.tbl_deep_extend(
    "force",
    opts,
    {
      name = "solargraph",
      locations = {
        ".bin/solargraph",
      },
      fallback_locations = {
        "bin/solargraph",
        "solargraph",
      },
    }
  )

  return language_server_cmd(opts)
end

local function tsserver_cmd(opts)
  opts = opts or {}
  opts = vim.tbl_deep_extend(
    "force",
    opts,
    {
      name = "tsserver",
      locations = {
        ".bin/typescript-language-server",
      },
      fallback_locations = {
        "node_modules/.bin/typescript-language-server",
        "typescript-language-server",
      },
    }
  )

  return language_server_cmd(opts)
end

M.custom_commands = nil

function M.add_custom_command(name, cmd)
  M.custom_commands[name] = cmd
end

function M.reload_custom_commands()
  logger.debug("Reload custom commands: ", M.custom_commands)
  for name, cmd in pairs(M.custom_commands) do
    logger.debug("Reloading ", name, cmd)

    local config = lspconfig[name]

    if config.manager then
      for _, client in ipairs(config.manager.clients()) do
        logger.debug("Stopping client", client.name)
        client.stop(true)
      end
    end
  end
end

function M.setup()
  M.custom_commands = {}

  -- vim.lsp.set_log_level("trace")
  -- require("vim.lsp.log").set_format_func(vim.inspect)

  M.add_custom_command("elixirls", function()
    return { elixirls_cmd() }
  end)
  M.add_custom_command("solargraph", function()
    return { solargraph_cmd(), "stdio" }
  end)
  M.add_custom_command("tsserver", function()
    return { tsserver_cmd(), "--stdio" }
  end)

  local enhance_server_opts = {
    ["elixirls"] = function(opts)
      opts.cmd = M.custom_commands.elixirls()
      opts.on_new_config = function(new_config, _)
        new_config.cmd = M.custom_commands.elixirls()
      end
      opts.settings = {
        elixirLS = {
          mixEnv = "test",
        }
      }
    end,
    ["solargraph"] = function(opts)
      opts.cmd = M.custom_commands.solargraph()
      opts.on_new_config = function(new_config, _)
        new_config.cmd = M.custom_commands.solargraph()
      end
      opts.settings = {
        solargraph = {
          folding = false,
          logLevel = "debug",
        }
      }
    end,
    ["tsserver"] = function(opts)
      opts.cmd = M.custom_commands.tsserver()
      opts.on_new_config = function(new_config, _)
        new_config.cmd = M.custom_commands.tsserver()
      end
      opts.init_options = {
        hostInfo = "neovim",
        logVerbosity = "verbose"
      }
    end,
    ["sumneko_lua"] = function(opts)
      local runtime_path = vim.split(package.path, ';')
      table.insert(runtime_path, 'lua/?.lua')
      table.insert(runtime_path, 'lua/?/init.lua')

      opts.settings = {
        Lua = {
          runtime = {
            -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
            version = 'LuaJIT',
            -- Setup your lua path
            path = runtime_path,
          },
          diagnostics = {
            -- Get the language server to recognize the `vim` global
            globals = { 'vim' },
          },
          workspace = {
            -- Make the server aware of Neovim runtime files
            library = vim.api.nvim_get_runtime_file('', true),
            useGitIgnore = false,
          },
          -- Do not send telemetry data containing a randomized but unique identifier
          telemetry = {
            enable = false,
          },
        },
      }
    end,
  }

  for _, server in ipairs(lsp_installer.get_installed_servers()) do
    local opts = {
      on_attach = on_attach,
      capabilities = capabilities,
    }

    if enhance_server_opts[server.name] then
      enhance_server_opts[server.name](opts)
    end

    lspconfig[server.name].setup(opts)
  end

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
