#!/bin/bash
DOTFILES=`pwd`

# Vim
ln -s "$DOTFILES/vim" "$HOME/.vim"
ln -s "$DOTFILES/vim/.vimrc" "$HOME/.vimrc"

# ZSH
ln -s "$DOTFILES/zsh/oh-my-zsh" "$HOME/.oh-my-zsh"
ln -s "$DOTFILES/zsh/.zshrc" "$HOME/.zshrc"

# Sublime Text
SUBLIME="$HOME/Library/Application Support/Sublime Text 2"
mkdir "$SUBLIME/old"
for directory in "Packages" "Installed Packages" "Pristine Packages"
do
	mv "$SUBLIME/$directory" "$SUBLIME/old"
	ln -s "$DOTFILES/sublime/$directory" "$SUBLIME"
done

PREFERENCES="$HOME/Library/Preferences"
# iTerm
mkdir "$PREFERENCES/old"
mv "$PREFERENCES/net.sourceforge.iTerm.plist" "$PREFERENCES/old"
ln -s "$DOTFILES/zsh/iterm/net.sourceforge.iTerm.plist" "$PREFERENCES"

# tig
ln -s "$DOTFILES/tig/.tigrc" "$HOME/.tigrc"