#!/bin/bash
DOTFILES=`pwd`

# Vim
ln -s "$DOTFILES/vim" "$HOME/.vim"
ln -s "$DOTFILES/vim/.vimrc" "$HOME/.vimrc"

# ZSH
ln -s "$DOTFILES/zsh/oh-my-zsh" "$HOME/.oh-my-zsh"
ln -s "$DOTFILES/zsh/.zshrc" "$HOME/.zshrc"

Sublime Text
SUBLIME="$HOME/Library/Application Support/Sublime Text 2"
mkdir -p "$SUBLIME/old"
for directory in "Packages" "Installed Packages" "Pristine Packages"
do
	mv "$SUBLIME/$directory" "$SUBLIME/old"
	ln -s "$DOTFILES/sublime/$directory" "$SUBLIME"
done

PREFERENCES="$HOME/Library/Preferences"
# iTerm
mkdir -p "$PREFERENCES/old"
mv "$PREFERENCES/net.sourceforge.iTerm.plist" "$PREFERENCES/old"
ln -s "$DOTFILES/zsh/iterm/net.sourceforge.iTerm.plist" "$PREFERENCES"

# tig
ln -s "$DOTFILES/tig/.tigrc" "$HOME/.tigrc"

# rbenv
ln -s "$DOTFILES/rbenv" "$HOME/.rbenv"
mkdir -p "$HOME/.rbenv/plugins"
ln -s "$DOTFILES/ruby-build" "$HOME/.rbenv/plugins"

# nvm
ln -s "$DOTFILES/nvm" "$HOME/.nvm"
