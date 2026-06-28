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

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; CYAN='\033[0;36m'; NC='\033[0m'
info()  { echo -e "${CYAN}──>${NC} $1"; }
ok()    { echo -e "${GREEN}  ✓${NC} $1"; }
warn()  { echo -e "${YELLOW}  ⚠${NC} $1"; }
err()   { echo -e "${RED}  ✗${NC} $1"; }

WITH_FLUTTER=false
WITH_PHP=false
FORCE=false

usage() {
  cat <<EOF
Usage: install.sh [options]

Options:
  --with-flutter    Install Flutter/Dart SDK via mise
  --with-php        Install PHP + Composer via mise
  --force           Overwrite existing ~/.config/nvim without prompting
  --help            Show this help
EOF
  exit 0
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --with-flutter) WITH_FLUTTER=true; shift ;;
    --with-php)     WITH_PHP=true; shift ;;
    --force)        FORCE=true; shift ;;
    --help|-h)      usage ;;
    *)              echo "Unknown option: $1"; usage ;;
  esac
done

# ── Prerequisites ──────────────────────────────────────────

info "Checking prerequisites…"

if ! command -v git &>/dev/null; then err "git is required"; exit 1; fi
if ! command -v curl &>/dev/null; then err "curl is required"; exit 1; fi

if command -v nvim &>/dev/null; then
  nvim_ver=$(nvim --version | head -1 | grep -oP '\d+\.\d+' | head -1)
  if awk "BEGIN { exit (!($nvim_ver >= 0.10)) }"; then
    ok "Neovim $nvim_ver+ found"
  else
    warn "Neovim $nvim_ver detected (0.10+ recommended)"
  fi
else
  warn "Neovim not found — will be needed after install"
fi

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
    echo -e "  ${YELLOW}~/.config/nvim already exists.${NC}"
    echo -n "  Backup and replace? [y/N] "
    read -r ans
    if [[ "$ans" =~ ^[Yy] ]]; then
      mv "$NVIM_CONFIG" "$NVIM_CONFIG.bak.$(date +%s)"
    else
      warn "Skipping symlink — existing config left as-is"
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
  ok "mise already installed ($(mise --version))"
fi

# ── Install toolchains (optional) ──────────────────────────

if $WITH_FLUTTER; then
  info "Installing Flutter/Dart SDK via mise…"
  mise use -g flutter
  ok "Flutter/Dart installed"
fi

if $WITH_PHP; then
  info "Installing PHP via mise…"
  command -v re2c &>/dev/null || { warn "re2c required for PHP build — install it (apt: apt-get install re2c, pacman: pacman -S re2c)"; }
  mise use -g php
  info "Installing Composer…"
  mise use -g composer
  ok "PHP + Composer installed"
fi

# ── Install Neovim plugins (headless) ──────────────────────

info "Installing Neovim plugins via lazy.nvim…"
nvim --headless "+Lazy! sync" +qa 2>&1 | tail -5
ok "Plugins installed"

# ── Install Mason packages ─────────────────────────────────

info "Installing LSPs, formatters, DAP adapters via Mason…"
nvim --headless "+MasonInstall --force" \
  intelephense \
  dart-debug-adapter \
  php-debug-adapter \
  prettierd stylua \
  shellcheck shfmt \
  sqlfluff \
  2>&1 | tail -5 || true
# Mason may report errors for tools whose runtimes are missing;
# that's harmless — re-run after installing the runtime.
ok "Mason packages installed (some may have been skipped)"

# ── Done ───────────────────────────────────────────────────

echo ""
echo -e "${GREEN}  ┌──────────────────────────────────────────┐${NC}"
echo -e "${GREEN}  │  dotfiles bootstrap complete!             │${NC}"
echo -e "${GREEN}  └──────────────────────────────────────────┘${NC}"
echo ""
echo "  Next steps:"
echo "    1. Restart your shell (or run 'exec \$SHELL')"
echo "    2. Open nvim and check :LspInfo for active LSPs"
echo "    3. git -C ~/dotfiles remote set-url origin git@github.com:art1-si/dotfiles.git"
echo "       (if you want to push from this device)"
echo ""
