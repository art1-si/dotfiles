-- Core editor options, sourced before lazy.nvim boots.
-- Maps to the relevant VSCode settings.json entries as closely as Neovim allows.

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- editor.lineNumbers: relative  + number on
vim.opt.number = true
vim.opt.relativenumber = true

-- editor.wordWrap: on
vim.opt.wrap = true
vim.opt.breakindent = true

-- editor.formatOnSave handled in autocmds.lua + conform.nvim (phase 4)

-- editor.lineHeight handled by terminal/guifont

-- editor.scrollbar.{vertical,horizontal}: hidden  +  editor.cursorSurroundingLines: 0-ish
vim.opt.scrolloff = 5
vim.opt.sidescrolloff = 8

-- editor.largeFileOptimizations: false  (we want full syntax on big files)
vim.opt.virtualedit = "block"

-- UI
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes" -- always show, avoids text jitter on diagnostics
vim.opt.cursorline = true
vim.opt.fillchars = {
  eob = " ",
  horiz = "─",
  horizup = "┴",
  horizdown = "┬",
  vert = "│",
  vertleft = "┤",
  vertright = "├",
  verthoriz = "┼",
  fold = " ",
  foldopen = "",
  foldclose = "",
  foldsep = " ",
  diff = "─",
  msgsep = "─",
  stl = " ",
  stlnc = " ",
}
vim.opt.list = true
vim.opt.listchars = { tab = "│ ", trail = "·", nbsp = "␣" }
vim.opt.pumheight = 14 -- completion menu height
vim.opt.pumblend = 10 -- pseudo-transparency for popup menu
vim.opt.winborder = "rounded"

-- editor.minimap.enabled: false  -> no minimap plugin

-- whitespace / indentation (per-ft overrides live in autocmds.lua)
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.shiftround = true
vim.opt.smartindent = true
vim.opt.autoindent = true

-- search
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true

-- swap/undo
vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.undolevels = 10000

-- splits behave like VSCode: <leader>h goes left, etc. (mapped in keymaps)
vim.opt.splitright = true
vim.opt.splitbelow = true

-- perf / responsiveness
vim.opt.updatetime = 200
vim.opt.timeoutlen = 400
vim.opt.ttimeoutlen = 10

-- completion / wildmenu
vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.wildmode = "longest:full,full"
vim.opt.wildoptions = "pum"

-- grep with ripgrep (Telescope + builtin)
vim.opt.grepprg = "rg --vimgrep --smart-case --hidden"
vim.opt.grepformat = "%f:%l:%c:%m"

-- editor.cursorSmoothCaretAnimation: on
vim.opt.smoothscroll = true

-- folds rely on treesitter (phase 3); keep open by default until then
vim.opt.foldcolumn = "0"
vim.opt.foldlevelstart = 99
vim.opt.foldenable = true

-- misc
vim.opt.showmode = false -- lualine (phase 2) will render mode
vim.opt.shortmess:append({ W = true, I = true, c = true, C = true })
vim.opt.diffopt:append({ "linematch:60", "algorithm:histogram" })
vim.opt.spell = false -- opt-in per-ft in autocmds
vim.opt.spelllang = { "en" }
vim.opt.fileformats = "unix,dos"