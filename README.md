# Personal Neovim Configuration

A from-scratch Neovim setup built on top of [lazy.nvim](https://github.com/folke/lazy.nvim).
No distribution (no LazyVim / NvChad / AstroNvim) — every line is owned.

Targets Flutter (Dart) and PHP development, migrating from VSCode.

## Requirements

- Neovim **0.10+** (tested on 0.12)
- Git
- A [Nerd Font](https://www.nerdfonts.com/). This setup uses **JetBrains Mono Nerd Font**.
- `ripgrep` (for Telescope grep)
- `node` (for some LSP servers via `:Mason`)
- `lazygit` (optional, `<leader>gg`)

## Installing language toolchains (out of scope for nvim)

Install via [mise](https://mise.jdx.dev/) or your system package manager:

```sh
mise use -g flutter       # pulls `dart` in
mise use -g php@8.3
mise use -g composer
```

LSP servers, formatters and DAP adapters are installed automatically by
`mason.nvim` (Intelephense, dartls, php-cs-fixer, dart-debug-adapter, php-debug-adapter).

## Install

```sh
git clone https://github.com/<user>/dotfiles ~/dotfiles
ln -s ~/dotfiles/.config/nvim ~/.config/nvim
nvim --headless "+Lazy! sync" +qa
```

`lazy.nvim` bootstraps itself on first launch — no manual plugin install needed.

## Layout

```
.config/nvim/
├── init.lua                # entry point
└── lua/
    ├── config/             # core editor (no plugins)
    │   ├── options.lua
    │   ├── autocmds.lua
    │   ├── keymaps.lua
    │   └── lazy.lua
    └── plugins/            # one file per concern
```

See `lua/plugins/` for the per-feature breakdown.