-- Treesitter: syntax, indent, textobjects, autotag, context.
-- Parsers cover dart/php/html/css/json/yaml/markdown/fish/bash/lua/vim.

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master", -- legacy API (`nvim-treesitter.configs`); avoid new "main" rewrite
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "TSInstall", "TSInstallSync", "TSUpdate", "TSUpdateSync" },
    build = ":TSUpdate",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      "windwp/nvim-ts-autotag",
      "nvim-treesitter/nvim-treesitter-context",
      "andymass/vim-matchup",
    },
    init = function()
      -- 2-space indent inside treesitter fold computation is fine; indentation uses
      -- core smartindent + per-ft overrides in autocmds.lua.
      vim.opt.foldmethod = "expr"
      vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    end,
    opts = {
      ensure_installed = {
        "bash", "fish", "lua", "vim", "vimdoc", "query",
        "json", "jsonc", "yaml", "toml", "regex",
        "markdown", "markdown_inline",
        "html", "css", "scss", "javascript", "typescript",
        "dart", "php", "phpdoc",
        "git_config", "gitignore", "gitcommit", "git_rebase", "diff",
        "sql",
      },
      sync_install = false,
      auto_install = true,
      ignore_install = {},
      modules = {},
      highlight = {
        enable = true,
        disable = function(_, bufnr)
          -- TS highlight is slow on very large files; disable past 2MB.
          local ok, st = pcall(vim.api.nvim_buf_get_lines, bufnr, 0, -1, false)
          return ok and st and #st > 60000
        end,
        additional_vim_regex_highlighting = { "markdown" },
      },
      indent = { enable = true, disable = { "php" } }, -- php indentation handled by LSP
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = "<C-s>",
          node_decremental = "<bs>",
        },
      },
      matchup = { enable = true, include_match_words = true },
      autotag = { enable = true, filetypes = { "html", "xml", "php", "dart", "javascript", "typescript", "javascriptreact", "typescriptreact" } },
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          lookbehind = false,
          include_surrounding_whitespace = true,
          keymaps = {
            ["aa"] = "@parameter.outer",
            ["ia"] = "@parameter.inner",
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
            ["ii"] = "@conditional.inner",
            ["ai"] = "@conditional.outer",
            ["al"] = "@loop.outer",
            ["il"] = "@loop.inner",
            ["ab"] = "@block.outer",
            ["ib"] = "@block.inner",
            ["as"] = "@statement.outer",
          },
        },
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer", ["]a"] = "@parameter.outer" },
          goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer", ["]A"] = "@parameter.outer" },
          goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer", ["[a"] = "@parameter.outer" },
          goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer", ["[A"] = "@parameter.outer" },
        },
        swap = {
          enable = true,
          swap_next = { ["<leader>lsa"] = "@parameter.inner" },
          swap_previous = { ["<leader>lsa"] = "@parameter.inner" },
        },
        lsp_interop = {
          enable = true,
          border = "rounded",
          peek_definition_code = { ["<leader>lp"] = "@function.outer", ["<leader>lP"] = "@class.outer" },
        },
      },
      context = {
        enable = true,
        max_lines = 0,
        min_window_height = 0,
        line_numbers = true,
        multiline_threshold = 20,
        trim_scope = "inner",
        mode = "cursor",
        separator = nil,
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
}