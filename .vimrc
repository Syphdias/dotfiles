syntax on
    let g:jellybeans_overrides = {
    \    'Search': { 'guifg': '303030', 'guibg': 'f0f000',
    \              'ctermfg': 'Black', 'ctermbg': 'Yellow',
    \              'attr': 'bold' },
    \}
colorscheme jellybeans
"set bg=dark
"set clipboard=autoselect,exclude:.*
set viminfo='100,<1000,s100,h
set tabstop=8 softtabstop=4 expandtab shiftwidth=4 smarttab
autocmd FileType yaml set shiftwidth=2

"set number relativenumber " linenumbers

set scrolloff=3
set modeline      " Enables infile settings
set wildmenu      " Better command-line completion
set wildmode=longest,list,full " ???
"set DoMatchParen " ?????
set showcmd       " Show partial commands in the last line of the screen
set hlsearch      " Highlight searches (use <C-L> to temporarily turn off highlighting; see the mapping of <C-L> below)
set incsearch     " Highlight every mached char you type (jumps for partials and back for none)
set ignorecase    " Use case insensitive search
set smartcase     " except when using capital letters
set foldlevel=5   " to expand yaml folds by default
set cindent       " https://vim.fandom.com/wiki/Restoring_indent_after_typing_hash
set cinkeys-=0#   "   prevent inserting # from indenting (also next line)
set indentkeys-=0# "  -> does not work!?

if has("autocmd") " save cursor position
  autocmd BufReadPost *
      \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
      \ |   exe "normal! g`\""
      \ | endif
endif

set undofile               " maintain persistent undo history
set undodir=~/.vim/undodir " folder with undo files

" status line
"set laststatus=2
"set statusline+=%t

" Keybinds
map <F2> :TableModeRealign <CR>
nmap <C-n> :set invnumber invrelativenumber <CR>
nmap <C-h> :nohlsearch <CR>

" http://vim.wikia.com/wiki/Example_vimrc

" set spell spl=de,en sps=20 spf=~/.vim/spell/de.add

" syntastic 'defaults'
filetype plugin indent on "https://blog.netways.de/2012/10/30/puppet-und-vim/

autocmd filetype markdown setlocal spell spl=en,de_20 textwidth=80
autocmd FileType gitcommit setlocal spell spl=en,de_20 textwidth=72

set statusline=%f\ %h%w%m%r\            " from default
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
set statusline+=%=%(%l,%c%V\ %=\ %P%)	" from default

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 1
"let g:syntastic_quiet_messages = {
"    \ "regex": '[single_quote_string_with_variables]',
"    \ "file:p": ['\m\c\.p$'] }

" checkers
"let g:syntastic_puppet_checkers = ['puppet-lint']
" von JD (yaml)
let g:syntastic_yaml_checkers = ['yamllint']
let g:syntastic_yaml_yamllint_args = "-c ~/.yamllint"
let g:syntastic_aggregate_errors = 1
let g:syntastic_enable_signs=1
"let g:syntastic_puppet_puppetlint_args="--no-140chars-check"
let g:syntastic_puppet_puppetlint_args="--no-140chars-check --no-autoloader_layout-check"
let g:syntastic_python_flake8_args="--append-config ~/.config/flake8"

" neovim only
if has('nvim')
    set list         " only shows relevant stuff in nvim
    set laststatus=1 " disable purly cosmetic bs bar
    " remap switch to normal mode
    tnoremap <Esc> <C-\><C-n>
    " show terminal cursor (default theme does not support that otb)
    hi! TermCursorNC ctermfg=15 guifg=#fdf6e3 ctermbg=14 guibg=#93a1a1 cterm=NONE gui=NONE
    set inccommand=split
endif

" http://chneukirchen.org/dotfiles/.vimrc ?
