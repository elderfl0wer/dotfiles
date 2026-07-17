#!/usr/bin/env bash
# Shreyaan Misra, July 2026
# v1 - Initial Script.

set -e

echo "Fedora Linux"

echo "Updating global packages"
sudo dnf upgrade --refresh -y

echo "Installing User Packages"
sudo dnf install coreutils gcc make python neovim clang unzip ncurses git clangd -y

echo "Setting User Programs"
cat >> ~/.bashrc << 'EOF'

bind 'TAB:menu-complete'

# User Aliases
alias ..="cd .."

alias cls="clear"

alias la="ls -a -h -l"
alias ll="ls -h -l"

alias vi="nvim"
alias vim="nvim"

EOF

touch ~/.inputrc
cat >> ~/.inputrc << 'EOF'
set bell-style none
EOF

mkdir -p ~/.config/nvim/lua
wget -P ~/.config/nvim/ https://raw.githubusercontent.com/elderfl0wer/dotfiles/refs/heads/master/neovim/init.lua
wget -P ~/.config/nvim/lua/ https://raw.githubusercontent.com/elderfl0wer/dotfiles/refs/heads/master/neovim/lua/plugins.lua https://raw.githubusercontent.com/elderfl0wer/dotfiles/refs/heads/master/neovim/lua/lsp.lua



