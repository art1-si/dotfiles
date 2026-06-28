-- Linting via nvim-lint (light, async). Pent
--
-- PHP linting is handled by intelephense LSP itself (configured in lsp.lua),
-- so we only wire currencies for non-LSP linters here:
--   - write-good / codespell for prose/markdown (off by default)
--   - shellcheck for bash
--   - fish_indent for fish
--   - sqlfluff for sql
--   - cspell for workspace words (matches VSCode cSpell.diagnosticLevel: "Hint")
--
-- Mason packages we expect to be installed (will be ensured at the bottom):
--   shellcheck, fish_indent, sqlfluff, cspell

return {
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      local lint = require("lint")
      lint.linters_by_ft = {
        bash = { "shellcheck" },
        sh = { "shellcheck" },
        fish = { "fish" },
        sql = { "sqlfluff" },
        -- cspell runs on any prose-ish filetype; toggle via :LintEnable/Cspell toggle
        -- markdown = { "cspell" }, -- disabled by default (noisy); uncomment to opt-in
      }

      -- cspell: dictionary + diagnostic style mirrors VSCode cSpell.diagnosticLevel: "Hint"
      lint.linters.cspell = lint.linters.cspell or { cmd = "cspell", stdin = false, append_fname = true, args = { "lint", "--no-progress", "--no-summary" }, stream = "stdout", parser = require("lint.parser").from_errorformat("E:%f:%l:%c - %m"), }

      -- Trigger lint on save + on InsertLeave (keeps diagnostic UI synced with VSCode error lens).
      local aug = vim.api.nvim_create_augroup("user_lint", { clear = true })
      vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
        group = aug,
        callback = function(args)
          if vim.bo[args.buf].buftype == "" and vim.bo[args.buf].filetype ~= "" then
            -- Switch to that buffer (so lsp + lint both see current ft)
            local prev = vim.api.nvim_get_current_buf()
            vim.api.nvim_set_current_buf(args.buf)
            lint.try_lint()
            vim.api.nvim_set_current_buf(prev)
          end
        end,
      })
    end,
  },
}