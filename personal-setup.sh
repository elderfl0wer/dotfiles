#!/usr/bin/env bash
# Shreyaan Misra, July 2026
# v1.1 - Fixed lazy.nvim bootstrap, idempotency, toggleterm shell, ncurses-devel.

set -euo pipefail

echo "Fedora Linux"

echo "Updating global packages"
sudo dnf upgrade --refresh -y

echo "Installing User Packages"
sudo dnf install -y \
    coreutils gcc make python neovim clang unzip \
    ncurses ncurses-devel git clangd

echo "Setting User Programs"

BASHRC="$HOME/.bashrc"
MARKER="# --- setup.sh user config ---"

if ! grep -qF "$MARKER" "$BASHRC" 2>/dev/null; then
    cat >> "$BASHRC" << EOF

$MARKER
bind 'TAB:menu-complete'

# User Aliases
alias ..="cd .."
alias cls="clear"
alias la="ls -a -h -l"
alias ll="ls -h -l"
alias vi="nvim"
alias vim="nvim"
EOF
    echo "Appended aliases/config to ~/.bashrc"
else
    echo "~/.bashrc already configured, skipping"
fi

INPUTRC="$HOME/.inputrc"
touch "$INPUTRC"
if ! grep -qF "set bell-style none" "$INPUTRC"; then
    echo "set bell-style none" >> "$INPUTRC"
    echo "Configured ~/.inputrc"
else
    echo "~/.inputrc already configured, skipping"
fi

echo "Setting up Neovim config"
mkdir -p ~/.config/nvim/lua

wget -q -O ~/.config/nvim/init.lua \
    https://raw.githubusercontent.com/elderfl0wer/dotfiles/refs/heads/master/neovim/init.lua

wget -q -O ~/.config/nvim/lua/plugins.lua \
    https://raw.githubusercontent.com/elderfl0wer/dotfiles/refs/heads/master/neovim/lua/plugins.lua

wget -q -O ~/.config/nvim/lua/lsp.lua \
    https://raw.githubusercontent.com/elderfl0wer/dotfiles/refs/heads/master/neovim/lua/lsp.lua

# --- Fix: hardcoded "powershell" shell in toggleterm config won't exist on Linux ---
if grep -q 'shell = "powershell"' ~/.config/nvim/lua/plugins.lua; then
    sed -i 's/shell = "powershell",/shell = vim.o.shell,/' ~/.config/nvim/lua/plugins.lua
    echo "Patched toggleterm.nvim to use the default system shell instead of powershell"
fi

# --- Fix: init.lua errors out if lazy.nvim isn't present; bootstrap it here ---
echo "Bootstrapping lazy.nvim"
LAZYPATH="$HOME/.local/share/nvim/lazy/lazy.nvim"
if [ ! -d "$LAZYPATH" ]; then
    git clone --filter=blob:none --branch=stable \
        https://github.com/folke/lazy.nvim.git "$LAZYPATH"
else
    echo "lazy.nvim already installed, skipping"
fi

echo "Installing/syncing Neovim plugins headlessly (first run can take a minute)"
nvim --headless "+Lazy! sync" +qa || {
    echo "Plugin sync reported an issue - open nvim manually and run :Lazy sync to check."
}

echo "Done. Start a new shell (or 'source ~/.bashrc') to pick up aliases."
