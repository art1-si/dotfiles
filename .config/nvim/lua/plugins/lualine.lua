-- Statusline: lualine.nvim with catppuccin.
-- Mode colours mirror the VSCode `vim.statusBarColors` settings:
--   normal  -> base/menthol text    (#1e1e2e / #a6adc8)
--   insert  -> green                (#a6e3a1)
--   visual  -> peach                (#fab387)

local function macro_rec()
  local reg = vim.fn.reg_recording()
  if reg == "" then return "" end
  return "󰑊 " .. reg
end

return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons", "catppuccin/nvim" },
    init = function()
      -- hide the built-in mode text at bottom since lualine shows it
      vim.o.showmode = false
    end,
    opts = function()
      local palette = require("catppuccin.palettes").get_palette("mocha")

      -- Table of mode -> label + (fg, bg) used in the mode section.
      local modes = {
        n      = { label = "NORMAL",   c = { fg = palette.base,    bg = palette.lavender, gui = "bold" } },
        no     = { label = "OP",       c = { fg = palette.base,    bg = palette.lavender } },
        nov    = { label = "O-PEND",   c = { fg = palette.base,    bg = palette.lavender } },
        niI    = { label = "NORMAL i", c = { fg = palette.base,    bg = palette.lavender } },
        i      = { label = "INSERT",   c = { fg = palette.base,    bg = palette.green,   gui = "bold" } },
        ic     = { label = "INS-CPL",  c = { fg = palette.base,    bg = palette.green } },
        R      = { label = "REPLACE",  c = { fg = palette.base,    bg = palette.red,     gui = "bold" } },
        Rv     = { label = "V-REPL",   c = { fg = palette.base,    bg = palette.red } },
        v      = { label = "VISUAL",   c = { fg = palette.base,    bg = palette.peach,   gui = "bold" } },
        V      = { label = "V-LINE",   c = { fg = palette.base,    bg = palette.peach } },
        [""]  = { label = "V-BLCK",   c = { fg = palette.base,    bg = palette.peach } },
        s      = { label = "SELECT",   c = { fg = palette.base,    bg = palette.peach } },
        S      = { label = "S-LINE",   c = { fg = palette.base,    bg = palette.peach } },
        c      = { label = "COMMAND",  c = { fg = palette.base,    bg = palette.sky,     gui = "bold" } },
        t      = { label = "TERM",     c = { fg = palette.base,    bg = palette.yellow } },
        _      = { label = "-" ,      c = { fg = palette.base,    bg = palette.surface0 } },
      }

      local mode_section = function()
        local m = modes[vim.fn.mode()] or modes._
        vim.api.nvim_set_hl(0, "lualine_a_mode", { fg = m.c.fg, bg = m.c.bg, bold = m.c.gui == "bold" })
        return m.label
      end

      -- "changed/readonly" helper
      local modified = function()
        if vim.bo.modified then return "●" end
        if vim.bo.modifiable == false then return "󰌾" end
        return ""
      end

      local file_loc = function()
        local enc = (vim.bo.fenc ~= "" and vim.bo.fenc) or vim.o.enc
        local fmt = vim.bo.fileformat
        return string.format("%s[%s]", enc, fmt)
      end

      local lsp_state = function()
        if vim.lsp.status == nil then return "" end
        local ok, st = pcall(vim.lsp.status)
        return ok and st or ""
      end

      local conditions = { hide_in_width = function() return vim.o.columns > 80 end }

      return {
        options = {
          globalstatus = true,
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
          disabled_filetypes = { "neo-tree", "alpha", "toggleterm", "dapui*", "help", "Trouble" },
          ignore_focus = { "neo-tree", "toggleterm", "dapui*" },
          refresh = { statusline = 200 },
        },
        sections = {
          lualine_a = { mode_section },
          lualine_b = { macro_rec },
          lualine_c = {
            { "filetype", icon_only = true, padding = { left = 1, right = 0 } },
            { "filename", path = 1, symbols = { modified = "●", readonly = "󰌾", unnamed = "[No Name]", newfile = "[New]" } },
            { modified },
          },
          lualine_x = {
            { "diagnostics", sources = { "nvim_diagnostic" }, symbols = { error = "󰅚 ", warn = "󰀪 ", info = "󰋽 ", hint = "󰌶 " } },
            { "diff", symbols = { added = " ", modified = " ", removed = " " }, cond = conditions.hide_in_width },
            { file_loc, cond = conditions.hide_in_width },
          },
          lualine_y = { lsp_state },
          lualine_z = { { "location", padding = { left = 1, right = 1 } } },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { { "filename", path = 1 } },
          lualine_x = { "location" },
          lualine_y = {},
          lualine_z = {},
        },
        extensions = { "lazy", "mason", "toggleterm", "neo-tree", "trouble" },
      }
    end,
  },
}