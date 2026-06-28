-- Editing niceties: surround, comment, flash (replace VSCode q/e jumps),
-- autopairs intentionally NOT enabled (per VSCode autoClosingBrackets: never).

return {
  -- nvim-surround: cs/ds/ys — change/delete/add surroundings. Plugin defaults are sane.
  {
    "kylechui/nvim-surround",
    event = { "BufReadPost", "BufNewFile" },
    version = "*",
    opts = { move_cursor = "begin" },
  },

  -- Comment.nvim: gcc / gbc / gc-motion.
  {
    "numToStr/Comment.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {
      mappings = { basic = true, extra = true, extended = false },
      -- dart's commentstring is "// %s" — set in autocmds.lua FileType dart
    },
  },

  -- flash.nvim: jump to anywhere with a few keystrokes.
  -- Replaces VSCode shift+space q/e relative-goto jump. Use s/S/R in normal/visual.
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {
      labels = "asdfghjklqwertyuiopzxcvbnm",
      search = { mode = "search", exclude = { "flash_prompt" } },
      jump = { jumplist = true, register = true, nohlsearch = true, autojump = false },
      label = { uppercase = false, rainbow = { enabled = true, shades = 6 } },
      highlight = { backdrop = true, matches = true, punct = false },
      modes = {
        search = { enabled = true, highlight = { backdrop = false } },
        char = { enabled = true, autohide = true, multi_line = true },
        treesitter = { enabled = true, jumps = { notree = false } },
        treesitter_search = { enabled = true },
        remote = { enabled = true },
      },
    },
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      { "R", mode = { "o" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
    },
  },

  -- nvim-spectre: project-wide find/replace (UI analogue of VSCode's search&replace)
  {
    "nvim-pack/nvim-spectre",
    cmd = { "Spectre" },
    keys = {
      { "<leader>sr", "<Cmd>Spectre<CR>", desc = "Project find/replace" },
    },
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      replace_engine = { sed = { cmd = "sed", args = nil } },
      default = { find = { cmd = "rg" } },
      is_insert_mode = false,
      open_cmd = "botright new",
      line_sep = "┃─────────────────────────────────────────────────────────────────────────────────────────────────────",
    },
  },

  -- nvim-autopairs: intentionally loaded but DISABLED — keeps the plugin available
  -- in case we want bracket-pairType for specific langs later without re-installing.
  -- Honours VSCode `editor.autoClosingBrackets: never` / `editor.autoClosingQuotes: never`.
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      local npairs = require("nvim-autopairs")
      npairs.setup({
        enable_check_bracket_line = false,
        disable_filetype = { "TelescopePrompt", "spectre_panel", "dap-repl", "snacks_input", "snacks_rename_input" },
        check_ts = false,
        ignored_next_char = "[%w%.%[%(%{%\"]",
        fast_wrap = {},
      })
      -- effectively turn it OFF by mapping no-op; keeps the module path stable for blink.cmp integration
      npairs.disable()
    end,
  },
}