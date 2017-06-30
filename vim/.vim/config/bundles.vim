" bundles configurations

function! s:bundle(config_name, ...)
  if a:0 > 0
    Plug a:config_name
  else
    execute 'source '. $HOME. '/.vim/config/bundle_settings/'. a:config_name. '.vim'
  endif
endfunction

function! s:enableDev()

  call s:bundle('tpope/vim-fugitive', 1)
  call s:bundle('peterhoeg/vim-qml', 1)
  call s:bundle('tpope/vim-git', 1)
  call s:bundle('tagbar')
  call s:bundle('airblade/vim-rooter', 1)
  call s:bundle('vim-scripts/Maven-Compiler', 1)
  call s:bundle('xolox/vim-session', 1)
  call s:bundle('xolox/vim-reload', 1)
  call s:bundle('tpope/vim-commentary', 1)
  call s:bundle('kana/vim-vspec', 1)
  call s:bundle('rdnetto/YCM-Generator', 1)
  call s:bundle('junegunn/gv.vim', 1)
  call s:bundle('cosminadrianpopescu/filesync', 1)
  call s:bundle('mattn/emmet-vim', 1)
  call s:bundle('Xuyuanp/nerdtree-git-plugin', 1)
  call s:bundle('vim-javacomplete2')
  call s:bundle('goyo')
  call s:bundle('vimtex')
  call s:bundle('completers')
  call s:bundle('zeavim')
  call s:bundle('ludovicchabant/vim-gutentags', 1)
  call s:bundle('MarcWeber/vim-addon-local-vimrc', 1)
  call s:bundle('syntastic')
  call s:bundle('vim-scripts/ifdef-highlighting', 1)

  call plug#end()
endfunction

silent! call plug#begin('~/.vim/bundle')

call s:bundle('xolox/vim-misc', 1)
call s:bundle('unite')
call s:bundle('Shougo/neomru.vim', 1)
call s:bundle('vimproc')
call s:bundle('Shougo/tabpagebuffer.vim', 1)
call s:bundle('unite-outline')
call s:bundle('vim-startify')
call s:bundle('vim-anzu')
call s:bundle('vim-easymotion')
call s:bundle('delimitMate')
call s:bundle('snippets')
call s:bundle('chrisbra/SudoEdit.vim', 1)
call s:bundle('dhruvasagar/vim-table-mode', 1)
call s:bundle('powerman/vim-plugin-ruscmd', 1)
call s:bundle('gorkunov/smartpairs.vim', 1)
call s:bundle('EinfachToll/DidYouMean', 1)
call s:bundle('ack')
call s:bundle('chrisbra/Recover.vim', 1)
call s:bundle('tpope/vim-surround', 1)
call s:bundle('wincent/terminus', 1)
call s:bundle('james9909/stackanswers.vim', 1)
call s:bundle('907th/vim-auto-save', 1)
call s:bundle('wellle/visual-split.vim', 1)
call s:bundle('tpope/vim-vinegar', 1)
call s:bundle("vifm")
call s:bundle('tpope/vim-dispatch', 1)
call s:bundle('ryanoasis/vim-devicons', 1)
call s:bundle('vim-xkbswitch')
call s:bundle('nerdtree')
call s:bundle('tpope/vim-speeddating', 1)
call s:bundle('skywind3000/asyncrun.vim', 1)
call s:bundle('markdown')
call s:bundle('clever-f')

if !empty($TMUX)
  call s:bundle('tmuxline')
  call s:bundle('christoomey/vim-tmux-navigator', 1)
endif

if $VIM_ENV == 'wiki'
  call s:bundle('vimwiki')
endif

let g:languagetool_jar = $HOME. '/Soft/LanguageTool/languagetool-commandline.jar'
if filereadable(g:languagetool_jar)
  call s:bundle('LanguageTool')
endif

if isdirectory($HOME. '/.cheat')
  call s:bundle('wsdjeg/vim-cheat', 1)
endif

call plug#end()

if $VIM_ENV == 'dev'
  call s:enableDev()
else
  command! -nargs=0 -bar EnableDev call s:enableDev()
endif

" vim:set fdm=marker sw=2 nowrap:
