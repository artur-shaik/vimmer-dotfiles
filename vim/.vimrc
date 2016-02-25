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
 
 " Use ag in unite grep source.
 let g:unite_source_grep_command = 'ag'
 let g:unite_source_grep_default_opts =
 \ '-i --vimgrep --hidden --ignore ' .
 \ '''.hg'' --ignore ''.svn'' --ignore ''.git'' --ignore ''.bzr'''
 let g:unite_source_grep_recursive_opt = ''

 nnoremap <space>/ :Unite grep:.<cr>
 nnoremap <silent> <C-p> :Unite -no-split -buffer-name=files -start-insert file_rec/async:!<cr>
 nnoremap <leader>f :Unite -no-split -buffer-name=files -start-insert file<cr>
 nnoremap <leader>m :Unite -no-split -buffer-name=mru -start-insert file_mru<cr>
 nnoremap <leader>y :Unite -no-split -buffer-name=yank history/yank<cr>
 nnoremap <silent> <C-b> :Unite -start-insert -buffer-name=buffer buffer<cr>
 
 " Interface for Git
 let g:unite_source_menu_menus = {}
 let g:unite_source_menu_menus.git = {
     \ 'description' : 'Fugitive interface',
     \}
 let g:unite_source_menu_menus.git.command_candidates = [
     \[' git status', 'Gstatus'],
     \[' git diff', 'Gvdiff'],
     \[' git commit', 'Gcommit'],
     \[' git stage/add', 'Gwrite'],
     \[' git checkout', 'Gread'],
     \[' git rm', 'Gremove'],
     \[' git cd', 'Gcd'],
     \[' git push', 'exe "Git! push -u origin " input("branch: ")'],
     \[' git pull', 'exe "Git! pull " input("branch: ")'],
     \[' git fetch', 'Gfetch'],
     \[' git merge', 'Gmerge'],
     \[' git browse', 'Gbrowse'],
     \[' git head', 'Gedit HEAD^'],
     \[' git parent', 'edit %:h'],
     \[' git log commit buffers', 'Glog --'],
     \[' git log current file', 'Glog -- %'],
     \[' git log last n commits', 'exe "Glog -" input("num: ")'],
     \[' git log first n commits', 'exe "Glog --reverse -" input("num: ")'],
     \[' git log until date', 'exe "Glog --until=" input("day: ")'],
     \[' git log grep commits',  'exe "Glog --grep= " input("string: ")'],
     \[' git log pickaxe',  'exe "Glog -S" input("string: ")'],
     \[' git index', 'exe "Gedit " input("branchname\:filename: ")'],
     \[' git mv', 'exe "Gmove " input("destination: ")'],
     \[' git grep',  'exe "Ggrep " input("string: ")'],
     \[' git prompt', 'exe "Git! " input("command: ")'],
     \] " Append ' --' after log to get commit info commit buffers
 nnoremap <silent> <space>g :Unite -direction=botright -silent -buffer-name=git menu:git<CR>

 NeoBundle 'Shougo/unite-outline' " {{{2
 nnoremap <space>o :Unite outline<cr>

 NeoBundle 'osyo-manga/vim-anzu' " {{{2
 nmap n <Plug>(anzu-n-with-echo)
 nmap N <Plug>(anzu-N-with-echo)
 nmap * <Plug>(anzu-star-with-echo)
 nmap # <Plug>(anzu-sharp-with-echo)
 
 nmap <Esc><Esc> <Plug>(anzu-clear-search-status)

 NeoBundle 'Lokaltog/vim-easymotion' " {{{2
 map <space> <Plug>(easymotion-prefix)

 NeoBundle 'Valloric/YouCompleteMe' "{{{2
 let g:ycm_server_log_level = 'debug'
 let g:ycm_semantic_triggers =  {
     \   'c' : ['->', '.'],
     \   'objc' : ['->', '.'],
     \   'ocaml' : ['.', '#'],
     \   'cpp,objcpp' : ['->', '.', '::'],
     \   'perl' : ['->'],
     \   'php' : ['->', '::'],
     \   'cs,javascript,d,python,perl6,scala,vb,elixir,go' : ['.'],
     \   'java,jsp' : ['.', '::'],
     \   'vim' : ['re![_a-zA-Z]+[_\w]*\.'],
     \   'ruby' : ['.', '::'],
     \   'lua' : ['.', ':'],
     \   'erlang' : [':'],
     \ }

 let g:ycm_global_ycm_extra_conf = '~/.ycm_extra_conf.py'
 let g:ycm_confirm_extra_conf = 0
 let g:ycm_collect_identifiers_from_tags_files = 1
 let g:ycm_autoclose_preview_window_after_completion = 1

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
 
 NeoBundle 'tfnico/vim-gradle.git' " {{{2

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

 NeoBundle 'plasticboy/vim-markdown' " {{{2

 NeoBundle 'christoomey/vim-tmux-navigator' " {{{2

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

 let g:startify_change_to_dir = 0

 NeoBundle 'vimwiki/vimwiki' " {{{2
 nnoremap <leader>W :VimwikiIndex<cr>


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
 let g:languagetool_lang='ru'
 
 NeoBundle 'MarcWeber/vim-addon-local-vimrc.git' " {{{2

 NeoBundle 'xolox/vim-session.git' " {{{2

 NeoBundle 'xolox/vim-reload' " {{{2

 NeoBundle 'xolox/vim-misc' " {{{2

 NeoBundle 'tpope/vim-rsi.git' " {{{2
 let g:rsi_no_meta = 1

 NeoBundle 'tpope/vim-commentary.git' " {{{2

 NeoBundle 'xolox/vim-colorscheme-switcher.git' " {{{2
 let g:colorscheme_switcher_define_mappings = 0

 NeoBundle 'artur-shaik/vim-javacomplete2' " {{{2
 let g:JavaComplete_MavenRepositoryDisable = 0
 let g:JavaComplete_UseFQN = 0
 
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

 NeoBundle 'james9909/stackanswers.vim.git' " {{{2

 NeoBundle 'rdnetto/YCM-Generator' " {{{2

 NeoBundle 'lervag/vimtex' " {{{2

 let g:vimtex_view_method = 'zathura'

 if !exists('g:ycm_semantic_triggers')
   let g:ycm_semantic_triggers = {}
 endif
 let g:ycm_semantic_triggers.tex = [
       \ 're!\\[A-Za-z]*(ref|cite)[A-Za-z]*([^]]*])?{([^}]*, ?)*'
       \ ]

 NeoBundle '907th/vim-auto-save' " {{{2

 NeoBundle 'wellle/tmux-complete.vim' " {{{2

 let g:tmuxcomplete#trigger = 'omnifunc'

 NeoBundle 'wellle/visual-split.vim' " {{{2

 NeoBundle 'tpope/vim-vinegar' " {{{2

 NeoBundle 'vifm/vifm.vim' " {{{2

 NeoBundle 'junegunn/gv.vim' " {{{2

 " NeoBundle 'hsanson/vim-android' " {{{2

 " let g:android_sdk_path = '/home/ash/Android/Sdk/'
 " let g:gradle_quickfix_show = 0

 NeoBundle 'cosminadrianpopescu/filesync' " {{{2

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

 call neobundle#end()

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
 " set t_Co=256

 set background=light
 colorscheme paradox

 syntax on 

 set cursorline

 hi Visual term=none cterm=none ctermbg=1 gui=none ctermfg=15
 hi CursorLine term=none cterm=bold ctermfg=8 ctermbg=15
 hi Pmenu ctermbg=2 ctermfg=15 guibg=2 guifg=none
 hi PmenuSel ctermfg=2 ctermbg=15
 hi LineNr ctermfg=5
 hi SpellBad term=underline cterm=underline ctermbg=none ctermfg=1
 hi Error term=none cterm=none ctermbg=none ctermfg=1
 " hi Search ctermbg=8

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

 let g:netrw_liststyle=3
 " -------------------
 "  Auto Commands {{{1
 " -------------------

 augroup initialautocommands
     autocmd!
     
     " smartident after keywords in python
     autocmd BufRead *.py setlocal smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class

     autocmd FileType java,jsp setlocal omnifunc=javacomplete#Complete
     autocmd Filetype java,jsp,pom compiler mvn
     autocmd Filetype java,jsp no <F4> :JCimportAdd<CR>
     autocmd Filetype java,jsp ino <F4> <esc>:JCimportAddI<CR>
     autocmd Filetype java,jsp no <F9> :make clean<CR>
     autocmd Filetype java,jsp no <F10> :wa<CR> :make compile<CR>
     autocmd Filetype java,jsp no <F11> :make exec:exec<CR>
 augroup END

 " ------------------
 "  Mappings {{{1
 " ------------------

 " set leader for comma
 let mapleader = ","
 let maplocalleader = ","
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
 imap <C-h> <backspace>

 imap <C-b> <Left>
 imap <C-a> <esc>^i
 imap <C-f> <Right>
 imap <C-e> <End>
 imap <C-d> <Del>
 imap <C-h> <BS>
 imap <C-n> <Down>
 imap <C-p> <Up>

 cmap <Esc>k <Up>
 cmap <Esc>j <Down>
 cmap <Esc>l <Enter>

 " replace word under cursor with entered 
 " in all document
 nnoremap <Leader>s :%s/\<<C-r><C-w>\>/<C-r><C-w>/g<Left><Left>

 " easy split navigation
 nnoremap <C-j> <C-W>j
 nnoremap <C-k> <C-W>k
 nnoremap <C-l> <C-W>l
 nnoremap <C-h> <C-W>h

 nnoremap <Leader>b :EditVifm<CR>

 " Tab/Shift+Tab for switching between buffers
 nnoremap  <silent>   <tab>  :if &modifiable && !&readonly && &modified <CR> :write<CR> :endif<CR>:bnext<CR>
 nnoremap  <silent> <s-tab>  :if &modifiable && !&readonly && &modified <CR> :write<CR> :endif<CR>:bprevious<CR>

 " delete current buffer and keep split
 nnoremap <leader>d :bp\|bd #<CR>

 nnoremap gs :Gstatus<cr>
 nnoremap gC :Gcommit<cr>

 nnoremap g= gg=Gg``

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
 set foldcolumn=0

 " ------------------
 "  Abbr {{{1
 " ------------------
 cabbr <expr> %% expand('%:p:h')
 iabbr @@ Artur Shaikhullin <ashaihullin@gmail.com>

 " Status Line: {{{1

 function! Status(winnum)
   let active = a:winnum == winnr()
   let bufnum = winbufnr(a:winnum)
 
   let stat = ''
 
   " this function just outputs the content colored by the
   " supplied colorgroup number, e.g. num = 2 -> User2
   " it only colors the input if the window is the currently
   " focused one
 
   function! Color(active, group, content)
     if a:active
       return '%#' . a:group . '#' . a:content . '%*'
     else
       return a:content
     endif
   endfunction
 
   " this handles alternative statuslines
   let usealt = 0
 
   let type = getbufvar(bufnum, '&buftype')
   let name = bufname(bufnum)
 
   let altstat = ''
 
   if type ==# 'help'
     let altstat .= '%#SLHelp# HELP %* ' . fnamemodify(name, ':t:r')
     let usealt = 1
   elseif name ==# '__Gundo__'
     let altstat .= ' Gundo'
     let usealt = 1
   elseif name ==# '__Gundo_Preview__'
     let altstat .= ' Gundo Preview'
     let usealt = 1
   endif
 
   if usealt
     return altstat
   endif
 
   " column
   "   this might seem a bit complicated but all it amounts to is
   "   a calculation to see how much padding should be used for the
   "   column number, so that it lines up nicely with the line numbers
 
   "   an expression is needed because expressions are evaluated within
   "   the context of the window for which the statusline is being prepared
   "   this is crucial because the line and virtcol functions otherwise
   "   operate on the currently focused window
 
   function! Column()
     let vc = virtcol('.')
     let ruler_width = max([strlen(line('$')), (&numberwidth - 1)]) + &l:foldcolumn
     let column_width = strlen(vc)
     let padding = ruler_width - column_width
     let column = ''
 
     if padding <= 0
       let column .= vc
     else
       " + 1 because for some reason vim eats one of the spaces
       let column .= repeat(' ', padding + 1) . vc
     endif
 
     return column . ' '
   endfunction
 
   let stat .= '%#SLColumn#'
   let stat .= '%{Column()}'
   let stat .= '%*'
   
   " file name
   let stat .= Color(active, 'SLArrows', active ? ' »' : ' «')
   let stat .= ' %<'
   let stat .= '%f'
   let stat .= ' ' . Color(active, 'SLArrows', active ? '«' : '»')
 
   " file modified
   let modified = getbufvar(bufnum, '&modified')
   let stat .= Color(active, 'SLLineNr', modified ? ' +' : '')
 
   " read only
   let readonly = getbufvar(bufnum, '&readonly')
   let stat .= Color(active, 'SLLineNR', readonly ? ' ‼' : '')
 
   " paste
   if active
     if getwinvar(a:winnum, '&spell')
       let stat .= Color(active, 'SLLineNr', ' S')
     endif
 
     if getwinvar(a:winnum, '&paste')
       let stat .= Color(active, 'SLLineNr', ' P')
     endif
   endif
 
   " right side
   let stat .= '%='

   " git branch
   if exists('*fugitive#head')
     let head = fugitive#head()
 
     if empty(head) && exists('*fugitive#detect') && !exists('b:git_dir')
       call fugitive#detect(getcwd())
       let head = fugitive#head()
     endif
   endif
 
   if !empty(head)
     let stat .= Color(active, 'SLBranch', '  ') . head . ' '
   endif

   " file type
   let stat .= ' %y'

   " progress
   let stat .= Color(active, 'SLProgress', ' %P ')

   return stat
 endfunction
 
 function! s:RefreshStatus()
   for nr in range(1, winnr('$'))
     call setwinvar(nr, '&statusline', '%!Status(' . nr . ')')
   endfor
 endfunction
 
 command! RefreshStatus :call <SID>RefreshStatus()
 
 augroup status
   autocmd!
   autocmd VimEnter,VimLeave,WinEnter,WinLeave,BufWinEnter,BufWinLeave * :RefreshStatus
 augroup END
 " }}}
