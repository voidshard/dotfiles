call plug#begin('~/.local/share/nvim/plugged')

"
""Swap top/bottom or left/right split
"Ctrl+W R
"Break out current window into a new tabview
"Ctrl+W T
"Close every window in the current tabview but the current one
"Ctrl+W o
"Max out the height of the current split
"ctrl + w _
"Max out the width of the current split
"ctrl + w |
"Normalize all split sizes, which is very handy when resizing terminal
"ctrl + w =
"Get out of vim terminal in insert mode
"ctrl + \ n
"


" vim snippets
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

" colours
Plug 'chriskempson/base16-vim'
Plug 'rafi/awesome-vim-colorschemes'

" fuzzy file find / grep / replace
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

"  Code completion and what not for various things
Plug 'hdima/python-syntax'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
" Plug 'neoclide/coc.nvim', {'do': 'yarn install --frozen-lockfile'}
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'easymotion/vim-easymotion'

" Start screen of recent files
Plug 'mhinz/vim-startify'

" Enhanced status line & helpful indications
Plug 'vim-airline/vim-airline'  " vim-airline/vim-airline
Plug 'vim-airline/vim-airline-themes'  " vim-airline-themes
" Plug 'airblade/vim-gitgutter'  " git change information
" Plug 'tpope/vim-fugitive'  " various git functions
Plug 'RRethy/vim-illuminate'  " highlight work under cursor

" fancy icons & filebrowser
Plug 'scrooloose/nerdtree'
Plug 'ryanoasis/vim-devicons'
Plug 'Xuyuanp/nerdtree-git-plugin'

" super undo powers
Plug 'mbbill/undotree'

call plug#end()

" set leader to space key
let mapleader="\<SPACE>"

" Configure undo tree
nnoremap <leader>u :UndotreeToggle<cr>

if has("persistent_undo")
    set undodir="/home/${USER}/.undodir"
    set undofile
endif

" Open nerdtree
map <C-z> :NERDTreeToggle<CR>

" Tet showmatch           " Show matching brackets.
set formatoptions+=o    " Continue comment marker in new lines.
set expandtab           " Insert spaces when TAB is pressed.
set tabstop=4           " Render TABs using this many spaces.
set shiftwidth=4        " Indentation amount for < and > commands.

" required for coc
set shell=/bin/sh

" misc
set cursorline " highlight entire line of cursor
set splitright  " when I say split I mean split right by default
set dictionary+=~/.config/nvim/words  " add UK English dict
set complete+=k  " use dictionary lookup <CTRL-X><CTRL-K>

" nerd tree devicons font
set guifont=DroidSansMono\ Nerd\ Font\ 11

" always search forward with n and backward with N
nnoremap <expr> n  'Nn'[v:searchforward]
nnoremap <expr> N  'nN'[v:searchforward]<Paste>

" shortcuts / key remaps
nnoremap <C-x> :FZF<cr>
let g:fzf_history_dir = '~/.local/share/fzf-history'
nmap ; :Buffers<cr>
nmap <leader>e :Tags<cr>
nmap <leader>r :Files<cr>
command! -bang -nargs=? -complete=dir HFiles
  \ call fzf#vim#files(<q-args>, {'source': 'ag --hidden --ignore .git -g ""'}, <bang>0)
nmap <leader>i :HFiles<cr>
nmap <leader>l :Lines<cr>
nmap <leader>a :Ag<cr>
nmap <leader>h :History<cr>
command! CmdHist call fzf#vim#command_history({'right': '40'})
command! QHist call fzf#vim#search_history({'right': '40'})

nnoremap <C-f> :buffers<cr>
nnoremap <C-t> :vsplit<cr>
nnoremap <C-c> :Ag<cr>

" file type recognition
filetype on
filetype plugin on
filetype indent on

" syntax highlighting
syntax on

" airline
" let g:airline#extensions#tabline#enabled = 2
let g:airline#extensions#tabline#enabled = 0
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline#extensions#tabline#right_sep = ' '
let g:airline#extensions#tabline#right_alt_sep = '|'
let g:airline_left_sep = ' '
let g:airline_left_alt_sep = '|'
let g:airline_right_sep = ' '
let g:airline_right_alt_sep = '|'

" Trigger configuration. You need to change this to something other than <tab> if you use one of the following:
" - https://github.com/Valloric/YouCompleteMe
" - https://github.com/nvim-lua/completion-nvim
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger='<c-j>'
let g:UltiSnipsJumpBackwardTrigger='<c-k>'
let g:UltiSnipsSnippetDirectories=["UltiSnips", "custom_snippets"]


" colour
set termguicolors
syntax on
colorscheme PaperColor
hi normal guibg=none ctermbg=none

" add please support
au BufRead,BufNewFile BUILD,*.build_def set filetype=please
au BufRead,BufNewFile BUILD,*.build_def,*.build_defs set syntax=python

" ====================================================== python
set expandtab
set tabstop=4
set shiftwidth=4
set expandtab
let python_highlight_all = 1
set tabstop=8 softtabstop=0 expandtab shiftwidth=4 smarttab
autocmd BufEnter BUILD :setlocal filetype=py

" ======================================================= Golang
" GoToDefinition: C-]
" Build / check: <leader>b
" OpenTest file: GoAlternate (:A)
" OpenTest file in split: (:AV / :AS)
" ]]: jump to next function
" [[: jump to previous function

" https://github.com/tcncloud/wollemi#vim
autocmd BufWritePost *.go silent exec '!wollemi --log fatal gofmt' shellescape(expand('%:h'), 1)

" bind coc
autocmd Filetype go command! -bang A call go#alternate#Switch(<bang>0, 'edit')
autocmd Filetype go command! -bang AV call go#alternate#Switch(<bang>0, 'vsplit')
autocmd Filetype go command! -bang AS call go#alternate#Switch(<bang>0, 'split')

nmap <leader>b :GoBuild<cr>
nmap <leader>t :GoAlternate<cr> " alternate between file.go and file_test.go
nmap <leader>v :AV<cr> " open test file in vsplit
nmap <leader>f :GoFmt<cr> " run gofmt
nmap <leader>l :GoLint<cr> " run go linter
nmap <leader>o :GoInfo<cr> " get info about identifier under the cursor
nmap <leader>d :GoDoc<cr> " display godoc for thing under cursor
nmap <leader>i :GoImports<cr> " runs goimports

" close scratch when insert mode exits
autocmd InsertLeave * if pumvisible() == 0|pclose|endif

" if gofmt fails on save dont pop up an annoying list
let g:go_fmt_fail_silently = 0

let g:go_highlight_variable_assignments = 1
let g:go_highlight_variable_declarations = 1
let g:go_highlight_fields = 1
let g:go_highlight_types = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_function_parameters = 1
let g:go_highlight_functions = 1
let g:go_highlight_operators = 1


