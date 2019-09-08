set foldmethod=indent
set foldlevel=99
match Error /\t\|\s\+$/
nnoremap <silent> <F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar>:nohl<CR>
set tabstop=2 "Indentation levels every tw columns
set shiftwidth=2
set expandtab "Convert all tabs that are typed to spaces

