-- Debug Adapter Protocol: nvim-dap + dap-ui + virtual-text.
-- Adapters: dart (dart-debug-adapter via mason), php (php-debug-adapter / Xdebug via mason).
-- Keymaps restore the VSCode bindings: <leader>b toggle breakpoint, <leader>r run/continue.

local M = {}

-- Resolve the absolute path to a mason-installed binary.
local function mason_bin(name)
  local path = vim.fn.stdpath("data") .. "/mason/bin/" .. name
  return vim.fn.exepath(path) ~= "" and path or nil
end

return {
  {
    "mfussenegger/nvim-dap",
    event = "VeryLazy",
    dependencies = {
      { "rcarriga/nvim-dap-ui", dependencies = { "nvim-neotest/nvim-nio" } },
      "theHamsta/nvim-dap-virtual-text",
      "williamboman/mason.nvim",
      "folke/neodev.nvim",
    },
    -- Wire keymaps eagerly (before dap UI loads) so they work even if user
    -- hasn't opened the UI yet.
    keys = function()
      local K = vim.keymap.set
      local dap = require("dap")
      return {
        { "<leader>db", function() dap.toggle_breakpoint() end, desc = "Toggle breakpoint" },
        { "<leader>dB", function() dap.set_breakpoint(vim.fn.input("Breakpoint condition: ")) end, desc = "Conditional breakpoint" },
        { "<leader>dg", function() dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: ")) end, desc = "Log point" },
        { "<leader>dc", function() dap.continue() end, desc = "Continue / start debug" },
        { "<leader>dr", function()
          -- "Smart run": mirrors VSCode <leader>r debug run/continue
          dap.continue()
        end, desc = "Run / continue" },
        { "<leader>di", function() dap.step_into() end, desc = "Step into" },
        { "<leader>do", function() dap.step_over() end, desc = "Step over" },
        { "<leader>dO", function() dap.step_out() end, desc = "Step out" },
        { "<leader>dk", function() dap.step_back() end, desc = "Step back" },
        { "<leader>dU", function() dap.up() end, desc = "Up stack frame" },
        { "<leader>dD", function() dap.down() end, desc = "Down stack frame" },
        { "<leader>dt", function() dap.terminate() end, desc = "Terminate session" },
        { "<leader>dx", function()
          dap.terminate()
          require("dapui").close()
        end, desc = "Terminate + close UI" },
        { "<leader>dR", function() dap.repl.toggle() end, desc = "Toggle REPL" },
        { "<leader>dp", function() dap.pause() end, desc = "Pause" },
        { "<F5>",  function() dap.continue() end,    desc = "DAP continue" },
        { "<F6>",  function() dap.step_over() end,   desc = "DAP step over" },
        { "<F7>",  function() dap.step_into() end,   desc = "DAP step into" },
        { "<F8>",  function() dap.step_out() end,    desc = "DAP step out" },
        { "<F9>",  function() dap.toggle_breakpoint() end, desc = "DAP toggle breakpoint" },
      }
    end,
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      -- Signs: VSCode-style red circle for breakpoints
      local sign_bp = vim.fn.sign_getdefined("DapBreakpoint")
      if sign_bp and #sign_bp == 0 then
        vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticSignError", linehl = "", numhl = "" })
        vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DiagnosticSignWarn", linehl = "", numhl = "" })
        vim.fn.sign_define("DapBreakpointRejected", { text = "◆", texthl = "DiagnosticSignHint", linehl = "", numhl = "" })
        vim.fn.sign_define("DapLogPoint", { text = "◆", texthl = "DiagnosticSignInfo", linehl = "", numhl = "" })
        vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DiagnosticSignWarn", linehl = "DebugPC", numhl = "DapStopped" })
      end

      -- Auto-open/close dap-ui on session lifecycle
      dap.listeners.before.attach["user_dapui"] = function() dapui.open() end
      dap.listeners.before.launch["user_dapui"] = function() dapui.open() end
      dap.listeners.before.event_terminated["user_dapui"] = function() dapui.close() end
      dap.listeners.before.event_exited["user_dapui"] = function() dapui.close() end

      -- Adapters ---------------------------------------------------------------------

      -- Dart / Flutter: dart-debug-adapter (aka "dart debug adapter" MS-vintage)
      -- Mason installs it as `dart-debug-adapter` (executable shim).
      local dart_bin = mason_bin("dart-debug-adapter")
      if dart_bin then
        dap.adapters.dart = {
          type = "executable",
          command = dart_bin,
          args = { "flutter" },
          -- flutter adapter runs on port 43500 by default
          options = { detached = false },
        }
        -- Some adapter scripts use the "flutter debugger" entry directly. Provide both names.
        dap.adapters.flutter = dap.adapters.dart
      end

      -- PHP / Xdebug: php-debug-adapter (installed via mason above)
      local php_bin = mason_bin("php-debug-adapter")
      if php_bin then
        dap.adapters.php = {
          type = "executable",
          command = php_bin,
          args = { "run" },
        }
      end

      -- Configurations ----------------------------------------------------------------
      -- Per-language. They only apply when the matching filetype is active.

      dap.configurations.dart = {
        {
          type = "dart",
          request = "launch",
          name = "Launch Flutter (debug)",
          -- dart.debugExternalPackageLibraries: true (VSCode setting)
          -- is honored by the adapter via name; here we request a no- Observatory
          -- session by default. vim.fn.getcwd is the project root.
          cwd = "${workspaceFolder}",
          program = "${workspaceFolder}/lib/main.dart",
          args = {},
          toolRetryDelayms = 200,
        },
        {
          type = "dart",
          request = "attach",
          name = "Attach to running Flutter",
          cwd = "${workspaceFolder}",
          -- matches VSCode flutter.attach
          vmServiceUri = function()
            return vim.fn.input("VM Service URI: ")
          end,
          toolRetryDelayms = 200,
        },
      }

      dap.configurations.php = {
        {
          type = "php",
          request = "launch",
          name = "Listen for Xdebug (default)",
          port = 9003,
          -- pathMappings keyed to project root so remote paths map correctly
          pathMappings = {
            ["/var/www/html"] = "${workspaceFolder}",
          },
        },
        {
          type = "php",
          request = "launch",
          name = "Run current PHP file",
          port = 9003,
          program = "${file}",
          cwd = "${workspaceFolder}",
        },
      }
    end,
  },

  -- nvim-dap-ui: the sidebar with scopes/stack/breakpoints/watch/repl.
  {
    "rcarriga/nvim-dap-ui",
    event = "VeryLazy",
    dependencies = { "nvim-neotest/nvim-nio", "mfussenegger/nvim-dap" },
    keys = {
      { "<leader>du", function() require("dapui").toggle() end, desc = "Toggle DAP UI" },
      { "<leader>de", function() require("dapui").eval() end, desc = "Eval word/selection" },
      { "<leader>de", function() require("dapui").eval() end, mode = "x", desc = "Eval selection" },
    },
    opts = {
      icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
      mappings = {
        expand = { "<CR>", "<2-LeftMouse>" },
        open = "o",
        remove = "d",
        edit = "e",
        repl = "r",
        toggle = "t",
      },
      expand_lines = true,
      layouts = {
        {
          elements = {
            { id = "scopes", size = 0.40 },
            { id = "breakpoints", size = 0.20 },
            { id = "stacks", size = 0.25 },
            { id = "watches", size = 0.15 },
          },
          size = 40,
          position = "left",
        },
        {
          elements = { { id = "repl", size = 0.55 }, { id = "console", size = 0.45 } },
          size = 0.30,
          position = "bottom",
        },
      },
      controls = {
        enabled = true,
        element = "repl",
        icons = {
          pause = "󰏤", play = "󰐊", step_into = "󰿕", step_over = "󰆷",
          step_out = "󰆹", step_back = "󁺮", run_last = "↻",
          terminate = "󰜘", disconnect = "󱒾",
        },
      },
      floating = { max_height = nil, max_width = nil, border = "rounded", mappings = { close = { "q", "<Esc>" } } },
      render = { max_type_length = nil, max_value_lines = 100 },
      windows = { indent = 1 },
    },
  },

  -- nvim-dap-virtual-text: inline variable values while stopped at a breakpoint
  {
    "theHamsta/nvim-dap-virtual-text",
    event = "VeryLazy",
    dependencies = { "mfussenegger/nvim-dap", "nvim-treesitter/nvim-treesitter" },
    opts = {
      enabled = true,
      enable_commands = false,
      highlight_changed_variables = true,
      highlight_new_as_changed = true,
      show_stop_reason = true,
      commented = false,
      only_first_definition = true,
      all_references = false,
      clear_on_continue = false,
      virt_text_pos = "eol",
      all_frames = false,
      virt_lines = false,
      virt_text_win_col = nil,
    },
  },
}