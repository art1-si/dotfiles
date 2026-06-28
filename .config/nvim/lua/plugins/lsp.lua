-- LSP: lspconfig + mason.nvim + handlers + on-attach keymaps.
-- Servers: intelephense (php), dartls (dart), jsonls, yamlls, cssls, html, marksman, lua_ls.
-- Formatters live in formatting.lua (conform.nvim); linters live in lint.lua.

local M = {}

-- Map of server name -> config table passed to lspconfig[name].setup().
-- Anything not in this list uses defaults via mason-lspconfig's auto-config.
M.servers = {
  -- PHP: intelephense, mirroring VSCode intelephense-client config.
  intelephense = {
    settings = {
      intelephense = {
        format = { enable = false }, -- formatting handled by php-cs-fixer (conform.nvim)
        environment = { phpVersion = "8.3" },
        files = {
          maxSize = 5000000,
          associations = { "*.php", "*.phtml", "*.module" },
        },
        diagnostics = { enable = true },
        -- mirror VSCode php.inlayHints.*.enabled = false
        inlayHints = { paramsEnabled = false, typesLambdaParameter = false },
      },
    },
  },

  -- Dart/Flutter
  dartls = {
    settings = {
      dart = {
        lineLength = 120, -- matches dart.lineLength
        suggestSnippets = true,
        updateImportsOnRename = true,
        renameFilesWithClasses = "prompt", -- matches dart.renameFilesWithClasses
        analyzeAngularTemplates = true,
        enableSnippets = true,
        showTodos = true, -- matches dart.showTodos
        -- debugExternalPackageLibraries handled in dap.lua phase 5
      },
    },
  },

  -- Lua for editing this very config
  lua_ls = {
    settings = {
      Lua = {
        runtime = { version = "LuaJIT", path = vim.split(package.path, ";") },
        diagnostics = { globals = { "vim" } },
        workspace = {
          checkThirdParty = false,
          library = { vim.env.VIMRUNTIME },
          maxPreload = 2000, preloadFileSize = 50000,
        },
        telemetry = { enable = false },
      },
    },
  },

  -- JSON / YAML / CSS / HTML / Markdown
  jsonls = {
    settings = {
      json = {
        -- schemas resolved at config-time below, not at module-load
        validate = { enable = true },
      },
    },
  },
  yamlls = {
    settings = {
      yaml = {
        schemaStore = { enable = true, url = "" },
        schemas = {
          ["https://json.schemastore.org/bitbucket-pipelines.json"] = "bitbucket-pipelines.yml",
        },
        validate = true,
        hover = true,
      },
    },
  },
  cssls = { settings = { css = { validate = true, lint = { argumentsInColorFunction = "warning" } } } },
  html = {},
  marksman = {},
}

return {
  -- mason.nvim: install/upgrade external tools (servers, formatters, DAP adapters).
  {
    "williamboman/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonLog" },
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      ui = {
        border = "rounded",
        icons = { package_installed = "✓", package_pending = "➜", package_uninstalled = "✗" },
      },
      max_concurrent_installers = 4,
      registries = { "github:mason-org/mason-registry" },
    },
  },

  -- mason-lspconfig: bridge between mason installed packages and lspconfig.
  {
    "williamboman/mason-lspconfig.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
    opts = {
      ensure_installed = vim.tbl_keys(M.servers),
      automatic_installation = true,
    },
  },

  -- SchemaStore (for jsonls schemas).
  {
    "b0o/schemastore.nvim",
    lazy = true,
  },

  -- nvim-lspconfig: actual LSP setup using handlers.
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      -- cmp-nvim-lsp intentionally omitted — we use blink.cmp, not nvim-cmp
      "folke/neoconf.nvim",
    },
    config = function()
      require("neoconf").setup()
      local lspconfig = require("lspconfig")
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      -- blink.cmp capabilities
      local ok, blink = pcall(require, "blink.cmp")
      if ok and blink.get_lsp_capabilities then
        capabilities = blink.get_lsp_capabilities(capabilities)
      elseif package.loaded["cmp_nvim_lsp"] then
        capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
      end
      -- fold range provider for nvim-ufo future use
      capabilities.textDocument.foldingRange = { dynamicRegistration = false, lineFoldingOnly = true }

      -- Custom keymaps attached to every LSP-enabled buffer.
      local on_attach = function(client, bufnr)
        local K = function(lhs, action, desc)
          vim.keymap.set("n", lhs, action, { buffer = bufnr, silent = true, noremap = true, desc = "LSP: " .. desc })
        end

        -- Navigation (these match VSCode shift+space d / F12 family, on <leader>l prefix)
        K("<leader>ld", vim.lsp.buf.definition, "Go to definition")
        K("<leader>lD", vim.lsp.buf.declaration, "Go to declaration")
        K("<leader>lt", vim.lsp.buf.type_definition, "Go to type definition")
        K("<leader>li", vim.lsp.buf.implementation, "Go to implementation")
        K("<leader>lr", vim.lsp.buf.references, "Find references")
        K("<leader>ls", vim.lsp.buf.document_symbol, "Document symbols")
        K("<leader>lS", vim.lsp.buf.workspace_symbol, "Workspace symbols")

        -- Hover + signature (K shows hover natively in vim; bind a key too)
        K("<leader>lk", vim.lsp.buf.hover, "Hover")
        K("<C-k>", vim.lsp.buf.signature_help, "Signature help")

        -- Actions
        K("<leader>la", vim.lsp.buf.code_action, "Code action")
        K("<leader>ln", vim.lsp.buf.rename, "Rename (F2)")
        K("<leader>lf", function()
          require("conform").format({ bufnr = bufnr, async = true, lsp_format = "fallback" })
        end, "Format buffer")

        -- Diagnostics
        K("<leader>ll", vim.diagnostic.open_float, "Line diagnostic")
        K("]d", function() vim.diagnostic.jump({ count = 1, float = true }) end, "Next diagnostic")
        K("[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, "Prev diagnostic")
        K("<leader>lq", vim.diagnostic.setqflist, "Send diagnostics to quickfix")

        -- Highlight word under cursor (LSP document highlight)
        if client:supports_method("textDocument/documentHighlight") then
          local aug = vim.api.nvim_create_augroup("lsp_doc_highlight_" .. bufnr, { clear = true })
          vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
            group = aug, buffer = bufnr,
            callback = vim.lsp.buf.document_highlight,
          })
          vim.api.nvim_create_autocmd({ "CursorMoved", "BufLeave" }, {
            group = aug, buffer = bufnr,
            callback = vim.lsp.buf.clear_references,
          })
        end
      end

      -- Diagnostic configuration: virtual text in line (errorLens vibe), underline, no auto-insert
      vim.diagnostic.config({
        virtual_text = {
          prefix = "●",
          spacing = 4,
          source = "if_many",
          -- only show for current line to keep noise low (error-lens-like)
          current_line = true,
        },
        signs = {
          text = { [vim.diagnostic.severity.ERROR] = "󰅚", [vim.diagnostic.severity.WARN] = "󰀪", [vim.diagnostic.severity.INFO] = "󰋽", [vim.diagnostic.severity.HINT] = "󰌶" },
          linehl = false, numhl = false,
        },
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = { border = "rounded", source = "if_many", focusable = false, header = "", prefix = "" },
      })

      -- Merge capabilities + on_attach + per-server settings, then set up each.
      for name, cfg in pairs(M.servers) do
        cfg = vim.tbl_deep_extend("force", {
          capabilities = capabilities,
          on_attach = on_attach,
        }, cfg)
        if name == "jsonls" then
          local ok, ss = pcall(require, "schemastore")
          if ok then cfg.settings.json.schemas = ss.json.schemas() end
        end
        lspconfig[name].setup(cfg)
      end
    end,
  },

  -- neoconf.nvim: per-project LSP settings (`.neoconf.json`)
  { "folke/neoconf.nvim", cmd = "Neoconf", opts = {} },
}