-- Entry point. Keep this minimal — everything else is modular under lua/config and lua/plugins.

-- Ensure mise tool shims (flutter, dart, php, node, etc.) are in PATH
-- so LSP, DAP, and flutter-tools can resolve binaries regardless of shell init.
local mise_shims = vim.fn.expand("~/.local/share/mise/shims")
if vim.fn.isdirectory(mise_shims) == 1 then
  vim.env.PATH = mise_shims .. ":" .. vim.env.PATH
end

-- Load core (lazy.nvim is bootstrapped inside config.lazy; it then imports plugins).
require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.lazy")

-- Debug: log all messages for troubleshooting insert mode errors
local msg_log = vim.fn.expand("~/.config/nvim/msg.log")
vim.api.nvim_create_autocmd("MsgHistory", {
  callback = function() end,
})
vim.api.nvim_create_autocmd("UIEnter", {
  once = true,
  callback = function()
    vim.schedule(function()
      os.remove(msg_log)
    end)
  end,
})

-- Set colorscheme ASAP so first painted frame matches our theme.
-- catppuccin is lazy=false (loaded eagerly) in lua/plugins/theme.lua, so it's available here.
pcall(vim.cmd.colorscheme, "catppuccin")