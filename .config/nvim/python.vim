" python
  " (python) Deoplete                                                                                 
let g:tmuxcomplete#trigger = ''                                                            
let g:deoplete#enable_at_startup = 1                                                       
let g:deoplete#enable_smart_case = 1                                                       
set completeopt=longest,menuone,preview                                                    
let g:deoplete#sources = {}                                                                
let g:deoplete#sources._=['omni', 'member', 'tag', 'file']                                 
let g:SuperTabDefaultCompletionType = "<c-n>"                                              
let g:SuperTabClosePreviewOnPopupClose = 1                                                 
let g:echodoc#enable_at_startup = 1                                                        
autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif                   
set shortmess+=c                                                                           
inoremap <expr> <cr> pumvisible() ? "\<c-y>" : "\<c-g>u\<cr>"                              
inoremap <expr><tab>  pumvisible() ? "\<c-n>" : "\<tab>"                                   
inoremap <expr><C-h> deoplete#smart_close_popup()."\<C-h>"                                 
inoremap <expr><BS>  deoplete#smart_close_popup()."\<C-h>"                                 
inoremap <silent><expr> <c-space> deoplete#mappings#manual_complete()                      
inoremap <silent><expr> <esc> pumvisible() ? "<c-e><esc>" : "<esc>" 
set expandtab
set tabstop=4
set shiftwidth=4
set expandtab
let python_highlight_all = 1
let g:deoplete#sources['python'] = g:deoplete#sources._ + ['jedi']
let g:deoplete#sources#jedi#show_docstring = 1
set tabstop=8 softtabstop=0 expandtab shiftwidth=4 smarttab



