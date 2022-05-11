_G.logger = require("titan.logger").new {
  level = "info",
}

function _G.put(...)
  return logger.debug(...)
end
