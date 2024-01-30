" Integrate with the system clipboard
set clipboard+=unnamedplus

nnoremap <silent> <Esc><Esc> <Esc>:nohlsearch<CR><Esc>

" show existing tab with 4 spaces width
set tabstop=2
" when indenting with '>', use 4 spaces width
set shiftwidth=2
" On pressing tab, insert 4 spaces
set expandtab

" This maybe is needed in macos?
set ttimeoutlen=50

lua require('plugins')
