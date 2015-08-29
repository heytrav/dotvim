" vim: set foldmethod=marker
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
set rtp+=~/repos/powerline/bindings/vim
call vundle#begin()


" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'
Plugin 'The-NERD-Commenter'
Plugin 'tpope/vim-fugitive'
Plugin 'L9'
Plugin 'jsbeautify'
Plugin 'Tabular'
Plugin 'unimpaired.vim'
Plugin 'ctrlp.vim'
Plugin 'surround.vim'
Plugin 'Jinja'
Plugin 'Autoclose'
Plugin 'Gist.vim'
Plugin 'WebAPI.vim'
Bundle 'powerline/powerline', {'rtp': 'powerline/bindings/vim/'}
Plugin 'git://git.wincent.com/command-t.git'
Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
Plugin 'airblade/vim-gitgutter'
Bundle 'SirVer/ultisnips'
Bundle 'honza/vim-snippets'
Bundle 'altercation/vim-colors-solarized'
Bundle 'jlanzarotta/bufexplorer'
call vundle#end()            " required
set laststatus=2
filetype plugin indent on    " required
syntax on
set t_Co=256
colorscheme solarized
inoremap <C-l> <C-k>
filetype indent on
filetype plugin on

let netrw_list_hide='\.pyc,\.swp,\.git,tags'
let g:ctrlp_mruf_exclude = '.*\.git/.*/COMMIT_EDITMSG'
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files']
"let g:airline#extensions#tabline#enabled = 1


let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"

let mapleader = ","
map <leader>td <Plug>TaskList
noremap <leader>. :CtrlPTag<CR>

" Tips from vimcasts
" Bubble single lines
nmap <C-Up> [e
nmap <C-Down> ]e
" Bubble multiple lines
vmap <C-Up> [egv
vmap <C-Down> ]egv

if has("autocmd")
    autocmd bufwritepost .vimrc source $MYVIMRC
endif

nmap <leader>v :tabedit $MYVIMRC<CR>
nmap <leader>g :tabedit ~/.gvimrc<CR>

"=====[ Indenting support ]================== {{{

set wrapmargin=78
set autoindent "Retain indentation on next line
set smartindent "Turn on autoindenting of blocks
"But not magic outdenting of comments...
inoremap # X<C-H>#




"=====[ Make Visual modes work better ]================== {{{1


" Make BS/DEL work as expected
vmap <BS> x

"Square up visual selections
set virtualedit=block

"=====[ Smarter completion ]================================== {{{1

"Add file of std words for <TAB> completion...
set complete+=k~/.vim/std_completions




" Convert to/from spaces/tabs...
map <silent> TS :set expandtab<CR>:%retab!<CR>
map <silent> TT :set noexpandtab<CR>:%retab!<CR>

"=====[ Spelling support ]================================== {{{1

" Correct common mistypings in-the-fly...
iab retrun return
iab pritn print
iab teh the
iab liek like
iab liekwise likewise
iab Pelr Perl
iab pelr perl
iab ;t 't
iab moer more
iab previosu previous

" Ring the bell every time "it's" is typed...
imap it's it's<ESC><ESC>a

"=====[ Tab handling ]====================================== {{{1

set tabstop=4 "Indentation levels every four columns
set softtabstop=4
set shiftwidth=4 "Indent/outdent by four columns
set shiftround "Indent/outdent to nearest tabstop
set smarttab
set expandtab "Convert all tabs that are typed to spaces



"=====[ Grammar checking ]======================================== {{{1

let g:check_grammar = 0

function! CheckGrammar ()
if g:check_grammar
"match WHITE_ON_RED /_ref[ ]*[[{(]\|_ref[ ]*-[^>]/
call BadRefs()
let g:check_grammar = 0
else
match WHITE_ON_RED /\c\<your\>\|\<you're\>\|\<it's\>\|\<its\>\|\<we're\>\|\<were\>\|\<where\>\|\<they're\>\|\<there\>\|\<their\>/
let g:check_grammar = 1
endif
echo ""
endfunction

" Toggle grammar checking...
map <silent> ;g :call CheckGrammar()<CR>``



"=====[ Highlight cursor column on request ]=================== {{{1

highlight CursorColumn term=bold ctermfg=black ctermbg=green

map <silent> ;c :set cursorcolumn!<CR>


"=====[ Highlight spelling errors on request ]===================

set spelllang=en_us
map <silent> ;s :setlocal invspell<CR>


"=====[ Miscellaneous features ]================================== {{{1

set title "Show filename in titlebar of window
set titleold=

set nomore "Don't page long listings

set autowrite "Save buffer automatically when changing files
set autoread "Always reload buffer when external changes detected

" What to save in .viminfo...
set viminfo=h,'50,<10000,s1000,/1000,:100

set backspace=indent,eol,start "BS past autoindents, line boundaries,
" and even the start of insertion

set matchpairs+=<:>   ",«:» "Match angle brackets too

"set background=dark "when guessing, guess bg is dark


set fileformats=unix,mac,dos "Handle Mac and DOS line-endings
"but prefer Unix endings


"set wildmode=list:longest,full "Show list of completions
" and complete as much as possible,
" then iterate full completions

set noshowmode "Suppress mode change messages


set updatecount=10 "Save buffer every 10 chars typed


set textwidth=78 "Wrap at column 78

set scrolloff=2 "Scroll when 2 lines from top/bottom

set ruler "Show cursor location info on status line

" Use space to jump down a page (like browsers do)...
noremap <Space> <PageDown>

" Keycodes and maps timeout in 3/10 sec...
set timeout timeoutlen=300 ttimeoutlen=300
"=====[ Cut and paste from MacOSX clipboard ]====================

" use ack instead of grep
set grepprg=ack

"===[ Clear tabs and trailing whitespace ]================== {{{1
"match Error /\t\|\s\+$/
nnoremap <silent> <F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar>:nohl<CR>
