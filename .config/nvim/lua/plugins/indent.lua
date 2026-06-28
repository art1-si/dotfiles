-- indent-blankline: catppuccin "indentRainbow.colors" from VSCode settings.json.

return {
  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPost", "BufNewFile" },
    main = "ibl",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = function()
      local palette = require("catppuccin.palettes").get_palette("mocha")

      -- VSCode indentRainbow.colors (rgba values, mapped to catppuccin hex below)
      -- rgba(242,205,205,0.1)  -> red
      -- rgba(243,139,168,0.1) -> pink
      -- rgba(137,180,250,0.1) -> blue
      -- rgba(249,226,175,0.1) -> yellow
      -- rgba(116,199,236,0.1) -> sky
      -- rgba(235,160,172,0.1) -> maroon
      local rainbow = {
        palette.red, palette.pink, palette.blue, palette.yellow,
        palette.sky, palette.maroon,
      }

      -- highlight each indent level with its own colour
      vim.api.nvim_set_hl(0, "IblIndent", { fg = palette.surface0, nocombine = true })
      vim.api.nvim_set_hl(0, "IblScope",  { fg = palette.lavender, nocombine = true })
      for i, c in ipairs(rainbow) do
        vim.api.nvim_set_hl(0, ("IblRainbow%d"):format(i), { fg = c, nocombine = true })
      end

      return {
        indent = {
          char = "┊",
          tab_char = "┊",
          highlight = "IblIndent",
          smart_indent_cap = true,
        },
        whitespace = { highlight = { "IblIndent" }, remove_blankline_trail = true },
        scope = {
          enabled = true,
          char = "▎",
          show_start = false,
          show_end = false,
          highlight = "IblScope",
        },
        exclude = {
          filetypes = {
            "help", "alpha", "neo-tree", "Trouble", "trouble", "lazy", "mason",
            "notify", "toggleterm", "dapui_scopes", "dapui_breakpoints",
            "dapui_stacks", "dapui_watches", "dapui_hover", "dap-repl",
            "dap-terminal", "terminal", "log", "markdown", "checkhealth",
          },
          buftypes = { "terminal", "nofile", "quickfix", "prompt" },
        },
      }
    end,
    config = function(_, opts)
      local hooks = require("ibl.hooks")
      -- NOTE: ibl v3 supports `rainbow` via its own setup object, providing we pass
      -- a list of highlight groups for the `indent.highlight` field. Cheaper to override.
      opts.indent.highlight = {
        "IblRainbow1", "IblRainbow2", "IblRainbow3",
        "IblRainbow4", "IblRainbow5", "IblRainbow6",
      }
      require("ibl").setup(opts)
      hooks.register(hooks.type.SCOPE_HIGHLIGHT, function(_, _, _, scope_index)
        return scope_index
      end)
    end,
  },
}