local M = {}

local util = require 'packer.util'

function M.plugin_name(plugin_spec, spec_line)
  local spec_type = type(plugin_spec)
  if spec_type == 'string' then
    plugin_spec = { plugin_spec }
  end

  if plugin_spec[1] == vim.NIL or plugin_spec[1] == nil then
    logger.warn('No plugin name provided at line ' .. spec_line .. '!')
    return
  end

  local path = vim.fn.expand(plugin_spec[1])
  local name_segments = vim.split(path, util.get_separator())
  local segment_idx = #name_segments
  local name = plugin_spec.as or name_segments[segment_idx]
  while name == '' and segment_idx > 0 do
    name = name_segments[segment_idx]
    segment_idx = segment_idx - 1
  end

  if name == '' then
    logger.warn('"' .. plugin_spec[1] .. '" is an invalid plugin name!')
    return
  end

  return name
end

return M
