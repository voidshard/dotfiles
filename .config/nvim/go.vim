" Golang
" GoToDefinition: C-]
" Build / check: <leader>b
" OpenTest file: GoAlternate (:A)
" OpenTest file in split: (:AV / :AS)
" ]]: jump to next function
" [[: jump to previous function

autocmd Filetype go command! -bang A call go#alternate#Switch(<bang>0, 'edit')
autocmd Filetype go command! -bang AV call go#alternate#Switch(<bang>0, 'vsplit')
autocmd Filetype go command! -bang AS call go#alternate#Switch(<bang>0, 'split')

nnoremap <C-b> :GoDef<cr>  " go to defintion
nmap <leader>b :GoBuild<cr>
nmap <leader>t :GoAlternate<cr> " alternate between file.go and file_test.go
nmap <leader>v :AV<cr> " open test file in vsplit

