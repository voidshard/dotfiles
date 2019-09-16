" -- template --

call plug#begin('~/.local/share/nvim/plugged')

" colours
Plug 'chriskempson/base16-vim'
Plug 'rafi/awesome-vim-colorschemes'

" read local .editorconfig files
Plug 'editorconfig/editorconfig-vim'

" fuzzy file find / grep / replace
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'dkprice/vim-easygrep'
"      <Leader>vv  - Grep for the word under the cursor, match all occurences,
"                   like |gstar|
"      <Leader>vV  - Grep for the word under the cursor, match whole word, like
"                   |star|
"      <Leader>vr  - Perform a global search on the word under the cursor
"                   and prompt for a pattern with which to replace it.

" commenting powers
Plug 'scrooloose/nerdcommenter'

"  Code completion and what not for various things
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'neoclide/coc.nvim', {'tag': '*', 'branch': 'release'}
Plug 'neoclide/coc-snippets', {'do': 'yarn install --frozen-lockfile'}
Plug 'neoclide/coc-tsserver', {'do': 'yarn install --frozen-lockfile'}
Plug 'neoclide/coc-prettier', {'do': 'yarn install --frozen-lockfile'}
Plug 'neoclide/coc-eslint', {'do': 'yarn install --frozen-lockfile'}
Plug 'neoclide/coc-tslint', {'do': 'yarn install --frozen-lockfile'}
Plug 'neoclide/coc-css', {'do': 'yarn install --frozen-lockfile'}
Plug 'neoclide/coc-lists', {'do': 'yarn install --frozen-lockfile'} " mru and stuff
Plug 'neoclide/coc-highlight', {'do': 'yarn install --frozen-lockfile'} " color highlighting
Plug 'heavenshell/vim-pydocstring'

" Enhanced status line & helpful indications
Plug 'vim-airline/vim-airline'  " vim-airline/vim-airline
Plug 'vim-airline/vim-airline-themes'  " vim-airline-themes
Plug 'airblade/vim-gitgutter'  " git change information
Plug 'tpope/vim-fugitive'  " various git functions
Plug 'RRethy/vim-illuminate'  " highlight work under cursor

" Snippets
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

" fancy icons & filebrowser
Plug 'scrooloose/nerdtree'
Plug 'ryanoasis/vim-devicons'

" super undo powers
Plug 'mbbill/undotree'

call plug#end()

set shell=/bin/sh

"  --- scrooloose/nerdcommenter
"[count]<leader>ci |NERDCommenterInvert| Toggles the comment state of the selected line(s) individually
"[count]<leader>c<space> |NERDCommenterToggle| Toggles the comment state of the selected line(s). If the topmost selected line is commented, all selected lines are uncommented and vice versa.

" Allow commenting and inverting empty lines (useful when commenting a region)
let g:NERDCommentEmptyLines = 1
" Enable trimming of trailing whitespace when uncommenting
let g:NERDTrimTrailingWhitespace = 1


" set leader to space key
let mapleader="\<SPACE>"

" Configure undo tree
nnoremap <leader>u :UndotreeToggle<cr>

if has("persistent_undo")
    set undodir="~/.undodir"
    set undofile
endif

" Open nerdtree
map <C-z> :NERDTreeToggle<CR>

" Tet showmatch           " Show matching brackets.
set formatoptions+=o    " Continue comment marker in new lines.
set expandtab           " Insert spaces when TAB is pressed.
set tabstop=4           " Render TABs using this many spaces.
set softtabstop=4
set shiftwidth=4        " Indentation amount for < and > commands.

" misc
set cursorline 
set splitright
set nu  " show line numbers
set dictionary+=/usr/share/dict/words
set dictionary+=/usr/share/dict/british-english
set dictionary+=/usr/share/dict/cracklib-small
set dictionary+=/usr/share/dict/corncob_lowercase
set complete+=k  " use dictionary lookup <CTRL-X><CTRL-K>

" UltiSnips
let g:UltiSnipsExpandTrigger="<C-j>"
let g:UltiSnipsJumpForwardTrigger="<C-j>"
let g:UltiSnipsJumpBackwardTrigger="<C-k>"

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
" nmap <c-[> <c-[>:redraw!<cr>

nmap <silent> <C-p> <Plug>(pydocstring)

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
let g:airline#extensions#tabline#enabled = 2
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline#extensions#tabline#right_sep = ' '
let g:airline#extensions#tabline#right_alt_sep = '|'
let g:airline_left_sep = ' '
let g:airline_left_alt_sep = '|'
let g:airline_right_sep = ' '
let g:airline_right_alt_sep = '|'


" colour
set termguicolors
syntax on
colorscheme dracula
hi normal guibg=none ctermbg=none

" ====================================================== python
  " (python) Deoplete                                                                                 

set expandtab
set tabstop=4
set shiftwidth=4
set expandtab

" ======================================================= Golang
" GoToDefinition: C-]
" Build / check: <leader>b
" OpenTest file: GoAlternate (:A)
" OpenTest file in split: (:AV / :AS)
" ]]: jump to next function
" [[: jump to previous function

autocmd Filetype go command! -bang A call go#alternate#Switch(<bang>0, 'edit')
autocmd Filetype go command! -bang AV call go#alternate#Switch(<bang>0, 'vsplit')
autocmd Filetype go command! -bang AS call go#alternate#Switch(<bang>0, 'split')

let g:deoplete#sources#go#unimported_packages = 1
let g:deoplete#sources#go#fallback_to_source = 1
let g:deoplete#sources#go#source_importer = 1

nnoremap <C-i> :GoImports<cr> " runs goimports
nmap <leader>v :AV<cr> " open test file in vsplit
nmap <leader>f :GoFmt<cr> " run gofmt
nmap <leader>l :GoLint<cr> " run go linter

" close scratch when insert mode exits
autocmd InsertLeave * if pumvisible() == 0|pclose|endif


