#!/bin/bash

mkdir -p ~/.config/nvim
mkdir -p ~/.config/alacritty
ln -s "$(pwd)/init.vim" ~/.config/nvim/init.vim
ln -s "$(pwd)/.tmux.conf" ~/.tmux.conf
ln -s "$(pwd)/.alacritty.toml" ~/.config/alacritty/alacritty.toml
