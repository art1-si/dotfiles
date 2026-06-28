-- Completion: blink.cmp with LSP / path / snippet / buffer sources.
-- Matches VSCode: editor.autoClosingBrackets/Quotes: never — so we DON'T enable
-- pairs from this side; (autopairs plugin is intentionally absent / loaded as no-op).

return {
  {
    "saghen/blink.cmp",
    lazy = false,
    version = "*", -- use stable tagged release
    dependencies = {
      "rafamadriz/friendly-snippets",
      "L3MON4D3/LuaSnip", -- snippet engine behind blink's snippet source
    },
    opts = function()
      return {
        keymap = {
          preset = "default",
          -- VSCode-like accept: <Tab> / <CR> confirm, <C-n>/<C-p> move, <C-e> abort
          ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
          ["<C-e>"] = { "hide", "fallback" },
          ["<CR>"] = { "accept", "fallback" },
          ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
          ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
          ["<C-n>"] = { "select_next", "fallback" },
          ["<C-p>"] = { "select_prev", "fallback" },
          ["<C-b>"] = { "scroll_documentation_up", "fallback" },
          ["<C-f>"] = { "scroll_documentation_down", "fallback" },
          ["<C-k>"] = { "show_signature", "hide_signature", "fallback" },
        },
        appearance = {
          use_nvim_cmp_as_default = false,
          nerd_font_variant = "normal",
        },
        sources = {
          providers = {
            lsp = { name = "LSP", module = "blink.cmp.sources.lsp", enabled = true },
            path = { name = "Path", module = "blink.cmp.sources.path", enabled = true, opts = { show_slash = false } },
            luasnip = { name = "Snip", module = "blink.cmp.sources.luasnip", enabled = true },
            buffer = { name = "Buf", module = "blink.cmp.sources.buffer", enabled = true, opts = { get_bufnrs = function() return vim.api.nvim_list_bufs() end } },
          },
          default = { "lsp", "path", "luasnip", "buffer" },
          per_filetype = {
            -- dart completion is heavy from LSP; keep buffer off
            dart = { "lsp", "path", "luasnip" },
            php = { "lsp", "path", "luasnip", "buffer" },
          },
        },
        completion = {
          keyword = { range = "full" },
          trigger = { show_on_keyword = true, show_on_trigger_character = true, show_on_insert_on_trigger_character = true, show_on_accept_on_trigger_character = false, show_in_snippet = true },
          list = {
          selection = { preselect = function(ctx) return ctx.mode == "default" end, auto_insert = false },
          cycle = { from_bottom = true },
          max_items = 200,
        },
          accept = { create_undo_point = true, auto_brackets = { enabled = false } },
          menu = {
            enabled = true,
            border = "rounded",
            winhighlight = "Normal:BlinkCmpMenu,FloatBorder:FloatBorder,CursorLine:BlinkCmpMenuSelection,Search:None",
            draw = {
              columns = {
                { "kind_icon", gap = 1 },
                { "label", "label_description", gap = 1 },
                { "source_name" },
              },
            },
          },
          documentation = {
            auto_show = true,
            auto_show_delay_ms = 200,
            update_delay_ms = 50,
            treesitter_highlighting = true,
            window = {
              border = "rounded",
              winhighlight = "Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder,EndOfBuffer:BlinkCmpDoc",
              scrollbar = true,
            },
          },
          ghost_text = { enabled = false },
        }
      }
    end,
    opts_extend = { "sources.default" },
    config = function(_, opts)
      -- friendly-snippets needs to be loaded once so LuaSnip sees the JSON defs.
      require("luasnip.loaders.from_vscode").lazy_load()
      require("blink.cmp").setup(opts)
    end,
  },

  -- LuaSnip: snippet engine + vscode-style loader.
  {
    "L3MON4D3/LuaSnip",
    build = "make install_jsregexp",
    lazy = true,
    dependencies = { "rafamadriz/friendly-snippets" },
    opts = {
      history = true,
      delete_check_guards = false,
      update_events = { "InsertLeave", "TextChangedI" },
      enable_autosnippets = true,
    },
    keys = function()
      local K = vim.keymap.set
      K({ "i", "s" }, "<C-l>", function() require("luasnip").jump(1) end, { silent = true, desc = "Snippet forward" })
      K({ "i", "s" }, "<C-h>", function() require("luasnip").jump(-1) end, { silent = true, desc = "Snippet back" })
      K({ "i", "s" }, "<C-q>", function()
        local ls = require("luasnip")
        if ls.choice_active() then ls.change_choice(1) end
      end, { silent = true, desc = "Snippet choice next" })
      return {}
    end,
  },
}