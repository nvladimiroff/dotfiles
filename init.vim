function! IsWSL()
  if has("unix")
    let lines = readfile("/proc/version")
    if lines[0] =~ "microsoft"
      return 1
    endif
  endif
  return 0
endfunction

if IsWSL()
  set clipboard^=unnamed

  let g:clipboard = {
        \ 'name': 'win32yank-wsl',
        \ 'copy': {
        \    '+': '/home/nvladimiroff/.local/bin/win32yank.exe -i --crlf',
        \    '*': '/home/nvladimiroff/.local/bin/win32yank.exe -i --crlf',
        \  },
        \ 'paste': {
        \    '+': '/home/nvladimiroff/.local/bin/win32yank.exe -o --lf',
        \    '*': '/home/nvladimiroff/.local/bin/win32yank.exe -o --lf',
        \ },
        \ 'cache_enabled': 0,
        \ }
end

nnoremap <silent> <Esc><Esc> <Esc>:nohlsearch<CR><Esc>

" show existing tab with 4 spaces width
set tabstop=2
" when indenting with '>', use 4 spaces width
set shiftwidth=2
" On pressing tab, insert 4 spaces
set expandtab

" This maybe is needed in macos?
set ttimeoutlen=50
