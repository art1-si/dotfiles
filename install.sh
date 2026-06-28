#!/usr/bin/env bash
set -euo pipefail

# ─────────────────────────────────────────────────────────────
#  dotfiles/install.sh
#  Bootstraps the Neovim config on a fresh machine.
#  Idempotent — safe to re-run.
# ─────────────────────────────────────────────────────────────

DOTFILES_REPO="https://github.com/art1-si/dotfiles.git"
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"
NVIM_CONFIG="$HOME/.config/nvim"

GREEN='\033[0;32m'; YELLOW='\033[1;33m'; CYAN='\033[0;36m'; NC='\033[0m'
info() { echo -e "${CYAN}──>${NC} $1"; }
ok()   { echo -e "${GREEN}  ✓${NC} $1"; }
warn() { echo -e "${YELLOW}  ⚠${NC} $1"; }

FORCE=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --force) FORCE=true; shift ;;
    --help|-h)
      echo "Usage: install.sh [--force]"; exit 0 ;;
    *) echo "Unknown option: $1"; exit 1 ;;
  esac
done

# ── Prerequisites ──────────────────────────────────────────

info "Checking prerequisites…"
command -v git  >/dev/null 2>&1 || { echo "git required"; exit 1; }
command -v curl >/dev/null 2>&1 || { echo "curl required"; exit 1; }
command -v nvim >/dev/null 2>&1 || warn "Neovim not found (install it first)"
ok "git + curl found"

# ── Clone / sync dotfiles ──────────────────────────────────

if [[ -d "$DOTFILES_DIR/.git" ]]; then
  info "Updating dotfiles…"
  git -C "$DOTFILES_DIR" pull --ff-only
else
  info "Cloning dotfiles…"
  git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
fi
ok "Dotfiles at $DOTFILES_DIR"

# ── Symlink ~/.config/nvim ─────────────────────────────────

if [[ -L "$NVIM_CONFIG" ]] && [[ "$(readlink "$NVIM_CONFIG")" == "$DOTFILES_DIR/.config/nvim" ]]; then
  ok "Symlink already points to dotfiles"
elif [[ -e "$NVIM_CONFIG" ]]; then
  if $FORCE; then
    warn "Overwriting $NVIM_CONFIG (--force)"
    mv "$NVIM_CONFIG" "$NVIM_CONFIG.bak.$(date +%s)"
  else
    echo ""
    echo -n "  ~/.config/nvim exists. Backup and replace? [y/N] "
    read -r ans
    if [[ "$ans" =~ ^[Yy] ]]; then
      mv "$NVIM_CONFIG" "$NVIM_CONFIG.bak.$(date +%s)"
    else
      warn "Skipping symlink"
    fi
  fi
fi

if [[ ! -e "$NVIM_CONFIG" ]]; then
  ln -sfn "$DOTFILES_DIR/.config/nvim" "$NVIM_CONFIG"
  ok "Symlinked $NVIM_CONFIG → $DOTFILES_DIR/.config/nvim"
fi

# ── Install mise (version manager) ─────────────────────────

if ! command -v mise &>/dev/null; then
  info "Installing mise…"
  curl https://mise.run | sh
  # shellcheck disable=SC2016
  echo 'eval "$(~/.local/bin/mise activate bash)"' >> "$HOME/.bashrc"
  export PATH="$HOME/.local/bin:$PATH"
  ok "mise installed"
else
  ok "mise already installed"
fi

# ── Install Neovim plugins (headless) ──────────────────────

info "Installing Neovim plugins via lazy.nvim…"
nvim --headless "+Lazy! sync" +qa 2>&1 | tail -5
ok "Plugins installed"

# ── Done ───────────────────────────────────────────────────

echo ""
echo -e "${GREEN}  ┌──────────────────────────────────────────┐${NC}"
echo -e "${GREEN}  │  dotfiles bootstrap complete!             │${NC}"
echo -e "${GREEN}  └──────────────────────────────────────────┘${NC}"
echo ""
echo "  Open nvim and Mason will auto-install LSPs on first file open."
echo "  Or run :Mason to see available tools."
echo ""
