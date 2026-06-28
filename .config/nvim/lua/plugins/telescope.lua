-- Telescope: fuzzy finder. <leader>f prefix mirrors VSCode Cmd+P / Cmd+Shift+F.
-- Live grep uses ripgrep (configured in options.lua as &grepprg).

return {
  {
    "nvim-telescope/telescope.nvim",
    branch = "master",
    cmd = "Telescope",
    event = "VeryLazy",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      "nvim-telescope/telescope-ui-select.nvim",
    },
    init = function()
      vim.g.telescope_theme = "dropdown"
    end,
    opts = function()
      local actions = require("telescope.actions")
      local action_state = require("telescope.actions.state")
      local themes = require("telescope.themes")

      -- open selected file in horizontal/v vertical split (like VSCode <leader>h/l move editor to group)
      local open_split_below = function(prompt_bufnr)
        actions.close(prompt_bufnr)
        local entry = action_state.get_selected_entry()
        if not entry then return end
        vim.cmd("below split " .. entry.path)
      end
      local open_vsplit_right = function(prompt_bufnr)
        actions.close(prompt_bufnr)
        local entry = action_state.get_selected_entry()
        if not entry then return end
        vim.cmd("belowright vsplit " .. entry.path)
      end

      return {
        defaults = {
          vimgrep_arguments = {
            "rg", "--color=never", "--no-heading", "--with-filename",
            "--line-number", "--column", "--smart-case", "--hidden", "--glob", "!.git/",
          },
          prompt_prefix = "  ",
          entry_maker = nil,
          initial_mode = "insert",
          selection_strategy = "reset",
          sorting_strategy = "ascending",
          layout_strategy = "horizontal",
          layout_config = {
            horizontal = { prompt_position = "top", preview_width = 0.55, results_width = 0.8 },
            vertical = { mirror = false },
            width = 0.87, height = 0.80, preview_cutoff = 120,
          },
          file_sorter = require("telescope.sorters").get_fzy_sorter,
          generic_sorter = require("telescope.sorters").get_fzy_sorter,
          file_ignore_patterns = { "node_modules", ".git/", "target/", "dist/", ".dart_tool/", "build/" },
          path_display = { "truncate" },
          color_devicons = true,
          set_env = { ["COLORTERM"] = "truecolor" },
          borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
          winblend = 0,
          wrap_results = true,
          mappings = {
            i = {
              ["<C-c>"] = actions.close,
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-n>"] = actions.move_selection_next,
              ["<C-p>"] = actions.move_selection_previous,
              ["<C-s>"] = open_split_below,
              ["<C-v>"] = open_vsplit_right,
              ["<C-t>"] = actions.select_tab,
              ["<C-u>"] = actions.preview_scrolling_up,
              ["<C-d>"] = actions.preview_scrolling_down,
              ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
              ["<C-l>"] = actions.complete_tag,
              ["<C-h>"] = actions.which_key,
              ["<Tab>"] = actions.toggle_selection + actions.move_selection_next,
              ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_previous,
              ["<CR>"] = actions.select_default,
              ["<C-x>"] = actions.select_horizontal,
              ["<C-e>"] = actions.select_vertical,
              ["<C-/>"] = actions.which_key,
            },
            n = {
              ["<esc>"] = actions.close,
              ["q"] = actions.close,
              ["<CR>"] = actions.select_default,
              ["<C-s>"] = open_split_below,
              ["<C-v>"] = open_vsplit_right,
              ["j"] = actions.move_selection_next,
              ["k"] = actions.move_selection_previous,
              ["<C-n>"] = actions.move_selection_next,
              ["<C-p>"] = actions.move_selection_previous,
              ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
            },
          },
        },
        pickers = {
          find_files = { theme = "dropdown", previewer = true, hidden = false },
          buffers = { theme = "dropdown", previewer = true, sort_mru = false, sort_lastused = true },
          oldfiles = { theme = "dropdown", previewer = true },
          live_grep = { theme = "ivy", previewer = true },
          grep_string = { theme = "ivy", previewer = true, only_sort_text = true },
          current_buffer_fuzzy_find = { theme = "dropdown", previewer = true },
          lsp_references = { theme = "dropdown", previewer = true },
          lsp_definitions = { theme = "dropdown", previewer = true },
          lsp_implementations = { theme = "dropdown", previewer = true },
          lsp_type_definitions = { theme = "dropdown", previewer = true },
          diagnostics = { theme = "ivy", previewer = true },
          command_history = { theme = "dropdown", previewer = false },
          search_history = { theme = "dropdown", previewer = false },
          help_tags = { theme = "dropdown", previewer = true },
          man_pages = { theme = "dropdown", previewer = true },
        },
        extensions = {
          fzf = { fuzzy = true, override_generic_sorter = true, override_file_sorter = true, case_mode = "smart_case" },
          ["ui-select"] = themes.get_dropdown({}),
        },
      }
    end,
    config = function(_, opts)
      require("telescope").setup(opts)
      pcall(require("telescope").load_extension, "fzf")
      pcall(require("telescope").load_extension, "ui-select")
    end,
  },

  -- plenary: keep loaded as a dep of telescope/spectre/gitsigns (already, but explicit doesn't hurt).
  { "nvim-lua/plenary.nvim", lazy = true },
}