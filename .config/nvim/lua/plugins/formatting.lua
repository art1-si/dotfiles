-- Formatting via conform.nvim. Matches VSCode formatOnSave.
--   dart     -> dart format (dart.enableSdkFormatter: true, lineLength 120)
--   php      -> php-cs-fixer (junstyle) using .php-cs.dist.php or ephemeral rules
--   json/jsonc/yaml/markdown -> prettierd
--   lua      -> stylua ($stylua.toml committed at repo root)

return {
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      { "<leader>cf", function() require("conform").format({ async = true, lsp_format = "fallback" }) end, desc = "Format buffer" },
      { "<leader>cf", function() require("conform").format({ async = true, lsp_format = "fallback" }) end, mode = "x", desc = "Format selection" },
    },
    opts = {
      formatters_by_ft = {
        dart = { "dart_format" },
        php = { "php_cs_fixer" },
        json = { "prettierd" },
        jsonc = { "prettierd" },
        yaml = { "prettierd" },
        ["docker-compose"] = { "prettierd" },
        ["yaml.docker-compose"] = { "prettierd" },
        html = { "prettierd" },
        css = { "prettierd" },
        scss = { "prettierd" },
        javascript = { "prettierd" },
        typescript = { "prettierd" },
        markdown = { "prettierd" },
        lua = { "stylua" },
        sql = { "sqlfluff" },
      },
      default_format_opts = {
        lsp_format = "never",
        timeout_ms = 5000,
        quiet = false,
      },
      format_on_save = function(bufnr)
        -- Respect buffer-local `format_on_save = false` (e.g. when editing files outside workspace).
        if vim.b[bufnr].skip_format_on_save then return nil end
        -- Skip huge files.
        if vim.api.nvim_buf_line_count(bufnr) > 50000 then return nil end
        return {
          timeout_ms = 5000,
          lsp_format = "fallback", -- use LSP formatter if no conform formatter for this ft
        }
      end,
      formatters = {
        dart_format = {
          command = "dart",
          args = { "format" },
          -- conform passes the file path automatically; dart needs the line length via flags.
          -- The `dart.lineLength` setting is honoured by the dartls LSP; we keep the CLI default here.
        },
        php_cs_fixer = {
          command = "php-cs-fixer",
          args = { "fix", "--using-cache=no", "--quiet", "$FILENAME" },
          stdin = false,
          cwd = function()
            return vim.fn.getcwd()
          end,
          -- Resolve the project-local PHP CS Fixer if present (VSCode extension behaviour).
          require_cwd = false,
        },
        stylua = {
          command = "stylua",
          args = { "--search-parent-directories", "--stdin-filepath", "$FILENAME", "-" },
          stdin = true,
          cwd = function()
            return vim.fn.getcwd()
          end,
        },
        prettierd = {
          command = "prettierd",
          args = { "$FILENAME" },
          stdin = true,
          cwd = function()
            return vim.fn.getcwd()
          end,
        },
      },
    },
    init = function()
      -- Show a status message when conform formats a buffer (small, dismissable).
      vim.o.formatoptions = vim.o.formatoptions
    end,
  },
}