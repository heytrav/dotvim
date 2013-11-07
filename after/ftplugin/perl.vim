colorscheme candycode


"======[ Folding  ]==============
""set foldmethod=marker


"Adjust keyword characters for Perlish identifiers...
"set iskeyword+=:
"set iskeyword+=$
"set iskeyword+=%
"set iskeyword+=@
"set iskeyword-=,


"=====[ Smarter searching ]==================================

set incsearch "Lookahead as search pattern specified
set ignorecase "Ignore case in all searches...
set smartcase "...unless uppercase letters used
set hlsearch "Highlight all search matches

"Key mapping to switch off highlighting till next search...
map H :nohlsearch<CR>


"=====[ Text formatting ]==================================

" Format file with perltidy...
map ;t 1G!Gperltidy -q <CR>


" Format file with autoformat (capitalize to specify options)...
"map F !Gformat -T4 -
"map <silent> f !Gformat -T4<CR>


"=====[ Run Perl programs from within vim ]========================

" Execute Perl file...
map W :!clear;perl -w %<CR>

" Debug Perl file...
map Q :!perl -d %<CR>

" Run perldoc...
"map ?? :!pd
"set keywordprg=pd


"=====[ Add or subtract comments ]===============================

"function! ToggleComment ()
"let currline = getline(".")
"if currline =~ '^#'
"s/^#//
"elseif currline =~ '\S'
"s/^/#/
"endif
"endfunction

"map <silent> # :call ToggleComment()<CR>j0

match Error /\t\|\s\+$/
nnoremap <silent> <F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar>:nohl<CR>
