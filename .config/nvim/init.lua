-- Error log: captures errors to ~/.config/nvim/error.log.
-- Includes vim.notify ERROR/WARN + dump of :messages on VimLeavePre.
local _errlog = vim.fn.expand("~/.config/nvim/error.log")
if vim.fn.argc(-1) == 0 then
  local f = io.open(_errlog, "w"); if f then f:write("--- session " .. os.date("%Y-%m-%d %H:%M:%S") .. " ---\n"); f:close() end
end
local _orig_notify = vim.notify
vim.notify = function(msg, level, ...)
  if type(msg) ~= "string" then msg = vim.inspect(msg) end
  if level == vim.log.levels.ERROR or level == vim.log.levels.WARN then
    local f = io.open(_errlog, "a"); if f then f:write(os.date("%H:%M:%S") .. " [notify] " .. msg .. "\n"); f:close() end
  end
  return _orig_notify(msg, level, ...)
end
vim.api.nvim_create_autocmd("VimLeavePre", {
  callback = function()
    local f = io.open(_errlog, "a")
    if f then
      f:write("--- messages ---\n" .. vim.fn.execute("messages") .. "\n---\n")
      f:close()
    end
  end,
})

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

-- Set colorscheme ASAP so first painted frame matches our theme.
-- catppuccin is lazy=false (loaded eagerly) in lua/plugins/theme.lua, so it's available here.
pcall(vim.cmd.colorscheme, "catppuccin")