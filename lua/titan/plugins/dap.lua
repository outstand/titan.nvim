local M = {}

local config = {
}

function M.setup(opts)
  config = vim.tbl_deep_extend('force', config, opts or {})

  local dap_ok, dap = pcall(require, "dap")
  if not dap_ok then return end

  -- local function repl_toggle() require("dap").repl.toggle(nil, "botright split") end
  -- local function continue() require("dap").continue() end
  -- local function step_out() require("dap").step_out() end
  -- local function step_into() require("dap").step_into() end
  -- local function step_over() require("dap").step_over() end
  -- local function run_last() require("dap").run_last() end
  -- local function toggle_breakpoint() require("dap").toggle_breakpoint() end
  -- local function set_breakpoint() require("dap").set_breakpoint(fn.input("Breakpoint condition: ")) end
  --
  -- nnoremap("<localleader>db", toggle_breakpoint, "dap: toggle breakpoint")
  -- nnoremap("<localleader>dB", set_breakpoint, "dap: set breakpoint")
  -- nnoremap("<localleader>dc", continue, "dap: continue or start debugging")
  -- nnoremap("<localleader>de", step_out, "dap: step out")
  -- nnoremap("<localleader>di", step_into, "dap: step into")
  -- nnoremap("<localleader>do", step_over, "dap: step over")
  -- nnoremap("<localleader>dl", run_last, "dap REPL: run last")
  -- nnoremap("<localleader>dt", repl_toggle, "dap REPL: toggle")

  -- dap.adapters.mix_task = {
  --   type = "executable",
  --   command = require("mega.utils").lsp.elixirls_cmd({ debugger = true }),
  --   args = {},
  -- }
  --
  -- dap.configurations.elixir = {
  --   {
  --     type = "mix_task",
  --     name = "mix test",
  --     task = "test",
  --     taskArgs = { "--trace" },
  --     request = "launch",
  --     startApps = true, -- for Phoenix projects
  --     projectDir = "${workspaceFolder}",
  --     requireFiles = {
  --       "test/**/test_helper.exs",
  --       "test/**/*_test.exs",
  --       "apps/**/test/**/test_helper.exs",
  --       "apps/**/test/**/*_test.exs",
  --     },
  --   },
  --   {
  --     type = "mix_task",
  --     name = "phx.server",
  --     request = "launch",
  --     task = "phx.server",
  --     projectDir = ".",
  --   },
  -- }
end

return M
