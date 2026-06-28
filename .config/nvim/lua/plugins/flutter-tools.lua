-- Flutter-tools: device picker, run/attach, hot reload, devtools, outline.
-- Integrates with nvim-dap for breakpoint debugging and dartls for LSP features.
-- Keymaps mirror VSCode Flutter workflow: <leader>a attach, <leader>n select device.

return {
  {
    "nvim-flutter/flutter-tools.nvim",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio",
    },
    opts = {
      -- Resolve the real flutter binary via mise to avoid shim symlink issue.
      -- fn.exepath returns the mise shim; fn.resolve follows shim -> /usr/bin/mise
      -- which makes flutter-tools incorrectly derive SDK root as /usr.
      flutter_path = (function()
        local p = vim.fn.system("mise which flutter 2>/dev/null"):gsub("%s+", "")
        if p == "" then return vim.fn.exepath("flutter") end
        return p
      end)(),
      fvm = false,
      widget_guides = { enabled = true, debug = false },
      closing_tags = { highlight = "Identifier", enabled = true },
      dev_log = {
        enabled = true,
        open_cmd = "20split",
        filter = nil,
      },
      dev_tools = {
        autoscroll = true,
        open_cmd = "tab",
      },
      outline = { open_cmd = "30vnew" },
      debugger = {
        enabled = true,
        run_via_dap = true,
        register_configurations = function(paths)
          local dap = require("dap")
          dap.configurations.dart = {
            {
              type = "dart",
              request = "launch",
              name = "Launch Flutter (debug)",
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
              vmServiceUri = function()
                return vim.fn.input("VM Service URI: ")
              end,
              toolRetryDelayms = 200,
            },
          }
        end,
      },
      lsp = {
        color = { enabled = false }, -- handled by vim.lsp.document_color on Nvim 0.12+
        capabilities = nil,
        settings = {
          dart = {
            lineLength = 120,
            suggestSnippets = true,
            updateImportsOnRename = true,
            renameFilesWithClasses = "prompt",
            analyzeAngularTemplates = true,
            enableSnippets = true,
            showTodos = true,
          },
        },
      },
    },
    keys = {
      -- Run / debug
      { "<leader>rr", function() require("flutter-tools").run() end, desc = "Flutter run" },
      { "<leader>rR", function() require("flutter-tools").restart() end, desc = "Flutter hot restart" },
      { "<leader>rl", function() require("flutter-tools").reload() end, desc = "Flutter hot reload" },

      -- Attach to running app (VSCode muscle memory: <leader>a)
      { "<leader>a", function() require("flutter-tools").attach() end, desc = "Flutter attach" },

      -- Device selection (VSCode muscle memory: <leader>n)
      { "<leader>n", function() require("flutter-tools").devices() end, desc = "Flutter select device" },

      -- DevTools / outline
      { "<leader>rd", function() require("flutter-tools").dev_tools() end, desc = "Flutter DevTools" },
      { "<leader>ro", function() require("flutter-tools").outline() end, desc = "Flutter widget outline" },

      -- LSP
      { "<leader>rL", function() require("flutter-tools").lsp_restart() end, desc = "Flutter LSP restart" },
    },
  },
}
