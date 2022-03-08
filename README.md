# titan.nvim

## Recommended setup:

init.lua:
```lua
local ok, _ = pcall(require, "titan.global")
if not ok then
	print("Unable to require titan.global")
end

local user_packer_config = require("user.packer-config").config()

local packer_bootstrap = require("user.packer-bootstrap")
packer_bootstrap.startup(user_packer_config)

local titan = require("titan")
titan.setup{}
```

user/packer-bootstrap.lua:
```lua
-- Install packer
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  _G.packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

-- Install titan
install_path = fn.stdpath('data')..'/site/pack/packer/start/titan.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({'git', 'clone', 'https://github.com/outstand/titan.nvim', install_path})
end

local M = {}

local titan_packer_util = require("titan.packer.util")

function M.startup(user_packer_config)
  local titan_packer_config = require("titan").packer_config

  require('packer').startup(function(use)
    for _, plugin_data in ipairs(titan_packer_config) do
      local plugin_spec = plugin_data.spec
      local spec_line = plugin_data.line

      -- find name
      local name = titan_packer_util.plugin_name(plugin_spec, spec_line)

      -- do we have a user override?
      if user_packer_config.plugin_specs_by_name[name] ~= nil then
        logger.debug("USER: " .. name)
        use(user_packer_config.plugin_specs_by_name[name].spec)
      else
        logger.debug("titan: " .. name)
        use(plugin_spec)
      end
    end

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if _G.packer_bootstrap then
      require('packer').sync()
    end
  end)
end

return M
```

user/packer-config.lua:
```lua
local M = {}

local titan_packer_util = require("titan.packer.util")

local plugin_specs = nil
local plugin_specs_by_name = nil

local function use(plugin_spec)
  local spec = {
    spec = plugin_spec,
    line = debug.getinfo(2, 'l').currentline,
  }
  plugin_specs[#plugin_specs + 1] = spec

  local name = titan_packer_util.plugin_name(spec.spec, spec.line)
  plugin_specs_by_name[name] = spec
end

function M.reset()
  plugin_specs = {}
  plugin_specs_by_name = {}
end

function M.config()
  M.reset()

  -- User plugins and overrides go here
  use "~/dev/titan.nvim"
  use "~/dev/lunarized"

  return {
    plugin_specs = plugin_specs,
    plugin_specs_by_name = plugin_specs_by_name,
  }
end

return M
```
