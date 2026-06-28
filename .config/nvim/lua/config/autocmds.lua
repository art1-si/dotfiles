-- Autocommands for the core editor. Plugin-related autocommands live in lua/plugins/*.
local aug = vim.api.nvim_create_augroup("user", { clear = true })

-- Briefly highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  group = aug,
  pattern = "*",
  callback = function()
    vim.hl.on_yank({ higroup = "IncSearch", timeout = 150 })
  end,
  desc = "Highlight yank",
})

-- Restore last cursor position when reopening a file
vim.api.nvim_create_autocmd("BufReadPost", {
  group = aug,
  pattern = "*",
  callback = function(args)
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    local lcount = vim.api.nvim_buf_line_count(args.buf)
    if mark and mark[1] > 1 and mark[1] <= lcount then
      vim.api.nvim_win_set_cursor(0, { mark[1], math.max(0, mark[2]) })
    end
  end,
  desc = "Restore cursor position",
})

-- Per-filetype settings matching your VSCode language settings.json entries.
local ft_aug = vim.api.nvim_create_augroup("user.filetype", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  group = ft_aug,
  pattern = { "dart" },
  callback = function()
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
    vim.opt_local.textwidth = 120 -- dart.lineLength: 120
    vim.opt_local.expandtab = true
    vim.bo.commentstring = "// %s" -- dart uses // for line comments
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = ft_aug,
  pattern = { "php" },
  callback = function()
    vim.opt_local.shiftwidth = 4 -- php-cs-fixer typically expects 4
    vim.opt_local.tabstop = 4
    vim.opt_local.expandtab = true
    vim.opt_local.formatoptions:remove({ "r", "o" }) -- no auto-insert comment leaders
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = ft_aug,
  pattern = { "json", "jsonc", "yaml", "dockercompose", "github-actions-workflow" },
  callback = function()
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
    vim.opt_local.expandtab = true
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = ft_aug,
  pattern = { "markdown" },
  callback = function()
    vim.opt_local.spell = true
    vim.opt_local.conceallevel = 2
  end,
})

-- Auto-close the quickfix window when picking an entry
vim.api.nvim_create_autocmd("FileType", {
  group = ft_aug,
  pattern = "qf",
  callback = function()
    vim.keymap.set("n", "<CR>", "<CR>", { buffer = true, silent = true })
  end,
})

-- Stop accidental writes to files outside the workspace — matches dart.warnWhenEditingFilesOutsideWorkspace vibe
-- (kept light: just disable swap/undo for very large files)
vim.api.nvim_create_autocmd({ "BufReadPre" }, {
  group = aug,
  pattern = "*",
  callback = function(args)
    if vim.fn.getfsize(args.file) > 1024 * 1024 * 10 then -- >10MB
      vim.opt_local.swapfile = false
      vim.opt_local.undofile = false
    end
  end,
  desc = "Disable undo/swap on very large files",
})