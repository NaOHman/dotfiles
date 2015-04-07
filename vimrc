set autoindent
set tabstop=4
set shiftwidth=4
set expandtab
set number
set backspace=indent,eol,start
set incsearch
set scrolloff=3

colorscheme noctu
execute pathogen#infect()


nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
nnoremap <C-Up> <C-W>+
nnoremap <C-Down> <C-W>-
nnoremap <C-Left> <C-W><
nnoremap <C-Right> <C-W>> 

syntax on
filetype plugin indent on

let g:ycm_key_list_select_completion=['<TAB>','<Down>']
let g:ycm_key_list_previous_completion=['<S-TAB>','<Up>']

let airline_powerline_fonts=1
let g:airline_theme='solarized'
let delimitMate_expand_cr=1

au FileType xml,xhtml so ~/.vim/ftplugin/html_autoclosetag.vim
au FileType haskell nnoremap <buffer> <C-i> :HdevtoolsType<CR>
au FileType haskell nnoremap <buffer> <silent> <C-S-o> :HdevtoolsClear<CR>
au FileType haskell nnoremap <buffer> <silent> <C-S-p> :HdevtoolsInfo<CR>

map <C-d> :call NERDComment(0,"toggle")<CR>
map <C-n> :NERDTreeToggle<CR>
nmap <C-t> :TagbarToggle<CR>
nmap <C-d> :call NERDComment(0,"toggle")<CR>
