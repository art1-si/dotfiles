# Changelog

## Phase 6 — Flutter-tools (2026-06-28)

- Added `flutter-tools.nvim` with device picker, run/attach, hot reload, DevTools, widget outline
- Keymaps: `<leader>a` attach, `<leader>n` select device, `<leader>rr` run, `<leader>rl` reload, `<leader>rR` restart, `<leader>rd` DevTools, `<leader>ro` outline
- Dart LSP management moved from `lsp.lua` to flutter-tools (with existing settings preserved)
- Dart DAP adapter/config removed from `dap.lua` — flutter-tools handles it
- Native `vim.lsp.document_color` for Flutter widget colour previews (Nvim 0.12+)
- Mise shims added to `PATH` in `init.lua` for tool resolution
- Which-key groups updated for Flutter keymaps

## Phase 5 — DAP (2026-06-28)

- `nvim-dap` with VSCode-style breakpoints and stepping
- `nvim-dap-ui` — floating left panel (scopes/breakpoints/stacks/watches) + bottom REPL/console
- `nvim-dap-virtual-text` — inline variable values at breakpoints
- Adapters: `dart-debug-adapter` (Flutter), `php-debug-adapter` (Xdebug :9003)
- DAP UI auto-opens on attach/launch, auto-closes on terminate/exited
- Red bullet breakpoint signs, yellow stopped-frame arrow
- Keymaps: `<leader>db`/`dB`/`dg` breakpoints, `<leader>dr` run, `<leader>di`/`do`/`dO` step, `<leader>du`/`dD` frames, `<leader>dt`/`dx` terminate, `<leader>dR` REPL, `<leader>dp` pause, F5–F9

## Phase 4 — LSP + Formatting + Lint + Quality (2026-06-28)

**LSP:**
- Mason + mason-lspconfig for auto-installing servers
- `intelephense` (PHP 8.3, inlayHints off, format deferred to php-cs-fixer)
- `dartls` (lineLength 120, renameFilesWithClasses prompt, showTodos)
- `lua_ls` (LuaJIT, vim globals, no telemetry)
- `jsonls` (schemastore), `yamlls` (bitbucket-pipelines schema), `cssls`, `html`, `marksman`
- blink.cmp capabilities, UFO fold range provider
- Diagnostic virtual text (current-line only, error-lens style)
- Per-buffer on-attach LSP keymaps (nav, hover, actions, diagnostics, document highlight)

**Formatting:**
- conform.nvim with format-on-save: `dart format`, `php-cs-fixer`, `prettierd` (json/yaml/html/css/js/ts/md), `stylua`, `sqlfluff`
- `<leader>cf` manual format

**Linting:**
- nvim-lint for `shellcheck` (bash/sh), `fish`, `sqlfluff` (sql)
- Triggers: BufWritePost, BufReadPost, InsertLeave

**Quality:**
- `trouble.nvim` v3 — diagnostics, symbols, loclist, quickfix
- `fidget.nvim` — LSP progress spinner
- `todo-comments.nvim` — TODO/FIXME/HACK/NOTE/WARN/PERF/TEST highlighting
- Inlay hints auto-enabled on LSP attach (intelephense excluded)

## Phase 3 — Treesitter + Completion + Editing (2026-06-28)

- Treesitter: 27 parsers, incremental selection (C-space), textobjects (af/if/ac/ic/aa/ia), function/class/cond/loop move, autotag
- `blink.cmp` — completion with LSP/path/LuaSnip/buffer sources
- `LuaSnip` + `friendly-snippets`
- `nvim-surround` — ys/ds/cs
- `Comment.nvim` — gcc/gbc/gc-motion
- `flash.nvim` — s/S/R for jump/treesitter-jump/remote
- `nvim-spectre` — project find/replace (`<leader>sr`)
- `nvim-autopairs` — loaded but disabled (matches VSCode `autoClosingBrackets: never`)
- Telescope: fzf-native + ui-select, per-picker themes

## Phase 2 — Editor UI (2026-06-28)

- `lualine` — statusline with mode colours (insert=green, visual=peach, normal=lavender)
- `neo-tree` — filesystem/buffers/git_status explorer under `<leader>e*`
- `which-key` — leader-key legend with named groups
- `noice.nvim` — cmdline/messages/popupmenu rollup
- `indent-blankline` — catppuccin rainbow indents
- `nvim-web-devicons` — file icons with php/dart/pubspec overrides

## Phase 1 — Core (2026-06-28)

- Dotfiles repo layout (`~/dotfiles/.config/nvim`)
- `lazy.nvim` as sole plugin manager (no LazyVim distribution)
- Core editor options mirroring VSCode settings (relativenumber, wrap, scrolloff, etc.)
- Per-filetype settings for dart, php, json, yaml, markdown
- Global keymaps: `<space>` leader, `jj`→Esc, window nav, buffer cycle, save/quit, clipboard
- `catppuccin-mocha` theme with transparent background and purple (#cba6f7) accents
- `lazy-lock.json` committed for reproducible installs

## Fixes (2026-06-28)

- **Treesitter**: migrated from archived `master` branch to `main`; use core `vim.treesitter.start()` for highlight; removed `vim-matchup` (CursorMoved crash) and `nvim-treesitter-context` (BufRead crash)
- **bufferline.nvim**: removed (user preference — no tabs); use `<Tab>`/`<S-Tab>` cycle + `<leader>fb` Telescope buffers
- **autocmds.lua**: fixed `nvim_set_cursor` → `nvim_win_set_cursor` (was crashing BufReadPost cursor restore)
- **lint.lua**: fixed `try_lint` signature (resolves linters by current ft)
- **blink.cmp**: fixed v1.10+ schema (moved border/winhighlight under `window.*`, dropped `enabled`)
- **which-key**: removed custom filter (was crashing on nil `m.keys`)
- **Transparency**: moved all `bg=NONE` overrides to `ColorScheme` autocmd (guaranteed to win against plugin integrations)
- **cmp-nvim-lsp**: removed dependency (broken on Nvim 0.12 with nvim-cmp not installed — we use blink.cmp)
