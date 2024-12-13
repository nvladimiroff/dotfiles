#!/bin/bash

mkdir -p ~/.config/nvim
mkdir -p ~/.config/alacritty
ln -s "$(pwd)/init.lua" ~/.config/nvim/init.lua
ln -s "$(pwd)/.gitconfig" ~/.gitconfig
ln -s "$(pwd)/.tmux.conf" ~/.tmux.conf
ln -s "$(pwd)/.alacritty.toml" ~/.config/alacritty/alacritty.toml
