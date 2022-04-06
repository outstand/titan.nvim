local M = {}

local lsputil = require("lspconfig.util")

function M.dir_has_file(dir, name)
  return lsputil.path.exists(lsputil.path.join(dir, name)), lsputil.path.join(dir, name)
end

function M.workspace_root()
  local cwd = vim.loop.cwd()

  if M.dir_has_file(cwd, "compose.yml") or M.dir_has_file(cwd, "docker-compose.yml") then
    return cwd
  end

  local function cb(dir, _)
    return M.dir_has_file(dir, "compose.yml") or M.dir_has_file(dir, "docker-compose.yml")
  end

  local root, _ = lsputil.path.traverse_parents(cwd, cb)
  return root
end

function M.workspace_has_file(name)
  local root = M.workspace_root()
  if not root then
    root = vim.loop.cwd()
  end

  return M.dir_has_file(root, name)
end

return M
