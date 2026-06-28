-- Entry point. Keep this minimal — everything else is modular under lua/config and lua/plugins.

-- Load core (lazy.nvim is bootstrapped inside config.lazy; it then imports plugins).
require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.lazy")

-- Set colorscheme ASAP so first painted frame matches our theme.
-- catppuccin is lazy=false (loaded eagerly) in lua/plugins/theme.lua, so it's available here.
pcall(vim.cmd.colorscheme, "catppuccin")