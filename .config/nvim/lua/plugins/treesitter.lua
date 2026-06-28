-- Treesitter setup using the MODERN API (nvim-treesitter `main` branch).
-- Neovim 0.11+ ships core TS highlight/indent/fold APIs, so we lean on those
-- instead of the legacy `nvim-treesitter.configs` modules (archived master branch).

local M = {}

-- Parsers to auto-install (matches VSCode langs + dotfile dev).
M.ensure_installed = {
  "bash", "fish", "lua", "vim", "vimdoc", "query",
  "json", "jsonc", "yaml", "toml", "regex",
  "markdown", "markdown_inline",
  "html", "css", "scss", "javascript", "typescript",
  "dart", "php", "phpdoc",
  "git_config", "gitignore", "gitcommit", "git_rebase", "diff",
  "sql",
}

-- Filetypes where treesitter highlight should NOT be enabled (use regex hl or none).
M.no_highlight = {}

-- Textobject query strings shared by move + select.
M.textobjects = {
  ["function.outer"] = "@function.outer",
  ["function.inner"] = "@function.inner",
  ["class.outer"]    = "@class.outer",
  ["class.inner"]    = "@class.inner",
  ["parameter.outer"] = "@parameter.outer",
  ["parameter.inner"] = "@parameter.inner",
  ["conditional.outer"] = "@conditional.outer",
  ["conditional.inner"] = "@conditional.inner",
  ["loop.outer"]     = "@loop.outer",
  ["loop.inner"]     = "@loop.inner",
  ["block.outer"]    = "@block.outer",
  ["block.inner"]    = "@block.inner",
  ["statement.outer"] = "@statement.outer",
}

return {
  -- nvim-treesitter itself — modern main branch, only manages parser install.
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "TSInstall", "TSInstallSync", "TSUpdate", "TSUpdateSync" },
    build = ":TSUpdate",
    init = function()
      -- Enable TS-based folding for all buffers (Neovim 0.10+ core API).
      vim.opt.foldmethod = "expr"
      vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    end,
    opts = {
      ensure_installed = M.ensure_installed,
      auto_install = true, -- install missing parsers on demand
    },
    config = function(_, opts)
      require("nvim-treesitter").setup(opts)

      -- Install missing parsers on first launch (synchronous-best-effort), then enable
      -- highlighting + indent on every TS-aware buffer.
      local function enable_ts_for_buf(bufnr)
        bufnr = bufnr or 0
        if not vim.api.nvim_buf_is_loaded(bufnr) then return end
        local ft = vim.bo[bufnr].filetype
        if ft == "" or vim.tbl_contains(M.no_highlight, ft) then return end
        -- Disable on enormous files (perf) — 60k lines is the legacy threshold.
        if vim.api.nvim_buf_line_count(bufnr) > 60000 then return end
        local lang = vim.treesitter.language.get_lang(ft) or ft
        local has_parser, _ = pcall(vim.treesitter.get_parser, bufnr, lang)
        if not has_parser then return end
        pcall(vim.treesitter.start, bufnr, lang)
        -- Treesitter-aware indentation (Neovim 0.10+).
        if ft ~= "php" then -- php indentation handled by intelephense LSP only
          vim.bo[bufnr].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end

      local ts_aug = vim.api.nvim_create_augroup("user_treesitter", { clear = true })
      vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
        group = ts_aug,
        callback = function(args) enable_ts_for_buf(args.buf) end,
      })
      -- Re-enable on FileType change too (covers re-Ft detection).
      vim.api.nvim_create_autocmd("FileType", {
        group = ts_aug,
        callback = function(args) enable_ts_for_buf(args.buf) end,
      })

      -- Lazy-load race: nvim-treesitter is configured to load on BufReadPost, so
      -- this config ran AFTER BufReadPost fired for already-open buffers. Catch up.
      for _, b in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(b) and vim.bo[b].filetype ~= "" then
          enable_ts_for_buf(b)
        end
      end
    end,
  },

  -- Textobjects + move + select via the modern (main) branch.
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      local tx = require("nvim-treesitter-textobjects")
      tx.setup({
        select = {
          lookahead = true,
          lookbehind = false,
          include_surrounding_whitespace = true,
          selection_modes = {
            ["@parameter.outer"] = "v", -- charwise
            ["@function.outer"]  = "V", -- linewise
            ["@class.outer"]     = "V",
          },
        },
        move = {
          set_jumps = true,
        },
      })

      local K = vim.keymap.set
      local move = require("nvim-treesitter-textobjects.move")
      local select = require("nvim-treesitter-textobjects.select")

      -- select (operator-pending + visual + visual-block)
      -- keymap id -> query
      local select_keys = {
        ["aa"] = M.textobjects["parameter.outer"],
        ["ia"] = M.textobjects["parameter.inner"],
        ["af"] = M.textobjects["function.outer"],
        ["if"] = M.textobjects["function.inner"],
        ["ac"] = M.textobjects["class.outer"],
        ["ic"] = M.textobjects["class.inner"],
        ["ii"] = M.textobjects["conditional.inner"],
        ["ai"] = M.textobjects["conditional.outer"],
        ["al"] = M.textobjects["loop.outer"],
        ["il"] = M.textobjects["loop.inner"],
        ["ab"] = M.textobjects["block.outer"],
        ["ib"] = M.textobjects["block.inner"],
        ["as"] = M.textobjects["statement.outer"],
      }
      for lhs, query in pairs(select_keys) do
        K({ "x", "o" }, lhs, function()
          select.select_textobject(query, "textobjects")
        end, { desc = "TS select " .. query, silent = true })
      end

      -- function / class / parameter movement
      local function bind_move(lhs_start_next, lhs_start_prev, lhs_end_next, lhs_end_prev, query)
        K({ "n", "x", "o" }, lhs_start_next, function() move.goto_next_start(query) end, { desc = "Next " .. query .. " start", silent = true })
        K({ "n", "x", "o" }, lhs_start_prev, function() move.goto_previous_start(query) end, { desc = "Prev " .. query .. " start", silent = true })
        K({ "n", "x", "o" }, lhs_end_next, function() move.goto_next_end(query) end, { desc = "Next " .. query .. " end", silent = true })
        K({ "n", "x", "o" }, lhs_end_prev, function() move.goto_previous_end(query) end, { desc = "Prev " .. query .. " end", silent = true })
      end

      bind_move("]f", "[f", "]F", "[F", M.textobjects["function.outer"])
      bind_move("]c", "[c", "]C", "[C", M.textobjects["class.outer"])
      bind_move("]a", "[a", "]A", "[A", M.textobjects["parameter.outer"])
    end,
  },

  -- Auto-close/rename HTML/Dart/PHP tags.
  {
    "windwp/nvim-ts-autotag",
    event = "InsertEnter",
    opts = {
      filetypes = { "html", "xml", "php", "dart", "javascript", "typescript", "javascriptreact", "typescriptreact" },
    },
  },
}