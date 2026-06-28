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
      transparent_background = true, -- editor + UI floats use the terminal background
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
      custom_highlights = function() return {} end, -- transparent overrides handled by the ColorScheme autocmd in config()
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd.colorscheme("catppuccin")

      -- Force transparent backgrounds AFTER catppuccin (and any integration) applied.
      -- Done in a ColorScheme autocmd so it survives theme reloads and overrides
      -- any integration (noice, neo-tree, ...) that sets bg after our custom_highlights.
      local aug = vim.api.nvim_create_augroup("catppuccin_transparent", { clear = true })
      vim.api.nvim_create_autocmd("ColorScheme", {
        group = aug,
        callback = function()
          local set = vim.api.nvim_set_hl
          local NONE = "NONE"
          local p = require("catppuccin.palettes").get_palette("mocha")
          -- Editor + non-current editor + floats + splilts
          set(0, "Normal",      { bg = NONE })
          set(0, "NormalNC",    { bg = NONE })
          set(0, "NormalFloat", { bg = NONE })
          set(0, "FloatBorder", { bg = NONE, fg = p.mauve })
          set(0, "WinSeparator", { bg = NONE, fg = p.mauve, bold = true })
          set(0, "VertSplit",   { bg = NONE, fg = p.mauve, bold = true })
          -- Sidebar-style plugins
          for _, hl in ipairs({
            "NeoTreeNormal", "NeoTreeNormalNC", "NeoTreeEndOfBuffer",
            "NvimTreeNormal", "NvimTreeNormalNC", "NvimTreeEndOfBuffer",
            "TroubleNormal", "TroubleNormalNC", "TroubleNormalSB",
            "SidebarNvimNormal", "SidebarNvimNormalNC",
            "TelescopeNormal", "TelescopeBorder", "TelescopePromptNormal", "TelescopePromptBorder",
            "TelescopeResultsNormal", "TelescopePreviewNormal",
            "NoiceCmdline", "NoicePopup", "NoiceNormal", "NoiceCmdlinePopup",
            "NoiceCmdlinePopupBorder", "NoiceConfirm", "NoiceConfirmBorder",
            "NoiceMini", "NoiceFormat",
            "DapUIFloatNormal", "DapUIStopNormal", "DapUIStoppedNormal",
            "DapUINormal", "DapUIPlayPauseNormal", "DapUIRestartNormal",
            "DapUIStepOverNormal", "DapUIStepIntoNormal", "DapUIStepOutNormal",
            "DapUIStepBackNormal", "DapUIWatchesEmpty", "DapUIWatchesValue",
            "DapUIBreakpointsCurrentLine", "DapUIBreakpointsDisabledLine",
            "BlinkCmpMenu", "BlinkCmpMenuBorder", "BlinkCmpDoc", "BlinkCmpDocBorder",
            "BlinkCmpGhostText",
          }) do
            pcall(set, 0, hl, { bg = NONE, ctermbg = NONE })
            -- also nil out special backgrounds / linked end-of-buffer
          end
          for _, hl in ipairs({
            "NeoTreeEndOfBuffer", "NvimTreeEndOfBuffer", "EndOfBuffer",
          }) do
            pcall(set, 0, hl, { bg = NONE, fg = p.surface0 })
          end
          -- Keep functional dark accents (status / tabline / cursorline / pmenu) on translucent bg
          set(0, "StatusLine",  { bg = p.surface0, fg = p.text })
          set(0, "StatusLineNC", { bg = NONE,       fg = p.overlay0 })
          set(0, "TabLine",      { bg = p.surface0, fg = p.overlay0 })
          set(0, "TabLineFill",  { bg = NONE,       fg = p.overlay0 })
          set(0, "TabLineSel",   { bg = p.surface0, fg = p.lavender })
          set(0, "WinBar",       { bg = NONE,       fg = p.text })
          set(0, "WinBarNC",     { bg = NONE,       fg = p.overlay0 })
          set(0, "CursorLine",   { bg = p.surface0 })
          set(0, "CursorColumn", { bg = p.surface0 })
          set(0, "SignColumn",   { bg = NONE })
          set(0, "FoldColumn",   { bg = NONE, fg = p.overlay0 })
          set(0, "LineNr",       { bg = NONE, fg = p.overlay0 })
          set(0, "CursorLineNr", { bg = p.surface0, fg = p.mauve })
          set(0, "LspInlayHint", { bg = NONE, fg = p.overlay1 })
          local diag_sp = { Error = p.red, Warn = p.yellow, Info = p.sky, Hint = p.lavender }
          for d, sp in pairs(diag_sp) do
            pcall(set, 0, "DiagnosticUnderline" .. d, { sp = sp, undercurl = true })
          end
          set(0, "IncSearch", { bg = p.mauve,    fg = p.base })
          set(0, "Search",     { bg = p.surface1, fg = p.text })
          set(0, "Pmenu",       { bg = p.surface0, fg = p.text })
          set(0, "PmenuSel",    { bg = p.surface1, fg = p.lavender, bold = true })
          set(0, "PmenuSbar",   { bg = p.surface0 })
          set(0, "PmenuThumb",  { bg = p.overlay0 })
        end,
      })
      -- Re-apply now (the autocmd only fires on future ColorScheme events).
      vim.api.nvim_exec_autocmds("ColorScheme", {})
    end,
  },
}