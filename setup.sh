#!/bin/bash

# brew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
(
  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"'
) >>$HOME/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"

brew update

# git
brew install git
git config --global user.name "Theodor-Felix Iacob"
git config --global user.email "toyo.iacob@gmail.com"
ssh-keygen -t rsa -b 4096 -C "toyo.iacob@gmail.com" -f $HOME/.ssh/github
eval "$(ssh-agent -s)"
ssh-add --apple-use-keychain $HOME/.ssh/github

# git sign with gpg
brew install gpg2 gnupg pinentry-mac
git config --global commit.gpgsign true

brew install stow

brew install --cask kitty

#tmux
brew install tmux
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
tmux source $HOME/.config/tmux/tmux.conf

#nvim
brew install nvim
zsh <(curl -s https://raw.githubusercontent.com/zap-zsh/zap/master/install.zsh) --branch release-v

brew install lazygit

brew install fzf fd

brew install bat

brew install zoxide

brew install tlrc

brew install eza

brew install starship

brew install thefuck

brew install yazi ffmpegthumbnailer sevenzip jq poppler fd ripgrep fzf zoxide imagemagick font-symbols-only-nerd-font

brew install node

brew install go
go install gotest.tools/gotestsum@latest

brew install rust

brew install protobuf

brew install luarocks

stow aerospace kitty nvim starship tmux zsh -t $HOME

#mac specific stuff
brew install --cask nikitabobko/tap/aerospace
brew install --cask raycast

echo "Add the SSH key to your Github account"
echo "Setup gnupg to sign commits https://gist.github.com/troyfontaine/18c9146295168ee9ca2b30c00bd1b41e"
echo "Run prefix+I while in tmux to install tpm plugins"

echo "Enable aerospace"
echo "Disable spotlight and set Raycast shortcut"
