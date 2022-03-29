local M = {}

local config = {
  load = {},
}

M.plugins = {
  "comment",
  "gitsigns",
  "lualine",
  "nvim-tree",
  "tabby",
  "telescope",
  "toggleterm",
  "vim-test",
}

-- function M.maybe_load_plugin(name, load, plugin_config)
function M.maybe_load_plugin(opts)
  local load = opts.load
  if type(load) == 'nil' then
    load = true
  end

  logger.debug("maybe_load_plugin", opts.name, load, opts.plugin_config)
  if not load then
    return
  end

  local path = "titan.plugins." .. opts.name
  require(path).setup(opts.plugin_config)
end

function M.setup(opts)
  config = vim.tbl_deep_extend('force', config, opts or {})

  for _, name in ipairs(M.plugins) do
    if type(config.load[name]) == 'nil' then
      config.load[name] = true
    end

    config[name] = config[name] or {}
    M.maybe_load_plugin{
      name = name,
      load = config.load[name],
      plugin_config = config[name],
    }
  end
end

return M
