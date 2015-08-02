" vim:foldlevel=0
" vim:foldmethod=marker
 " ------------------------
 "  Important {{{
 " ------------------------

 if has('vim_starting')
    set nocompatible               " Be iMproved

    " Required:
    set runtimepath+=~/.vim/bundle/neobundle.vim/
 endif

 set runtimepath-=~/.vim/bundle/ultisnips/plugin

 " -----------------------
 "  Bundles {{{1
 " -----------------------

 call neobundle#begin(expand('~/.vim/bundle/'))
 NeoBundleFetch 'Shougo/neobundle.vim' " {{{2

 NeoBundle 'tpope/vim-fugitive' " {{{2

 NeoBundle 'Shougo/unite.vim' " {{{2
 let g:unite_source_history_yank_enable = 1
 
 nnoremap <space>/ :Unite grep:.<cr>
 nnoremap <silent> <C-p> :<C-u>Unite -no-split -buffer-name=files -start-insert file_rec/async:!<cr>
 nnoremap <leader>f :<C-u>Unite -no-split -buffer-name=files -start-insert file<cr>
 nnoremap <leader>m :<C-u>Unite -no-split -buffer-name=mru -start-insert file_mru<cr>
 nnoremap <leader>y :<C-u>Unite -no-split -buffer-name=yank history/yank<cr>
 nnoremap <silent> <C-b> :<C-u>Unite -start-insert -buffer-name=buffer buffer<cr>

 NeoBundle 'Lokaltog/vim-easymotion' " {{{2
 map <space> <Plug>(easymotion-prefix)

 NeoBundle 'Valloric/YouCompleteMe' " {{{2
 let g:ycm_server_log_level = 'debug'
 let g:ycm_semantic_triggers =  {
     \   'c' : ['->', '.'],
     \   'objc' : ['->', '.'],
     \   'ocaml' : ['.', '#'],
     \   'cpp,objcpp' : ['->', '.', '::'],
     \   'perl' : ['->'],
     \   'php' : ['->', '::'],
     \   'cs,javascript,d,python,perl6,scala,vb,elixir,go' : ['.'],
     \   'java' : ['.', '::'],
     \   'vim' : ['re![_a-zA-Z]+[_\w]*\.'],
     \   'ruby' : ['.', '::'],
     \   'lua' : ['.', ':'],
     \   'erlang' : [':'],
     \ }

 let g:ycm_global_ycm_extra_conf = '~/.ycm_extra_conf.py'
 let g:ycm_confirm_extra_conf = 0
 let g:ycm_collect_identifiers_from_tags_files = 1

 NeoBundle 'Raimondi/delimitMate.git' " {{{2
 let delimitMate_expand_cr = 1

 NeoBundle 'SirVer/ultisnips' " {{{2
 let g:UltiSnipsExpandTrigger="<C-x>"
 let g:UltiSnipsJumpForwardTrigger="<c-b>"
 let g:UltiSnipsJumpBackwardTrigger="<c-z>"

 NeoBundle 'honza/vim-snippets' " {{{2
 let g:snips_author="Artur Shaik"
 let g:snips_email="ashaihullin@gmail.com"
 let g:snips_github="No"
	
 NeoBundle 'peterhoeg/vim-qml' " {{{2

 NeoBundle 'tpope/vim-git' " {{{2
 
 NeoBundle 'bling/vim-airline' " {{{2
 let g:airline#extensions#tabline#enabled = 1
 let g:airline_theme='solarized'
 let g:airline#extensions#tmuxline#enabled = 0

 NeoBundle 'tfnico/vim-gradle.git' " {{{2

 NeoBundle 'sjl/clam.vim' " {{{2

 NeoBundle 'xolox/vim-misc' " {{{2

 NeoBundle 'chrisbra/SudoEdit.vim' " {{{2

 NeoBundle 'edkolev/tmuxline.vim' " {{{2
 let g:tmuxline_theme='nightly_fox'
 let g:tmuxline_preset='nightly_fox'
 let g:tmuxline_powerline_separators = 0
 let g:tmuxline_separators = {
    \ 'left' : '',
    \ 'left_alt': '>',
    \ 'right' : '',
    \ 'right_alt' : '<',
    \ 'space' : ' '}

 NeoBundle 'dhruvasagar/vim-table-mode' " {{{2

 NeoBundle 'godlygeek/tabular' " {{{2

 NeoBundle 'plasticboy/vim-markdown' " {{{2

 NeoBundle 'christoomey/vim-tmux-navigator' " {{{2

 NeoBundle 'yakiang/excel.vim' " {{{2

 NeoBundle 'mhinz/vim-startify' " {{{2
 let g:startify_bookmarks = [ '~/.vimrc' ]
 let g:startify_custom_indices = ['f', 'g', 'h', 'y', 'u', 'i', 's', 'l']

 let g:startify_custom_header = [
    \ '    __   ____  ____  _  _  ____    ____  _  _   __   __  __ _     _  _  _   ',
    \ '   / _\ (  _ \(_  _)/ )( \(  _ \  / ___)/ )( \ / _\ (  )(  / )   / )(_)( \  ',
    \ '  /    \ )   /  )(  ) \/ ( )   /  \___ \) __ (/    \ )(  )  (   ( (  _  ) ) ',
    \ '  \_/\_/(__\_) (__) \____/(__\_)  (____/\_)(_/\_/\_/(__)(__\_)   \_)(_)(_/  ',
    \ '',
    \ ''
    \ ]

 let g:startify_custom_footer = [
    \ '    __   ____  ____  _  _  ____    ____  _  _   __   __  __ _     _  _  _   ',
    \ '   / _\ (  _ \(_  _)/ )( \(  _ \  / ___)/ )( \ / _\ (  )(  / )   / )(_)( \  ',
    \ '  /    \ )   /  )(  ) \/ ( )   /  \___ \) __ (/    \ )(  )  (   ( (  _  ) ) ',
    \ '  \_/\_/(__\_) (__) \____/(__\_)  (____/\_)(_/\_/\_/(__)(__\_)   \_)(_)(_/  ',
    \ '',
    \ ''
    \ ]

 NeoBundle 'vimwiki/vimwiki' " {{{2
 nnoremap <leader>W :VimwikiIndex<cr>

 NeoBundle 'scrooloose/nerdtree' " {{{2
 nnoremap <F7> :NERDTreeToggle<cr>

 NeoBundle 'powerman/vim-plugin-ruscmd' " {{{2

 NeoBundle 'Shougo/neomru.vim' " {{{2

 NeoBundle 'gorkunov/smartpairs.vim' " {{{2

 NeoBundle 'EinfachToll/DidYouMean' " {{{2

 NeoBundle 'mileszs/ack.vim' " {{{2
 let g:ackprg = 'ag --nogroup --nocolor --column'

 NeoBundle 'chrisbra/Recover.vim' " {{{2

 NeoBundle 'tpope/vim-surround' " {{{2

 NeoBundle 'majutsushi/tagbar' " {{{2
 nnoremap <F8> :TagbarToggle<cr>

 NeoBundle 'airblade/vim-rooter.git' " {{{2

 NeoBundle 'vim-scripts/Maven-Compiler' " {{{2

 NeoBundle 'vim-scripts/LanguageTool.git' " {{{2
 let g:languagetool_jar='$HOME/Soft/LanguageTool/languagetool-commandline.jar'
 
 NeoBundle 'MarcWeber/vim-addon-local-vimrc.git' " {{{2

 NeoBundle 'xolox/vim-session.git' " {{{2

 NeoBundle 'whatyouhide/vim-gotham' " {{{2

 NeoBundle 'xolox/vim-reload' " {{{2

 NeoBundle 'xolox/vim-misc' " {{{2

 NeoBundle 'tpope/vim-rsi.git' " {{{2
 let g:rsi_no_meta = 1

 NeoBundle 'tpope/vim-commentary.git' " {{{2

 NeoBundle 'xolox/vim-colorscheme-switcher.git' " {{{2
 let g:colorscheme_switcher_define_mappings = 0

 NeoBundle 'artur-shaik/vim-javacomplete2' " {{{2
 let g:JavaComplete_MavenRepositoryDisable = 0
 
 NeoBundle 'kana/vim-vspec' " {{{2

 NeoBundle 'wincent/terminus' " {{{2

 NeoBundle 'junegunn/goyo.vim' " {{{2
 function! s:goyo_enter()
    set nofoldenable
    set scrolloff=999
    Limelight
 endfunction

 function! s:goyo_leave()
    set foldenable
    set scrolloff=0
    Limelight!
    hi CursorLine term=none cterm=bold ctermbg=15
 endfunction

 autocmd! User GoyoEnter nested call <SID>goyo_enter()
 autocmd! User GoyoLeave nested call <SID>goyo_leave()

 " F6 toggle Goyo
 nnoremap <F6> :Goyo<cr>

 NeoBundle 'junegunn/limelight.vim' " {{{2
 let g:limelight_conceal_ctermfg = 14
 let g:limelight_paragraph_span = 1

 NeoBundle 'lyokha/vim-xkbswitch' " {{{2
 let g:XkbSwitchEnabled = 1

 " others plugins {{{2
 let python_highlight_all = 1
 " }}}

 execute "NeoBundle 'Shougo/vimproc.vim'," . string({
     \ 'build' : {
     \     'windows' : "",
     \     'cygwin' : 'make -f make_cygwin.mak',
     \     'mac' : 'make -f make_mac.mak',
     \     'unix' : 'make -f make_unix.mak',
     \    },
     \ })

 execute pathogen#infect()

 call unite#filters#matcher_default#use(['matcher_fuzzy'])

 " --------------------
 "  Tags {{{1
 " --------------------
 
 set tags+=./.tags
 
 " --------------------
 "  Syntax, highlighting and spelling {{{1
 " --------------------
 
 filetype on
 filetype plugin on
 filetype plugin indent on
 
 " enabling 256 colors mode
 set t_Co=256

 set background=light
 " colorscheme default
 colorscheme delek
 " let hour = strftime("%H")
 " if 6 <= hour && hour < 18
 " else
 "   set background=dark
   " colorscheme koehler
 " endif
 
 " colorscheme darkblue
 " set background=light

 syntax on 

 set cursorline

 hi Visual term=none cterm=none ctermbg=1 gui=none ctermfg=15
 hi CursorLine term=none cterm=bold ctermbg=15
 hi Pmenu ctermbg=2 ctermfg=15 guibg=2 guifg=none
 " hi SpellBad term=underline cterm=underline ctermbg=none ctermfg=1
 " hi Error term=none cterm=none ctermbg=none ctermfg=1
 " hi Search ctermbg=8
 " hi airline_tabsel term=none cterm=none ctermbg=1 gui=none ctermfg=15

 " --------------------
 "  Tabs and indenting {{{1
 " --------------------
 
 set tabstop=4 
 set shiftwidth=4
 set smarttab
 set expandtab 
 set softtabstop=4 
 set autoindent

 " -------------------
 "  Misc {{{1
 " -------------------
 
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
 " -------------------
 "  Auto Commands {{{1
 " -------------------

 augroup initialautocommands
     autocmd!
     " remove all spaces in the end of all python files
     autocmd BufWritePre *.py normal m`:%s/\s\+$//e ``
     
     " smartident after keywords in python
     autocmd BufRead *.py set smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class

     autocmd FileType java set omnifunc=javacomplete#Complete
     autocmd Filetype java compiler mvn
     autocmd Filetype pom compiler mvn
     autocmd Filetype java no <F4> :call javacomplete#AddImport()<CR>
     autocmd Filetype java no <F9> :make clean<CR>
     autocmd Filetype java no <F10> :wa<CR> :make compile<CR>
     autocmd Filetype java no <F11> :make exec:exec<CR>
 augroup END

 " ------------------
 "  Mappings {{{1
 " ------------------

 " set leader for comma
 let mapleader = ","
 let g:mapleader = ","

 " F3 to toggle paste and nopaste
 nnoremap <F3> :set paste!<CR>

 " F4 to toggle header and source files
 nnoremap <F4> :e %:p:s,.h$,.X123X,:s,.cpp$,.h,:s,.X123X$,.cpp,<CR>  

 " F5 list buffers
 nnoremap <F5> :buffers<CR>:buffer<Space>

 nmap <leader>w :w!<cr>
 nmap <leader>q :q<cr>
 nmap <leader>q! :q!<cr>
 map q: :q

 nnoremap <leader>ev :vsplit $MYVIMRC<cr>
 nnoremap <leader>sv :source $MYVIMRC<cr>

 " change window size with arrow keys
 noremap <up>    <C-W>+
 noremap <down>  <C-W>-
 noremap <left>  3<C-W><
 noremap <right> 3<C-W>>

 " remove spaces both sides of selection
 vmap gs :s/ \(<C-r>*\) /\1/g<cr>

 nnoremap ; :
 nnoremap : ;
 nnoremap ! :!

 " shortcuts for Esc
 imap <C-l> <esc>
 imap jk <esc>
 imap kk <esc>
 imap лл <esc>
 imap <F1> <Esc>
 map <F1> <Esc>

 " shortcuts for BS
 imap <C-h> <backspace>

 imap <C-b> <Left>
 imap <C-a> <esc>^i
 imap <C-f> <Right>
 imap <C-e> <End>
 imap <C-d> <Del>
 imap <C-h> <BS>
 imap <C-n> <Down>
 imap <C-p> <Up>

 " replace word under cursor with entered 
 " in all document
 nnoremap <Leader>s :%s/\<<C-r><C-w>\>/<C-r><C-w>/g<Left><Left>

 " easy split navigation
 nnoremap <C-J> <C-W>J
 nnoremap <C-K> <C-W>K
 nnoremap <C-L> <C-W>L
 nnoremap <C-H> <C-W>H

 " Tab/Shift+Tab for switching between buffers
 nnoremap  <silent>   <tab>  :if &modifiable && !&readonly && &modified <CR> :write<CR> :endif<CR>:bnext<CR>
 nnoremap  <silent> <s-tab>  :if &modifiable && !&readonly && &modified <CR> :write<CR> :endif<CR>:bprevious<CR>

 " delete current buffer and keep split
 nnoremap <leader>d :bp\|bd #<CR>

 nnoremap gs :Gstatus<cr>
 nnoremap gC :Gcommit<cr>

 function! RestoreRegister()
   let @" = s:restore_reg
   return ''
 endfunction

 function! s:Repl()
     let s:restore_reg = @"
     return "p@=RestoreRegister()\<cr>"
 endfunction

 let s:putSwap = 1
 function! TogglePutSwap()
     if s:putSwap
         vnoremap <silent> <expr> p <sid>Repl()
         let s:putSwap = 0
         echo 'noreplace put'
     else
         vnoremap <silent> <expr> p p
         let s:putSwap = 1
         echo 'replace put'
     endif
     return
 endfunction
 noremap <leader>p :call TogglePutSwap()<cr>

 let g:quickfix_is_open = 0
 function! ToggleQuickfix()
     if g:quickfix_is_open
         cclose
         let g:quickfix_is_open = 0
         execute g:quickfix_return_to_window . "wincmd w"
     else
         let g:quickfix_return_to_window = winnr()
         copen
         let g:quickfix_is_open = 1
     endif
 endfunction

 nnoremap Q :call ToggleQuickfix()<cr>

 " ------------------
 "  Displaying text {{{1
 " ------------------
 
 set nu 
 set wrap
 set linebreak

 " ------------------
 "  Mouse {{{1
 " ------------------
 
 set mousehide 
 set mouse=a 

 " ------------------
 "  Editing text {{{1
 " ------------------
 
 set backspace=indent,eol,start whichwrap+=<,>,[,]
 set showmatch
 set matchtime=2

 " ------------------
 "  Search {{{1
 " ------------------
 
 set ignorecase
 set smartcase
 set hlsearch
 set incsearch
 set magic

 " ------------------
 "  Messages and Info {{{1
 " ------------------
 
 set ruler
 set rulerformat=%55(%{strftime('%a\ %b\ %e\ %H:%M\ %p')}\ %5l,%-6(%c%V%)\ %P%)

 " ------------------
 "  Tabs ands Splits {{{1
 " ------------------

 set showtabline=1 " Показывать заголовок табов, если открыто больше 1 таба
 set splitbelow
 set splitright

 " ------------------
 "  Folding {{{1
 " ------------------
 
 set foldmethod=indent
 set foldlevel=20
 set foldcolumn=2

 " ------------------
 "  Abbr {{{1
 " ------------------
 cabbr <expr> %% expand('%:p:h')
 iabbr @@ Artur Shaikhullin <ashaihullin@gmail.com>
