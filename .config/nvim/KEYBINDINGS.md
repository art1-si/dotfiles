# Keybindings Manual

Leader key: `<space>` (VSCode's `shift+space` equivalent)

## General

| Key | Action |
|---|---|
| `jj` | Escape insert mode |
| `<Esc>` | Clear search highlight |
| `<leader>ww` | Save file |
| `<leader>wq` | Save and quit |
| `<leader>qq` | Close window |
| `<leader>qa` | Force quit all |

## Window Navigation

| Key | Action |
|---|---|
| `<leader>wh` | Focus window left |
| `<leader>wj` | Focus window below |
| `<leader>wk` | Focus window above |
| `<leader>wl` | Focus window right |
| `<leader>wv` | Split vertical |
| `<leader>ws` | Split horizontal |
| `<leader>wc` | Close window |
| `<C-Up>` | Resize taller |
| `<C-Down>` | Resize shorter |
| `<C-Left>` | Resize narrower |
| `<C-Right>` | Resize wider |

VSCode `shift+space h/j/k/l` → `<leader>wh/j/k/l` for focus groups.
Resize with arrow keys when window splits are active.

## Buffer Management

| Key | Action |
|---|---|
| `<Tab>` | Next buffer |
| `<S-Tab>` | Previous buffer |
| `<leader>bd` | Delete (close) buffer |
| `<leader>fb` | Find buffer (Telescope) |
| `<leader>1` | Buffer 1 (if set) |
| `<leader>2` | Buffer 2 (if set) |
| `<leader>3` | Buffer 3 (if set) |
| `<leader>4` | Buffer 4 (if set) |

No tab bar — use `<Tab>`/`<S-Tab>` to cycle or `<leader>fb` for fuzzy buffer search via Telescope (like VSCode's `Ctrl+Tab` picker).

## File Finding (Telescope)

| Key | VSCode analogue | Action |
|---|---|---|
| `<leader>ff` | `Cmd+P` | Find files |
| `<leader>fg` | `Cmd+Shift+F` | Live grep (search in files) |
| `<leader>fF` | — | Find files in current buffer's directory |
| `<leader>fb` | — | Find buffers |
| `<leader>fo` | — | Recent files |
| `<leader>fh` | — | Help tags |
| `<leader>fk` | — | Keymaps |
| `<leader>fc` | — | Command history |
| `<leader>fp` | `Cmd+Shift+P` | Command palette |
| `<leader>fr` | — | Resume last picker |

Open results in a vertical split with `<C-s>` or horizontal with `<C-v>`.

## Search in Buffer

| Key | Action |
|---|---|
| `<leader>ss` | Fuzzy find in current buffer |
| `<leader>sw` | Grep word under cursor |
| `<leader>sj` | Jumplist |
| `<leader>sm` | Marks |
| `<leader>sr` | Project find/replace (Spectre) |

## LSP

| Key | Action |
|---|---|
| `<leader>ld` | Go to definition |
| `<leader>lD` | Go to declaration |
| `<leader>lt` | Go to type definition |
| `<leader>li` | Go to implementation |
| `<leader>lr` | Find references |
| `<leader>ls` | Document symbols |
| `<leader>lS` | Workspace symbols |
| `<leader>lk` | Hover documentation |
| `<C-k>` | Signature help |
| `<leader>la` | Code action |
| `<leader>ln` | Rename (F2) |
| `<leader>lf` | Format buffer |
| `<leader>ll` | Line diagnostic (float) |
| `]d` | Next diagnostic |
| `[d` | Previous diagnostic |
| `<leader>lq` | Send diagnostics to quickfix |

## Formatting

| Key | Action |
|---|---|
| `<leader>cf` | Format buffer or selection |

Format-on-save is automatic. Per-filetype formatters:

| Filetype | Formatter |
|---|---|
| Dart | `dart format` |
| PHP | `php-cs-fixer` |
| JSON / YAML / HTML / CSS / JS / TS / Markdown | `prettierd` |
| Lua | `stylua` |
| SQL | `sqlfluff` |

## Debugging (DAP)

| Key | VSCode analogue | Action |
|---|---|---|
| `<leader>db` | `F9` | Toggle breakpoint |
| `<leader>dB` | — | Conditional breakpoint |
| `<leader>dg` | — | Log point |
| `<leader>dr` | `F5` | Run / continue |
| `<leader>dc` | `F5` | Continue |
| `<leader>di` | `F11` | Step into |
| `<leader>do` | `F10` | Step over |
| `<leader>dO` | `Shift+F11` | Step out |
| `<leader>dk` | — | Step back |
| `<leader>du` | — | Up stack frame |
| `<leader>dD` | — | Down stack frame |
| `<leader>dt` | `Shift+F5` | Terminate session |
| `<leader>dx` | — | Terminate + close DAP UI |
| `<leader>dR` | — | Toggle REPL |
| `<leader>dp` | — | Pause |
| `<leader>du` | — | Toggle DAP UI sidebar |
| `<leader>de` | — | Eval word/selection |

Function keys: `F5` continue, `F6` step over, `F7` step into, `F8` step out, `F9` toggle breakpoint.

DAP adapters are installed via Mason:
- **Dart/Flutter**: `dart-debug-adapter`
- **PHP**: `php-debug-adapter` (Xdebug, listens on port 9003)

## Flutter (flutter-tools)

| Key | VSCode analogue | Action |
|---|---|---|
| `<leader>rr` | — | Flutter run |
| `<leader>rl` | — | Flutter hot reload |
| `<leader>rR` | — | Flutter hot restart |
| `<leader>a` | — | Flutter attach to running app |
| `<leader>n` | — | Flutter select device |
| `<leader>rd` | — | Flutter DevTools (browser) |
| `<leader>ro` | — | Flutter widget outline |
| `<leader>rL` | — | Flutter LSP restart |

Attach (`<leader>a`) prompts for a VM Service URI — paste the URI from your running app's debug output.

## Git

| Key | Action |
|---|---|
| `<leader>g` | Git prefix (if gitsigns is configured) |

## Diagnostics / Quickfix

| Key | Action |
|---|---|
| `<leader>xx` | Trouble diagnostics |
| `<leader>xX` | Trouble buffer diagnostics |
| `<leader>xs` | Trouble document symbols |
| `<leader>xL` | Trouble loclist |
| `<leader>xQ` | Trouble quickfix |
| `<leader>xl` | LSP references/definitions (Trouble) |
| `<leader>ft` | Telescope todo |
| `<leader>xt` | Trouble todo |
| `]t` | Next todo comment |
| `[t` | Previous todo comment |
| `]q` | Next quickfix |
| `[q` | Previous quickfix |
| `<leader>xo` | Open quickfix list |

## Clipboard

| Key | Action |
|---|---|
| `<leader>y` | Yank to system clipboard |
| `<leader>Y` | Yank line to system clipboard |
| `p` / `P` (visual) | Paste without overwriting yank register |

## Flash (Fast Cursor Movement)

| Key | Action |
|---|---|
| `s` | Flash jump (type 2 chars to teleport) |
| `S` | Flash treesitter jump (jump to semantic node) |
| `R` | Flash remote (jump to visible window) |

Labels appear inline — type the shown characters to jump. Replaces VSCode `shift+space q/e` relative jump workflow.

## Text Objects

| Keys | Selects | Motion |
|---|---|---|
| `af` / `if` | Around / inner function | `]f` / `[f` next/prev function |
| `ac` / `ic` | Around / inner class | `]c` / `[c` next/prev class |
| `aa` / `ia` | Around / inner argument | `]a` / `[a` next/prev argument |
| `ab` / `ib` | Around / inner block | — |
| `ai` / `ii` | Around / inner indent | — |
| `al` / `il` | Around / inner loop | `]l` / `[l` next/prev loop |

Used in operator+object patterns like `daf` (delete around function), `ci{` (change inside braces).

## Surround

| Key | Action |
|---|---|
| `ys{motion}{char}` | Add surround (e.g. `ysiw"` wraps word in quotes) |
| `ds{char}` | Delete surround (e.g. `ds"` removes quotes) |
| `cs{from}{to}` | Change surround (e.g. `cs"'` changes `"` to `'`) |

## Comments

| Key | Action |
|---|---|
| `gcc` | Toggle comment on current line |
| `gc{motion}` | Toggle comment on motion |
| `gbc` | Toggle comment block |

## Movement (Enhanced)

| Key | Action |
|---|---|
| `J` | Join lines, keep cursor in place |
| `<C-d>` | Page down, center cursor |
| `<C-u>` | Page up, center cursor |
| `n` / `N` | Next/prev search match, center cursor |

## Explorer (Neo-tree)

| Key | Action |
|---|---|
| `<leader>ee` | Toggle file explorer |
| `<leader>ef` | Reveal current file in explorer |
| `<leader>eb` | Toggle buffers explorer |
| `<leader>eg` | Toggle git status explorer |

Standard file operations inside explorer: `a` add file, `d` delete, `r` rename, `c` copy, `p` paste, `y` copy-to-clipboard path.

## Window Splits (Telescope)

When a Telescope picker is open:
- `<C-s>` — open selection in vertical split
- `<C-v>` — open selection in horizontal split
