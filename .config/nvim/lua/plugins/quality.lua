-- Quality-of-life UI: trouble (diagnostic list), fidget (LSP progress),
-- error-lens-like inline diagnostics, inlay hints, todo-comments highlight.

return {
  -- trouble.nvim v3 — diagnostic / quickfix / references single panel
  {
    "folke/trouble.nvim",
    cmd = { "Trouble" },
    keys = {
      { "<leader>xx", "<Cmd>Trouble diagnostics toggle<CR>", desc = "Trouble diagnostics" },
      { "<leader>xX", "<Cmd>Trouble diagnostics toggle filter.buf=0<CR>", desc = "Trougle buffer diagnostics" },
      { "<leader>xs", "<Cmd>Trouble symbols toggle<CR>", desc = "Trouble symbols" },
      { "<leader>xL", "<cmd>Trouble loclist toggle<CR>", desc = "Trouble loclist" },
      { "<leader>xQ", "<cmd>Trouble qflist toggle<CR>", desc = "Trouble quickfix" },
      { "<leader>xl", "<cmd>Trouble lsp toggle<CR>", desc = "Trouble LSP refs/defs" },
    },
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      mode = "diagnostics",
      auto_close = false,
      auto_open = false,
      auto_preview = true,
      focus = true,
      restore = true,
      follow = true,
      pinned = false,
      indent_guides = true,
      win = { position = "right", border = "rounded", size = { width = 0.30 } },
      preview = { type = "main", border = "rounded" },
      keys = {
        ["?"] = "help",
        ["<cr>"] = "jump",
        ["<2-leftmouse>"] = "jump",
        ["<c-x>"] = "jump_split",
        ["<c-v>"] = "jump_vsplit",
        ["<c-t>"] = "open_tab",
        ["]"] = "next",
        ["["] = "prev",
        ["}"] = "last",
        ["{"] = "first",
        ["r"] = "toggle_refresh",
        ["p"] = "toggle_preview",
        ["q"] = "close",
        ["o"] = "jump_close",
        ["d"] = "delete",
        ["i"] = "inspect",
        ["c"] = "toggle_collapse",
      },
    },
  },

  -- fidget.nvim: LSP progress spinner in the corner (quiet, no logs everywhere)
  {
    "j-hui/fidget.nvim",
    event = "VeryLazy",
    opts = {
      notification = {
        window = {
          winblend = 0, border = "none",
          normal_hl = "Normal", name = "Fidget",
        },
        override_vim_notify = true,
      },
      progress = {
        display = { done_ttl = 1, done_icon = "✓", spinner = { "⣾","⣽","⣻","⢿","⡿","⣟","⣯","⣷" }, format_message = function(msg) return msg end },
      },
    },
  },

  -- Error lens-like inline diagnostics. Uses built-in `vim.diagnostic.config` virtual
  -- text already set in lsp.lua; we just enable a cleaner visual stack here.
  -- `chrisgrieser/nvim-errorlist-lens` would be an alternative; using virtual text keeps things minimal.

  -- todo-comments: highlight // TODO: / FIXME: / NOTE: / HACK: in code
  {
    "folke/todo-comments.nvim",
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "TodoTelescope", "TodoTrouble", "TodoLocList", "TodoQuickFix" },
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      signs = true,
      sign_priority = 8,
      keywords = {
        TODO = { icon = "󰄴 ", color = "hint", alt = { "WIP" } },
        FIXME = { icon = "󰅖 ", color = "error", alt = { "BUG", "FIXIT", "ISSUE" } },
        HACK = { icon = "󰈸 ", color = "warning" },
        NOTE = { icon = "󰋽 ", color = "info", alt = { "INFO" } },
        WARN = { icon = "󰀪 ", color = "warning", alt = { "WARNING" } },
        PERF = { icon = "󰓅 ", color = "perf" },
        TEST = { icon = "󰇒 ", color = "test" },
      },
      highlight = {
        before = "", -- don't spoil indent guides
        keyword = "wide",
        after = "",
        comments_only = true,
        max_line_len = 400,
      },
      colors = { error = { "DiagnosticError" }, warning = { "DiagnosticWarn" }, info = { "DiagnosticInfo" }, hint = { "DiagnosticHint" }, default = { "Identifier" }, test = { "Function" }, perf = { "Constant" } },
      pattern = [[\v\b(<FILE>|<TAG>):?\s*(<TAGNAME>)]],
    },
    keys = {
      { "<leader>ft", "<Cmd>TodoTelescope<CR>", desc = "TODO: telescope" },
      { "<leader>xt", "<Cmd>TodoTrouble<CR>", desc = "TODO: trouble" },
      { "]t", function() require("todo-comments").jump_next() end, desc = "Next todo" },
      { "[t", function() require("todo-comments").jump_prev() end, desc = "Prev todo" },
    },
  },

  -- Inlay hints: enable on LSP attach only for LSPs that support them.
  -- Honours VSCode php.inlayHints.*.enabled=false (intelephense inlayHints disabled in lsp.lua).
  {
    "neovim/nvim-lspconfig",
    optional = true,
    config = function()
      -- Enable inlay hints globally only if the buffer's LSP advertises them.
      -- lspconfig setup in lsp.lua already runs; this augments on_attach via autocmd.
      local aug = vim.api.nvim_create_augroup("user_inlay_hints", { clear = true })
      vim.api.nvim_create_autocmd("LspAttach", {
        group = aug,
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client and client:supports_method("textDocument/inlayHint") then
            local buf = args.buf
            -- intelephense: php.inlayHints.*.enabled=false in VSCode; keep that here too.
            if client.name == "intelephense" then return end
            pcall(vim.lsp.inlay_hint, true, { bufnr = buf })
          end
        end,
      })
    end,
  },
}