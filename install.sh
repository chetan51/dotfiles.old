#!/bin/bash
DOTFILES=`pwd`

# Vim
ln -s "$DOTFILES/vim" "$HOME/.vim"
ln -s "$DOTFILES/vim/.vimrc" "$HOME/.vimrc"

# ZSH
ln -s "$DOTFILES/zsh/prezto" "$HOME/.zprezto"
setopt EXTENDED_GLOB
for rcfile in $DOTFILES/zsh/runcoms/*; do
  ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
done

# Sublime Text
SUBLIME="$HOME/Library/Application Support/Sublime Text 3"
mkdir -p "$SUBLIME/old"
for directory in "Packages" "Installed Packages"
do
	mv "$SUBLIME/$directory" "$SUBLIME/old"
	ln -s "$DOTFILES/sublime/$directory" "$SUBLIME"
done

PREFERENCES="$HOME/Library/Preferences"
# iTerm
mkdir -p "$PREFERENCES/old"
mv "$PREFERENCES/com.googlecode.iterm2.plist" "$PREFERENCES/old"
ln -s "$DOTFILES/iterm/com.googlecode.iterm2.plist" "$PREFERENCES"

# tig
ln -s "$DOTFILES/tig/.tigrc" "$HOME/.tigrc"

# rbenv
ln -s "$DOTFILES/rbenv" "$HOME/.rbenv"
mkdir -p "$HOME/.rbenv/plugins"
ln -s "$DOTFILES/ruby-build" "$HOME/.rbenv/plugins"

# nvm
ln -s "$DOTFILES/nvm" "$HOME/.nvm"
