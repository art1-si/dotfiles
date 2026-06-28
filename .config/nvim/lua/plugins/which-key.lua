-- which-key: legend popup for <space> leader (and other mappings).
-- Newer which-key (v3) uses spec table; we declare groups so the legend is consistent.

return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      preset = "modern",
      delay = 200,
      notify = false,
      plugins = { marks = true, registers = true, spelling = { enabled = true, suggestions = 20 }, presets = { operators = false, motions = false, text_objects = false } },
      win = {
        no_overlap = true,
        border = "rounded",
        title = true,
        title_pos = "center",
      },
      layout = { height = { min = 4, max = 25 }, width = { min = 20, max = 50 }, spacing = 3 },
      icons = {
        breadcrumb = "»",
        separator = "  ",
        group = "… ",
        rules = false,
        colors = false,
      },
      show_keys = true,
      -- Disable in these contexts
      filter = function(m)
        return (m.is_description and m.desc ~= "") or m.keys:match("^" .. vim.g.mapleader)
      end,
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)

      -- Preset group labels — keeps the <space> legend tidy.
      wk.add({
        { "<leader>b", group = "  Buffer" },
        { "<leader>c", group = " 󰆧 Code/LSP" },
        { "<leader>d", group = " 󰃭 Debug" },
        { "<leader>f", group = " 󰈞 File/Find" },
        { "<leader>g", group = " 󰊢 Git" },
        { "<leader>q", group = " 󰗼 Quit/Session" },
        { "<leader>s", group = " 󰺕 Search" },
        { "<leader>t", group = " 󰆽 Toggle/Tool" },
        { "<leader>w", group = " 󱂬 Window" },
        { "<leader>x", group = " 󰁨 Quickfix/Trouble" },
        { "<leader>h", group = " 󰑏 Help/Hunk (gitsigns)" },
        { "<leader>l", group = " 󰓹 LSP action" },
        { "<leader>r", group = " 󰑕 Refactor/Run" },
        { "<leader>n", group = " 󰀬 Notes" },
        { "<leader>1", group = " Buffers [1..9] jump" },
      })
    end,
  },
}