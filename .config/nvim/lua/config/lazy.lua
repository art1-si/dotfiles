-- Bootstrap lazy.nvim and import plugins from lua/plugins/*.
-- lazy.nvim is the ONLY plugin manager used (no LazyVim distribution).

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    repo,
    lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = { { import = "plugins" } },

  defaults = {
    -- By default, plantown plugins are lazy-loaded via configured event/cmd/ft keys.
    -- Set lazy=true to force lazy-load everything (recommended once keymaps are in).
    lazy = false,
  },

  -- Apply the theme on `:Lazy restore` etc. Falls back to a built-in if catppuccin missing.
  install = {
    missing = true,
    colorscheme = { "catppuccin", "habamax" },
  },

  -- Keep plugin versions tracked in lazy-lock.json (committed) but don't auto-bump.
  checker = { enabled = false, frequency = 3600 },
  change_detection = { enabled = true, notify = false },

  performance = {
    rtp = {
      disabled_plugins = {
        "gzip", "matchit", "matchparen", "netrwPlugin", "tarPlugin",
        "tohtml", "tutor", "zipPlugin",
      },
    },
  },

  -- Quiet UI
  ui = { border = "rounded" },

  readme = { enabled = true },
})