-- File explorer: neo-tree.nvim.
-- Mirrors the VSCode sidebar with material icon flavour (via nvim-web-devicons).

return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    cmd = "Neotree",
    keys = {
      { "<leader>ef", "<Cmd>Neotree toggle reveal filesystem<CR>", desc = "Explorer: filesystem (reveal)" },
      { "<leader>ee", "<Cmd>Neotree toggle focus filesystem<CR>", desc = "Explorer: toggle" },
      { "<leader>eb", "<Cmd>Neotree buffers toggle<CR>", desc = "Explorer: buffers" },
      { "<leader>eg", "<Cmd>Neotree git_status toggle<CR>", desc = "Explorer: git status" },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    deactivate = function()
      vim.cmd([[Neotree close]])
    end,
    opts = function()
      -- use ll /mkdir from <leader>f / fileutils.newFileAtRoot mapping lives closer to fold.
      return {
        sources = { "filesystem", "buffers", "git_status", "document_symbols" },
        close_if_last_window = false, -- VSCode keeps sidebar; nvim usually wants to quit too
        popup_border_style = "rounded",
        enable_git_status = true,
        enable_diagnostics = true,
        enable_normal_mode_for_inputs = false,
        open_files_do_not_replace_types = { "terminal", "Trouble", "trouble", "qf", "help" },
        sort_case_insensitive = false,
        sort_function = nil,
        default_component_configs = {
          indent = {
            indent_size = 2, padding = 1, with_markers = true,
            indent_marker = "│", last_indent_marker = "└",
            highlight = "NeoTreeIndentMarker", highlight_expand = "NeoTreeIndentMarker",
            with_expand = true,
          },
          icon = {
            folder_closed = "", folder_open = "", folder_empty = "", folder_empty_open = "",
            default = "󰈚",
            highlight = "NeoTreeFileIcon",
          },
          modified = { symbol = "●", highlight = "NeoTreeModified" },
          git_status = {
            symbols = {
              added     = "✚", modified  = "", deleted   = "✖", renamed   = "",
              untracked = "", ignored   = "", unstaged  = "󰄗", staged    = "✓",
              conflict  = "", unmerged  = "",
            },
          },
          diagnostics = {
            symbols = { error = "󰅚 ", warn = "󰀪 ", hint = "󰌶 ", info = "󰋽 " },
            highlights = { error = "DiagnosticSignError", warn = "DiagnosticSignWarn", hint = "DiagnosticSignHint", info = "DiagnosticSignInfo" },
          },
          name = { trailing_slash = false, use_git_status_colors = true, highlight = "NeoTreeFileName" },
        },
        window = {
          position = "left", width = 32, mappings = {
            ["<space>"] = { "toggle_node", nowait = false },
            ["<2-LeftMouse>"] = "open",
            ["<cr>"] = "open",
            ["l"] = "open",
            ["h"] = "close_node",
            ["S"] = "open_split",
            ["s"] = "open_vsplit",
            ["t"] = "open_tabnew",
            ["w"] = "open_with_window_picker",
            ["z"] = "close_all_nodes",
            ["Z"] = "expand_all_nodes",
            ["a"] = { "add", config = { show_path = "none" } },
            ["A"] = "add_directory",
            ["d"] = "delete",
            ["r"] = "rename",
            ["y"] = "copy_to_clipboard",
            ["x"] = "cut_to_clipboard",
            ["p"] = "paste_from_clipboard",
            ["c"] = "copy",
            ["m"] = "move",
            ["q"] = "close_window",
            ["R"] = "refresh",
            ["?"] = "show_help",
            ["<bs>"] = "navigate_up",
            ["."] = "set_root",
            ["[g"] = "prev_git_modified",
            ["]g"] = "next_git_modified",
          },
          fuzzy_finder = {
            fuzzy_find_inputs = false, -- let dressing handle popup styling
          },
        },
        filesystem = {
          window = { mappings = {
            ["H"] = "toggle_hidden", ["/"] = "fuzzy_finder", ["D"] = "fuzzy_finder_directory",
            ["f"] = "filter_on_submit", ["<C-x>"] = "clear_filter", ["#"] = "fuzzy_sorter",
          } },
          filtered_items = {
            visible = false, hide_hidden = true, hide_by_name = { ".DS_Store" }, hide_by_pattern = {}, always_show = { ".gitignored" }, never_show = {}, never_show_by_pattern = {},
          },
          follow_current_file = { enabled = true },
          group_empty_dirs = false,
          hijack_netrw_behavior = "open_default",
          use_libuv_file_watcher = true,
        },
        buffers = { follow_current_file = { enabled = true }, show_on_open = "getbufinfo('%')", group_empty_dirs = true },
        git_status = { window = { position = "float" } },
        event_handlers = {
          { event = "neo_tree_window_after_open", handler = function(args)
            if args.source == "filesystem" then
              vim.opt_local.signcolumn = "no"
              vim.opt_local.foldcolumn = "0"
            end
          end },
        },
      }
    end,
  },
}