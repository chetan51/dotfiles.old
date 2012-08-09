#!/bin/bash
DOTFILES=`pwd`

# Vim
ln -s "$DOTFILES/vim" "$HOME/.vim"
ln -s "$DOTFILES/vim/.vimrc" "$HOME/.vimrc"

# ZSH
ln -s "$DOTFILES/zsh/.zshrc" "$HOME/.zshrc"

# Sublime Text
SUBLIME="$HOME/Library/Application Support/Sublime Text 2"
mkdir "$SUBLIME/old"
for directory in "Packages" "Installed Packages" "Pristine Packages" "Settings"
do
	mv "$SUBLIME/$directory" "$SUBLIME/old"
	ln -s "$DOTFILES/sublime/$directory" "$SUBLIME"
done
