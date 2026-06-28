-- Theme: catppuccin/nvim — matches VSCode Catppuccin Mocha.
-- NOTE: integrations are declared up front even before the corresponding plugins land;
-- catppuccin no-ops them gracefully when the plugin isn't installed yet.

return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    branch = "main",
    opts = {
      flavour = "mocha", -- Mocha, Latte, Frappe, Macchiato
      background = { light = "latte", dark = "mocha" },
      transparent_background = false,
      term_colors = true,
      dim_inactive = { enabled = false, shade = "dark", percentage = 0.15 },
      show_end_of_buffer = false,
      -- mirroring your `catppuccin.italicKeywords: false`
      styles = {
        comments = { "italic" },
        keywords = {}, -- NO italic — matches VSCode setting
        functions = {},
        variables = {},
        numbers = {},
        booleans = {},
        properties = {},
        types = {},
        conditionals = {},
        loops = {},
      },
      default_integrations = true,
      integrations = {
        cmp = false, -- using blink.cmp later; harmless if not present
        blink_cmp = true,
        coc_nvim = false,
        decorate = true,
        fidget = true,
        flash = true,
        gitsigns = true,
        illuminate = { enabled = true },
        indent_blankline = { enabled = true, scope_color = "lavender" },
        lsp_trouble = true,
        mason = true,
        markdown = true,
        native_lsp = { enabled = true, underlines = { errors = { "undercurl" }, hints = { "undercurl" }, warnings = { "undercurl" }, information = { "undercurl" } } },
        neotree = true,
        noice = true,
        notify = true,
        octo = true,
        semantic_tokens = true,
        telescope = { enabled = true },
        treesitter = true,
        treesitter_context = true,
        which_key = true,
        barbar = false,
        dap = true,
        dap_ui = true,
        rainbow_delimiters = true,
        symbols_outline = false,
        mini = { enabled = true, indentscope_color = "lavender" },
        render_markdown = true,
        neotest = false,
        neorg = false,
        overseer = false,
        symbols = false,
      },
      color_overrides = {
        mocha = {
          -- purple accent (matches VSCode `#cba6f7` sideBar/border)
          mauve = "#cba6f7",
        },
      },
      custom_highlights = function(colors)
        local set = vim.api.nvim_set_hl
        -- Purple borders like VSCode workbench.colorCustomizations (#cba6f7)
        set(0, "WinSeparator", { fg = colors.mauve, bold = true })
        set(0, "VertSplit", { link = "WinSeparator" })
        set(0, "FloatBorder", { fg = colors.mauve })
        set(0, "NormalFloat", { bg = colors.base })
        set(0, "CursorLineNr", { fg = colors.mauve, bold = true })
        set(0, "LineNr", { fg = colors.overlay0 })
        -- LSP underline hints use lavender
        set(0, "LspInlayHint", { fg = colors.overlay1, italic = true })
        -- Stronger search
        set(0, "IncSearch", { bg = colors.mauve, fg = colors.base })
        set(0, "Search", { bg = colors.surface1, fg = colors.text })
        -- Diagnostic virtual text underline tone matches errorLens vibe
        set(0, "DiagnosticUnderlineError", { sp = colors.red, undercurl = true })
        set(0, "DiagnosticUnderlineWarn", { sp = colors.yellow, undercurl = true })
        set(0, "DiagnosticUnderlineInfo", { sp = colors.sky, undercurl = true })
        set(0, "DiagnosticUnderlineHint", { sp = colors.lavender, undercurl = true })
        return {}
      end,
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd.colorscheme("catppuccin")
    end,
  },
}