#!/bin/bash

mkdir -p ~/.config/nvim
ln -s "$(pwd)/init.vim" ~/.config/nvim/init.vim
ln -s "$(pwd)/.tmux.conf" ~/.tmux.conf
ln -s "$(pwd)/.tmux-wsl" ~/.tmux-wsl
ln -s "$(pwd)/.tmux-macos" ~/.tmux-macos
