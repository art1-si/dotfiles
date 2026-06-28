-- Global keymaps that don't belong to a specific plugin.
-- Plugin-specific bindings are defined next to their setup() calls in lua/plugins/*.
--
-- Leader is <space> (set in options.lua). Replaces the old VSCode shift+space leader.

local map = function(mode, lhs, rhs, desc)
  vim.keymap.set(mode, lhs, rhs, { desc = desc, silent = true, noremap = true })
end

-- Escape insert mode with `jj` (from VSCode vim.insertModeKeyBindings)
map("i", "jj", "<Esc>", "Escape")
map("i", "kJ", "<Esc>", "Escape")

-- Clear search highlight on <Esc>
map("n", "<Esc>", "<Cmd>nohlsearch<CR>", "Clear search highlight")

-- Save / quit
map("n", "<leader>ww", "<Cmd>write<CR>", "Save")
map("n", "<leader>wq", "<Cmd>wq<CR>", "Save and quit")
map("n", "<leader>qq", "<Cmd>quit<CR>", "Quit window")
map("n", "<leader>qa", "<Cmd>qa!<CR>", "Force quit all")

-- Window navigation: <leader>h/j/k/l — mirrors VSCode vim.normalModeKeyBindings focus groups
map("n", "<leader>wh", "<C-w>h", "Focus left window")
map("n", "<leader>wj", "<C-w>j", "Focus window below")
map("n", "<leader>wk", "<C-w>k", "Focus window above")
map("n", "<leader>wl", "<C-w>l", "Focus right window")

-- Split / move windows (VSCode shift+space w / p / c analogues)
map("n", "<leader>wv", "<C-w>v", "Split window vertical")
map("n", "<leader>ws", "<C-w>s", "Split window horizontal")
map("n", "<leader>wc", "<Cmd>close<CR>", "Close current window")

-- Buffers (until bufferline lands in phase 2):cycle/numbers
map("n", "<S-Tab>", "<Cmd>bprevious<CR>", "Previous buffer")
map("n", "<Tab>", "<Cmd>bnext<CR>", "Next buffer")
map("n", "<leader>bd", "<Cmd>bdelete<CR>", "Delete buffer")

-- Move lines up/down in visual/normal mode (handy replacements for j/k block moves)
map("v", "J", ":m '>+1<CR>gv=gv", "Move selection down")
map("v", "K", ":m '<-2<CR>gv=gv", "Move selection up")

-- Keep cursor in place on J and on <C-d>/<C-u>
map("n", "J", "mzJ`z", "Join lines, keep cursor")
map("n", "<C-d>", "<C-d>zz", "Half-page down, centered")
map("n", "<C-u>", "<C-u>zz", "Half-page up, centered")
map("n", "n", "nzzzv", "Next match centered")
map("n", "N", "Nzzzv", "Prev match centered")

-- Don't lose paste register when pasting over a selection
map("x", "p", '"_dP"', "Paste without yanking overwritten text")
map("x", "P", '"_dP"', "Paste without yanking overwritten text")

-- Yank to system clipboard via <leader>y (primary through OSC52 set up by terminal)
map({ "n", "x" }, "<leader>y", '"+y', "Yank to system clipboard")
map("n", "<leader>Y", '"+Y', "Yank line to system clipboard")

-- Quickfix / location navigation (defined here so even without trouble.nvim they work)
map("n", "]q", "<Cmd>cnext<CR>zz", "Next quickfix")
map("n", "[q", "<Cmd>cprev<CR>zz", "Prev quickfix")
map("n", "<leader>xo", "<Cmd>copen<CR>", "Open quickfix list")

-- Sane window resize with arrows (terminals eat these sometimes; fine as fallback)
map("n", "<C-Up>", "<Cmd>resize +2<CR>", "Resize window taller")
map("n", "<C-Down>", "<Cmd>resize -2<CR>", "Resize window shorter")
map("n", "<C-Left>", "<Cmd>vertical resize -2<CR>", "Resize window narrower")
map("n", "<C-Right>", "<Cmd>vertical resize +2<CR>", "Resize window wider")

-- Disable Ex mode (Q) — VSCode users instinctively reach for Q for everything
map("n", "Q", "<Nop>", "Disable Ex mode")

-- Telescope-driven fuzzy finders (plugin loaded on first invocation via `cmd`).
-- Mirrors VSCode Cmd+P / Cmd+Shift+F / Cmd+B / Cmd+Shift+P workflow.
-- Some use <cmd> so they work even when telescope.lua isn't yet loaded (lazy.nvim autoloads on cmd).
map("n", "<leader>ff", "<Cmd>Telescope find_files<CR>", "Find files (Cmd+P)")
map("n", "<leader>fg", "<Cmd>Telescope live_grep<CR>", "Live grep (Cmd+Shift+F)")
map("n", "<leader>fF", "<Cmd>Telescope find_files cwd=<C-r>=fnamemodify(expand('%'), ':h')<CR><CR>", "Find files in buffer dir")
map("n", "<leader>fb", "<Cmd>Telescope buffers<CR>", "Find buffers")
map("n", "<leader>fo", "<Cmd>Telescope oldfiles<CR>", "Recent files")
map("n", "<leader>fh", "<Cmd>Telescope help_tags<CR>", "Help tags")
map("n", "<leader>fk", "<Cmd>Telescope keymaps<CR>", "Keymaps")
map("n", "<leader>fc", "<Cmd>Telescope command_history<CR>", "Command history")
map("n", "<leader>fp", "<Cmd>Telescope commands<CR>", "Command palette (Cmd+Shift+P)")
map("n", "<leader>fr", "<Cmd>Telescope resume<CR>", "Resume last picker")

-- buffer-scoped fuzzy find (like VSCode Cmd+Shift+O symbol nav)
map("n", "<leader>ss", "<Cmd>Telescope current_buffer_fuzzy_find<CR>", "Fuzzy find in buffer")
map("n", "<leader>sw", "<Cmd>Telescope grep_string<CR>", "Grep word under cursor")
map("n", "<leader>sj", "<Cmd>Telescope jumplist<CR>", "Jumplist")
map("n", "<leader>sm", "<Cmd>Telescope marks<CR>", "Marks")
map("n", "<leader>sr", "<Cmd>Spectre<CR>", "Project find/replace")