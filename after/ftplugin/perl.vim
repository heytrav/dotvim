

"Key mapping to switch off highlighting till next search...
map H :nohlsearch<CR>


"=====[ Text formatting ]==================================

" Format file with perltidy...
map ;t 1G!Gperltidy -q -st -se -i=4 -ci=4 -pt=2 -otr -sot -sct -nsfs -noll -nola<CR>



"=====[ Run Perl programs from within vim ]========================

" Execute Perl file...
map W :!clear;perl -w %<CR>

" Debug Perl file...
map Q :!perl -d %<CR>

" Run perldoc...
"map ?? :!pd
"set keywordprg=pd



match Error /\t\|\s\+$/
nnoremap <silent> <F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar>:nohl<CR>
