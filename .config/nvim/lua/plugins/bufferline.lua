-- Buffer tabs. behaviour mirrors VSCode's single-tab bar with sticky scrolled tabs.
-- Replaces <leader>1..4 + buffer navigation; keep them all working via numbers/hj (below).

return {
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons", "catppuccin/nvim" },
    -- catppuccin integration is enabled in the theme file; we just theme per-mode.
    opts = function()
      local palette = require("catppuccin.palettes").get_palette("mocha")
      return {
        options = {
          mode = "buffers", -- VSCode-like tabs
          numbers = "ordinal",
          close_command = "bdelete! %d",
          right_mouse_command = "bdelete! %d",
          left_mouse_command = "buffer %d",
          middle_mouse_command = nil,
          indicator = { style = "underline", size = 2 },
          buffer_close_icon = "󰅖",
          modified_icon = "●",
          close_icon = "",
          left_trunc_marker = "",
          right_trunc_marker = "",
          max_name_length = 28,
          max_prefix_length = 24,
          tab_size = 22,
          truncate_names = true,
          diagnostics = "nvim_lsp",
          diagnostics_update_in_insert = false,
          diagnostics_indicator = function(count, level, _, _)
            return string.format("(%d %s)", count, level:sub(1, 1))
          end,
          color_icons = true,
          show_buffer_icons = true,
          show_buffer_close_icons = true,
          show_close_icon = true,
          show_tab_indicators = true,
          show_duplicate_prefix = false,
          persist_buffer_sort = true,
          separator_style = { "", "" },
          enforce_regular_tabs = false,
          always_show_bufferline = true,
          sort_by = "insert_after_current",
          -- VSCode `workbench.editor.limit`: 3 max tabs per group
          offsets = {
            {
              filetype = "neo-tree",
              text = "File Explorer",
              highlight = "Directory",
              text_align = "center",
              separator = true,
            },
          },
        },
        highlights = {
          -- use catppuccin mauve/lavender for selected, surface0 for fill
          fill = { bg = palette.base },
          background = { bg = palette.base, fg = palette.overlay0 },
          buffer_visible = { bg = palette.base, fg = palette.overlay1 },
          buffer_selected = { bg = palette.base, fg = palette.lavender, bold = true },
          mod = { fg = palette.peach },
          mod_visible = { fg = palette.peach },
          mod_selected = { fg = palette.peach },
          close_button = { fg = palette.overlay0, bg = palette.base },
          close_button_visible = { fg = palette.overlay0, bg = palette.base },
          close_button_selected = { fg = palette.red, bg = palette.base },
          indicator_selected = { bg = palette.mauve, fg = palette.mauve, sp = palette.mauve, underline = true },
          separator = { fg = palette.base, bg = palette.base },
          separator_selected = { fg = palette.base, bg = palette.base },
          separator_visible = { fg = palette.base, bg = palette.base },
          tab_selected = { bg = palette.base, fg = palette.lavender, bold = true },
          tab = { bg = palette.surface0, fg = palette.overlay1 },
          tab_close = { fg = palette.red, bg = palette.base },
          error = { fg = palette.red, bg = palette.base },
          error_visible = { fg = palette.red, bg = palette.base },
          error_selected = { fg = palette.red, bg = palette.base, sp = palette.red, underline = true },
          warning = { fg = palette.yellow, bg = palette.base },
          warning_visible = { fg = palette.yellow, bg = palette.base },
          warning_selected = { fg = palette.yellow, bg = palette.base, sp = palette.yellow, underline = true },
          info = { fg = palette.sky, bg = palette.base },
          info_visible = { fg = palette.sky, bg = palette.base },
          info_selected = { fg = palette.sky, bg = palette.base, sp = palette.sky, underline = true },
          hint = { fg = palette.teal, bg = palette.base },
          hint_visible = { fg = palette.teal, bg = palette.base },
          hint_selected = { fg = palette.teal, bg = palette.base, sp = palette.teal, underline = true },
          numbers = { fg = palette.overlay1, bg = palette.base },
          numbers_visible = { fg = palette.overlay1, bg = palette.base },
          numbers_selected = { fg = palette.lavender, bg = palette.base, bold = true },
          duplicate = { fg = palette.overlay0, italic = true },
          duplicate_visible = { fg = palette.overlay0, italic = true },
          duplicate_selected = { fg = palette.overlay1, italic = true },
        },
      }
    end,
    keys = function()
      local K = vim.keymap.set
      local bufmap = function(lhs, action, desc)
        K("n", lhs, action, { desc = desc, silent = true, noremap = true })
      end
      -- <leader>1..9 jump to buffer N — preserves VSCode <leader>1..4 muscle memory, extends it.
      for i = 1, 9 do
        bufmap("<leader>" .. i, function()
          require("bufferline").go_to_buffer(i, true)
        end, ("Go to buffer %d"):format(i))
      end
      bufmap("<leader>bl", "<Cmd>BufferLineCycleNext<CR>", "Next buffer")
      bufmap("<leader>bh", "<Cmd>BufferLineCyclePrev<CR>", "Prev buffer")
      bufmap("<leader>bc", "<Cmd>BufferLineCloseOthers<CR>", "Close other buffers")
      bufmap("<leader>bp", "<Cmd>BufferLineTogglePin<CR>", "Pin buffer")
      bufmap("<leader>bs", "<Cmd>BufferLineSortByDirectory<CR>", "Sort buffers by directory")
      return {}
    end,
  },
}