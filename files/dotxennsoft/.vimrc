call pathogen#infect()
call pathogen#helptags()

:imap jk <Esc>

function ToggleNERDTree()
  execute ":NERDTreeToggle"
endfunction
command -nargs=0 ToggleNERDTree :call ToggleNERDTree()

nmap nt  :ToggleNERDTree<CR>

map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

:set noswapfile
