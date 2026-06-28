-- UI bits: icons, vim.ui dressing, noice (commandline/messages).

return {
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
    opts = {
      default = true,
      override = {
        -- PHP / Dart / Flutter-flavoured icon tweaks (falls back to nerd font glyphs).
        php = { icon = "", name = "Php" },
        dart = { icon = "", name = "Dart" },
        ["pubspec.yaml"] = { icon = "", name = "Pubspec" },
      },
    },
  },

  {
    "stevearc/dressing.nvim",
    lazy = true,
    event = "VeryLazy",
    opts = {
      input = { default_prompt = "➤ " },
      select = { backend = { "telescope", "fzf_lua", "builtin" } },
    },
  },

  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = { "MunifTanjim/nui.nvim", "nvim-tree/nvim-web-devicons" },
    opts = {
      cmdline = { view = "cmdline_popup", format = { cmdline = { pattern = "^:", icon = ":", lang = "vim" } } },
      messages = { view = "mini", view_error = "mini", view_warn = "mini", view_history = "messages" },
      popupmenu = { enabled = true, backend = "nui" },
      notify = { enabled = true, view = "notify" },
      lsp = {
        progress = { enabled = true, format = "lsp_progress", throttle = 1000 / 30 },
        hover = { enabled = false }, -- prefer native K
        signature = { enabled = true, auto_open = { enabled = true, trigger = true, luasnip = true } },
        message = { enabled = true, view = "mini" },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        inc_search = false,
        cmdline_photo_to_split = false,
      },
      throttle = 1000 / 30,
      views = {},
      routes = {
        { filter = { event = "msg_show", find = "%d+L,%s+%d+B" }, opts = { skip = true } }, -- "written" silence
        { filter = { event = "msg_show", kind = "search_count" }, opts = { skip = true } },
        { filter = { event = "msg_show", find = "^Hunk" }, opts = { skip = true } }, -- gitsigns chatter
      },
      health = { checker = false },
    },
  },
}