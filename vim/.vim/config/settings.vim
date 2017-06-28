" basic settings

set tabstop=4 
set shiftwidth=4
set smarttab
set expandtab 
set softtabstop=4 
set autoindent

set tags+=./.tags
set undodir=~/.vim/undodir

set history=700
set showtabline=0
set autoread
set termencoding=utf-8 
set novisualbell 

" don't redraw while executing macros (good performance config)
set lazyredraw
set encoding=utf-8
set fileencodings=utf8,cp1251

set undolevels=500
set undoreload=500
set laststatus=2

let g:netrw_liststyle=3

set number
set wrap
set linebreak

set mousehide 
set mouse=a 

set backspace=indent,eol,start whichwrap+=<,>,[,]
set showmatch
set matchtime=2

set ignorecase
set smartcase
set hlsearch
set incsearch
set magic

set ruler
set rulerformat=%55(%{strftime('%a\ %b\ %e\ %H:%M\ %p')}\ %5l,%-6(%c%V%)\ %P%)

" show tab header only when 1 or more tabs exists
set showtabline=1 

set splitbelow
set splitright

set foldmethod=indent
set foldlevel=20
set foldcolumn=0

" vim:set fdm=marker sw=2 nowrap:
