if has('vim_starting')
   set nocompatible               " Be iMproved
endif

" set leader for '
let mapleader = "'"
let maplocalleader = "'"
let g:mapleader = "'"

source $HOME/.vim/config/bundles.vim
source $HOME/.vim/config/syntax.vim
source $HOME/.vim/config/mappings.vim
source $HOME/.vim/config/settings.vim
source $HOME/.vim/config/abbreviation.vim
source $HOME/.vim/config/statusline.vim
source $HOME/.vim/config/autocommands.vim
